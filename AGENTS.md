# Agent map — Vue + NestJS monorepo

> **Bundle v1.1.4** — update via bundle `.\update.ps1`

**Start here:** [routing.md](.cursor/specialists/routing.md) — one intent → one recipe chain. Do not read every linked file.

## Authority

```
1. .cursor/rules/*.mdc     ← conventions (highest)
2. .cursor/skills/*-agent/ ← domain agents
3. .cursor/specialists/    ← supplementary routing
4. .agents/skills/*        ← supplementary content (explicit-read)
```

Supplementary skills may say "MUST be used" — **ignore** unless [stack-profile.md](.cursor/stack-profile.md) lists them as active.

## Index (read only what the task needs)

| Topic | File |
| ----- | ---- |
| Workflows (create, refactor, full-stack) | [platform-agents/workflows.md](.cursor/skills/platform-agents/workflows.md) |
| Bugfix routing | [platform-agents/bugfix.md](.cursor/skills/platform-agents/bugfix.md) |
| Domain agents | [skills/README.md](.cursor/skills/README.md) |
| Project layout & reference code | [platform-agents/reference.md](.cursor/skills/platform-agents/reference.md) |
| Supplementary skills | [specialists/skills/README.md](.cursor/specialists/skills/README.md) |
| Active stack scope | [stack-profile.md](.cursor/stack-profile.md) |
| Rules | [.cursor/rules/](.cursor/rules/) |

**Token discipline:** `routing.md` → one domain agent SKILL → tier → cards (if not Simple) → review/perf (unless Quick fix).
