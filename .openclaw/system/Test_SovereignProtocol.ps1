# OPENCLAW SOVEREIGN PROTOCOL TESTER (V55.0)
# -----------------------------------------------
# [MANDATE]: Stress test Engine & UI Bridge 
# [TARGET]: gemma4:e2b (Zeta Sovereign)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$EnginePath = Join-Path $PSScriptRoot "..\OpenClaw_Engine.ps1"
$LogPath = Join-Path $PSScriptRoot "diagnostic.log"

if (-not (Test-Path $EnginePath)) { Write-Error "CRITICAL: Engine file not found."; exit 1 }
. $EnginePath # Sourcing Engine first so functions are available

Write-Host "--- SOVEREIGN INTEGRITY AUDIT INITIATED ---" -ForegroundColor Cyan
Write-OClawLog "TEST_SUITE_START" "Initiating 5-Pass Stress Test"

$TestQueries = @(
    "What is your identity name?",
    "Calculate the current VRAM status.",
    "Show me the model type.",
    "Who created the Zebra Sovereign V45 design?",
    "Confirm hardware lock status."
)

$SuccessCount = 0
foreach ($q in $TestQueries) {
    Write-Host "[TEST] Sending: $q" -NoNewline
    $Timer = [System.Diagnostics.Stopwatch]::StartNew()
    
    try {
        . $EnginePath
        $Response = Invoke-OClawQuery $q 2 # Force Tier 2 (Heavy)
        $Timer.Stop()
        
        if ($Response -match "Gemma-4" -and $Response -notmatch "ERROR") {
            Write-Host " [PASS] ($($Timer.Elapsed.TotalSeconds)s)" -ForegroundColor Green
            $SuccessCount++
        } else {
            Write-Host " [FAIL]" -ForegroundColor Red
            Write-Host "   -> Response: $($Response.Substring(0, [Math]::Min(50, $Response.Length)))..." -ForegroundColor Gray
            Write-OClawLog "TEST_FAIL" "Query: $q | Response: $Response"
        }
    } catch {
        Write-Host " [CRASH]" -ForegroundColor Red
        Write-OClawLog "TEST_CRASH" "Query: $q | Error: $($_.Exception.Message)"
    }
}

Write-Host "`n--- AUDIT SUMMARY ---" -ForegroundColor Cyan
Write-Host "Success Rate: $SuccessCount / $($TestQueries.Count)"
Write-Host "Diagnostic Log: $LogPath"

if ($SuccessCount -eq $TestQueries.Count) {
    Write-Host "[+] INTEGRITY VERIFIED: Sovereign Core is Stable." -ForegroundColor Green
    Write-OClawLog "TEST_SUITE_END" "PASS"
} else {
    Write-Host "[X] INTEGRITY BREACHED: Core instablity detected." -ForegroundColor Red
    Write-OClawLog "TEST_SUITE_END" "FAIL"
}
