# End-to-end examples — Vue + NestJS monorepo

Generic patterns from `.cursor/rules/`. Replace `{domain}`, `{Feature}`, `{Entity}` with your modules.

**New cached reads:** pinia-colada-expert → vue-component-creator → platform-review-agent  
**Store changes:** pinia-architect → vue-component-creator → platform-review-agent  
**New screen + API:** nestjs-api-agent → vue-router-agent (if route) → vue-component-creator → platform-review-agent

---

## 1. Colada — cached product/options read

```ts
// ui/src/queries/{domain}.queries.ts
import { defineQueryOptions } from '@pinia/colada';
import { getItems } from '@/api';

export const DOMAIN_KEYS = {
  root: ['my-domain'] as const,
  items: (payload: Payload) => [...DOMAIN_KEYS.root, 'items', payload.id ?? ''] as const,
};

export const myDomainItems = defineQueryOptions((payload: Payload) => ({
  key: DOMAIN_KEYS.items(payload),
  enabled: Boolean(payload?.id),
  query: async () => getItems(payload),
}));
```

```vue
<script setup lang="ts">
import { computed } from 'vue';
import { useQuery } from '@pinia/colada';
import { myDomainItems } from '@/queries';

const props = defineProps<{ payload: Payload }>();
const payload = computed(() => props.payload);
const items = useQuery(() => myDomainItems(payload.value));
</script>
```

Point agents to **your** Colada reference files in [reference.md](reference.md).

---

## 2. Pinia + service — domain selection (legacy norm)

```ts
// ui/src/stores/{domain}.store.ts
import { defineStore } from 'pinia';
import { ref } from 'vue';
import { MyDomainService } from '@/services';

export const useMyDomainStore = defineStore('my-domain', () => {
  const selected = ref<EntityInterface>();

  async function setSelected(id?: string) {
    selected.value = id ? await MyDomainService.get(id) : undefined;
  }

  return { selected, setSelected };
});
```

---

## 3. Vue Router — new menu route

```ts
// enums/router.enum.ts
enum RouterName {
  MY_FEATURE = 'My Feature',
}
enum RouterPathEnum {
  MY_FEATURE = `${RouterPathBaseEnum.APP}my-feature`,
}
```

```ts
// configPath or router module — lazy import
{
  name: RouterName.MY_FEATURE,
  path: RouterPathEnum.MY_FEATURE,
  component: () => import('@/views/MyFeature/MyFeature.vue'),
  meta: { /* permissions */ },
}
```

```ts
const router = useRouter();
router.push({ name: RouterName.MY_FEATURE, params: { id } });
```

Workflow: **vue-router-agent** → **vue-component-creator** → **platform-review-agent**

---

## 4. Backend + frontend — search endpoint

```ts
// src/ui-api/note/note.controller.ts
@UseGuards(AuthGuard)
@Controller('/uiapi/note')
export default class NoteController {
  @Post('/search')
  @HttpCode(200)
  async search(@Body() params: FilterParams) {
    return this.noteService.search(params);
  }
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

---

## 5. DataGrid — list + metadata

```vue
<DataGrid
  :api-metadata-url="UiApiGridUrlPathEnum.GRID_MY_ENTITY"
  :api-data-url="UiApiUrlPathEnum.MY_ENTITY_SEARCH"
  headers-auto-parser-mapping
  :table-label="t('item.itemList', { name: t('myEntity') })"
/>
```

Backend: `src/domain/grid/metadata/my-entity.metadata.ts`

Workflow: **data-grid-agent** → **vue-router-agent** (if new route) → **platform-review-agent**

---

## 6. i18n — new feature keys

```ts
// src/global/locales/en/my-feature.ts (or your locale root)
export const myFeature = {
  label: 'My Feature | My Features',
};
```

Register in locale `index.ts`. Use `useI18n<{ message: MessageSchema }>({ useScope: 'global' })` or project shorthand.

---

## 7. Performance — common issues

| Issue | Fix |
| ----- | --- |
| `watch` deps not all used in callback | Destructure or split watchers |
| Dictionary store inside tight computed loops | Precompute / memoize |
| `console.log` in computed getters | Remove before merge |
