# OPENCLAW SOVEREIGN SUITE: SYSTEM [V2.0]
# =========================================
# [ACTIONS]: DAEMON_START, DAEMON_STATUS, WINDOW_LIST, WINDOW_FOCUS, GPU_STATUS, SECURITY_SCAN, LOG_VITAL

param(
    [string]$Action = "VITAL_STATUS",
    [string]$Title = "",
    [int]$ProcessId = 0,
    [string]$Message = ""
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogsDir = Join-Path $PSScriptRoot "..\..\logs"
if (-not (Test-Path $LogsDir)) { New-Item -ItemType Directory -Path $LogsDir -Force | Out-Null }

# --- WIN32 API HELPERS ---
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
}
"@

# --- ACTIONS ---
switch ($Action.ToUpper()) {
    "WINDOW_LIST" {
        $windows = Get-Process | Where-Object { $_.MainWindowTitle -and $_.MainWindowHandle -ne [IntPtr]::Zero }
        $output = "[WINDOW LIST] Found $($windows.Count):`n"
        foreach ($w in $windows) { $output += "  [PID $($w.Id)] $($w.ProcessName) -> `"$($w.MainWindowTitle)`"`n" }
        Write-Output $output
    }

    "WINDOW_FOCUS" {
        $target = Get-Process | Where-Object { $_.MainWindowTitle -match $Title -or $_.Id -eq $ProcessId } | Select-Object -First 1
        if ($target) {
            [WinAPI]::ShowWindow($target.MainWindowHandle, 9) | Out-Null
            [WinAPI]::SetForegroundWindow($target.MainWindowHandle) | Out-Null
            Write-Output "[SYSTEM] Focused window: $($target.ProcessName)"
        }
    }

    "GPU_STATUS" {
        if (Get-Command "nvidia-smi" -ErrorAction SilentlyContinue) {
            $stats = nvidia-smi --query-gpu=name,memory.total,memory.used,utilization.gpu --format=csv,noheader,nounits,index=0
            $p = $stats[0].Split(',')
            Write-Output "{"Name": "$($p[0].Trim())", "Total": $($p[1]), "Used": $($p[2]), "Util": $($p[3])}"
        } else { Write-Output "{"Error": "NVIDIA_NOT_FOUND"}" }
    }

    "CHECK_GUARDRAIL" {
        Write-Output "[SYSTEM] V8.0 Hardware Guardrail Check..."
        $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}}
        if (Get-Command "nvidia-smi" -ErrorAction SilentlyContinue) {
            $free = nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits
            Write-Output "{"Status": "READY", "FreeVRAM": $free, "FreeRAM": $($mem.FreeGB)}"
        } else { Write-Output "{"Status": "CPU_ONLY", "FreeRAM": $($mem.FreeGB)}" }
    }

    "VRAM_WATCHDOG" {
        Write-Output "[SYSTEM] Recursive Hardware Watchdog Active (V8.0)..."
        # Dynamic context-throttling logic triggered via Engine
    }

    "VITAL_STATUS" {
        $cpu = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
        $mem = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeGB";Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}}
        Write-Output "[VITAL STATUS] CPU: $cpu% | Free RAM: $($mem.FreeGB)GB"
    }

    "LOG_VITAL" {
        $ts = Get-Date -f "yyyy-MM-dd HH:mm:ss"
        $entry = "[$ts] $Message"
        Add-Content -Path (Join-Path $LogsDir "sovereign_vitals.log") -Value $entry
        Write-Output "[SYSTEM] Logged vital: $Message"
    }

    default { Write-Output "[SYSTEM] Unknown action: $Action" }
}
