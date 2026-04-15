# ==============================================================================
# OPENCLAW SOVEREIGN ENGINE - [VERSION V3.1] - [PRECISION_CORE]
# ==============================================================================
# [IDENTITY]: OPENCLAW_ENGINE_V3.1
# [MANDATE]: Concise / Conversation-Aware / Browser + File + Daemon Capable
# ------------------------------------------------------------------------------

$script:OClawRoot = $PSScriptRoot
$script:WkDir = Resolve-Path (Join-Path $PSScriptRoot "..")
$script:LocalKnowledge = Join-Path $PSScriptRoot "system"
$script:LogFile = Join-Path $script:LocalKnowledge "diagnostic.log"
$script:ChatHistoryFile = Join-Path $PSScriptRoot "system\skills_bridge\chat_log.jsonl"
$script:OllamaUrl = "http://localhost:11434"

# --- LOGGING ---
function Write-OClawLog([string]$LogEvent, [string]$Details = "") {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $script:LogFile -Value "[$ts] [$LogEvent] $Details" -ErrorAction SilentlyContinue
}

# --- 1. MODEL DETECTION & TIERING ---
function Get-OClawModels {
    try {
        $tags = Invoke-RestMethod -Uri "$script:OllamaUrl/api/tags" -TimeoutSec 3
        return $tags.models | ForEach-Object { $_.name }
    } catch { return @() }
}

function Get-OClawIdentity([int]$Tier = 0) {
    $Available = Get-OClawModels
    $Fast = if ($Available -contains "gemma4:e2b") { "gemma4:e2b" } elseif ($Available.Count -gt 0) { $Available[0] } else { "gemma4:e2b" }
    $Heavy = if ($Available -contains "gemma4:e4b") { "gemma4:e4b" } else { $Fast }

    switch ($Tier) {
        0 {
            $RAM = [math]::Round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB, 0)
            return if ($RAM -ge 16) { $Heavy } else { $Fast }
        }
        1 { return $Fast }
        2 { return $Heavy }
        default { return $Fast }
    }
}

function Test-OClawConnection {
    try { Invoke-RestMethod -Uri "$script:OllamaUrl/api/tags" -TimeoutSec 2 | Out-Null; return $true } catch { return $false }
}

# --- 2. PRIVACY & CONTEXT ---
function Protect-OClawPrivacy([string]$Payload) {
    return $Payload -replace 'c:\\Users\\[^\\]+\\Desktop', 'C:\WORKSPACE' -replace '[a-fA-F0-9]{32,}', '[REDACTED]'
}

function Get-OClawContext {
    $RulesDir = Join-Path $script:LocalKnowledge "core_rules"
    
    # 1. Load Mandatory Mandates (MD)
    $Mandate = if (Test-Path (Join-Path $RulesDir "SOVEREIGN_MANDATE.md")) { Get-Content (Join-Path $RulesDir "SOVEREIGN_MANDATE.md") -Raw } else { "" }
    
    # 2. Load System Rules (YAML)
    $Rules = if (Test-Path (Join-Path $RulesDir "SYSTEM_RULES.yaml")) { Get-Content (Join-Path $RulesDir "SYSTEM_RULES.yaml") -Raw } else { "" }
    
    # 3. Load Model Registry (JSON) for dynamic context
    $Registry = if (Test-Path (Join-Path $RulesDir "MODEL_REGISTRY.json")) { Get-Content (Join-Path $RulesDir "MODEL_REGISTRY.json") -Raw } else { "" }

    $Directive = @"
[IDENTITY]: OpenClaw V2.0 Sovereign Singularity.
[BUILD]: Hybrid (MD/YAML/JSON/Moon/XML)
[RULES]: $Rules
[MANDATE]: $Mandate
"@

    return "$Directive`n`nREGISTRY_META:`n$Registry"
}

# --- 3. CONVERSATION HISTORY ---
function Get-OClawHistory([int]$MaxTurns = 5) {
    if (-not (Test-Path $script:ChatHistoryFile)) { return "" }
    $Lines = Get-Content $script:ChatHistoryFile -Tail ($MaxTurns * 2) -ErrorAction SilentlyContinue
    $History = ""
    foreach ($line in $Lines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try {
            $obj = $line | ConvertFrom-Json -ErrorAction Stop
            if ($obj.user) { $History += "USER: $($obj.user)`n" }
            if ($obj.assistant) { $History += "ASSISTANT: $($obj.assistant)`n" }
        } catch {}
    }
    return $History
}

function Save-OClawTurn([string]$UserMsg, [string]$AssistantMsg) {
    $dir = Split-Path $script:ChatHistoryFile -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $entry = @{ user = $UserMsg; assistant = $AssistantMsg; timestamp = (Get-Date -Format "o") } | ConvertTo-Json -Compress
    Add-Content -Path $script:ChatHistoryFile -Value $entry -ErrorAction SilentlyContinue
}

# --- 4. PRECISION INFERENCE ---
function Invoke-OClawQuery([string]$UserMessage, [int]$Tier = 0) {
    $Model = Get-OClawIdentity $Tier
    $Context = Get-OClawContext
    $History = Get-OClawHistory 5

    $FullPrompt = "$Context`n`n"
    if ($History) { $FullPrompt += "RECENT CONVERSATION:`n$History`n" }
    $FullPrompt += "USER: $UserMessage`nASSISTANT (OpenClaw):"

    $Prompt = Protect-OClawPrivacy $FullPrompt

    $Body = @{
        model = $Model
        prompt = $Prompt
        stream = $false
        options = @{
            stop = @("USER:", "ASSISTANT:", "<THOUGHTS>")
            num_ctx = 4096
        }
    } | ConvertTo-Json -Compress

    Write-OClawLog "QUERY" "Model=$Model Tier=$Tier Msg=$($UserMessage.Substring(0, [Math]::Min(80, $UserMessage.Length)))"

    $Response = try {
        Invoke-RestMethod -Uri "$script:OllamaUrl/api/generate" -Method Post -Body $Body -ContentType "application/json" -TimeoutSec 180
    } catch {
        Write-OClawLog "INF_FAIL" $_.Exception.Message
        $null
    }

    if (-not $Response) { return "[ENGINE OFFLINE] Cannot reach Ollama at $script:OllamaUrl. Please ensure Ollama is running." }

    $RawRes = $Response.response

    # Clean system artifacts from response
    $CleanRes = $RawRes -replace '(?s)<ACTION>.*?</ACTION>', '' `
                        -replace '(?s)<THOUGHTS>.*?</THOUGHTS>', '' `
                        -replace '^\s*(OK\.|Sure\.|Certainly\.)\s*', ''

    # Dispatch any embedded actions
    $ActionMatches = [regex]::Matches($RawRes, "<ACTION>(.*?)<\/ACTION>")
    foreach ($Match in $ActionMatches) {
        try {
            $actionObj = $Match.Groups[1].Value.Trim() | ConvertFrom-Json
            if ($actionObj.MissionKey) { Invoke-OClawMission $actionObj.MissionKey $actionObj.Params }
        } catch { Write-OClawLog "DISPATCH_ERROR" $Match.Groups[1].Value }
    }

    $Result = $CleanRes.Trim()

    # Save conversation turn
    Save-OClawTurn $UserMessage $Result

    # Log performance
    if ($Response.eval_count -and $Response.eval_duration) {
        $tps = [math]::Round($Response.eval_count / ($Response.eval_duration / 1e9), 1)
        Write-OClawLog "PERF" "Tokens=$($Response.eval_count) Speed=${tps}t/s Model=$Model"
    }

    return $Result
}

# --- 5. TACTICAL MISSION DISPATCHER ---
function Invoke-OClawMission([string]$MissionKey, $Params) {
    Write-OClawLog "MISSION" $MissionKey
    
    # Mapping table for Mission to Suite/Action
    $Map = @{
        "BROWSER_START"    = @{ Suite="Tactical_Suite"; Action="BROWSER_START" }
        "BROWSER_NAV"      = @{ Suite="Tactical_Suite"; Action="BROWSER_NAV" }
        "VISUAL_PULSE"     = @{ Suite="Tactical_Suite"; Action="BROWSER_UI" }
        "OCR"              = @{ Suite="Tactical_Suite"; Action="VISION_OCR" }
        
        "GPU_STATUS"       = @{ Suite="Sovereign_Suite"; Action="GPU_STATUS" }
        "WINDOW_LIST"      = @{ Suite="Sovereign_Suite"; Action="WINDOW_LIST" }
        "WINDOW_FOCUS"     = @{ Suite="Sovereign_Suite"; Action="WINDOW_FOCUS" }
        "DAEMON_STATUS"    = @{ Suite="Sovereign_Suite"; Action="DAEMON_STATUS" }
        
        "SPEAK"            = @{ Suite="Media_Suite"; Action="VOICE_SPEAK" }
        "SCREEN_FULL"      = @{ Suite="Media_Suite"; Action="SCREEN_CAPTURE" }
        "NOTIFY"           = @{ Suite="Media_Suite"; Action="NOTIFY_SEND" }
        
        "FILE_CRAWL"       = @{ Suite="Cognition_Suite"; Action="FILE_CRAWL" }
        "FILE_READ"        = @{ Suite="Cognition_Suite"; Action="FILE_READ" }
        "PIN_CHUNK"        = @{ Suite="Cognition_Suite"; Action="PIN_CHUNK" }
        "NOTE_CREATE"      = @{ Suite="Cognition_Suite"; Action="NOTE_CREATE" }
        "RAG_QUERY"        = @{ Suite="Cognition_Suite"; Action="RAG_QUERY" }
        "DECOMPOSE"        = @{ Suite="Cognition_Suite"; Action="DECOMPOSE_TASK" }
        "SURVEY"           = @{ Suite="Cognition_Suite"; Action="SURVEY_CONTEXT" }
        "BLUEPRINT"        = @{ Suite="Cognition_Suite"; Action="GENERATE_BLUEPRINT" }
        "PYRAMID"          = @{ Suite="Cognition_Suite"; Action="PYRAMID_DRILL" }
        "DISCOVERY"        = @{ Suite="Cognition_Suite"; Action="SMART_DISCOVERY" }
        
        "AUDIT_UI"         = @{ Suite="Tactical_Suite"; Action="AUDIT_UI" }
        "GUARDRAIL"        = @{ Suite="Sovereign_Suite"; Action="CHECK_GUARDRAIL" }
        
        "GATEWAY_CONNECT"  = @{ Suite="Bridge_Suite"; Action="GATEWAY_CONNECT" }
        "CODE_RUN"         = @{ Suite="Bridge_Suite"; Action="CODE_RUN" }
        "PIPELINE_RUN"     = @{ Suite="Bridge_Suite"; Action="PIPELINE_RUN" }
        "MODEL_COMPARE"    = @{ Suite="Bridge_Suite"; Action="MODEL_COMPARE" }
        "SWARM_EXECUTE"    = @{ Suite="Bridge_Suite"; Action="SWARM_EXECUTE" }
        "HANDOFF"          = @{ Suite="Bridge_Suite"; Action="TEAM_HANDOFF" }
    }

    if ($Map.ContainsKey($MissionKey)) {
        $T = $Map[$MissionKey]
        $Args = "-Action $($T.Action)"
        if ($Params.Url) { $Args += " -Url `"$($Params.Url)`"" }
        if ($Params.Text) { $Args += " -Text `"$($Params.Text)`"" }
        if ($Params.Code) { $Args += " -Code `"$($Params.Code)`"" }
        if ($Params.Path) { $Args += " -Path `"$($Params.Path)`"" }
        if ($Params.Title) { $Args += " -Title `"$($Params.Title)`"" }
        if ($Params.Content) { $Args += " -Content `"$($Params.Content)`"" }
        
        return Invoke-OClawSkill $T.Suite $Args
    }

    # Fallback to direct skill if not mapped
    $SkillPath = Join-Path "$script:LocalKnowledge\OpenClaw_Skills" "$MissionKey.ps1"
    if (Test-Path $SkillPath) { return Invoke-OClawSkill $MissionKey }
    return "UNKNOWN_MISSION: $MissionKey"
}
            $SkillPath = Join-Path "$script:LocalKnowledge\OpenClaw_Skills" "$MissionKey.ps1"
            if (Test-Path $SkillPath) { return Invoke-OClawSkill $MissionKey }
            return "UNKNOWN_MISSION: $MissionKey"
        }
    }
}

function Invoke-OClawSkill([string]$SkillName, [string]$SkillArgs = "") {
    $SkillPath = Join-Path "$script:LocalKnowledge\OpenClaw_Skills" "$SkillName.ps1"
    if (-not (Test-Path $SkillPath)) {
        Write-OClawLog "SKILL_NOT_FOUND" $SkillName
        return "Skill '$SkillName' not found."
    }
    Write-OClawLog "SKILL_RUN" $SkillName
    try {
        if ($SkillArgs) {
            return Invoke-Expression "& powershell -ExecutionPolicy Bypass -File `"$SkillPath`" $SkillArgs"
        } else {
            return & powershell -ExecutionPolicy Bypass -File $SkillPath
        }
    } catch {
        Write-OClawLog "SKILL_ERROR" "$SkillName : $($_.Exception.Message)"
        return "Skill error: $($_.Exception.Message)"
    }
}

# --- 6. ENGINE INFO ---
function Get-OClawStatus {
    $online = Test-OClawConnection
    $models = if ($online) { (Get-OClawModels) -join ", " } else { "N/A" }
    $gpu = & powershell -ExecutionPolicy Bypass -File (Join-Path $script:LocalKnowledge "OpenClaw_Skills\Get_GPU_Status.ps1") 2>$null
    return @{
        Online = $online
        Models = $models
        ActiveModel = Get-OClawIdentity 1
        GPU = $gpu
        Version = "3.1"
    }
}

# CLI mode
if ($args.Count -gt 0) { Invoke-OClawQuery ($args -join " ") }
