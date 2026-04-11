# OPENCLAW SKILL: MEMORY GRAPH [V1.2]
# [OBJECTIVE]: Extract semantic DNA from chat history and lexicon with fail-safe parsing.
# [ANTI-PATTERN ENFORCEMENT]:
#   WRONG:  Extracting DNA from pure system instructions or "Thinking" blocks.
#   CORRECT: Extracting ONLY definitive user preferences and confirmed design patterns.
#   WRONG:  Failing if a single line in chat_log.jsonl is malformed.
#   CORRECT: Using try-catch resilience to preserve the graph integrity.

$LogPath = Join-Path $PSScriptRoot "../skills_bridge/chat_log.jsonl"
$LexPath = Join-Path $PSScriptRoot "../skills_bridge/user_lexicon.yaml"
$GraphPath = Join-Path $PSScriptRoot "../skills_bridge/memory_graph.json"

Write-Host "[MEMORY] Synthesizing Project DNA Graph..." -ForegroundColor Magenta

$History = if (Test-Path $LogPath) { Get-Content $LogPath } else { @() }
$Lexicon = if (Test-Path $LexPath) { Get-Content $LexPath -Raw } else { "" }

$Entities = @{
    "DESIGN_DNA" = @()
    "CORE_LOGIC" = @()
    "USER_PREF"  = @()
}

# Scan Lexicon for P0 Mandates (YAML format)
if ($Lexicon -match 'mandate:\s*"(.*)"') {
    $Entities.CORE_LOGIC += $Matches[1].Split("/").Trim()
}

# Scan History with Resilience
$History | ForEach-Object {
    if (-not [string]::IsNullOrWhiteSpace($_)) {
        try {
            $obj = $_ | ConvertFrom-Json -ErrorAction Stop
            if ($obj.assistant -match "Zeta|Cinematic|Liquid Glass") { $Entities.DESIGN_DNA += "Zeta Cinematic Aesthetics" }
            if ($obj.user -match "Gemma4|Gemma-4") { $Entities.CORE_LOGIC += "Gemma-4 Deep Integration" }
        } catch {
            # Skip malformed lines
        }
    }
}

# [GHOST-PROTOCOL]: Pre-emptive workspace summary (Zero-Token Logic)
function Invoke-GhostScan {
    $summary = @()
    $files = Get-ChildItem -Path $PSScriptRoot/../../ -Filter "*.yaml" -Recurse | Select-Object -First 5
    foreach ($f in $files) {
        $summary += "$($f.Name) (Linked)"
    }
    return $summary -join ", "
}

$Entities.CORE_LOGIC += "Ghost Scan Active: $(Invoke-GhostScan)"

$Entities.DESIGN_DNA = $Entities.DESIGN_DNA | Select-Object -Unique
$Entities.CORE_LOGIC = $Entities.CORE_LOGIC | Select-Object -Unique

$Graph = @{
    Version    = "1.2"
    LastUpdate = (Get-Date -Format "o")
    GhostNode  = (Invoke-GhostScan)
    Graph      = $Entities
}

$Graph | ConvertTo-Json | Set-Content -Path $GraphPath -Force

Write-Host "[SUCCESS] Memory Graph evolved. Ghost Protocol summary generated." -ForegroundColor Green
