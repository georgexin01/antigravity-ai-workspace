# OPENCLAW SKILL: CONSULTATION CARD [V1.0]
# ==========================================
# [PURPOSE]: Proactive logic analysis before code execution
# [SOURCE]: Claude Mythos V6.0 Synergy Pattern
# [ACTION]: ANALYZE

param(
    [string]$TaskName = "New Task",
    [string]$TargetModule = "",
    [string]$ProposedLogic = ""
)

function Show-ConsultationCard {
    $card = @"
┌─────────────────────────────────────────┐
│ SOVEREIGN CONSULTATION CARD             │
│ MISSION: $TaskName             │
│                                         │
│ Analyzed Patterns:                      │
$($ProposedLogic -replace '^', '│   • ' -replace '`n', "`n│   • ")
│                                         │
│ Confirm Execution? [Yes / Modify]       │
└─────────────────────────────────────────┘
"@
    Write-Output $card
}

Show-ConsultationCard
