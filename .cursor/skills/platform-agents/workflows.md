# Workflow recipes

**Single source of truth** for create/refactor chains and audit rules. Orchestration: [SKILL.md](SKILL.md). Index: [AGENTS.md](../../../AGENTS.md). Bugfix routing: [bugfix.md](bugfix.md). Supplementary index: [specialists/README.md](../../specialists/README.md).

**Recipes override** the generic execution order in [SKILL.md](SKILL.md). Rules [component-creation.mdc](../../rules/component-creation.mdc) and [component-refactor.mdc](../../rules/component-refactor.mdc) are short triggers only.

## Quick fix (skip full workflow)

Use when the user says **quick fix**, **szybka poprawka**, **bez review**, **minimal**, or the change is clearly:

- one-line / typo in an existing file
- i18n or copy only
- cosmetic class/style with no logic change

**Chain:** `vue-component-creator` only — no pre-steps, supplementary skills, handoffs, `platform-review-agent`, or `platform-performance-agent`.

Does **not** apply to: new file scaffold, new screen, refactor, multi-file changes, or store/API/route work.

## New component (default)

When the user asks to **create**, **scaffold**, or **add a new** Vue component (`.vue`). Trigger: [component-creation.mdc](../../rules/component-creation.mdc). Skip this section for [Quick fix](#quick-fix-skip-full-workflow).

**Assess Vue tier** in [vue-tier.md](../../specialists/vue-tier.md) before coding.

| Scope                         | Skill chain                                                                                                                                 |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **New component** (UI only)   | [pre-steps](#pre-steps-new-component) → `vue-component-creator` + supplementary per tier → `platform-review-agent` → `platform-performance-agent` (if data binding — see [When to add perf audit](#when-to-add-perf-audit)) |
| **New component + new route** | `vue-router-agent` (+ [vue-router-best-practices](../../specialists/skills/vue-router-best-practices.md) if guards/params) → chain above |
| **New component + store**     | `pinia-architect` (+ [vue-pinia-best-practices](../../specialists/skills/vue-pinia-best-practices.md)) → chain above |
| **New component + API read**  | `nestjs-api-agent` (if new endpoint) → `pinia-colada-expert` → chain above — tier **Standard** minimum                                    |
| **New component + list**      | `data-grid-agent` (+ `nestjs-api-agent` if new endpoint) → `vue-router-agent` (if new route) → chain above — tier **Standard** minimum    |

### Pre-steps (new component)

Run only layers the feature needs — **do not** run backend/grid/router agents for a simple presentational component with no new route, API, store, or grid.

| Need                         | Domain agent          | Specialist |
| ---------------------------- | --------------------- | ---------- |
| New route / navigation       | `vue-router-agent`    | [vue-router-best-practices](../../specialists/skills/vue-router-best-practices.md) (guards, param lifecycle) |
| New or changed store state   | `pinia-architect`     | [vue-pinia-best-practices](../../specialists/skills/vue-pinia-best-practices.md) |
| New cached read              | `pinia-colada-expert` | [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md) (complex query/payload types) |
| New `/uiapi` endpoint        | `nestjs-api-agent`    | [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md), [nestjs-expert](../../specialists/skills/nestjs-expert.md) (complex modules) |
| List screen / grid metadata  | `data-grid-agent`     | [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md) (backend metadata) |

Map: [by-agent.md](../../specialists/by-agent.md).

**Always** end with `platform-review-agent` (except [Quick fix](#quick-fix-skip-full-workflow)). Add `platform-performance-agent` per [When to add perf audit](#when-to-add-perf-audit).

## Refactor (default)

When the user asks to **refactor**, **restructure**, **migrate**, or **modernize** existing Vue/UI code (not scaffold a new file). Trigger: [component-refactor.mdc](../../rules/component-refactor.mdc). Skip for [Quick fix](#quick-fix-skip-full-workflow).

| Scope                              | Skill chain                                                                                                                                 |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Refactor** (component/view only) | [pick layer](#pick-layer-refactor) → `vue-component-creator` + [specialists tier](../../specialists/vue-tier.md) → `platform-review-agent` → `platform-performance-agent` (if UI/reactivity) |
| **Refactor** (store → Colada)      | `pinia-colada-expert` (+ [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md) if types) → `vue-component-creator` + supplementary per tier → `platform-review-agent` → `platform-performance-agent` |
| **Refactor** (store shape/actions) | `pinia-architect` (+ [vue-pinia-best-practices](../../specialists/skills/vue-pinia-best-practices.md)) → `vue-component-creator` (if views change) → `platform-review-agent` → `platform-performance-agent` |
| **Refactor** (routing)             | `vue-router-agent` (+ [vue-router-best-practices](../../specialists/skills/vue-router-best-practices.md)) → `vue-component-creator` (if views change) → `platform-review-agent` → `platform-performance-agent` |
| **Refactor** (API / DTO)           | `nestjs-api-agent` (+ [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md) / [nestjs-expert](../../specialists/skills/nestjs-expert.md)) → downstream UI agents as needed → `platform-review-agent` (+ `platform-performance-agent` if UI) |
| **Refactor** (list / grid)         | `data-grid-agent` (+ `nestjs-api-agent` if backend metadata) → `vue-component-creator` / `vue-router-agent` as needed → `platform-review-agent` → `platform-performance-agent` |
| **Refactor** (i18n / copy only)    | [Quick fix](#quick-fix-skip-full-workflow) if trivial; else `vue-component-creator` → `platform-review-agent` — skip perf |

### Pick layer (refactor)

Start with the **deepest layer** being changed, then move up to UI. Use [bugfix.md](bugfix.md) when the symptom is clear; otherwise:

| What changes                         | Start with            | Supplementary |
| ------------------------------------ | --------------------- | ------------- |
| Cached reads: store cache → Colada   | `pinia-colada-expert` | [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md) (complex query/payload types) |
| Store actions, selection, modal state | `pinia-architect`     | [vue-pinia-best-practices](../../specialists/skills/vue-pinia-best-practices.md) |
| Routes, guards, navigation           | `vue-router-agent`    | [vue-router-best-practices](../../specialists/skills/vue-router-best-practices.md) |
| `/uiapi` endpoint, DTO, domain logic | `nestjs-api-agent`    | [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md), [nestjs-expert](../../specialists/skills/nestjs-expert.md) |
| Grid columns, filters, metadata    | `data-grid-agent`     | [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md) (backend metadata) |
| SFC template/script only             | `vue-component-creator` | [by-agent.md](../../specialists/by-agent.md) |

**Editing existing files:** match neighbouring code in untouched areas (`general.mdc`). Apply latest patterns only to code you are actively refactoring — no drive-by legacy rewrites.

**Always** end with `platform-review-agent` (except [Quick fix](#quick-fix-skip-full-workflow)). Add `platform-performance-agent` per [When to add perf audit](#when-to-add-perf-audit).

Does **not** apply to: bugfix with a single obvious cause (use [bugfix.md](bugfix.md)) — unless the user explicitly asked to refactor.

## Full-stack (UI + API)

| Scenario                           | Skill chain                                                                                                                     |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **New screen** (existing API)      | `vue-router-agent` → `vue-component-creator` → `platform-review-agent` → `platform-performance-agent`                                     |
| **New screen + API**               | `nestjs-api-agent` → `vue-router-agent` → `vue-component-creator` → `platform-review-agent` → `platform-performance-agent`                |
| **Detail / edit form** (new route) | `vue-router-agent` → `pinia-architect` (if store) → `vue-component-creator` → `platform-review-agent` → `platform-performance-agent`      |
| **New cached read**                | `nestjs-api-agent` (if needed) → `pinia-colada-expert` → `vue-component-creator` → `platform-review-agent` → `platform-performance-agent` |
| **New list + metadata + API**      | `data-grid-agent` + `nestjs-api-agent` → `vue-router-agent` → `platform-review-agent` → `platform-performance-agent`                      |

## Frontend only

| Scenario                         | Skill chain                                                                                          |
| -------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Store-only change**            | `pinia-architect` → `vue-component-creator` → `platform-review-agent` → `platform-performance-agent`           |
| **New list screen** (API exists) | `data-grid-agent` → `vue-router-agent` (if new route) → `platform-review-agent` → `platform-performance-agent` |
| **Refactor** (any scope)         | [Refactor (default)](#refactor-default) — pick layer; [specialists](../../specialists/README.md) |
| **i18n / copy only**             | [Quick fix](#quick-fix-skip-full-workflow) if trivial; else `vue-component-creator` → `platform-review-agent` |

## Backend only

| Scenario                                         | Skill chain                                                 |
| ------------------------------------------------ | ----------------------------------------------------------- |
| **New `/uiapi` endpoint**                        | `nestjs-api-agent` → `platform-review-agent`                     |
| **Grid metadata + search endpoint**              | `nestjs-api-agent` + `data-grid-agent` → `platform-review-agent` |
| **Domain service / DTO fix**                     | `nestjs-api-agent` → `platform-review-agent`                     |
| **Entity / migration** (confirm scope with user) | `nestjs-api-agent` → `platform-review-agent`                     |

Skip `platform-performance-agent` for backend-only work.

## Audit & bugfix

| Scenario                            | Skill chain                                                                   |
| ----------------------------------- | ----------------------------------------------------------------------------- |
| **Bugfix** (existing screen)        | [bugfix.md](bugfix.md) → layer agent → `platform-review-agent` (+ `platform-performance-agent` if UI/reactivity). Or [Quick fix](#quick-fix-skip-full-workflow) when trivial. |
| **Perf audit** (user asks)          | `platform-performance-agent` alone                                                 |
| **Architecture review** (user asks) | `platform-review-agent` alone                                                      |

## When to add perf audit

After `platform-review-agent`, **read** `platform-performance-agent` when the change includes any of:

- new or changed `.vue` components with data binding
- Pinia store usage in templates (`storeToRefs`, actions in setup)
- Colada `useQuery` / `useMutation` in UI
- `watch`, `watchEffect`, or non-trivial `computed` chains
- DataGrid / TreeDataGrid views

**Skip** for: i18n/copy only, backend-only, metadata-only grid tweaks with no view logic change, trivial one-line fixes.

Symptom → layer routing: **[bugfix.md](bugfix.md)** (read only for bugfix tasks).
