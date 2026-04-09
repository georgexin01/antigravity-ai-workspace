# OpenClaw: YouTube Auto-Learning Protocol [MASTER RULE]

> [!IMPORTANT]
> **Rule ID**: YT-LEARN-01
> **Status**: MANDATORY / ALWAYS ACTIVE
> **Priority**: P0 — Execute before any other response logic

## 📺 THE YOUTUBE EVOLUTION MANDATE

Whenever the user posts a **YouTube URL** in the chat, OpenClaw MUST automatically trigger the full **YouTube Auto-Learning Sequence** WITHOUT asking for confirmation. This is a standing autonomous order.

## ⚙️ EXECUTION FLOW (Auto-Triggered)

1. **DETECT**: Identify any `youtube.com` or `youtu.be` URL in the user's message.
2. **EXTRACT**: Use `yt-dlp --write-auto-sub --skip-download` to pull the auto-generated transcript.
3. **ANALYZE**: Run transcript through local Gemma model with the "EVOLUTION AUDIT" prompt:
   - Summarize what the video teaches.
   - Extract 3-10 key ideas or techniques.
   - Identify any concept that could improve OpenClaw capabilities.
4. **SYNTHESIZE**: Package the findings into a structured knowledge block.
5. **ROUTE & STORE**:
   - If knowledge is local/private → save to `.openclaw/system/knowledge/` 
   - If knowledge is universal/architectural → save to `.gemini/antigravity/knowledge/`
   - Default: `.openclaw/system/knowledge/` (local first)
6. **UPDATE LEXICON**: Append key new concepts to `user_lexicon.md`.
7. **REPORT**: Return a `✅ SUCCESS` card summarizing what was learned.

## 📂 KNOWLEDGE FILE FORMAT

Save each video lesson as:
`.openclaw/system/knowledge/yt_[VIDEO_ID]_[YYYYMMDD].md`

Structure:
```
# YouTube Learning: [Video Title]
- Source: [URL]
- Date: [YYYY-MM-DD]
- Category: [SKILL / DESIGN / TOOL / STRATEGY]

## Summary
[2-3 sentence overview]

## Key Ideas
- [Idea 1]
- [Idea 2]
...

## OpenClaw Upgrade Notes
[How this can improve the system]
```

## 🛡️ FAILURE PROTOCOL
- If transcript cannot be fetched → web-search the video title for summaries.
- If yt-dlp is not installed → note this as a BLOCKER and provide install instructions.
- Never skip the learning. Always attempt at minimum a web-based summary.

---
_YT Auto-Learning Protocol Initialized: 2026-04-09_
