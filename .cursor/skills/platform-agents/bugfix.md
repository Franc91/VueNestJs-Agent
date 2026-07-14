# Bugfix — pick the layer

Symptom → domain agent → supplementary. Read **only** when fixing an existing screen or cross-layer bug — not for [New component](workflows.md#new-component-default) or [Refactor](workflows.md#refactor-default).

**Trivial** (typo, i18n, one-liner) → [Quick fix](workflows.md#quick-fix-skip-full-workflow) — `vue-component-creator` only.

**Chain:** layer agent → supplementary (if listed) → `platform-review-agent` → `platform-performance-agent` when UI/reactivity changed ([when to add perf audit](workflows.md#when-to-add-perf-audit)).

Tier for `.vue` work: [vue-tier.md](../../specialists/vue-tier.md). Backend: [backend-tier.md](../../specialists/backend-tier.md). Map: [by-agent.md](../../specialists/by-agent.md).

## Symptom → agent → supplementary

| Symptom / area | Start with | Supplementary |
| -------------- | ---------- | ------------- |
| Template, props, Vuetify, component logic | `vue-component-creator` | tier per [vue-tier.md](../../specialists/vue-tier.md) |
| UI not updating, SFC structure, component boundaries | `vue-component-creator` | [vue-best-practices](../../specialists/skills/vue-best-practices.md) |
| Script setup macros, `defineModel`, watchers, built-in components | `vue-component-creator` | [vue](../../specialists/skills/vue.md) |
| Complex composable design, TypeScript props, component architecture | `vue-component-creator` | [vue-expert](../../specialists/skills/vue-expert.md) |
| Store action, selection, modal state | `pinia-architect` | — |
| UI not updating after store changes (destructuring, method binding) | `pinia-architect` | [vue-pinia-best-practices](../../specialists/skills/vue-pinia-best-practices.md) |
| Colada cache keys, stale data, query typing | `pinia-colada-expert` | [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md) (if types) |
| API response, DTO, domain logic | `nestjs-api-agent` | — |
| Module/DI issues, guards, exception filters, circular deps | `nestjs-api-agent` | [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md) |
| Complex module layout, DTO design, TypeORM service patterns | `nestjs-api-agent` | [nestjs-expert](../../specialists/skills/nestjs-expert.md) |
| TypeScript errors, complex types, slow typecheck | domain agent | [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md) / [typescript-expert](../../specialists/skills/typescript-expert.md) |
| Grid columns, filters, search, metadata | `data-grid-agent` | [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md) (backend metadata) |
| Route param, guard, wrong navigation | `vue-router-agent` | — |
| Stale data on same-route param change, guard infinite loop, `beforeRouteEnter` | `vue-router-agent` | [vue-router-best-practices](../../specialists/skills/vue-router-best-practices.md) |
| Slow renders, deep watches, unnecessary refetch | `platform-performance-agent` | [vue-best-practices](../../specialists/skills/vue-best-practices.md) (perf refs) |

Back: [workflows.md](workflows.md) · [AGENTS.md](../../../AGENTS.md)
