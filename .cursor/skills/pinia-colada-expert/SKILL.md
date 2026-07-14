---
name: pinia-colada-expert
description: Creates Pinia Colada queries, cache keys, and stale-time configuration for server state. Use when adding cached API reads, refactoring store caches to Colada, or wiring useQuery in new read-heavy features.
---

# Pinia Colada Expert

Owns **cached server reads** via Pinia Colada. Does not replace existing `services/` + store flows unless explicitly scoped.

## Authoritative rules

- **Primary:** [pinia-colada.mdc](../../rules/pinia-colada.mdc)
- **HTTP boundary:** [services.mdc](../../rules/services.mdc)
- **Store boundary:** [pinia-stores.mdc](../../rules/pinia-stores.mdc)
- **Project context:** [general.mdc](../../rules/general.mdc), [../platform-agents/reference.md](../platform-agents/reference.md)
- **Walkthrough:** [../platform-agents/examples.md](../platform-agents/examples.md)
- **Docs:** [pinia-colada.esm.dev](https://pinia-colada.esm.dev/) when unsure

## Prefer latest patterns

Follow `pinia-colada.mdc` and mirror `vehicle-configurator.queries.ts` — this is the template for **new** cached reads. Do not copy legacy store+`watch`+service refetch patterns.

## Rule

Do not write code if information is missing.
Ask questions first.

## Layout (`pinia-colada.mdc`)

```
ui/src/
  api/{domain}.api.ts           # thin HTTP — UiApiUrlPathEnum
  queries/{domain}.queries.ts   # defineQueryOptions + key factory
  queries/index.ts              # barrel exports
```

Reference: `vehicle-configurator.queries.ts` + `vehicle-configurator.api.ts`.

## Query template

```ts
import { defineQueryOptions } from '@pinia/colada';
import { getFundedRegulatedProductOptions } from '@/api';

export const VEHICLE_CONFIGURATOR_KEYS = {
  root: ['vehicle-configurator'] as const,
  regulatedProducts: (payload: Payload) =>
    [...VEHICLE_CONFIGURATOR_KEYS.root, 'regulated-products', ...getPayloadKeyParts(payload)] as const,
};

export const vehicleConfiguratorRegulatedProducts = defineQueryOptions((payload: Payload) => ({
  key: VEHICLE_CONFIGURATOR_KEYS.regulatedProducts(payload),
  enabled: hasRequiredPayload(payload),
  query: async () => getFundedRegulatedProductOptions(payload),
}));
```

## Component usage (`vue.mdc` consumers)

```ts
import { useQuery } from '@pinia/colada';
import { vehicleConfiguratorRegulatedProducts } from '@/queries';

const productsPayload = computed(() => ({
  /* params */
}));
const regulatedProducts = useQuery(() => vehicleConfiguratorRegulatedProducts(productsPayload.value));
```

Use `.data`, `.isPending`, `.error`, `.refresh` — match `SupplementaryProductsSection.vue`.

## Cache rules (`pinia-colada.mdc`)

1. Stable hierarchical keys — include all response-affecting params
2. Export `XXX_KEYS` factory alongside query options
3. `enabled` until required payload fields exist
4. No UI state in queries — modals/tabs → Pinia store
5. HTTP in `api/` — not duplicated in query file

## When NOT to use Colada

- Editing legacy enquiry/customer/task flows (`XxxService` + store)
- One-off POST/PATCH from a form
- Loader/toast — `ServiceHelper` / `loader.store`

Inline `useQuery` in a store is rare (`customer-offer.store.ts`) — prefer `queries/` for new work.

## Supplementary (specialists)

**When:** complex query/types → [by-agent.md](../../specialists/by-agent.md).

**Cards:** [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md), [typescript-expert](../../specialists/skills/typescript-expert.md) · [TypeScript stack](../../stack-profile.md#typescript-stack). Store boundaries: [vue-pinia-best-practices](../../specialists/skills/vue-pinia-best-practices.md).

**Orchestration:** [Refactor store→Colada](../platform-agents/workflows.md#refactor-default) · [New cached read](../platform-agents/workflows.md#full-stack-ui--api). Hand off UI to `vue-component-creator`.

## Checklist before finishing

- [ ] Matches `pinia-colada.mdc` checklist
- [ ] Keys hierarchical; `enabled` guards incomplete payload
- [ ] HTTP in `api/` or existing service
- [ ] Exported from `queries/index.ts`
- [ ] Handoff to `vue-component-creator` with query names for UI
