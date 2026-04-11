# ZTV V36.0 SOVEREIGN SOLVER HERMES (PowerShell Native)
# --------------------------------------------------
# [IDENTITY]: SOVEREIGN_V36.0_HERMES
# [MANDATE]: Strictly Fenced / Smart Balanced / Zero Cloud

param (
    [string]$TargetAction = "CAPTCHA_SOLVE",
    [string]$SnipPath = "c:\Users\User\OneDrive\Desktop\workspace\snipaste\active_mission.png",
    [string]$ArchiveDir = "C:\Users\User\OneDrive\Desktop\workspace\archive\failed_missions",
    [string]$WisdomPath = "c:\Users\User\OneDrive\Desktop\workspace\.openclaw\system\knowledge\faucet_wisdom_vault.md",
    [string]$SkillsDir = "c:\Users\User\OneDrive\Desktop\workspace\.openclaw\system\OpenClaw_Skills"
)

# 1. HARDWARE IDENTITY LOCK (High-Fidelity Sync)
$HardwareID = (Get-CimInstance Win32_BaseBoard).SerialNumber
$VerifiedID = "07C9611_P51E971105" 

# Use Smart Router for model selection
$RouterPath = Join-Path $SkillsDir "Sovereign_SmartRouter.ps1"
$Model = if (Test-Path $RouterPath) { 
    & powershell -ExecutionPolicy Bypass -File $RouterPath -UserQuery "Solve faucet captcha identify unique icon in snipaste"
} else { "gemma4:e2b" }

# 2. WISDOM INJECTION (SM-DNA Sync)
$WisdomContext = if (Test-Path $WisdomPath) { Get-Content $WisdomPath -Raw } else { "" }
$HermesVault = "c:\Users\User\OneDrive\Desktop\workspace\.openclaw\system\knowledge\hermes_protocol_wisdom.md"
$HermesMeta = if (Test-Path $HermesVault) { Get-Content $HermesVault -Raw } else { "" }

# 3. TRIGGER SILENT PULSE
Write-Host "[1/4] Triggering ALV Pulse..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -File "c:\Users\User\OneDrive\Desktop\workspace\snipaste\auto_pulse.ps1"
Start-Sleep -Seconds 2 

if (-not (Test-Path $SnipPath)) {
    $Err = "Snip failed. active_mission.png not found."
    & powershell -ExecutionPolicy Bypass -File (Join-Path $SkillsDir "Sovereign_ErrorClassifier.ps1") -ErrorMessage $Err
    Write-Host "[ERROR] $Err" -ForegroundColor Red
    exit 1
}

# 4. HERMES BRAIN HANDSHAKE (Fenced Context)
$Badge = "(Hermes:V36)"
Write-Host "[2/4] Delegating Logic to $Badge $Model..." -ForegroundColor Yellow

$Prompt = @"
<HERMES_WISDOM>
$HermesMeta
</HERMES_WISDOM>

<FAUCET_WISDOM>
$WisdomContext
</FAUCET_WISDOM>

<MISSION_TASK>
Analyze faucet_state from image. 
1. START with <REASONING_SCRATCHPAD> to analyze outlier heuristics.
2. FIND the unique icon (odd rotation or different shape).
3. FIND the 'Verify' or 'Claim' button.
4. Use <MISSION_EXECUTION> for valid JSON coordinates relative to the 1600x765 window.
Format: { "unique_icon": [X, Y], "verify_button": [X, Y], "reasoning": "..." }
</MISSION_TASK>
"@

# Run Ollama and capture output
try {
    $Result = ollama run $Model $SnipPath $Prompt
} catch {
    $Err = "GPU Handshake failed. Check Ollama service: $($_.Exception.Message)"
    & powershell -ExecutionPolicy Bypass -File (Join-Path $SkillsDir "Sovereign_ErrorClassifier.ps1") -ErrorMessage $Err
    Write-Host "[ERROR] $Err" -ForegroundColor Red
    exit 1
}

# 5. OUTPUT SYNC & AUTO-POST-MORTEM
Write-Host "[3/4] $Badge Logic Synced. Tactical Coordinates Received." -ForegroundColor Green
$Result | Out-File "c:\Users\User\OneDrive\Desktop\workspace\faucet\solver_output.txt" -Encoding utf8

$IsFailure = ($Result -match "FAILED" -or $Result -match "ERROR" -or ($Result -match "NULL"))

if ($IsFailure) {
    # [Rest of failure logic remains same but improved reporting]
    $Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $FailPath = Join-Path $ArchiveDir "fail_$Timestamp"
    New-Item -ItemType Directory -Path $FailPath -Force | Out-Null
    Copy-Item $SnipPath (Join-Path $FailPath "failed_capture.png")
    $Result | Out-File (Join-Path $FailPath "action_log.json")
    
    Write-Host "[4/4] [!] MISSION FAILURE DETECTED. Triggering Phoenix Autonomous Post-Mortem..." -ForegroundColor Coral
    $PhoenixPath = "c:\Users\User\OneDrive\Desktop\workspace\faucet\scripts\phoenix_recursive_tester.ps1"
    & powershell -ExecutionPolicy Bypass -File $PhoenixPath
} else {
    Write-Host "[4/4] MISSION READY. Awaiting Gemini-3 Bridge Execution." -ForegroundColor Cyan
}
