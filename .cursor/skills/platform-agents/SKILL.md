---
name: platform-agents
description: Orchestrates Vue + NestJS full-stack monorepo work (ui/ + /uiapi/) — picks workflows, specialized skills in order, and handoffs. Use when planning or implementing any screen, list, form, store, Colada query, backend endpoint, bugfix, refactor, or multi-step task in ui/ or src/.
disable-model-invocation: true
---

# Multi-Agent Workflow (full-stack)

Orchestrates **Vue frontend** (`code/ui/`) and **NestJS backend** (`code/src/`, `/uiapi/`) — full-stack, not Vue-only.

Split work across specialized skills. **Read and follow one skill per pass** — do not mix roles in a single pass.

**Recipes in [workflows.md](workflows.md) override** the default execution order below.

## Auto-invoke skills (mandatory)

Before writing code for any task covered by this map:

0. **Non-trivial task** → read [workflows.md](workflows.md); after each domain agent → [specialists/README.md](../../specialists/README.md) ([specialists.mdc](../../rules/specialists.mdc)).
1. Pick the workflow from [workflows.md](workflows.md).
2. For each step, **read** the skill file: `.cursor/skills/{skill-name}/SKILL.md`.
   - **Domain skills** (`vue-component-creator`, `vue-router-agent`, `pinia-architect`, `pinia-colada-expert`, `data-grid-agent`, `nestjs-api-agent`) — auto-invoke from task context; always read the full file before coding.
   - **This file, `platform-review-agent`, `platform-performance-agent`** — read explicitly via path from `AGENTS.md` or the workflow chain; do not rely on auto-discovery.
3. Implement only that skill's scope; output a [Handoff](#handoff-format).
4. **Read** the next skill in the chain and continue until the workflow is complete.
5. Skip steps that do not apply; never skip `platform-review-agent` on feature work unless the user asked for a minimal quick fix.
6. After review, **read** `platform-performance-agent` when the change touches UI or reactivity — see [workflows.md](workflows.md) → _When to add perf audit_.

**New component** → [workflows.md → New component (default)](workflows.md#new-component-default). **Refactor** → [Refactor (default)](workflows.md#refactor-default). **Quick fix** (user says so, or trivial one-liner / i18n / typo) → [Quick fix](workflows.md#quick-fix-skip-full-workflow): `vue-component-creator` only.

Classify [Vue tier](workflows.md#new-component-default) via [vue-tier.md](../../specialists/vue-tier.md) before writing `.vue` code.

## Authoritative conventions (`.cursor/rules/`)

Skills implement workflow; **rules define conventions**. When in doubt, read the rule file:

| Rule                                             | Agent skills that use it                                                                 |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------- |
| [general.mdc](../../rules/general.mdc)           | All                                                                                      |
| [vue.mdc](../../rules/vue.mdc)                   | `vue-component-creator`, `vue-router-agent`, `platform-review-agent`, `platform-performance-agent` |
| [pinia-stores.mdc](../../rules/pinia-stores.mdc) | `pinia-architect`, `platform-review-agent`                                                    |
| [pinia-colada.mdc](../../rules/pinia-colada.mdc) | `pinia-colada-expert`, `platform-review-agent`, `platform-performance-agent`                       |
| [services.mdc](../../rules/services.mdc)         | `vue-component-creator`, `pinia-colada-expert`, `platform-review-agent`, `nestjs-api-agent`   |
| [nestjs.mdc](../../rules/nestjs.mdc)             | `nestjs-api-agent`, `platform-review-agent`, `data-grid-agent`                                |
| [data-grid.mdc](../../rules/data-grid.mdc)       | `data-grid-agent`, `platform-review-agent`                                                    |
| [i18n.mdc](../../rules/i18n.mdc)                 | `vue-component-creator`, `data-grid-agent`, `platform-review-agent`                           |

## Prefer latest patterns

Every agent must follow **current** conventions from `.cursor/rules/` — not legacy code copied from old domains.

- New features → newest layer for the job (Colada for reads, VueUse for DOM, `defineModel`, typed setup stores).
- Reference implementations in **your** repo (see [reference.md](reference.md)) beat ad-hoc legacy patterns.
- When rules and neighbouring legacy code conflict on **new** code, rules win. Ask before widening scope to refactor legacy.

## Rule

Do not write code if information is missing.
Ask questions first.

## Project resources

- [workflows.md](workflows.md) · [bugfix.md](bugfix.md) · [specialists/README.md](../../specialists/README.md) · [reference.md](reference.md) · [examples.md](examples.md)
- Stack profiles: [Frontend](../../stack-profile.md#frontend-stack) · [Backend](../../stack-profile.md#backend-stack) · [TypeScript](../../stack-profile.md#typescript-stack) in [stack-profile.md](../../stack-profile.md)

## Agent map

| Task                                                     | Skill                       | Primary rule                                                                                         |
| -------------------------------------------------------- | --------------------------- | ---------------------------------------------------------------------------------------------------- |
| New `.vue`, props, emits, Vuetify, VueUse, i18n in views | `vue-component-creator`     | `vue.mdc`                                                                                            |
| Vue reactivity/SFC gotchas (supplementary)               | `vue-best-practices`        | [skills/vue-best-practices.md](../../specialists/skills/vue-best-practices.md) · `vue.mdc` |
| Vue 3.5 API reference (supplementary)                    | `vue`                       | [card](../../specialists/skills/vue.md) · `vue.mdc` |
| Advanced Vue patterns (supplementary)                    | `vue-expert`                | [card](../../specialists/skills/vue-expert.md) · `vue.mdc` |
| Routes, guards, `meta`, navigation wiring                | `vue-router-agent`          | `vue.mdc`                                                                                            |
| Vue Router gotchas (supplementary)                       | `vue-router-best-practices` | [card](../../specialists/skills/vue-router-best-practices.md) · `vue.mdc` |
| Pinia store design, actions                              | `pinia-architect`           | `pinia-stores.mdc`                                                                                   |
| Pinia reactivity gotchas (supplementary)                 | `vue-pinia-best-practices`  | [card](../../specialists/skills/vue-pinia-best-practices.md) · `pinia-stores.mdc` |
| Colada queries, cache keys                               | `pinia-colada-expert`       | `pinia-colada.mdc`                                                                                   |
| Backend `/uiapi` endpoints                               | `nestjs-api-agent`          | `nestjs.mdc`                                                                                         |
| NestJS architecture gotchas (supplementary)              | `nestjs-best-practices`     | [card](../../specialists/skills/nestjs-best-practices.md) · [Backend](../../stack-profile.md#backend-stack) |
| Advanced NestJS patterns (supplementary)                 | `nestjs-expert`             | [card](../../specialists/skills/nestjs-expert.md) · [Backend](../../stack-profile.md#backend-stack) |
| TypeScript advanced types (supplementary)                | `typescript-advanced-types` | [card](../../specialists/skills/typescript-advanced-types.md) · [TypeScript](../../stack-profile.md#typescript-stack) |
| TypeScript debugging (supplementary)                     | `typescript-expert`         | [card](../../specialists/skills/typescript-expert.md) · [TypeScript](../../stack-profile.md#typescript-stack) |
| List screens, grid metadata                              | `data-grid-agent`           | `data-grid.mdc`                                                                                      |
| Architecture compliance                                  | `platform-review-agent`          | all rules                                                                                            |
| Watchers, re-renders, perf                               | `platform-performance-agent`     | `vue.mdc` + `pinia-colada.mdc`                                                                       |

## Execution order (default stack)

Use this order when multiple layers are involved. Skip steps that do not apply.

```
1. pinia-architect      → store shape (if needed)
2. pinia-colada-expert  → queries (if new cached reads)
3. nestjs-api-agent     → backend endpoint (if new API)
4. data-grid-agent      → list screen + metadata (if DataGrid)
5. vue-router-agent     → routes / guards / meta (if new screens or paths)
6. vue-component-creator → wire UI to stores/services/queries
7. platform-review-agent     → verify against rules
8. platform-performance-agent → audit reactivity (after review, when UI/reactivity — see workflows.md)
```

**Legacy domains** often need only `vue-component-creator` + store/service edits — skip Colada unless adding new cached reads.

Workflow recipes (skill chains, perf audit, bugfix layer): [workflows.md](workflows.md).

## Boundaries

- **Components** — stores, composables, Colada; no Axios clients (`general.mdc`, `vue.mdc`)
- **Stores** — `services/`; no new read caches (`pinia-stores.mdc`)
- **Colada** — `queries/` + `api/` (`pinia-colada.mdc`)
- **Review / Performance** — read-only unless user asks to fix after audit

## Handoff format

After each skill pass, output:

```markdown
## Handoff

- **Done**: [what was created/changed]
- **Files**: [paths]
- **Next agent**: [skill name]
- **Rules checked**: [e.g. vue.mdc, pinia-stores.mdc]
- **Notes**: [assumptions, open questions]
```

Then **read** `.cursor/skills/{next-agent}/SKILL.md` and continue.
