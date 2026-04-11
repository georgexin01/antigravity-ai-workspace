# PHOENIX RECURSIVE TESTER V36.0 HERMES (PowerShell Native)
# ---------------------------------------------------------
# [IDENTITY]: PHOENIX_RECURSIVE_V36.0
# [MANDATE]: Zero-Human Intervention / Experience-Driven Evolution

param (
    [string]$ArchiveDir = "C:\Users\User\OneDrive\Desktop\workspace\archive\failed_missions",
    [string]$WisdomPath = "c:\Users\User\OneDrive\Desktop\workspace\.openclaw\system\knowledge\faucet_wisdom_vault.md",
    [string]$SkillsDir = "c:\Users\User\OneDrive\Desktop\workspace\.openclaw\system\OpenClaw_Skills"
)

# 1. HARDWARE IDENTITY LOCK
$HardwareID = (Get-CimInstance Win32_BaseBoard).SerialNumber
$VerifiedID = "07C9611_P51E971105" 

# Use Smart Router for heavy synthesis
$RouterPath = Join-Path $SkillsDir "Sovereign_SmartRouter.ps1"
$Model = if (Test-Path $RouterPath) { 
    & powershell -ExecutionPolicy Bypass -File $RouterPath -UserQuery "Phoenix 10-pass recursive synthesis and golden rule generation"
} else { "gemma4:e2b" }

Write-Host "--- PHOENIX RECURSIVE TESTER V36.0 (HERMES TIER) ---" -ForegroundColor Cyan
Write-Host "[PHOENIX] Smart Router Selection: $Model" -ForegroundColor Green

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
    Write-Host "[PHOENIX] (Hermes) Pass $i/10: '$Focus'..." -ForegroundColor Yellow
    
    $Prompt = @"
Pass Analysis Pass $i/10. focus: $Focus.
<REASONING_SCRATCHPAD>
Analyze the CAPTCHA image with a primary heuristic of '$Focus'. 
Deduce the TRUE outlier by mapping visual deviations.
</REASONING_SCRATCHPAD>

<MISSION_EXECUTION>
{ "pass": $i, "focus": "$Focus", "deduced_answer": [X, Y], "reason": "..." }
</MISSION_EXECUTION>
"@

    $PassResult = ollama run $Model $ImgPath $Prompt
    $Results += $PassResult
}

# 4. CONSENSUS SYNTHESIS & WISDOM CONSOLIDATION
Write-Host "[PHOENIX] Synthesizing consensus via Hermes Protocol..." -ForegroundColor Green
$SynthesisPrompt = @"
Below are 10 post-mortem analysis results for the same failed mission.
<REASONING_SCRATCHPAD>
Synthesize them into a single 'Golden Correction'.
Identify which coordinate the majority agree on. Explain the logic of the outlier.
</REASONING_SCRATCHPAD>

<MISSION_EXECUTION>
{ 
    "consensus_coordinate": [X, Y], 
    "majority_agreement_percent": "...", 
    "final_golden_rule": "The permanent rule to avoid this failure" 
}
</MISSION_EXECUTION>

Data: $Results
"@

$FinalCorrection = ollama run $Model $SynthesisPrompt
$FinalCorrection | Out-File (Join-Path $LatestFail "recursive_synthesis.json") -Encoding utf8

# 5. AUTO-EVOLUTION (Wisdom Vault & Experience Cap Update)
try {
    $CorrectionObj = $FinalCorrection | ConvertFrom-Json
    $NewRule = $CorrectionObj.final_golden_rule
    if ($NewRule) {
        $RuleEntry = "`n### [RULE_ID: FS-HERMES-$(Get-Date -Format 'ssmmHH')]`n- **Origin**: synthesized from $($Failures[0].Name)`n- **Heuristic**: $NewRule`n"
        Add-Content -Path $WisdomPath -Value $RuleEntry
        
        # Trigger Experience Capture
        $CapSkill = Join-Path $SkillsDir "Sovereign_ExperienceCapture.ps1"
        if (Test-Path $CapSkill) {
            & powershell -ExecutionPolicy Bypass -File $CapSkill -Type "PHOENIX" -TrajectoryPath (Join-Path $LatestFail "recursive_synthesis.json")
        }
        
        Write-Host "[PHOENIX] SUCCESS: Local Wisdom Vault evolved with new Hermes heuristic." -ForegroundColor Green
    }
} catch {
    $Err = "Failed to parse synthesis for autonomous wisdom update: $($_.Exception.Message)"
    & powershell -ExecutionPolicy Bypass -File (Join-Path $SkillsDir "Sovereign_ErrorClassifier.ps1") -ErrorMessage $Err
    Write-Host "[PHOENIX] WARNING: $Err" -ForegroundColor Yellow
}

Write-Host "[PHOENIX] Protocol Complete." -ForegroundColor Green
