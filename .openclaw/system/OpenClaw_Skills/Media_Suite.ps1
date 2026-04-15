# OPENCLAW SOVEREIGN SUITE: MEDIA [V2.0]
# =========================================
# [ACTIONS]: SCREEN_CAPTURE, VOICE_SPEAK, NOTIFY_SEND, UI_RENDER

param(
    [string]$Action = "NOTIFY_SEND",
    [string]$Title = "OpenClaw System",
    [string]$Message = "Action Completed.",
    [string]$Text = "",
    [string]$ImagePath = ""
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$VaultDir = Join-Path $PSScriptRoot "..\skills_bridge\visual_vault"
if (-not (Test-Path $VaultDir)) { New-Item -ItemType Directory -Path $VaultDir -Force | Out-Null }

# --- ACTIONS ---
switch ($Action.ToUpper()) {
    "SCREEN_CAPTURE" {
        Add-Type -AssemblyName System.Windows.Forms, System.Drawing
        $screen = [Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap = New-Object Drawing.Bitmap ($screen.Width, $screen.Height)
        [Drawing.Graphics]::FromImage($bitmap).CopyFromScreen(0,0,0,0,$bitmap.Size)
        $path = Join-Path $VaultDir "cap_$(Get-Date -f yyyyMMdd_HHmm).png"
        $bitmap.Save($path, [Drawing.Imaging.ImageFormat]::Png); $bitmap.Dispose()
        Write-Output "[MEDIA] Screenshot saved: $path"
    }

    "NOTIFY_SEND" {
        Add-Type -AssemblyName System.Windows.Forms
        $notification = New-Object Windows.Forms.NotifyIcon
        $notification.Icon = [System.Drawing.SystemIcons]::Information
        $notification.BalloonTipTitle = $Title
        $notification.BalloonTipText = $Message
        $notification.Visible = $true
        $notification.ShowBalloonTip(3000)
        Start-Sleep -Seconds 1
        $notification.Dispose()
        Write-Output "[MEDIA] Notification sent: $Title"
    }

    "VOICE_SPEAK" {
        Add-Type -AssemblyName System.Speech
        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $synth.Speak($Text)
        Write-Output "[MEDIA] Voice Output: $Text"
    }

    default { Write-Output "[MEDIA] Unknown action: $Action" }
}
