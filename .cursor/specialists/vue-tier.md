# Vue tier

Classify **before** writing `.vue` code when `vue-component-creator` is in the chain.

Used by: [New component](../skills/platform-agents/workflows.md#new-component-default), [Refactor](../skills/platform-agents/workflows.md#refactor-default), [Bugfix](../skills/platform-agents/bugfix.md).

**Default when unsure:** **Standard**.

## Tiers

| Tier | When | Read |
| ---- | ---- | ---- |
| **Simple** | Presentational only — props in, events out; no store, Colada, complex forms, or custom composables | Skip supplementary — `vue.mdc` + `vue-component-creator` |
| **Standard** | Typical feature component — forms, store consumption, `defineModel`, moderate template logic | [vue-best-practices](skills/vue-best-practices.md) |
| **Substantial** | Complex composables, heavy TypeScript, architecture decisions, performance-sensitive lists | [vue-best-practices](skills/vue-best-practices.md) + [vue](skills/vue.md) + [vue-expert](skills/vue-expert.md) |

## Examples

| Scenario | Tier |
| -------- | ---- |
| Static card, label + slot | Simple |
| Edit form with `v-form`, store actions, i18n | Standard |
| Reusable data table with virtual scroll, typed emits, shared composable | Substantial |
| Bugfix: one prop typo | [Quick fix](../skills/platform-agents/workflows.md#quick-fix-skip-full-workflow) — no tier |

## After classifying

1. Open listed [skill cards](skills/README.md).
2. Read only **active** references in [stack-profile.md → Frontend](../stack-profile.md#frontend-stack).
3. Continue the workflow — [by-agent.md](by-agent.md) for other domain agents in the same task.

Back: [README.md](README.md)
