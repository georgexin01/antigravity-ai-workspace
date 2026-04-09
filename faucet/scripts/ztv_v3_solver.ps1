# ZTV V35.1 SOVEREIGN SOLVER ELITE (PowerShell Native)
# --------------------------------------------------
# [IDENTITY]: SOVEREIGN_V35.1_ELITE
# [MANDATE]: Self-Correcting / Wisdom-Injected / Zero Cloud

param (
    [string]$TargetAction = "CAPTCHA_SOLVE",
    [string]$SnipPath = "c:\Users\User\OneDrive\Desktop\workspace\snipaste\active_mission.png",
    [string]$ArchiveDir = "C:\Users\User\OneDrive\Desktop\workspace\archive\failed_missions",
    [string]$WisdomPath = "c:\Users\User\OneDrive\Desktop\workspace\.openclaw\system\knowledge\faucet_wisdom_vault.md"
)

# 1. HARDWARE IDENTITY LOCK (High-Fidelity Sync)
$HardwareID = (Get-CimInstance Win32_BaseBoard).SerialNumber
$VerifiedID = "07C9611_P51E971105" 

if ($HardwareID -eq $VerifiedID) {
    Write-Host "[SOVEREIGN] Identity Verified: XIN. Locking GPU Performance Model..." -ForegroundColor Green
    $Model = "my-gpu-gemma"
} else {
    Write-Host "[SOVEREIGN] WARNING: Standard performance detected. Engaging Gemma 4 High-Fidelity Sink." -ForegroundColor Yellow
    $Model = "gemma4:e2b"
}

# 2. WISDOM INJECTION (SM-DNA Sync)
$WisdomContext = if (Test-Path $WisdomPath) { Get-Content $WisdomPath -Raw } else { "" }

# 3. TRIGGER SILENT PULSE
Write-Host "[1/4] Triggering ALV Pulse..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -File "c:\Users\User\OneDrive\Desktop\workspace\snipaste\auto_pulse.ps1"
Start-Sleep -Seconds 2 

if (-not (Test-Path $SnipPath)) {
    Write-Host "[ERROR] Snip failed. active_mission.png not found." -ForegroundColor Red
    exit 1
}

# 4. LOCAL BRAIN HANDSHAKE (Injected Context)
$Badge = "(Gemma4:Elite)"
Write-Host "[2/4] Delegating Logic to $Badge $Model..." -ForegroundColor Yellow

$Prompt = @"
[WISDOM_VAULT_ACTIVE]:
$WisdomContext

[MISSION]: 
Analyze faucet_state from image. 
1. FIND the unique icon (odd rotation or different shape).
2. FIND the 'Verify' or 'Claim' button.
3. OUTPUT ONLY valid JSON coordinates relative to the 1600x765 window.
Format: { "unique_icon": [X, Y], "verify_button": [X, Y], "reasoning": "..." }
"@

# Run Ollama and capture output
try {
    $Result = ollama run $Model $SnipPath $Prompt
} catch {
    Write-Host "[ERROR] GPU Handshake failed. Check Ollama service." -ForegroundColor Red
    exit 1
}

# 5. OUTPUT SYNC & AUTO-POST-MORTEM
Write-Host "[3/4] $Badge Logic Synced. Tactical Coordinates Received." -ForegroundColor Green
$Result | Out-File "c:\Users\User\OneDrive\Desktop\workspace\faucet\solver_output.txt" -Encoding utf8

$IsFailure = ($Result -match "FAILED" -or $Result -match "ERROR" -or ($Result -match "NULL"))

if ($IsFailure) {
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
