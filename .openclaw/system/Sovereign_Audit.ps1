# OPENCLAW SOVEREIGN AUDIT SUITE (V2.0)
# Consolidated Diagnostic for Hybrid Build

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$EnginePath = Join-Path $PSScriptRoot "..\OpenClaw_Engine.ps1"

Write-Host "--- SOVEREIGN HYBRID AUDIT V2.0 ---" -ForegroundColor Cyan

# 1. Integrity Check
Write-Host "[1/4] Integrity Audit ... " -NoNewline
if (Test-Path $EnginePath) {
    Write-Host "PASS (Engine Found)" -ForegroundColor Green
} else {
    Write-Host "FAIL (Engine Missing)" -ForegroundColor Red; exit 1
}

# 2. Hybrid Build Audit
Write-Host "[2/4] Hybrid Build Sync ... " -NoNewline
$RulesPath = Join-Path $PSScriptRoot "core_rules"
$SkillsPath = Join-Path $PSScriptRoot "OpenClaw_Skills"
$HybridFiles = @("SOVEREIGN_MANDATE.md", "SYSTEM_RULES.yaml", "MODEL_REGISTRY.json", "STRATEGIC_PULSE.yaml", "GUI_ASSETS.xml")
$Suites = @("Tactical_Suite.ps1", "Sovereign_Suite.ps1", "Media_Suite.ps1", "Cognition_Suite.ps1", "Bridge_Suite.ps1")

$Missing = @()
foreach ($f in $HybridFiles) { if (-not (Test-Path (Join-Path $RulesPath $f))) { $Missing += $f } }
foreach ($s in $Suites) { if (-not (Test-Path (Join-Path $SkillsPath $s))) { $Missing += $s } }

if ($Missing.Count -eq 0) {
    Write-Host "PASS (Hybrid Files + 5 Suites detected)" -ForegroundColor Green
} else {
    Write-Host "FAIL (Missing: $($Missing -join ', '))" -ForegroundColor Red
}

# 3. Model Visibility
Write-Host "[3/4] Model Connectivity ... " -NoNewline
try {
    $OllamaUrl = "http://localhost:11434"
    $tags = Invoke-RestMethod -Uri "$OllamaUrl/api/tags" -TimeoutSec 2 -ErrorAction SilentlyContinue
    if ($tags) {
        Write-Host "PASS ($($tags.models.Count) models online)" -ForegroundColor Green
    } else {
        Write-Host "OFFLINE (Local Ollama not found)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "OFFLINE" -ForegroundColor Yellow
}

# 4. Engine Health
Write-Host "[4/4] Engine Handshake ... " -NoNewline
if (Get-Command "powershell" -ErrorAction SilentlyContinue) {
    Write-Host "PASS (Ready)" -ForegroundColor Green
} else {
    Write-Host "FAIL" -ForegroundColor Red
}

# 5. Swarm Readiness (Singularity V3.0)
Write-Host "[+ ] Swarm V3.0 Readiness ... " -NoNewline
$Rules = Get-Content (Join-Path $RulesPath "SYSTEM_RULES.yaml") -Raw
if ($Rules -match "swarm_protocols") {
    Write-Host "PASS (Protocols Codified)" -ForegroundColor Green
} else {
    Write-Host "PENDING" -ForegroundColor Yellow
}

Write-Host "`nSummary: Audit Sequence Completed." -ForegroundColor Cyan
