---
name: vue-router-agent
description: Adds or changes Vue Router routes, guards, meta, and in-app navigation. Use when creating routes, route params, permissions meta, navigation bugs, or wiring new screens into the router in code/ui.
---

# Vue Router Agent

Designs and wires Vue Router in `code/ui/`. Navigation in components; route definitions in `router/`, `configPath.ts`, and enums.

**Canonical rules:** `.cursor/rules/vue.mdc`, `.cursor/rules/general.mdc`
Project summary: [../platform-agents/reference.md](../platform-agents/reference.md)

## Prefer latest patterns

Follow `vue.mdc` — `useRouter` / `useRoute`, `RouterName` / `RouterPathEnum`, no hardcoded URL strings or `window.location`.

## Rule

Do not write code if information is missing.
Ask questions first.

## When to use this skill vs component-creator

| Task                                           | Skill                                                                     |
| ---------------------------------------------- | ------------------------------------------------------------------------- |
| New route, path, `meta`, guard, enum entry     | `vue-router-agent`                                                        |
| Button/link that navigates from existing route | `vue-component-creator` (uses `vue.mdc` router section)                   |
| Route-change store sync (`selectedEnquiry`, …) | `vue-router-agent` + hand off to `pinia-architect` if store shape changes |

## File map

| Location                                | Role                                                        |
| --------------------------------------- | ----------------------------------------------------------- |
| `ui/src/router/index.ts`                | `createRouter`, global `beforeEach` / `afterEach`           |
| `ui/src/router/*.ts`                    | Standalone route trees (`AuthRoutes`, `AppraisalRoutes`, …) |
| `ui/src/config/configPath.ts`           | Main-layout menu + child routes                             |
| `ui/src/enums/router.enum.ts`           | `RouterName`, `RouterPathEnum`, `RouterPathBaseEnum`        |
| `ui/src/constants/*-routes.ts`          | Context maps (action-button, customer-text, enquiry)        |
| `ui/src/utils/helpers/router.helper.ts` | Cross-route domain side effects                             |

## Adding a main-layout route (typical)

1. Add **`RouterName`** and **`RouterPathEnum`** entries in `router.enum.ts`.
2. Add **`configPath.ts`** child with `global.name`, `global.path`, `route.component` (lazy `import()`), optional `meta.roleAttributes`.
3. If permissions apply, set `meta` — global `beforeEach` reads `roleAttributes` via `PermissionHelper`.
4. Wire navigation from UI: `router.push({ name: RouterName.X, params, query })`.
5. If route params drive entity selection, prefer **`RouterHelper`** in `afterEach` over per-view `onMounted` hacks.

## Navigation patterns

```ts
import { useRouter, useRoute } from 'vue-router';
import { RouterName } from '@/enums';

const router = useRouter();
const route = useRoute();

// Named route (preferred)
router.push({ name: RouterName.ENQUIRY_EDIT, params: { enquiryId: id } });

// React to param change on same component instance
watch(
  () => route.params.enquiryId,
  (id) => {
    /* reload */
  },
);
```

- **`router.push`** — normal navigation
- **`router.replace`** — no new history entry (redirects after save/login)
- **`RouterLink`** — declarative links in templates
- Unsaved changes: **`redirectTo`** / **`SweetAlertHelper.redirectPopUp`** when file already uses them

## Guards & meta

- **Do not** add new global guards outside `router/index.ts`.
- **`meta.roleAttributes`** + **`meta.options`** — permission gating in `beforeEach`.
- **`meta.requiresAuth`** — used on parent routes (e.g. `MainRoutes`).
- Domain sync on navigation → extend **`RouterHelper`**, call from `afterEach`.

## Supplementary (specialists)

**When:** guards, param lifecycle, redirect loops → [by-agent.md](../../specialists/by-agent.md).

**Card:** [vue-router-best-practices](../../specialists/skills/vue-router-best-practices.md) · active refs: [Frontend stack](../../stack-profile.md#frontend-stack).

**Orchestration:** pre-step in [New component](../platform-agents/workflows.md#new-component-default) / [Refactor](../platform-agents/workflows.md#refactor-default). Hand off views to `vue-component-creator`.

## Checklist before finishing

- [ ] `RouterName` / `RouterPathEnum` updated — no magic URL strings in components
- [ ] Route component lazy-loaded via `() => import(...)` like neighbours
- [ ] Permissions via `meta` when route is restricted
- [ ] Navigation uses `useRouter` + named routes
- [ ] Param-driven loads use `watch` on `route.params`, not only `onMounted`
- [ ] Cross-route store sync in `RouterHelper`, not duplicated in views
