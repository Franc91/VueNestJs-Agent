# End-to-end examples — Dealer Platform

Canonical conventions: `.cursor/rules/general.mdc`, `vue.mdc`, `pinia-stores.mdc`, `pinia-colada.mdc`, `services.mdc`, `nestjs.mdc`, `data-grid.mdc`, `i18n.mdc`.
**New work** uses the patterns below (Colada, VueUse, typed setup) — not legacy store+watch copies from older domains.

Workflow for **new cached reads**: pinia-colada-expert → vue-component-creator → platform-review-agent
Workflow for **existing domains**: pinia-architect (if store changes) → vue-component-creator → platform-review-agent
Workflow for **new screen + API**: nestjs-api-agent → vue-router-agent (if new route) → vue-component-creator → platform-review-agent

---

## 1. Colada — vehicle configurator product options (actual pattern)

Reference implementation in the repo:

- `ui/src/api/vehicle-configurator.api.ts` — HTTP
- `ui/src/queries/vehicle-configurator.queries.ts` — keys + `defineQueryOptions`
- `ui/src/views/CustomerOffer/sections/SupplementaryProductsSection/` — `useQuery` consumer

```ts
// ui/src/queries/vehicle-configurator.queries.ts
import { defineQueryOptions } from '@pinia/colada';
import { getFundedRegulatedProductOptions } from '@/api';

export const VEHICLE_CONFIGURATOR_KEYS = {
  root: ['vehicle-configurator'] as const,
  regulatedProducts: (payload: Payload) =>
    [...VEHICLE_CONFIGURATOR_KEYS.root, 'regulated-products', payload.derivativeId] as const,
};

export const vehicleConfiguratorRegulatedProducts = defineQueryOptions((payload: Payload) => ({
  key: VEHICLE_CONFIGURATOR_KEYS.regulatedProducts(payload),
  enabled: Boolean(payload?.derivativeId && payload?.manufacturerId),
  query: async () => getFundedRegulatedProductOptions(payload),
}));
```

```vue
<!-- Consumer — match SupplementaryProductsSection.vue -->
<script setup lang="ts">
import { computed } from 'vue';
import { useQuery } from '@pinia/colada';
import { vehicleConfiguratorRegulatedProducts } from '@/queries';

const props = defineProps<{ payload: Payload }>();

const productsPayload = computed(() => props.payload);

const regulatedProducts = useQuery(() => vehicleConfiguratorRegulatedProducts(productsPayload.value));
// regulatedProducts.data, .isPending, .error, .refresh
</script>
```

---

## 2. Pinia + service — enquiry domain (legacy norm)

```ts
// ui/src/stores/enquiry.store.ts (simplified)
import { defineStore } from 'pinia';
import { ref } from 'vue';
import { EnquiryService } from '@/services';

export const useEnquiryStore = defineStore('enquiry', () => {
  const selectedEnquiry = ref<EnquiryInterface>();

  async function setSelectedEnquiry(enquiryId?: string) {
    selectedEnquiry.value = enquiryId ? await EnquiryService.getEnquiry(enquiryId) : undefined;
  }

  return { selectedEnquiry, setSelectedEnquiry };
});
```

```vue
<!-- ui/src/views/enquiry/AddEditEnquiry/QuotedVehicleModal/QuotedVehicleModal.vue -->
<script setup lang="ts">
const selectedEnquiry = ref<EnquiryInterface>();
const isWhatNextAction = ref(false);

const open = ({ type, enquiry, isWhatNext = false }: OpenParams) => {
  selectedEnquiry.value = enquiry;
  isWhatNextAction.value = isWhatNext;
  quotedVehicleModalType.value = type;
  isOpen.value = true;
};

defineExpose({ open, isOpen });
</script>
```

Pass props through the chain:

```vue
<!-- QuotedVehicleModal → VehicleStock → VehicleStockFilters -->
<VehicleStock is-dialog :is-what-next-action="isWhatNextAction" />
<VehicleStockFilters :is-what-next-action="isWhatNextAction" />
```

---

## 3. Component — filters with MOI prefill

```ts
// ui/src/views/vehicle/VehicleStockFilters/constants.ts
export const MOI_FILTER_FIELDS = {
  make: 'manufacturerName',
  model: 'longModel',
  purchaseTypeCode: 'purchaseTypeCode',
} as const;
```

```ts
const applyMoiFilters = (): boolean => {
  const moi = selectedEnquiry.value?.moi;
  if (!isWhatNextAction || !moi) return false;

  return Object.entries(MOI_FILTER_FIELDS).some(([moiKey, fieldName]) =>
    setMoiFilterValue(fieldName, moi[moiKey as keyof typeof MOI_FILTER_FIELDS]),
  );
};
```

---

## 4. Vue Review — expected checks

| Check                                                               | Pass                           |
| ------------------------------------------------------------------- | ------------------------------ |
| HTTP via `EnquiryService`, not Axios in view                        | ✅                             |
| `isWhatNextAction` declared in `VehicleStock` props and passed down | ✅                             |
| i18n keys added to `src/global/locales/en/`                         | ✅                             |
| Vuetify fields match neighbouring styling (`underlined`, `#48a0cc`) | ✅                             |
| VueUse used instead of manual `addEventListener` in new code        | ✅                             |
| Ref/param name shadowing in `open()`                                | ❌ — use `selectedEnquiry` ref |

---

## 5. Vue Router — add menu route + navigation (actual pattern)

Reference implementation in the repo:

- `ui/src/enums/router.enum.ts` — `RouterName`, `RouterPathEnum`
- `ui/src/config/configPath.ts` — menu + lazy route component
- `ui/src/router/index.ts` — global guards, `meta.roleAttributes`
- `ui/src/views/diary/Diary.vue` — `useRouter` / `useRoute` consumption

```ts
// ui/src/enums/router.enum.ts (add entries)
enum RouterName {
  MY_FEATURE = 'My Feature',
}
enum RouterPathEnum {
  MY_FEATURE = `${RouterPathBaseEnum.ADMIN}my-feature`,
}
```

```ts
// ui/src/config/configPath.ts (child under main layout)
{
  global: {
    name: RouterName.MY_FEATURE,
    path: RouterPathEnum.MY_FEATURE,
    meta: {
      roleAttributes: [ApplicationAttributeCodeEnum.SOME_PERMISSION],
      options: { all: false },
    },
  },
  route: {
    component: () => import('@/views/admin/MyFeature/MyFeature.vue'),
  },
  verticalMenu: { title: t('pages.myFeature'), icon: markRaw(SomeIcon), show: true },
}
```

```ts
// Navigation from a component
import { useRouter } from 'vue-router';
import { RouterName } from '@/enums';

const router = useRouter();
router.push({ name: RouterName.MY_FEATURE, params: { id } });
```

Workflow: **vue-router-agent** → **vue-component-creator** → **platform-review-agent**

---

## 6. Backend + frontend — new search endpoint

```ts
// src/ui-api/note/note.controller.ts (pattern)
@UseGuards(CognitoAuthGuard)
@Controller('/uiapi/note')
export default class NoteController {
  @Post('/search')
  @HttpCode(200)
  public async search(@Body() params: FilterParams): Promise<SearchResponse<Note>> {
    return await this.noteService.search(params);
  }
}
```

```ts
// ui/src/enums/api.enum.ts
export enum UiApiUrlPathEnum {
  NOTE_SEARCH = `${ApiBaseUrl.NOTE}search`,
}
```

```ts
// ui/src/services/note.service.ts
export class NoteService {
  static async search(params: FilterParams) {
    return ServiceHelper.requestWrapper({
      requestData: {
        method: RequestMethodEnum.POST,
        url: UiApiUrlPathEnum.NOTE_SEARCH,
        data: params,
      },
    });
  }
}
```

Workflow: **nestjs-api-agent** → **vue-component-creator** (or **pinia-colada-expert** for cached reads)

---

## 7. Performance — common issues

| Issue                                                        | Fix                                     |
| ------------------------------------------------------------ | --------------------------------------- |
| `watch([metaData, moi], …)` only uses `metaData` in callback | Destructure all deps or split watchers  |
| `setMoiFilterValue` chained with `\|\|`                      | Use `some()` — apply all MOI fields     |
| `useDictionaryStore()` inside `computed` per chip            | Precompute or memoize dictionary lookup |
| `console.log` in `visibleChips` computed                     | Remove before merge                     |

---

## 8. DataGrid — list screen + metadata (actual pattern)

Reference:

- `ui/src/views/Admin/FieldSetManagment/FieldSetManagmentList/FieldSetManagmentList.vue` — flat `DataGrid`
- `ui/src/views/Customers/CustomerList/CustomerList.vue` — `TreeDataGrid` with child rows
- `src/domain/grid/metadata/customer.metadata.ts` — columns, filterSets
- `src/ui-api/grids/grids.controller.ts` — GET metadata endpoints

```vue
<DataGrid
  :api-metadata-url="UiApiGridUrlPathEnum.GRID_FIELD_SET"
  :api-data-url="UiApiUrlPathEnum.FIELD_SET_SEARCH"
  headers-auto-parser-mapping
  :table-label="t('item.itemList', { name: t('fieldSet') })"
/>
```

Workflow: **data-grid-agent** → **vue-router-agent** (if new route) → **platform-review-agent**

---

## 9. i18n — add keys for a new feature

```ts
// src/global/locales/en/my-feature.ts
export const myFeature = {
  label: 'My Feature | My Features',
  description: 'Description text',
};
```

```ts
// src/global/locales/en/index.ts — import and spread
import { myFeature } from './my-feature';

export const en = {
  // ...
  ...myFeature,
};
```

```vue
<script setup lang="ts">
import { useI18n } from 'vue-i18n';
import type { MessageSchema } from '@/plugins/i18n';

const { t } = useI18n<{ message: MessageSchema }>({ useScope: 'global' });
</script>

<template>
  <span>{{ t('label') }}</span>
</template>
```

Use existing shared keys first: `actions.save`, `errors.fieldIsRequired`, `crudItem.createItem`.
