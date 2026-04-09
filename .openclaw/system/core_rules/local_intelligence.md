# OpenClaw: Local Intelligence Vault (PRIVATE)

> [!CAUTION]
> **Identity**: OPENCLAW_LOCAL_V1.0
> **Scope**: PC-Specific configurations, mission logs, and sensitive workspace data.
> **Sync Type**: LOCAL ONLY. **DO NOT GIT SYNC.**

## 🆔 1. MACHINE FINGERPRINT
- **PC Identity**: XIN
- **Hardware Profile**: Linked to `_shared/hardware_ledger.md`.
- **Primary GPU**: NVIDIA GeForce RTX 2070 (8GB).

## 🌐 2. OFFICIAL INTEL (GITHUB/DOCS)
- **Official Repo**: https://github.com/openclaw/openclaw
- **Gateway Docs**: https://docs.openclaw.ai/
- **ClawHub (Skills)**: https://clawhub.ai

## 🛠️ 3. LOCAL OVERRIDES
- **Model Lock**: Use `my-gpu-gemma` (7.2GB) only.
- **Mission Cache**: Points to `c:\Users\User\OneDrive\Desktop\workspace\archive\failed_missions\`.

## 🚀 4. OPENCLAW PRO V30.1 SETUP (OFFICIAL)
To fully integrate the Global Gateway logic, execute these steps in an Administrative Shell:
1. **CLI Install**: `cmd /c npm install -g openclaw`
2. **Onboarding**: `openclaw setup`
3. **Gateway**: `openclaw start`

*Note: The local PowerShell UI is already synced with the local Gemma-4 Brain and will operate in parallel to the Global Gateway.*

## 📈 3. LOCAL SUCCESS MATRIX
- **Mission Tracking**: All local SPM (Satoshi-per-Minute) data should be summarized here before being purged from temporary logs.

---
_Local Vault Initialized: 2026-04-09_
