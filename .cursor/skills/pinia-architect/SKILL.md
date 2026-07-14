---
name: pinia-architect
description: Designs Pinia setup stores for domain and UI state, actions, getters, and store composition. Use when modeling selections, modals, enquiry state, store-only changes, or fixing store/action bugs — not for new read caches (use pinia-colada-expert).
---

# Pinia Architect

Designs Pinia stores in `ui/src/stores/`. Stores hold **mutable domain state** and call `services/` — not large read-only caches (those belong in Colada).

**Canonical rules:** `.cursor/rules/pinia-stores.mdc`, `.cursor/rules/services.mdc`, `.cursor/rules/general.mdc`
Project summary: [../platform-agents/reference.md](../platform-agents/reference.md)

## Prefer latest patterns

Follow `pinia-stores.mdc` and `general.mdc` — not legacy store shapes that duplicate read caches. New read-heavy lists → hand off to `pinia-colada-expert`, do not grow the store.

## Rule

Do not write code if information is missing.
Ask questions first.

## When to use Pinia vs Colada

| Pinia store (`ui/src/stores/`)          | Pinia Colada (`ui/src/queries/`)              |
| --------------------------------------- | --------------------------------------------- |
| Selected entity, wizard state, UI flags | GET-style reads that benefit from cache/dedup |
| Mutations, POST/PATCH flows             | Shared lists/options keyed by request params  |
| Loader/dialog flags (`loader.store`)    | Multiple components need the same cached read |

Example: `selectedEnquiry` + `setSelectedEnquiry()` → Pinia; funded product options → Colada.

Do not migrate legacy store domains to Colada unless explicitly asked.

## Store layout

```
ui/src/stores/
  enquiry.store.ts          # domain: selectedEnquiry, enquiries, activeVehicle
  loader.store.ts           # global UI: show/hide loader
  vehicle-configurator.store.ts
  index.ts                  # barrel re-exports
```

## Naming

| Item     | Pattern             | Example                                                  |
| -------- | ------------------- | -------------------------------------------------------- |
| File     | `{domain}.store.ts` | `enquiry.store.ts`                                       |
| Export   | `use{Domain}Store`  | `useEnquiryStore`                                        |
| Store id | kebab-case          | `'enquiry'`, `'finance-calculator'`                      |
| Actions  | verbs               | `setSelectedEnquiry`, `setIsUpdate`, `clearSelectedTask` |

## Setup store template

```ts
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { EnquiryService } from '@/services';

export const useEnquiryStore = defineStore('enquiry', () => {
  const selectedEnquiry = ref<EnquiryInterface>();
  const isUpdate = ref(false);

  const hasSelectedEnquiry = computed(() => Boolean(selectedEnquiry.value?.id));

  async function setSelectedEnquiry(enquiryId?: string) {
    // call EnquiryService / domain helpers
  }

  function setIsUpdate() {
    isUpdate.value = !isUpdate.value;
  }

  return { selectedEnquiry, isUpdate, hasSelectedEnquiry, setSelectedEnquiry, setIsUpdate };
});
```

## Design rules

1. **One domain per store** — `useEnquiryStore`, not a global god-store.
2. **Minimal state** — local `ref` in a component when only one subtree needs it.
3. **Expose mutations as functions** — components call store actions, not ad-hoc patches from outside.
4. **Getters as `computed`** — derived values live in the store, not duplicated in views.
5. **HTTP via services** — call `ui/src/services/*.service.ts`, not raw Axios in stores.
6. **Cross-store composition** — stores may use other stores; avoid circular imports.
7. **Reset helpers** — clear ephemeral state in `close()` / `reset()` when modals or wizards end.

## Supplementary (specialists)

**When:** store reactivity gotchas → [by-agent.md](../../specialists/by-agent.md).

**Card:** [vue-pinia-best-practices](../../specialists/skills/vue-pinia-best-practices.md) · active refs: [Frontend stack](../../stack-profile.md#frontend-stack).

**Orchestration:** pre-step in [New component](../platform-agents/workflows.md#new-component-default) / [Refactor](../platform-agents/workflows.md#refactor-default). Hand off UI wiring to `vue-component-creator`.

## Checklist before finishing

- [ ] Matches `{domain}.store.ts` + `use{Domain}Store` naming
- [ ] Service calls go through `@/services/`, not inline HTTP
- [ ] Returned state/actions are everything consumers need
- [ ] New read-only cached data belongs in Colada — hand off to `pinia-colada-expert`
