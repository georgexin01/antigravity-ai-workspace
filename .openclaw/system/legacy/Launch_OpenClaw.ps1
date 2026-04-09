# OPENCLAW LAUNCHER & SHORTCUT GENERATOR
# ----------------------------------------

$WkDir = (Get-Item $PSScriptRoot).Parent.FullName
$GuiPath = Join-Path $PSScriptRoot "OpenClaw_GUI.ps1"
$ShortcutPath = Join-Path $WkDir "Launch_OpenClaw.lnk"

# 1. FORCE SHORTCUT REGENERATION
Write-Host "[OPENCLAW] Synchronizing Workspace Shortcut..." -ForegroundColor Cyan
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
# Removed Hidden style for debug; can be re-added later.
$Shortcut.Arguments = "-ExecutionPolicy Bypass -NoProfile -File ""$GuiPath"""
$Shortcut.WorkingDirectory = $WkDir
$Shortcut.Description = "OpenClaw V1.0 Elite Agent"
$Shortcut.Save()
Write-Host "[SUCCESS] Shortcut synchronized: Launch_OpenClaw.lnk" -ForegroundColor Green

# 2. RUN GUI
Write-Host "[OPENCLAW] Launching Interface..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -NoProfile -File $GuiPath
