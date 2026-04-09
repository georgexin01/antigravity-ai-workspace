# ICON CONVERSION WORKER [V34.0]
# ---------------------------------
# [PURPOSE]: Convert PNG to professional multi-size ICO

Add-Type -AssemblyName System.Drawing
$AssetPath = Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "assets\crab_icon.png"
$OutPath = Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "OpenClaw.ico"

if (-not (Test-Path $AssetPath)) {
    Write-Host "[ERROR] Source crab_icon.png not found." -ForegroundColor Red
    exit 1
}

Write-Host "[OPENCLAW] Generating official .ico from crab_icon.png..." -ForegroundColor Cyan

$Img = [System.Drawing.Image]::FromFile($AssetPath)
# For simplicity in this environment, we'll create a high-res icon.
# Professional ICOs contain multiple sizes, but for the taskbar 256x256 is ideal.
$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($AssetPath) 
# Note: ExtractAssociatedIcon is for files. We'll use a direct save method.

# Programmatic Icon Creation
$Bitmap = New-Object System.Drawing.Bitmap($Img)
$HIcon = $Bitmap.GetHicon()
$FinalIcon = [System.Drawing.Icon]::FromHandle($HIcon)

# Save the Icon
$Stream = New-Object System.IO.FileStream($OutPath, "Create")
$FinalIcon.Save($Stream)
$Stream.Close()

$Img.Dispose()
$Bitmap.Dispose()

Write-Host "[SUCCESS] OpenClaw.ico generated at $OutPath" -ForegroundColor Green
exit 0
