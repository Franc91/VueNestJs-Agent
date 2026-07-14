# Domain agent → supplementary map

After reading a domain agent skill, use this table to pick supplementary skills. Combine with [vue-tier.md](vue-tier.md) or [backend-tier.md](backend-tier.md) where noted.

| Domain agent | When to read supplementary | Skills |
| ------------ | -------------------------- | ------ |
| `vue-component-creator` | Non–Quick-fix `.vue` work | Per [vue-tier.md](vue-tier.md) |
| `vue-router-agent` | Guards, param lifecycle, redirect loops, `beforeRouteEnter` | [vue-router-best-practices](skills/vue-router-best-practices.md) |
| `pinia-architect` | Store reactivity gotchas — destructuring, action binding, UI not updating | [vue-pinia-best-practices](skills/vue-pinia-best-practices.md) |
| `pinia-colada-expert` | Complex query/payload types; store boundary questions | [typescript-advanced-types](skills/typescript-advanced-types.md); optional [vue-pinia-best-practices](skills/vue-pinia-best-practices.md) |
| `data-grid-agent` | Backend metadata, search wiring, filter types | [nestjs-best-practices](skills/nestjs-best-practices.md); [typescript-advanced-types](skills/typescript-advanced-types.md) if complex metadata types |
| `nestjs-api-agent` | Any non-trivial `/uiapi` work | Per [backend-tier.md](backend-tier.md) |
| `platform-review-agent` | Diagnosing framework gotchas in findings | Cross-check [stack-profile.md](../stack-profile.md) — see agent skill table |
| `platform-performance-agent` | Perf-related reactivity issues | [vue-best-practices](skills/vue-best-practices.md) (perf refs) |

## Bugfix shortcuts

Full symptom table (SSOT): [bugfix.md](../skills/platform-agents/bugfix.md). Trigger: [bugfix.mdc](../rules/bugfix.mdc).

Back: [README.md](README.md) · Skill cards: [skills/README.md](skills/README.md)
