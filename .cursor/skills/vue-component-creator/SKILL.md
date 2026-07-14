---
name: vue-component-creator
description: Generates and refactors Vue 3 SFC components — Composition API, props, emits, Vuetify, forms, i18n, VueUse. Use when creating or editing .vue files, detail/edit forms, view wiring, copy/locale keys, or consuming stores, services, and Colada queries.
---

# Vue Component Creator

Generates Vue 3 components under `code/ui/`. Consumes existing stores, services, and Colada queries — does not invent new store schemas without handoff.

**Canonical rules:** `.cursor/rules/vue.mdc`, `.cursor/rules/general.mdc`, `.cursor/rules/services.mdc`
For Colada consumption see `.cursor/rules/pinia-colada.mdc`.
For locale keys see `.cursor/rules/i18n.mdc`.
Project summary: [../platform-agents/reference.md](../platform-agents/reference.md)

## Prefer latest patterns

Follow `vue.mdc` for all **new** code — VueUse, `defineModel`, typed props/emits, Vuetify form norms. Match a legacy file only when editing inside it; new components use current rules, not copied Options API or manual `addEventListener`.

## Rule

Do not write code if information is missing.
Ask questions first.

## Core conventions (from `vue.mdc`)

1. **`<script setup lang="ts">`** only — no Options API in new code.
2. Type **`defineProps`** and **`defineEmits`**; avoid `any`.
3. Use **`defineModel`** for `v-model` bindings (parent ↔ child).
4. Prefer **`computed`** over `watch` when deriving state.
5. User-facing text via `useI18n` / `useAppI18n` — keys in `src/global/locales/en/`.
6. Fetch data via **stores + services** (legacy norm) or **Colada `useQuery`** (new reads).
7. **`storeToRefs`** when destructuring Pinia state in components.
8. Browser/DOM utilities: prefer **VueUse** (`@vueuse/core`) over manual `addEventListener`.
9. Keep templates declarative; move non-trivial logic to `computed` or functions.
10. In-app navigation: **`useRouter`** / **`useRoute`**, **`RouterName`** — see `vue.mdc`; hand off new routes to `vue-router-agent`.
11. Remove `console.log`, `debugger`, and dead code before finishing.
12. **Do not extract a composable** when creating or refactoring a component if the logic is used only inside that component — keep it in `<script setup>`; extract to `composables/` only when two or more consumers need it (see `vue.mdc` → _Do not extract single-use logic_).

## File layout (actual)

```
ui/src/
  components/{Domain}/{Name}.vue     # shared/domain components
  views/{domain}/{Name}/{Name}.vue   # route pages (often feature-heavy)
  composables/use{Name}.ts
  layouts/AddEditComponent/          # common edit shell
```

There is no `components/ui/` or `components/features/` split — use domain folders (`WhatNextAction/`, `DataGrid/`).

## SFC template

```vue
<script setup lang="ts">
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import type { MessageSchema } from '@/plugins/i18n';
import { storeToRefs } from 'pinia';
import { useEnquiryStore } from '@/stores';

const { t } = useI18n<{ message: MessageSchema }>({ useScope: 'global' });

const { enquiryId, isWhatNextAction = false } = defineProps<{
  enquiryId: string;
  isWhatNextAction?: boolean;
}>();

const emit = defineEmits<{
  apply: [payload: FilterPayload[]];
  cancel: [];
}>();

const isOpen = defineModel<boolean>('isOpen', { default: false });

const { selectedEnquiry } = storeToRefs(useEnquiryStore());
const title = computed(() => t('actions.filter', 2));
</script>

<template>
  <v-row>
    <v-col cols="12">
      <h6 class="text-h6" v-text="title" />
    </v-col>
  </v-row>
</template>
```

## Vuetify patterns (match neighbouring fields)

| Prop           | Typical value in forms/modals                         |
| -------------- | ----------------------------------------------------- |
| `variant`      | `underlined`                                          |
| `color`        | `#48a0cc`                                             |
| `class`        | `font-size-input input-style` (+ `pa-0` where needed) |
| `hide-details` | `true` on dense rows                                  |

- **Modals:** `CustomModal` for standard dialogs
- **Forms:** `v-form` + `useCheckValidation(formRef)` from `@/composables`
- **Validation rules:** `useRules()` from `vuetify/labs/rules` where the file already uses it
- **Primary actions:** `class="font-weight-bold text-uppercase btn-default bg-gradient-primary …"`
- **Icons:** MDI — `icon="mdi-..."` or `<v-icon icon="mdi-..." />`

## Colada in components

```ts
import { useQuery } from '@pinia/colada';
import { vehicleConfiguratorRegulatedProducts } from '@/queries';

const payload = computed(() => ({
  /* params */
}));
const products = useQuery(() => vehicleConfiguratorRegulatedProducts(payload.value));
// products.data, .isPending, .error, .refresh
```

## Patterns in this codebase

- **Pinia:** `storeToRefs(useXxxStore())` — never destructure store without `storeToRefs`
- **Modals:** `CustomModal`, `defineExpose({ open, close })` on modal wrappers
- **Grids:** `DataGrid` + metadata from `/uiapi/grids/`
- **Props through chain:** declare in `defineProps` and pass to children explicitly

## Before generating code

1. Read the neighbouring view/component in the same domain.
2. Decide: local state, store, service call, or Colada query.
3. Propose file path matching existing structure.
4. Hand off to `pinia-architect`, `pinia-colada-expert`, `vue-router-agent`, or `data-grid-agent` if new store/query/route/grid layer is needed.

## Supplementary Vue

Classify tier in [vue-tier.md](../../specialists/vue-tier.md) **before** writing `.vue` code. **Default when unsure:** Standard.

**Cards:** [skills/README.md](../../specialists/skills/README.md) · routing: [by-agent.md](../../specialists/by-agent.md).

**Create:** [New component](../platform-agents/workflows.md#new-component-default) · **Refactor:** [Refactor](../platform-agents/workflows.md#refactor-default) · **Quick fix:** [Quick fix](../platform-agents/workflows.md#quick-fix-skip-full-workflow).

Project rules in `vue.mdc` and this skill take precedence over generic Vue advice.

## Checklist before finishing

- [ ] `<script setup lang="ts">`, typed props/emits
- [ ] Vuetify fields match neighbouring styling (`underlined`, `#48a0cc`, `font-size-input input-style`)
- [ ] User strings via `t()` / locale keys — not hardcoded
- [ ] Form validation uses `v-form` + project validation helper where applicable
- [ ] Browser/DOM utilities use VueUse when available
- [ ] In-app navigation uses Vue Router (`useRouter`, `RouterName`) — not `window.location`
- [ ] Shared logic in `composables/` and exported from `index.ts` — do not create a composable for logic used by one component only
- [ ] Props wired through parent → child when needed
- [ ] Matches domain folder conventions
