# Project reference — Dealer Platform (`code/`)

Vue frontend in `code/ui/`. NestJS backend in `code/src/`. Docker orchestration in parent repo `dealer-platform-docker/`.

## Canonical rules (source of truth)

Follow these before improvising conventions:

| Rule file                        | Scope                                                                  |
| -------------------------------- | ---------------------------------------------------------------------- |
| `.cursor/rules/general.mdc`      | Monorepo layout, data layers, backend paths, git                       |
| `.cursor/rules/vue.mdc`          | Vue 3, Vuetify 3, Vue Router, VueUse — components, composables, router |
| `.cursor/rules/pinia-stores.mdc` | Pinia setup stores                                                     |
| `.cursor/rules/pinia-colada.mdc` | Pinia Colada queries & API helpers                                     |
| `.cursor/rules/services.mdc`     | Frontend HTTP — services, api helpers, path enums                      |
| `.cursor/rules/nestjs.mdc`       | NestJS ui-api, domain, DTOs                                            |
| `.cursor/rules/data-grid.mdc`    | DataGrid, metadata, list views                                         |
| `.cursor/rules/i18n.mdc`         | Locales, `useI18n`, key naming                                         |

This file summarizes project layout; when it diverges from the rules, **the rules win**.

## Stack profiles

Frontend, backend, and TypeScript stack (supplementary skills scope) live in **[stack-profile.md](../../stack-profile.md)** — project-wide, not platform-agents-specific.

- [Frontend stack](../../stack-profile.md#frontend-stack)
- [Backend stack](../../stack-profile.md#backend-stack)
- [TypeScript stack](../../stack-profile.md#typescript-stack)

## Agents & supplementary routing

Orchestration and skill chains are **not** in this file — use:

| Layer | Entry |
| ----- | ----- |
| Index | [AGENTS.md](../../../AGENTS.md) |
| **Intent routing** | [decision.md](../../specialists/decision.md) |
| Workflows (create, refactor, full-stack) | [workflows.md](../platform-agents/workflows.md) |
| Bugfix (symptom → layer) | [bugfix.md](../platform-agents/bugfix.md) |
| Supplementary routing (tier, cards) | [specialists/README.md](../../specialists/README.md) |
| Active supplementary scope | [stack-profile.md](../../stack-profile.md) |

Domain agents: `.cursor/skills/{name}/SKILL.md`. Supplementary **content**: `.agents/skills/` (via [skill cards](../../specialists/skills/README.md)).

### Agent naming

| Prefix | Role |
| ------ | ---- |
| `platform-*` | Orchestration & audit across `ui/` + `src/` |
| `vue-*` | Vue/UI domain agents (`vue.mdc`) |
| `pinia-*`, `nestjs-*`, `data-grid-*` | Layer-specific domain agents |

Full table: [AGENTS.md → Naming conventions](../../../AGENTS.md#naming-conventions).

## Prefer latest patterns

Always use **current** norms from `.cursor/rules/` — do not treat legacy code as the template.

- **New work** → rules + reference implementations (`vehicle-configurator.queries.ts`, `SupplementaryProductsSection.vue`), not old store+service caches for read-heavy data.
- **Edits in legacy files** → match that file locally; do not spread legacy patterns to new files or features.
- **Unsure which API to use** → official docs (linked in each rule file), then rules, then reference implementations — not the oldest file in the domain.

## Monorepo layout

```
dealer-platform-docker/
├── docker-compose.yml       # nestjs, frontend, postgres
├── docker/
└── code/                    # workspace root (git root)
    ├── ui/                  # Vue 3 + Vite + TypeScript + Vuetify
    │   └── src/
    │       ├── api/                 # thin HTTP helpers for Colada
    │       ├── components/          # shared + domain components (flat folders)
    │       ├── composables/
    │       ├── enums/               # incl. api.enum.ts (UiApiUrlPathEnum)
    │       ├── interfaces/
    │       ├── layouts/
    │       ├── plugins/             # i18n.ts, vuetify.ts
    │       ├── queries/             # Pinia Colada
    │       ├── router/
    │       ├── services/            # primary HTTP layer
    │       │   └── api/             # Axios client (api.service.ts)
    │       ├── stores/              # Pinia *.store.ts
    │       ├── utils/
    │       └── views/               # route-level pages (often feature-heavy)
    ├── src/                 # NestJS backend
    │   ├── ui-api/          # controllers/DTOs for frontend → /uiapi/
    │   ├── domain/          # business modules
    │   ├── db/              # TypeORM entities, migrations
    │   ├── global/          # enums, locales
    │   └── infrastructure/
    └── env/
```

Path alias: `@/` → `ui/src/` (`ui/vite.config.mts`).

## Environment & API

| Topic                | Value                                                         |
| -------------------- | ------------------------------------------------------------- |
| Frontend REST prefix | `/uiapi/`                                                     |
| Dev proxy            | Vite proxies `^/uiapi/` → NestJS (`nestjs:3000` in Docker)    |
| HTTP client          | `ui/src/services/api/api.service.ts` (Axios)                  |
| Path enums           | `ui/src/enums/api.enum.ts` (`UiApiUrlPathEnum`, `ApiBaseUrl`) |

## State & data layers

| Layer                    | Role                                            | When to use                            |
| ------------------------ | ----------------------------------------------- | -------------------------------------- |
| `ui/src/services/`       | Primary HTTP — class services + `ServiceHelper` | Default for most domains               |
| `ui/src/stores/`         | Pinia setup stores — domain state + often HTTP  | Existing flows (`enquiry.store.ts`, …) |
| `ui/src/queries/`        | Pinia Colada — cached read queries              | New read-heavy features                |
| `ui/src/api/`            | Thin HTTP helpers for Colada                    | Used by `ui/src/queries/`              |
| `views/` / `components/` | UI — stores, services, composables              | Match neighbouring files               |

**Legacy norm:** stores call `XxxService` and cache entities (`selectedEnquiry`, `enquiries`).
**New read-heavy data:** use Pinia Colada in `ui/src/queries/` — do not migrate legacy stores unless asked.

## HTTP pattern (dominant)

See `.cursor/rules/services.mdc` for when to use `services/` vs `api/`.

```
Component / Store
  → services/{domain}.service.ts     (class, static methods)
    → ServiceHelper.requestWrapper()
      → services/api/api.service.ts
        → /uiapi/...
```

Example:

```ts
// ui/src/services/enquiry.service.ts
import { ApiBaseUrl, RequestMethodEnum, UiApiUrlPathEnum } from '@/enums';
import { ServiceHelper } from '@/utils/helpers';

export class EnquiryService {
  static async getEnquiry(id: string) {
    return ServiceHelper.requestWrapper({
      method: RequestMethodEnum.GET,
      url: `${ApiBaseUrl}${UiApiUrlPathEnum.ENQUIRY}/${id}`,
    });
  }
}
```

## Pinia Colada

Registered in `ui/src/main.ts`: `app.use(createPinia())` then `app.use(PiniaColada)`.

Reference implementation:

- `ui/src/queries/vehicle-configurator.queries.ts` — `defineQueryOptions`, `VEHICLE_CONFIGURATOR_KEYS`
- `ui/src/api/vehicle-configurator.api.ts` — HTTP called from queries
- Consumer: `SupplementaryProductsSection.vue` — `useQuery(() => …)`, `.data`, `.isPending`, `.error`, `.refresh`

See `.cursor/rules/pinia-colada.mdc` for naming, key factories, and `enabled` guards.

## Pinia stores

- Files: `ui/src/stores/{domain}.store.ts`
- Export: `use{Domain}Store`, id: kebab-case
- Setup stores only; HTTP via `@/services/`
- Often cache server entities and call services directly (`enquiry.store.ts`, `user.store.ts`)

See `.cursor/rules/pinia-stores.mdc`.

## Vue components & composables

- `<script setup lang="ts">` standard — see `.cursor/rules/vue.mdc`
- i18n: `useI18n<{ message: MessageSchema }>({ useScope: 'global' })` or `useAppI18n()`
- Vuetify 3 via `plugins/vuetify.ts`; forms often use `variant="underlined"`, `color="#48a0cc"`
- Modals: prefer `CustomModal`; validation via `v-form` + `useCheckValidation(formRef)`
- VueUse (`@vueuse/core`) for browser/DOM utilities — not manual `addEventListener` in new code
- Components grouped by domain folder: `components/WhatNextAction/`, `components/DataGrid/`
- Views are route shells but often contain substantial logic — match existing view style

## Vue Router

- Setup: `ui/src/router/index.ts` → registered in `main.ts`
- Enums: `ui/src/enums/router.enum.ts` — `RouterName`, `RouterPathEnum`, `RouterPathBaseEnum`
- Main menu routes: `ui/src/config/configPath.ts` (lazy `component: () => import(...)`)
- Standalone trees: `ui/src/router/AuthRoutes.ts`, `AppraisalRoutes.ts`, …
- Guards: global `beforeEach` / `afterEach` in `index.ts` only
- `meta.roleAttributes` — permission checks via `PermissionHelper` in `beforeEach`
- Route-change enquiry sync: `RouterHelper.syncSelectedEnquiryOnRouteChange` in `afterEach`
- Navigation in views: `useRouter()` / `useRoute()` — prefer named routes, not hardcoded paths
- Context route maps: `ui/src/constants/*-routes.ts`

See `.cursor/rules/vue.mdc` and skill `vue-router-agent`.

## i18n

See `.cursor/rules/i18n.mdc`.

Single source: `src/global/locales/en/` (domain files: `enquiry.ts`, `vehicle.ts`, `what-next.ts`, …).

```ts
// ui/src/plugins/i18n.ts
import * as messages from '../../../src/global/locales';
```

Add new keys in `src/global/locales/en/`, not in `ui/`.

## Backend (NestJS)

See **[Backend stack](../../stack-profile.md#backend-stack)** in `stack-profile.md` for active stack profile and `nestjs-best-practices` rule scope.
See `.cursor/rules/nestjs.mdc`. Skill: `nestjs-api-agent`.

| Package                | Role                                                  |
| ---------------------- | ----------------------------------------------------- |
| `src/ui-api/{domain}/` | Controllers + DTOs → `/uiapi/`                        |
| `src/domain/{domain}/` | Business logic (`*.service.ts`, `*.domain.module.ts`) |
| `src/db/`              | TypeORM entities, repos, migrations                   |
| `src/global/enum/`     | Shared enums                                          |
| `src/infrastructure/`  | Guards (`CognitoAuthGuard`), pipes, validators        |

Aliases: `@domain/*`, `@uiapi/*`, `@db/*`, `@global/*`, `@infrastructure/*`.

Reference: `customer.controller.ts`, `customer.service.ts`, `customer.ui-api.module.ts`.

Grid metadata: `src/domain/grid/metadata/`.

## DataGrid (list screens)

See `.cursor/rules/data-grid.mdc`. Skill: `data-grid-agent`.

| Piece            | Location                                       |
| ---------------- | ---------------------------------------------- |
| Components       | `ui/src/components/DataGrid/`, `TreeDataGrid/` |
| Metadata URLs    | `UiApiGridUrlPathEnum` in `api.enum.ts`        |
| Search URLs      | `UiApiUrlPathEnum.*_SEARCH`                    |
| Backend metadata | `src/domain/grid/metadata/*.metadata.ts`       |
| Grid API         | `src/ui-api/grids/grids.controller.ts`         |

Reference: `CustomerList.vue` (TreeDataGrid), `FieldSetManagmentList.vue` (DataGrid).

## Naming conventions

| Artifact          | Pattern                                  | Example                                     |
| ----------------- | ---------------------------------------- | ------------------------------------------- |
| Service           | `services/{domain}.service.ts`           | `enquiry.service.ts`                        |
| Store             | `stores/{domain}.store.ts`               | `enquiry.store.ts`                          |
| Colada queries    | `queries/{domain}.queries.ts`            | `vehicle-configurator.queries.ts`           |
| Colada API        | `api/{domain}.api.ts`                    | `vehicle-configurator.api.ts`               |
| Component         | `components/{Domain}/{Name}.vue`         | `WhatNextAction/WhatNextAction.vue`         |
| View              | `views/{domain}/{Name}/{Name}.vue`       | `enquiry/AddEditEnquiry/AddEditEnquiry.vue` |
| Composable        | `composables/use{Name}.ts`               | `useAppI18n.ts`                             |
| Interface         | `interfaces/{domain}/`                   | `interfaces/enquiry/enquiry.interface.ts`   |
| Route enum        | `enums/router.enum.ts`                   | `RouterName`, `RouterPathEnum`              |
| UI API controller | `ui-api/{domain}/{domain}.controller.ts` | `customer.controller.ts`                    |
| Domain service    | `domain/{domain}/{domain}.service.ts`    | `customer.service.ts`                       |
