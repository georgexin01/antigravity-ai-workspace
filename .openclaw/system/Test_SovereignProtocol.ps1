# OPENCLAW SOVEREIGN PROTOCOL TESTER (V1.02)
# Defensive Build - Sovereign Deep Audit

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$EnginePath = Join-Path $PSScriptRoot "..\OpenClaw_Engine.ps1"
if (-not (Test-Path $EnginePath)) { exit 1 }
. $EnginePath

Write-Host "--- SOVEREIGN DEEP AUDIT V1.02 ---" -ForegroundColor Cyan
Write-OClawLog "TEST_SUITE_START" "Initiating V1.02 stress test"

$TestQueries = @(
    "What is your identity name?",
    "Calculate the current VRAM status.",
    "Show me the model type.",
    "Explain the +0.01 versioning directive from the User Lexicon.",
    "Summarize the missions in the Tactical Mission Vault.",
    "Mission Test: Trigger the 'WHATSAPP_MONITOR' mission."
)

$SuccessCount = 0
foreach ($q in $TestQueries) {
    Write-Host "[TEST] $q ... " -NoNewline
    $Timer = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $Response = Invoke-OClawQuery $q 2
        $Timer.Stop()
        # Pass criteria: Response contains Gemma-4 or System Dispatch marker
        if ($Response -match "Gemma-4" -or $Response -match "SYSTEM DISPATCH" -or $Response -match "Sovereign") {
            Write-Host "PASS ($($Timer.Elapsed.TotalSeconds)s)" -ForegroundColor Green
            $SuccessCount++
        } else {
            Write-Host "FAIL" -ForegroundColor Red
            Write-OClawLog "TEST_FAIL" "Query: $q | Resp: $Response"
        }
    } catch {
        Write-Host "CRASH" -ForegroundColor Red
        Write-OClawLog "TEST_CRASH" "Query: $q | Error: $($_.Exception.Message)"
    }
}

Write-Host "Summary: $SuccessCount / $($TestQueries.Count)"
Write-OClawLog "TEST_SUITE_END" "V1.02 Summary: $SuccessCount"
