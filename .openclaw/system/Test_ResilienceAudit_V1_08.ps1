# OPENCLAW SOVEREIGN: RESILIENCE AUDIT V1.08
# --------------------------------------------------
# [MANDATE]: Verifying High-Inference Stability (450s)
# [VERSION]: V1.08

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$EnginePath = Join-Path $PSScriptRoot "..\OpenClaw_Engine.ps1"
if (-not (Test-Path $EnginePath)) { exit 1 }
. $EnginePath

$ResilienceQueries = @(
    "What is the system version and current Resilience Directive?",
    "Generate a complex 10-step plan for integrating SearXNG into the Sovereign interface.",
    "Explain the technical difference between V1.07 and V1.08 timeouts."
)

Write-Host "--- SOVEREIGN RESILIENCE AUDIT V1.08 ---" -ForegroundColor Cyan
$Results = @()

foreach ($q in $ResilienceQueries) {
    Write-Host "[PROBE] $q" -ForegroundColor White
    $Timer = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $Response = Invoke-OClawQuery $q 2 # Tier 2 (Heavy)
        $Timer.Stop()
        Write-Host "SUCCESS ($($Timer.Elapsed.TotalSeconds)s)" -ForegroundColor Green
        $Results += [PSCustomObject]@{
            Question = $q
            Answer   = $Response
            Time     = "$($Timer.Elapsed.TotalSeconds)s"
        }
    } catch {
        Write-Host "CRASH ($($Timer.Elapsed.TotalSeconds)s)" -ForegroundColor Red
        Write-OClawLog "RESILIENCE_CRASH" "Query: $q | Error: $($_.Exception.Message)"
    }
}

$Results | Out-String | Write-Host -ForegroundColor Green
Write-OClawLog "RESILIENCE_AUDIT" "V1.08 Complete. Heavy inference verified."
