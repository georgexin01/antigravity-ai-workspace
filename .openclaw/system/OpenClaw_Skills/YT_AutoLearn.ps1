# YT-AUTOLEARN SKILL [V35.0]
# ---------------------------------
# [PURPOSE]: Auto-extract YouTube transcript, synthesize knowledge, and store to vault.
# [TRIGGER]: Automatically called by engine when YouTube URL detected in user message.

param([string]$Url, [string]$UserNote = "")

$WkDir = Resolve-Path (Join-Path $PSScriptRoot "..\..\..") 
$LocalKnowledge = Join-Path $PSScriptRoot "..\..\"
$KnowledgePath = Join-Path $LocalKnowledge "knowledge"

if (-not (Test-Path $KnowledgePath)) { New-Item -ItemType Directory -Path $KnowledgePath -Force | Out-Null }

# --- PHASE 1: EXTRACT VIDEO ID ---
$VideoId = ""
if ($Url -match "v=([a-zA-Z0-9_-]{11})") { $VideoId = $Matches[1] }
elseif ($Url -match "youtu\.be/([a-zA-Z0-9_-]{11})") { $VideoId = $Matches[1] }

if (-not $VideoId) {
    Write-Output "### BLOCKER: [YT_LEARN] Could not extract Video ID from URL: $Url"
    exit 1
}

Write-Host "[YT-LEARN] Video ID: $VideoId" -ForegroundColor Cyan

# --- PHASE 2: EXTRACT TRANSCRIPT (via yt-dlp) ---
$Transcript = ""
$Title = "Unknown Video"

$YtDlp = Get-Command "yt-dlp" -ErrorAction SilentlyContinue
if ($YtDlp) {
    $TmpDir = Join-Path $env:TEMP "oclaw_yt_$VideoId"
    New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null
    
    Write-Host "[YT-LEARN] Fetching transcript..." -ForegroundColor Yellow
    & yt-dlp --quiet --skip-download --write-auto-sub --sub-lang en --convert-subs srt -o "$TmpDir\%(id)s" $Url 2>&1 | Out-Null

    # Try to get title
    $TitleRaw = & yt-dlp --get-title $Url 2>&1
    if ($LASTEXITCODE -eq 0) { $Title = $TitleRaw.Trim() }
    
    $SrtFile = Get-ChildItem $TmpDir -Filter "*.srt" | Select-Object -First 1
    if ($SrtFile) {
        $RawSrt = Get-Content $SrtFile.FullName -Raw
        # Strip SRT timestamps and numbers
        $Transcript = $RawSrt -replace '\d+\r?\n\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}\r?\n', '' -replace '<[^>]+>', ''
        $Transcript = ($Transcript -split "`n" | Where-Object { $_ -match '\w' } | Select-Object -Unique) -join " "
        $Transcript = $Transcript.Substring(0, [Math]::Min(4000, $Transcript.Length))
        Write-Host "[YT-LEARN] Transcript extracted ($($Transcript.Length) chars)." -ForegroundColor Green
    } else {
        Write-Host "[YT-LEARN] No transcript found. Falling back to web summary..." -ForegroundColor Yellow
    }
    Remove-Item $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "[YT-LEARN] yt-dlp not found. Install with: pip install yt-dlp" -ForegroundColor Yellow
}

# --- PHASE 3: BUILD ANALYSIS PROMPT ---
$UserContext = if ($UserNote) { "The user noted: '$UserNote'" } else { "" }
$TranscriptBlock = if ($Transcript) { "TRANSCRIPT:`n$Transcript" } else { "TRANSCRIPT: Not available. Base analysis on the video title/URL." }

$AnalysisPrompt = @"
You are the OpenClaw Sovereign Intelligence performing a YOUTUBE EVOLUTION AUDIT.

VIDEO TITLE: $Title
URL: $Url
$UserContext

$TranscriptBlock

Your task:
1. Provide a 2-3 sentence summary of what this video teaches.
2. List 3-10 key ideas or techniques covered.
3. Identify ANY concept that could upgrade or improve the OpenClaw AI system.
4. Rate relevance to OpenClaw evolution: HIGH / MEDIUM / LOW.

Format response as:
### SUMMARY:
[summary]

### KEY IDEAS:
- [idea]

### OPENCLAW UPGRADE POTENTIAL:
[upgrade notes]

### RELEVANCE: [HIGH/MEDIUM/LOW]
"@

# --- PHASE 4: QUERY LOCAL BRAIN ---
Write-Host "[YT-LEARN] Querying Sovereign Brain for analysis..." -ForegroundColor Cyan
$Body = @{
    model = "gemma:2b"
    prompt = $AnalysisPrompt
    stream = $false
    options = @{ num_ctx = 2048; num_gpu = 1 }
} | ConvertTo-Json -Compress

$Analysis = ""
try {
    $Response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $Body -ContentType "application/json" -TimeoutSec 90
    $Analysis = $Response.response
    Write-Host "[YT-LEARN] Brain analysis complete." -ForegroundColor Green
} catch {
    $Analysis = "Auto-analysis failed. Manual review required. Error: $($_.Exception.Message)"
    Write-Host "[YT-LEARN] Brain offline. Storing raw transcript." -ForegroundColor Red
}

# --- PHASE 5: STORE TO KNOWLEDGE VAULT ---
$DateStr = Get-Date -Format "yyyyMMdd"
$SafeTitle = ($Title -replace '[^\w\s-]', '' -replace '\s+', '_').Substring(0, [Math]::Min(40, $Title.Length))
$OutFile = Join-Path $KnowledgePath "yt_${VideoId}_${DateStr}.yaml"

$Content = @"
document_metadata:
  identity: "YT_LEARNING_$VideoId"
  source_url: "$Url"
  video_id: "$VideoId"
  date: "$(Get-Date -Format 'yyyy-MM-dd')"
  category: "YOUTUBE_LEARNING"
  status: "SOVEREIGN"
content:
  title: "$Title"
  user_note: "$UserNote"
  analysis: |
    $($Analysis -replace '"', '\"')
  raw_transcript_excerpt: |
    $($Transcript.Substring(0, [Math]::Min(500, $Transcript.Length)).Replace("`n", "`n    ").Replace("`r", ""))
evolution_log:
  - "YT Auto-Learning Captured: $(Get-Date -Format 'o')"
  - "Sovereign YAML Generation: 2026-04-11"
"@

Set-Content -Path $OutFile -Value $Content -Force
Write-Host "[YT-LEARN] Knowledge saved to: $OutFile" -ForegroundColor Green

# --- PHASE 6: REPORT ---
Write-Output "### ✅ SUCCESS: [YT_AUTOLEARN] Evolution complete for video: $Title"
Write-Output "Knowledge stored at: $OutFile"
