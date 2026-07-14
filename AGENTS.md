# Agent map — Dealer Platform

> **Bundle v1.1.0** — from `Desktop/VueNestJs Agent/`. Not in app repo. Update: `.\update.ps1` in bundle folder.

Quick index for Cursor agents, rules, and supplementary skills in `code/`.

## Document map

| Document                                                                           | Role                                                              |
| ---------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| **This file** (`AGENTS.md`)                                                        | Index — which agent/skill to use                                  |
| [`.cursor/stack-profile.md`](.cursor/stack-profile.md)                             | Active stack + which supplementary references apply               |
| [`.cursor/skills/platform-agents/workflows.md`](.cursor/skills/platform-agents/workflows.md) | Skill chains per scenario (create, refactor, full-stack) |
| [`.cursor/skills/platform-agents/bugfix.md`](.cursor/skills/platform-agents/bugfix.md) | Bugfix — symptom → layer agent (read only for bugfix) |
| [`.cursor/specialists/decision.md`](.cursor/specialists/decision.md) | **Start here** — intent → which doc to read (token-efficient) |
| [`.cursor/specialists/README.md`](.cursor/specialists/README.md) | Supplementary routing index |
| [`.cursor/skills/README.md`](.cursor/skills/README.md) | Domain agents + orchestration index |
| [`.cursor/skills/platform-agents/SKILL.md`](.cursor/skills/platform-agents/SKILL.md) | Orchestration, handoffs, default execution order |
| [`.cursor/skills/platform-agents/reference.md`](.cursor/skills/platform-agents/reference.md) | Project layout, naming, layers |
| [`.cursor/rules/`](.cursor/rules/) | **Authoritative conventions** (always win over skills) |
| [`.agents/skills/`](.agents/skills/) | Third-party supplementary skill **content** (`npx skills add`) |

> **Note:** `platform-agents` orchestrates **full-stack** work (Vue `ui/` + NestJS `src/ui-api/`), not Vue-only.

## Naming conventions

| Prefix | Role | Examples |
| ------ | ---- | -------- |
| **`platform-*`** | Cross-cutting orchestration & audit (Vue + NestJS) | `platform-agents`, `platform-review-agent`, `platform-performance-agent` |
| **`vue-*`** | Vue/UI layer domain agents (pair with `vue.mdc`) | `vue-component-creator`, `vue-router-agent` |
| **Layer name** | Single-stack domain agents | `pinia-architect`, `pinia-colada-expert`, `nestjs-api-agent`, `data-grid-agent` |

`vue-*` on UI agents is intentional — they implement `vue.mdc`, not full-stack orchestration. Supplementary skills keep upstream names (`vue-best-practices`, `nestjs-expert`, …).

## Authority (precedence)

```
1. .cursor/rules/*.mdc           ← project conventions (highest)
2. .cursor/skills/*-agent/       ← domain agents (project-specific)
3. .cursor/specialists/          ← when to read which supplementary (routing index)
4. .agents/skills/*              ← supplementary skill content (explicit-read)
```

Supplementary skills may say "MUST be used" in their own `SKILL.md` — **ignore that** unless `stack-profile.md` lists them as active for the current stack.

## Quick routing

Unsure which doc to open? → **[decision.md](.cursor/specialists/decision.md)** (one page, **one branch** — do not read every linked file).

**Token discipline:** read `decision.md` → follow **one** recipe chain → one domain agent SKILL per pass. Do not preload `workflows.md` + `bugfix.md` + all supplementary skills at start.

## How agents work (mandatory)

1. Match intent → **[decision.md](.cursor/specialists/decision.md)** or directly: [workflows.md](.cursor/skills/platform-agents/workflows.md) (create/refactor) · [bugfix.md](.cursor/skills/platform-agents/bugfix.md) (fix existing).
2. **Multi-step / multi-layer** (screen + API, store + UI, grid, cross-layer bugfix) → [agent-orchestration.mdc](.cursor/rules/agent-orchestration.mdc).
3. **New component** → [New component (default)](.cursor/skills/platform-agents/workflows.md#new-component-default) · **Refactor** → [Refactor (default)](.cursor/skills/platform-agents/workflows.md#refactor-default) · **Bugfix** → [bugfix.md](.cursor/skills/platform-agents/bugfix.md) · **Trivial** → [Quick fix](.cursor/skills/platform-agents/workflows.md#quick-fix-skip-full-workflow).
4. **Supplementary** — after each domain agent: [vue-tier](.cursor/specialists/vue-tier.md) / [backend-tier](.cursor/specialists/backend-tier.md) / [by-agent](.cursor/specialists/by-agent.md) → skill [cards](.cursor/specialists/skills/README.md) → `.agents/skills/` ([specialists.mdc](.cursor/rules/specialists.mdc)).
5. **Read** [platform-agents/SKILL.md](.cursor/skills/platform-agents/SKILL.md) for handoffs on multi-step chains.
6. **Read** one domain skill per pass: `.cursor/skills/{skill-name}/SKILL.md`.
7. End with **platform-review-agent** unless Quick fix applies; then **platform-performance-agent** per workflows → _When to add perf audit_.

## Domain agents (auto-invoke)

Read the full skill file before coding.

| Skill                   | SKILL.md | Rule               |
| ----------------------- | -------- | ------------------ |
| `vue-component-creator` | [SKILL.md](.cursor/skills/vue-component-creator/SKILL.md) | `vue.mdc`          |
| `vue-router-agent`      | [SKILL.md](.cursor/skills/vue-router-agent/SKILL.md) | `vue.mdc`          |
| `pinia-architect`       | [SKILL.md](.cursor/skills/pinia-architect/SKILL.md) | `pinia-stores.mdc` |
| `pinia-colada-expert`   | [SKILL.md](.cursor/skills/pinia-colada-expert/SKILL.md) | `pinia-colada.mdc` |
| `data-grid-agent`       | [SKILL.md](.cursor/skills/data-grid-agent/SKILL.md) | `data-grid.mdc`    |
| `nestjs-api-agent`      | [SKILL.md](.cursor/skills/nestjs-api-agent/SKILL.md) | `nestjs.mdc`       |

## Orchestration & audit (explicit read)

| Skill                   | When                                             |
| ----------------------- | ------------------------------------------------ |
| `platform-agents`       | Multi-step planning, skill chain selection       |
| `platform-review-agent`     | Final architecture review (read-only)            |
| `platform-performance-agent`| Reactivity/render audit after review (read-only) |

## Supplementary skills (explicit read)

Installed under `.agents/skills/`. **When to pull** each: [specialists index](.cursor/specialists/README.md) · tier: [vue](.cursor/specialists/vue-tier.md) / [backend](.cursor/specialists/backend-tier.md) · [by-agent map](.cursor/specialists/by-agent.md). Not a domain agent — no handoff.

| Skill                       | Card                                                                 | Active refs                                             | Pair with               |
| --------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------- | ----------------------- |
| `vue-best-practices`        | [card](.cursor/specialists/skills/vue-best-practices.md)             | [Frontend](.cursor/stack-profile.md#frontend-stack)     | `vue-component-creator` |
| `vue` (antfu)               | [card](.cursor/specialists/skills/vue.md)                            | [Frontend](.cursor/stack-profile.md#frontend-stack)     | `vue-component-creator` |
| `vue-expert`                | [card](.cursor/specialists/skills/vue-expert.md)                     | [Frontend](.cursor/stack-profile.md#frontend-stack)     | `vue-component-creator` |
| `vue-router-best-practices` | [card](.cursor/specialists/skills/vue-router-best-practices.md)      | [Frontend](.cursor/stack-profile.md#frontend-stack)     | `vue-router-agent`      |
| `vue-pinia-best-practices`  | [card](.cursor/specialists/skills/vue-pinia-best-practices.md)       | [Frontend](.cursor/stack-profile.md#frontend-stack)     | `pinia-architect`       |
| `nestjs-best-practices`     | [card](.cursor/specialists/skills/nestjs-best-practices.md)        | [Backend](.cursor/stack-profile.md#backend-stack)       | `nestjs-api-agent`, `data-grid-agent` |
| `nestjs-expert`             | [card](.cursor/specialists/skills/nestjs-expert.md)                | [Backend](.cursor/stack-profile.md#backend-stack)       | `nestjs-api-agent`      |
| `typescript-advanced-types` | [card](.cursor/specialists/skills/typescript-advanced-types.md)      | [TypeScript](.cursor/stack-profile.md#typescript-stack) | any domain agent        |
| `typescript-expert`         | [card](.cursor/specialists/skills/typescript-expert.md)            | [TypeScript](.cursor/stack-profile.md#typescript-stack) | any domain agent        |

Install / update: [specialists/skills/install.md](.cursor/specialists/skills/install.md) (SSOT from `skills-lock.json`). Validate locally: `node .cursor/scripts/validate-agent-links.mjs`.

## Rules (`.cursor/rules/`)

| Rule                    | Scope                                                       |
| ----------------------- | ----------------------------------------------------------- |
| `general.mdc`           | Monorepo, data layers, git — **always on**                  |
| `agent-orchestration.mdc` | Trigger → multi-step chains, workflows                    |
| `specialists.mdc`       | Trigger → [specialists/](.cursor/specialists/README.md) after domain agent |
| `component-creation.mdc` | Trigger → `workflows.md` _New component (default)_          |
| `component-refactor.mdc` | Trigger → `workflows.md` _Refactor (default)_               |
| `bugfix.mdc`             | Trigger → `bugfix.md` symptom → layer                       |
| `vue.mdc`          | Vue 3, Vuetify, Vue Router, VueUse         |
| `pinia-stores.mdc` | Pinia setup stores                         |
| `pinia-colada.mdc` | Cached read queries                        |
| `services.mdc`     | Frontend HTTP (`services/` vs `api/`)      |
| `nestjs.mdc`       | Backend ui-api, domain, DTOs               |
| `data-grid.mdc`    | DataGrid, TreeDataGrid, metadata           |
| `i18n.mdc`         | Locale keys, `useI18n`, `useAppI18n`       |
