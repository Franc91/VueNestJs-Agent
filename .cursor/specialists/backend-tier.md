# Backend tier

Classify when `nestjs-api-agent` is in the chain.

Used by: [Backend only](../skills/platform-agents/workflows.md#backend-only), pre-steps in [New component](../skills/platform-agents/workflows.md#new-component-default) / [Refactor](../skills/platform-agents/workflows.md#refactor-default).

**Default when unsure:** **Standard**.

## Tiers

| Tier | When | Read |
| ---- | ---- | ---- |
| **Simple** | Clone neighbour endpoint — same module shape, thin DTO, no new domain rules | Skip supplementary — conventions cache |
| **Standard** | New module, guards, validation, search endpoint, grid metadata backend | Skip supplementary — conventions cache. Open `nestjs.mdc` only if the cache lacks the detail |
| **Substantial** | Complex domain logic, TypeORM relations, multi-DTO flows, circular-dep risk | [nestjs-best-practices](skills/nestjs-best-practices.md) + [nestjs-expert](skills/nestjs-expert.md) — one active reference each, not the whole tree |

## TypeScript (any backend tier)

| When | Read |
| ---- | ---- |
| Complex DTOs, generics, mapped types | [typescript-advanced-types](skills/typescript-advanced-types.md) |
| `tsc` errors, module resolution, slow typecheck | [typescript-expert](skills/typescript-expert.md) |

## Examples

| Scenario | Tier |
| -------- | ---- |
| Add filter field to existing search DTO | Simple |
| New `POST /uiapi/domain/search` + domain service method | Standard |
| New domain module with entities, relations, multiple DTOs | Substantial |

## After classifying

1. Open listed [skill cards](skills/README.md).
2. Read only **active** rule categories in [stack-profile.md → Backend](../stack-profile.md#backend-stack).
3. Hand off UI to `pinia-colada-expert` or `vue-component-creator` when endpoint is ready.

Back: [README.md](README.md)
