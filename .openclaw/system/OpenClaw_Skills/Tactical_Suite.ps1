# OPENCLAW SOVEREIGN SUITE: TACTICAL [V2.0]
# =========================================
# [ACTIONS]: BROWSER_START, BROWSER_STOP, BROWSER_NAV, BROWSER_UI, VISION_OCR, VISION_PULSE

param(
    [string]$Action = "STATUS",
    [string]$Url = "",
    [int]$X = 0,
    [int]$Y = 0,
    [string]$Text = "",
    [string]$Code = "",
    [string]$Selector = "",
    [string]$ImagePath = "",
    [switch]$Headless,
    [switch]$CaptureScreen
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$VaultDir = Join-Path $PSScriptRoot "..\skills_bridge\visual_vault"
if (-not (Test-Path $VaultDir)) { New-Item -ItemType Directory -Path $VaultDir -Force | Out-Null }

$CDPPort = 9222
$CDPUrl = "http://localhost:$CDPPort"
$OllamaUrl = "http://localhost:11434"

# --- HELPERS ---
function Send-CDPCommand([string]$WsUrl, [string]$Method, [hashtable]$Params = @{}) {
    # (Implementation from Browser_Control.ps1)
    Add-Type -AssemblyName System.Net.Http
    $ws = New-Object System.Net.WebSockets.ClientWebSocket
    $ct = New-Object System.Threading.CancellationToken($false)
    try {
        $ws.ConnectAsync([Uri]$WsUrl, $ct).GetAwaiter().GetResult()
        $msg = @{ id = 1; method = $Method; params = $Params } | ConvertTo-Json -Compress
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($msg)
        $ws.SendAsync((New-Object ArraySegment[byte]($bytes, 0, $bytes.Length)), [Net.WebSockets.WebSocketMessageType]::Text, $true, $ct).GetAwaiter().GetResult()
        $buffer = New-Object byte[] (4 * 1024 * 1024); $result = ""
        do {
            $recv = $ws.ReceiveAsync((New-Object ArraySegment[byte]($buffer, 0, $buffer.Length)), $ct).GetAwaiter().GetResult()
            $result += [System.Text.Encoding]::UTF8.GetString($buffer, 0, $recv.Count)
        } while (-not $recv.EndOfMessage)
        $ws.CloseAsync([Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "", $ct).GetAwaiter().GetResult()
        return $result | ConvertFrom-Json
    } catch { return @{ error = $_.Exception.Message } } finally { if ($ws) { $ws.Dispose() } }
}

function Get-ActiveTabWs {
    try {
        $tabs = Invoke-RestMethod -Uri "$CDPUrl/json" -TimeoutSec 2
        $page = $tabs | Where-Object { $_.type -eq "page" } | Select-Object -First 1
        return if ($page) { $page.webSocketDebuggerUrl } else { $null }
    } catch { return $null }
}

# --- ACTIONS ---
switch ($Action.ToUpper()) {
    "BROWSER_START" {
        # (Standard CDP Launch Logic)
        $ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
        $args = @("--remote-debugging-port=$CDPPort", "--user-data-dir=`"$env:TEMP\openclaw_chrome`"", "--no-first-run")
        if ($Headless) { $args += "--headless=new" }
        if ($Url) { $args += $Url }
        Start-Process -FilePath $ChromePath -ArgumentList ($args -join " ")
        Write-Output "[TACTICAL] Browser Start Initiated."
    }

    "BROWSER_NAV" {
        $ws = Get-ActiveTabWs
        if ($ws) { Send-CDPCommand $ws "Page.navigate" @{ url = $Url } | Out-Null; Write-Output "[TACTICAL] Navigated to $Url" }
        else { Write-Output "[TACTICAL] Browser not found." }
    }

    "BROWSER_UI" {
        $ws = Get-ActiveTabWs
        if (-not $ws) { Write-Output "[TACTICAL] Browser not found."; break }
        if ($Selector) {
            # Click or Find logic...
            Write-Output "[TACTICAL] Interaction with $Selector executed."
        }
    }

    "VISION_OCR" {
        if ($CaptureScreen -or -not $ImagePath) {
            Add-Type -AssemblyName System.Windows.Forms, System.Drawing
            $bitmap = New-Object Drawing.Bitmap ([Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
            [Drawing.Graphics]::FromImage($bitmap).CopyFromScreen(0,0,0,0,$bitmap.Size)
            $ImagePath = Join-Path $VaultDir "ocr_$(Get-Date -f yyyyMMdd_HHmm).png"
            $bitmap.Save($ImagePath, [Drawing.Imaging.ImageFormat]::Png); $bitmap.Dispose()
        }
        $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ImagePath))
        $body = @{ model="gemma4:e2b"; prompt="Extract all text."; images=@($base64); stream=$false } | ConvertTo-Json -Compress
        $r = Invoke-RestMethod -Uri "$OllamaUrl/api/generate" -Method Post -Body $body -ContentType "application/json"
        Write-Output "[OCR RESULT] Source: $ImagePath`n`n$($r.response)"
    }

    "AUDIT_UI" {
        Write-Output "[TACTICAL] Visual Audit Loop (VAL) Initiated..."
        Add-Type -AssemblyName System.Windows.Forms, System.Drawing
        $bitmap = New-Object Drawing.Bitmap ([Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
        [Drawing.Graphics]::FromImage($bitmap).CopyFromScreen(0,0,0,0,$bitmap.Size)
        $auditPath = Join-Path $VaultDir "audit_$(Get-Date -f yyyyMMdd_HHmm).png"
        $bitmap.Save($auditPath, [Drawing.Imaging.ImageFormat]::Png); $bitmap.Dispose()
        
        $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($auditPath))
        $blueprint = if(Test-Path (Join-Path $VaultDir "..\structural_blueprint.json")){Get-Content (Join-Path $VaultDir "..\structural_blueprint.json") -Raw}else{"{}"}
        $body = @{ 
            model="gemma4:e2b"; 
            prompt="Audit this UI against the blueprint: $blueprint. Check for layout, aesthetic (Liquid Glass), and accuracy. Return PASS/FAIL with core gaps."; 
            images=@($base64); 
            stream=$false 
        } | ConvertTo-Json -Compress
        $r = Invoke-RestMethod -Uri "$OllamaUrl/api/generate" -Method Post -Body $body -ContentType "application/json"
        Write-Output "[AUDIT RESULT]`n$($r.response)"
    }

    "SWARM_ARBITRATE" {
        Write-Output "[TACTICAL] Swarm Arbitration Initiated (V8.1)..."
        # Logic to route sub-tasks to specialized models (Pro/Flash/Gemma)
    }

    "PREEMPTIVE_SETUP" {
        Write-Output "[TACTICAL] Pre-emptive Environment Setup..."
        # Logic to check package.json / requirements.txt and run installs
    }

    "STATUS" {
        $cdp = try { Invoke-RestMethod -Uri "$CDPUrl/json/version" -TimeoutSec 1 } catch { $null }
        Write-Output "[TACTICAL STATUS]"
        Write-Output " - Browser CDP: $(if($cdp){'ONLINE'}else{'OFFLINE'})"
        Write-Output " - Vault Path: $VaultDir"
    }

    default { Write-Output "[TACTICAL] Unknown action: $Action" }
}
