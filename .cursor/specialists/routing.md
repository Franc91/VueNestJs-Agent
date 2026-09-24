# Agent routing — which file to read

**Token budget wins.** You already have [conventions.md](../cache/conventions.md). Do not open `workflows.md`, `stack-profile.md`, or `platform-agents/SKILL.md` unless one row below has no matching skill. Do not read `.agents/skills/**`, review, or perf unless the user asked or the task is Substantial.

One screen — pick **one** row in §1, then read **one** domain skill. Do not read every file below.

**Stop rules:** Quick fix → implement → **stop** (no review, no supplementary). Review-only / perf-only → one audit SKILL → **stop**.

## 1. What is the user asking?

| Intent | Read | Then |
| ------ | ---- | ---- |
| Typo, i18n, cosmetic, *szybka poprawka* / *bez review* | [Quick fix](../skills/platform-agents/workflows.md#quick-fix-skip-full-workflow) | `vue-component-creator` only — **stop** |
| Create / scaffold new `.vue` | [New component](../skills/platform-agents/workflows.md#new-component-default) | pre-steps → [vue-tier](vue-tier.md) → domain agent |
| Refactor / migrate / modernize UI | [Refactor](../skills/platform-agents/workflows.md#refactor-default) | deepest layer → tier → domain agents |
| Fix bug on **existing** screen | [bugfix.md](../skills/platform-agents/bugfix.md) | symptom row → domain agent |
| New screen + API + store / grid | [agent-orchestration.mdc](../rules/agent-orchestration.mdc) | [workflows.md](../skills/platform-agents/workflows.md) |
| Architecture review only | [platform-review-agent/SKILL.md](../skills/platform-review-agent/SKILL.md) | read-only — **stop** |
| Perf / slow renders only | [platform-performance-agent/SKILL.md](../skills/platform-performance-agent/SKILL.md) | read-only — **stop** |

## 2. After each domain agent pass

Skip this section on Simple and Standard work. The conventions cache is enough.

| Layer changed | Classify | Map |
| ------------- | -------- | --- |
| `.vue` component | [vue-tier.md](vue-tier.md) | Simple and Standard → skip supplementary |
| `/uiapi` backend | [backend-tier.md](backend-tier.md) | Simple and Standard → skip supplementary |
| router / store / Colada / grid | [by-agent.md](by-agent.md) | supplementary only when blocked |

Open a [skill card](skills/README.md) only for **Substantial** work, then one active reference — not the whole `.agents/skills` tree.

## 3. End of feature work

Skip review and perf unless the user asked, or the task is Substantial.

1. [platform-review-agent](../skills/platform-review-agent/SKILL.md)
2. [platform-performance-agent](../skills/platform-performance-agent/SKILL.md) if UI/reactivity — [when to add perf audit](../skills/platform-agents/workflows.md#when-to-add-perf-audit)

## Authority

```
rules (.mdc)  →  domain agent SKILL  →  specialists (routing)  →  .agents/skills (content)
```

Index: [AGENTS.md](../../AGENTS.md) · Install supplementary: [skills/install.md](skills/install.md)
