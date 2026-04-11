# OPENCLAW SKILL: CONTEXT COMPRESSOR [V1.0]
# ==========================================
# [PURPOSE]: Synthesize chat history into compact YAML "Memory Nodes"
# [SOURCE]: Claude Mythos V6.0 Architecture
# [ACTION]: COMPRESS

param(
    [string]$LogPath = "../skills_bridge/chat_log.jsonl",
    [string]$NodePath = "../skills_bridge/memory_node.yaml"
)

$LogPath = Join-Path $PSScriptRoot $LogPath
$NodePath = Join-Path $PSScriptRoot $NodePath

if (-not (Test-Path $LogPath)) { Write-Warning "[COMPRESSOR] No chat log found."; exit }

$Log = Get-Content $LogPath | ForEach-Object { try { $_ | ConvertFrom-Json } catch { $null } } | Where-Object { $_ -ne $null }

# Take the last 20 messages or so
$Recent = $Log | Select-Object -Last 20

# Mock Synthesis (In a real scenario, the AI would generate this summary)
$Summary = "Active Objective: Sovereign Singularity Path Restoration. Completed YAML migration of 20 core docs. Initiated Claude Mythos intelligence upgrades. Currently in Wave 1: Context Compression & Module Registry."

$Node = @"
document_metadata:
  identity: "CONSOLIDATED_MEMORY_NODE"
  last_sync: "$(Get-Date -Format 'o')"
  message_count: $($Recent.Count)
content:
  active_context: "$Summary"
  key_entities:
    - identity: "Claude Mythos"
      relevance: "Current Architecture Standard"
    - identity: "YAML Migration"
      relevance: "Completed Foundation"
evolution_log:
  - "Memory Compression Triggered: $(Get-Date -Format 'o')"
"@

Set-Content -Path $NodePath -Value $Node -Encoding UTF8
Write-Host "[SUCCESS] Context compressed into Memory Node: $NodePath" -ForegroundColor Cyan
