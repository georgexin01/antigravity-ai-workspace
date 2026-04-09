# OpenClaw: Frontend Intelligence Laws (P0)

> [!IMPORTANT]
> **Identity**: CLAUDE_FRONTEND_V2.0
> **Mandate**: S-CORE 95 Compliance on ALL local code generation.

## 🏛️ 1. ARCHITECTURAL HIERARCHY
1. **Type Safety**: No `any`. DB interfaces MUST match SQL exactly (snake_case).
2. **Store Correctness**: Setup syntax only. `$reset()` mandatory.
3. **List Rendering**: Handle 3-states (Loading/Empty/Data).
4. **Detail Views**: Supporting dual-mode (Embedded/Page).
5. **Form Integrity**: Validate and emit `submit/cancel`.

## ⚡ 2. NETWORK & SECURITY
- **Request Client**: All calls MUST go through `requestClient`.
- **Soft Delete**: Use `is_delete: true` for removals.
- **Environment**: No secrets in source code.

---
_Frontend Laws Transferred: 2026-04-09_
