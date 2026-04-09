# OPENCLAW BUILD PIPELINE [V34.3]
# ----------------------------------
# [PURPOSE]: Robust Compilation with explicit assembly linking

Write-Host "[BUILD] Initiating Sovereign Compilation..." -ForegroundColor Cyan

$CscPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
$Source = Join-Path $PSScriptRoot "OpenClaw.cs"
$OutPath = Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..\..")) "OpenClaw.exe"
$IconPath = Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "OpenClaw.ico"

# Explicitly link necessary .NET assemblies
$Refs = @("/r:System.Windows.Forms.dll", "/r:System.Drawing.dll", "/r:System.dll", "/r:System.Net.dll")
$IconFlag = if (Test-Path $IconPath) { "/win32icon:`"$IconPath`"" } else { "" }

Write-Host "[BUILD] Target: $OutPath" -ForegroundColor Gray

& $CscPath /target:winexe /out:"$OutPath" $IconFlag $Refs $Source

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] OpenClaw.exe forged with structural hardening." -ForegroundColor Green
} else {
    Write-Host "[FAILED] Compilation failed." -ForegroundColor Red
    exit 1
}
