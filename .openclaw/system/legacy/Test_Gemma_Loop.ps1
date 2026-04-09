# OPENCLAW DIAGNOSTIC: GEMMA-4 HANDSHAKE TEST
# --------------------------------------------

$EnginePath = Join-Path $PSScriptRoot "OpenClaw_Engine.ps1"

Write-Host "--- OPENCLAW PRO DIAGNOSTIC ---" -ForegroundColor Cyan
Write-Host "[1/3] Waking up Local Brain (Ollama)..." -ForegroundColor Yellow

# Load Engine
if (-not (Test-Path $EnginePath)) {
    Write-Host "[ERROR] Engine not found at $EnginePath" -ForegroundColor Red
    exit 1
}
. $EnginePath

# Send Verification Ping
Write-Host "[2/3] Sending Synced Handshake (Gemma4 Query)..." -ForegroundColor Yellow
$TestMsg = "Reply with exactly: 'HANDSHAKE SUCCESSFUL (V30.1)'"
$Response = Invoke-OClawQuery $TestMsg

# Verify
if ($Response -like "*HANDSHAKE SUCCESSFUL*") {
    Write-Host "[3/3] [SUCCESS] Gemma-4 is online and acknowledging OpenClaw Pro." -ForegroundColor Green
    Write-Host "Response: $Response" -ForegroundColor Cyan
} else {
    Write-Host "[ERROR] Handshake failed or timed out." -ForegroundColor Red
    Write-Host "Raw Response: $Response" -ForegroundColor Yellow
    exit 1
}
