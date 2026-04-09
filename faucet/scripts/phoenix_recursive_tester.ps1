# PHOENIX RECURSIVE TESTER V35.1 ELITE (PowerShell Native)
# ---------------------------------------------------------
# [IDENTITY]: PHOENIX_RECURSIVE_V35.1
# [MANDATE]: Zero-Human Intervention / Mandatory Wisdom Consolidation

param (
    [string]$ArchiveDir = "C:\Users\User\OneDrive\Desktop\workspace\archive\failed_missions",
    [string]$WisdomPath = "c:\Users\User\OneDrive\Desktop\workspace\.openclaw\system\knowledge\faucet_wisdom_vault.md"
)

# 1. HARDWARE IDENTITY LOCK
$HardwareID = (Get-CimInstance Win32_BaseBoard).SerialNumber
$VerifiedID = "07C9611_P51E971105" 

if ($HardwareID -eq $VerifiedID) {
    $Model = "my-gpu-gemma"
} else {
    $Model = "gemma4:e2b"
}

Write-Host "--- PHOENIX RECURSIVE TESTER 35.1 ---" -ForegroundColor Cyan
Write-Host "[PHOENIX] Identity Lock: $Model Active." -ForegroundColor Green

# 2. LOCATE LATEST FAILURE
$Failures = Get-ChildItem -Path $ArchiveDir -Directory | Sort-Object LastWriteTime -Descending
if (-not $Failures) {
    Write-Host "[PHOENIX] No failed missions found in archive." -ForegroundColor Yellow
    exit 0
}

$LatestFail = $Failures[0].FullName
$ImgPath = Join-Path $LatestFail "failed_capture.png"
Write-Host "[PHOENIX] Analyzing Failure: $($Failures[0].Name)" -ForegroundColor Cyan

# 3. THE 10-PASS STRESS LOOP
$Focuses = @("Symmetry Inversion", "Rotation outlier", "Statistical Rarity", "Bait Resistance (Color)", "Bait Resistance (Shading)", "Grid Alignment Drill", "Feature Contrast", "Silhouette Weighting", "Inverted Silhouette", "Coordinate Drift")
$Results = @()

for ($i = 1; $i -le 10; $i++) {
    $Focus = $Focuses[($i-1) % $Focuses.Length]
    Write-Host "[PHOENIX] (Gemma4) Pass $i/10: Focused on '$Focus'..." -ForegroundColor Yellow
    
    $Prompt = @"
Fail Analysis Pass $i/10. focus: $Focus.
Analyze the CAPTCHA image with a primary heuristic of '$Focus'. 
Identify the TRUE unique or outlier icon. 
Return ONLY valid JSON: { "pass": $i, "focus": "$Focus", "deduced_answer": [X, Y], "reason": "..." }
"@

    $PassResult = ollama run $Model $ImgPath $Prompt
    $Results += $PassResult
}

# 4. CONSENSUS SYNTHESIS & WISDOM CONSOLIDATION
Write-Host "[PHOENIX] Synthesizing 10-Pass consensus..." -ForegroundColor Green
$SynthesisPrompt = @"
Below are 10 post-mortem analysis results for the same failed mission.
Synthesize them into a single 'Golden Correction'.
Identify which coordinate the majority agree on.

Data: $Results

Return ONLY valid JSON: 
{ 
    "consensus_coordinate": [X, Y], 
    "majority_agreement_percent": "...", 
    "final_golden_rule": "The permanent rule to avoid this failure" 
}
"@

$FinalCorrection = ollama run $Model $SynthesisPrompt
$FinalCorrection | Out-File (Join-Path $LatestFail "recursive_synthesis.json") -Encoding utf8

# 5. AUTO-EVOLUTION (Wisdom Vault Update)
try {
    $CorrectionObj = $FinalCorrection | ConvertFrom-Json
    $NewRule = $CorrectionObj.final_golden_rule
    if ($NewRule) {
        $RuleEntry = "`n### [RULE_ID: FS-AUTO-$(Get-Date -Format 'ssmmHH')]`n- **Origin**: synthesized from $($Failures[0].Name)`n- **Heuristic**: $NewRule`n"
        Add-Content -Path $WisdomPath -Value $RuleEntry
        Write-Host "[PHOENIX] SUCCESS: Local Wisdom Vault evolved with new heuristic." -ForegroundColor Green
    }
} catch {
    Write-Host "[PHOENIX] WARNING: Failed to parse synthesis for autonomous wisdom update." -ForegroundColor Yellow
}

Write-Host "[PHOENIX] Protocol Complete." -ForegroundColor Green
