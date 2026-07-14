---
name: data-grid-agent
description: Adds or changes DataGrid list screens, grid metadata, filter sets, and search wiring. Use when working on DataGrid, TreeDataGrid, grid metadata, list views, column filters, or grid-related bugfixes in code/ui or code/src/domain/grid.
---

# DataGrid Agent

Designs list screens and grid metadata across frontend and backend.

**Canonical rules:** `.cursor/rules/data-grid.mdc`, `.cursor/rules/vue.mdc`, `.cursor/rules/i18n.mdc`, `.cursor/rules/nestjs.mdc`, `.cursor/rules/services.mdc`
Project summary: [../platform-agents/reference.md](../platform-agents/reference.md)

## Prefer latest patterns

Follow `data-grid.mdc` — `DataGrid` / `TreeDataGrid`, `UiApiGridUrlPathEnum`, metadata in `src/domain/grid/metadata/`. Do not build ad-hoc tables for standard searchable lists.

## Rule

Do not write code if information is missing.
Ask questions first.

## When to use this skill

| Task                                      | Skill                                                      |
| ----------------------------------------- | ---------------------------------------------------------- |
| New list screen with filters/sort         | `data-grid-agent`                                          |
| New grid metadata / columns / filter sets | `data-grid-agent`                                          |
| Custom slot column in existing grid       | `vue-component-creator` (UI only)                          |
| New domain search endpoint                | `data-grid-agent` + `nestjs-api-agent` if endpoint missing |

## Pick the right component

| Screen shape         | Component            | Example                     |
| -------------------- | -------------------- | --------------------------- |
| Flat list            | `DataGrid`           | `FieldSetManagmentList.vue` |
| Parent + child rows  | `TreeDataGrid`       | `CustomerList.vue`          |
| List with totals row | `DataGridWithTotals` | deal-stacker grids          |

## Full-stack checklist (new grid)

### Backend

1. **`src/domain/grid/metadata/{domain}.metadata.ts`** — extend `BaseMetadata`, implement `grid()`
2. Export from `metadata/index.ts`; inject in **`GridService`**
3. **`grids.controller.ts`** — `@Get('/grids/my-domain')`
4. Domain **`POST /uiapi/{domain}/search`** if not existing (`nestjs-api-agent`)

### Frontend enums

5. **`UiApiGridUrlPathEnum.GRID_MY_DOMAIN`** in `api.enum.ts`
6. **`UiApiUrlPathEnum.MY_DOMAIN_SEARCH`** for data endpoint

### View

7. List view with `DataGrid` or `TreeDataGrid`
8. `fixedConditions`, `defaultQueue`, `table-label` via `t()`
9. `actions` / `buttonActions` with `router.push` for row actions (`vue.mdc`)

## View template

```vue
<script setup lang="ts">
import DataGrid from '@/components/DataGrid/DataGrid.vue';
import { UiApiGridUrlPathEnum, UiApiUrlPathEnum } from '@/enums';
import { useI18n } from 'vue-i18n';
import type { MessageSchema } from '@/plugins/i18n';

const { t } = useI18n<{ message: MessageSchema }>({ useScope: 'global' });
</script>

<template>
  <DataGrid
    :api-metadata-url="UiApiGridUrlPathEnum.GRID_MY_DOMAIN"
    :api-data-url="UiApiUrlPathEnum.MY_DOMAIN_SEARCH"
    headers-auto-parser-mapping
    :table-label="t('item.itemList', { name: t('myDomain.label') })"
    :fixed-conditions="fixedCondition"
  />
</template>
```

## Metadata tips

- **columns:** `text`, `value`, `sortable`, `sortData` — match `customer.metadata.ts`
- **filterSets:** named queues with `filterSetName`, `conditions`, `columns`
- **subFilterSets:** use `BaseMetadata` helpers (`createEnumSubFilter`, …)
- **GridMetadata enum:** add entry in `metadata.grid.enum.ts` when wiring new metadata service name

## Handoff

```markdown
## Handoff

- **Grid**: DataGrid | TreeDataGrid
- **Metadata**: GET /uiapi/grids/...
- **Search**: POST /uiapi/.../search
- **Enums**: UiApiGridUrlPathEnum._, UiApiUrlPathEnum._
- **Next**: vue-router-agent (if new list route), platform-review-agent
```

## Supplementary (specialists)

**When:** backend metadata → [by-agent.md](../../specialists/by-agent.md).

**Cards:** [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md) · [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md) (complex metadata types).

**Orchestration:** [New list + metadata](../platform-agents/workflows.md#full-stack-ui--api) · often pairs with `nestjs-api-agent`. Hand off routes to `vue-router-agent`, cells to `vue-component-creator`.

## Checklist before finishing

- [ ] Metadata + controller + `GridService` registration
- [ ] Frontend enums — no hardcoded grid URLs
- [ ] Correct grid component for parent/child shape
- [ ] `fixedConditions` and `defaultQueue` match screen context
- [ ] Labels via `t()` / locale keys (`i18n.mdc`)
- [ ] Row actions use Vue Router where navigation is needed
