# OPENCLAW INTEGRITY GUARDIAN [V33.0]
# -----------------------------------
# [PURPOSE]: Mandatory Post-Edit Stability Verification

Write-Host "[GUARDIAN] Initiating Integrity Check..." -ForegroundColor Cyan

$EnginePath = Join-Path $PSScriptRoot "OpenClaw_Engine.ps1"
$GUIPath = Join-Path $PSScriptRoot "OpenClaw_GUI.ps1"

# 1. PATH VERIFICATION
if (-not (Test-Path $EnginePath) -or -not (Test-Path $GUIPath)) {
    Write-Host "[FAILED] Core scripts missing." -ForegroundColor Red
    exit 1
}

# 2. ENGINE HANDSHAKE (Ollama)
Write-Host "[GUARDIAN] Verifying Engine Handshake..." -ForegroundColor Gray
. $EnginePath
$Response = Invoke-OClawQuery "Respond with SUCCESS: Handshake Verified" 1

if ($Response -match "### SUCCESS" -or $Response -match "### INSIGHT") {
    Write-Host "[PASSED] Engine Shield & Handshake active." -ForegroundColor Green
} else {
    Write-Host "[FAILED] Engine produced raw unshielded output." -ForegroundColor Red
    exit 1
}

# 3. GUI SYNTAX CHECK
Write-Host "[GUARDIAN] Verifying GUI Syntax..." -ForegroundColor Gray
try {
    $script = Get-Content $GUIPath -Raw
    $errors = $null
    $tokens = $null
    [System.Management.Automation.Language.Parser]::ParseInput($script, [ref]$tokens, [ref]$errors)
    
    if ($errors) {
        throw "Syntax errors detected in GUI script: $($errors[0].Message)"
    }
    Write-Host "[PASSED] GUI Syntax is valid." -ForegroundColor Green
} catch {
    Write-Host "[FAILED] GUI Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "[SUCCESS] OpenClaw Sovereign V33.0 Integrity Confirmed." -ForegroundColor Cyan
exit 0
