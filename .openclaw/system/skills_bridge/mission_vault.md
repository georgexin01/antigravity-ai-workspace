# OpenClaw: Tactical Mission Vault (V1.1)

This vault contains the active protocols for daily repeating tasks and browser-based missions.

## 📱 1. WHATSAPP MONITOR (VISUAL)
- **Pulse Trigger**: Run `auto_pulse.ps1` to capture the browser state.
- **Detection DNA**: 
  - Look for the **Green Dot** (Unread indicator) in the left sidebar.
  - Scan for the **Blue Double Tick** (Read confirmation) or **Grey Tick** (Sent).
- **Auto-Reply**: Generate a concise "Mission Summary" reply draft when a task-related keyword is detected.

## 💰 2. BROWSER MONETIZATION (QUESTS)
- **Claim Detection**: Scan for buttons labeled "Claim," "Redeem," or "Verify."
- **Timer Protocol**: Extract numeric values next to "Next Claim:" or "Timer." 
- **Wait Logic**: If timer > 0, calculate the NEXT_WAVE time and update the GUI status.

## 🦅 3. FAUCET MISSION WAVES
- **Core Tool**: Use `c:\Users\User\OneDrive\Desktop\workspace\faucet\scripts\ztv_v3_solver.ps1`.
- **Constraint**: Only run capture missions when the browser window is in focus.

---
_Tactical Vault Initialized: 2026-04-09_
