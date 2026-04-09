# OpenClaw: Execution P0 & GPU Mandate

> [!IMPORTANT]
> **GPU First**: ALL Level 3 Cognition (Vision, Captchas, Heavy Data Scrapes) MUST be delegated to the local GPU.
> **Target Velocity**: 35-45 t/s. 
> **Handshake Limit**: 120s (Extended for VRAM Loading).

## ⚡ 1. GPU PERFORMANCE LAWS
- **Identity Lock**: Check `core_rules/system_identity.md` before query.
- **VRAM Safeguard (P0)**: Current limit is **8GB**. Monitor `nvidia-smi`.
- **Model Mandate**: Always use Tiered Models. Chat (Tier 1) uses 2B model. Mission (Tier 2) uses 7B model.

## 🛠️ 2. EXECUTION STANDARDS (SOVEREIGN)
- **Build First**: Run `npm run build` (or equivalent) before any production deployment or mission wave.
- **Dynamic Targeting**: Never use static X/Y coordinates for browser buttons. Always re-calculate bounding boxes via ZTV/JS after every page refresh.
- **Unique Outlier Logic**: For icon-based captchas, filter for the 4 similar "distractors" and extract the 1 unique outlier.
- **Failure Threshold**: If velocity < 10 t/s, flush OClaw process and restart model.

## 🦅 2. THE GHOST PROTOCOL (LOCAL DISCOVERY)
OpenClaw works as the "Structural Architect" (Local Expert).
- **Discovery**: Use Gemma4 to scan for code-level gaps and structural anomalies before cloud planning.
- **Mission Briefing**: Gemini-3 (Cloud) sends a **Structural Mission Briefing** to OpenClaw. OpenClaw handles the dense code drafting.
- **Review Loop**: 100% of local code output MUST be reviewed by Gemini-3 before merging.

## 🧹 3. AUTO-CLEANUP & RETENTION
OpenClaw is an active janitor.
- **Recordings**: Purge `.webp` files immediately after session.
- **Temp Scripts**: Delete scratch scripts in `/workspace/.tmp/` after use.
- **Logs**: Summarize mission results to `local_success_matrix.md`, then purge raw logs.

## 🛡️ 4. THE ERROR ESCALATION PROTOCOL (MANDATORY)
1. **CHECK VAULT**: Verify `_shared/error_learning_vault.md` for existing fixes.
2. **DEBUG + FIX (1)**: Identify root cause and attempt direct fix.
3. **ALTERNATIVE (2)**: Try a different approach/logic if the first fails.
4. **SWAP COMPONENT (3)**: Replace the approach entirely if unstable.
5. **NOTIFY USER**: Halt after 3 failed attempts and present the "Blocker Card."

## 👁️ 5. VISION MASTER RULE (SNIPASTE HANDSHAKE)
- **Tool**: Snipaste (F1)
- **Activation**: Signal "VISION_PULSE" in chat.
- **Workflow**: OpenClaw triggers `auto_pulse.ps1` -> Reads `active_mission.png` -> Evaluates visual state via ZTV Engine.

## 🛡️ 6. SOVEREIGN LEARNING (PHOENIX PROTOCOL)
- **Rule**: On ANY mission failure, trigger the **10-pass Recursive Analysis**.
- **Consensus**: Synthesize a "Golden Rule" and append it to this local vault.

---
_Execution Rules Initialized: 2026-04-09_
