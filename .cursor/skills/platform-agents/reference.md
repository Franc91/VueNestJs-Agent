# Project reference — Vue + NestJS monorepo

**Template** — customize paths and examples for your workspace after `install.ps1`.

Assumed layout (adjust if yours differs):

- Frontend: `{workspace}/ui/` (Vue 3 + Vite)
- Backend: `{workspace}/src/` (NestJS)
- UI API prefix: `/uiapi/`

## Customize for your project

| What to set | Where |
| ----------- | ----- |
| Stack (UI lib, ORM, auth) | [stack-profile.md](../../stack-profile.md) |
| Folder layout, reference files | This file — edit paths below |

Point **reference implementations** to real files in **your** repo (one Colada query + consumer, one store + service, one grid, one controller).

## Canonical rules

| Rule file | Scope |
| --------- | ----- |
| `.cursor/rules/general.mdc` | Layout, git, agent routing |
| `.cursor/rules/vue.mdc` | Vue 3, Vuetify, Router, VueUse |
| `.cursor/rules/pinia-stores.mdc` | Pinia setup stores |
| `.cursor/rules/pinia-colada.mdc` | Cached read queries |
| `.cursor/rules/services.mdc` | HTTP — services vs api |
| `.cursor/rules/nestjs.mdc` | ui-api, domain, DTOs |
| `.cursor/rules/data-grid.mdc` | DataGrid, metadata |
| `.cursor/rules/i18n.mdc` | Locales, `useI18n` |

Rules win over this summary.

## Agent routing

| Layer | Entry |
| ----- | ----- |
| Index | [AGENTS.md](../../../AGENTS.md) |
| Intent | [routing.md](../../specialists/routing.md) |
| Workflows | [workflows.md](../platform-agents/workflows.md) |
| Bugfix | [bugfix.md](../platform-agents/bugfix.md) |
| Supplementary | [specialists/README.md](../../specialists/README.md) |

## Monorepo layout (typical)

```
your-repo/                   # or workspace root
├── ui/                      # Vue 3 + Vite + TypeScript
│   └── src/
│       ├── api/             # thin HTTP for Colada
│       ├── components/
│       ├── composables/
│       ├── enums/           # api.enum.ts, router.enum.ts
│       ├── queries/         # Pinia Colada
│       ├── router/
│       ├── services/        # class services + ServiceHelper
│       ├── stores/          # Pinia *.store.ts
│       └── views/
├── src/                     # NestJS
│   ├── ui-api/              # BFF → /uiapi/
│   ├── domain/
│   ├── db/
│   └── global/              # enums, shared locales
└── env/                     # optional
```

Path alias: `@/` → `ui/src/` (common Vite setup).

## Environment & API

| Topic | Typical value |
| ----- | ------------- |
| Frontend REST | `/uiapi/` |
| Dev proxy | Vite → NestJS `:3000` |
| HTTP client | `ui/src/services/api/api.service.ts` (Axios) |
| Path enums | `ui/src/enums/api.enum.ts` |

## State & data layers

| Layer | Role | When |
| ----- | ---- | ---- |
| `services/` + `ServiceHelper` | Primary HTTP | Default mutations & legacy stores |
| `stores/` | Domain + UI state | Selection, wizards, flags |
| `queries/` + `api/` | Pinia Colada | **New** read-heavy cached data |

Do not migrate legacy store caches to Colada unless asked.

## HTTP pattern

```
Component / Store
  → services/{domain}.service.ts
    → ServiceHelper.requestWrapper()
      → api.service.ts → /uiapi/...
```

## Pinia Colada (new reads)

Pick **your** reference pair after install:

- `ui/src/queries/{domain}.queries.ts` — `defineQueryOptions`, key factory
- `ui/src/api/{domain}.api.ts` — HTTP only
- Consumer `.vue` — `useQuery(() => …)`, `.data`, `.isPending`, `.refresh`

See [examples.md](../platform-agents/examples.md) §1.

## Pinia stores

- `{domain}.store.ts` → `use{Domain}Store`
- Setup stores; HTTP via `@/services/`
- Example pattern: selected entity + `setSelected*` actions

## Vue & router

- `<script setup lang="ts">`, typed props/emits
- Router enums in `enums/router.enum.ts`; lazy routes in config/router files
- Guards in `router/index.ts` — match your project's auth pattern

## i18n

Shared locales outside `ui/` or under `src/global/locales/` — see `i18n.mdc`. Add keys in locale modules, not hardcoded in components.

## Backend (NestJS)

| Package | Role |
| ------- | ---- |
| `src/ui-api/{domain}/` | Controllers + DTOs |
| `src/domain/{domain}/` | Business logic |
| `src/db/` | TypeORM entities, migrations |
| `src/domain/grid/metadata/` | DataGrid metadata |

Pick **your** reference controller + service (e.g. a simple CRUD domain).

## DataGrid

- UI: `DataGrid` / `TreeDataGrid` components
- Backend metadata: `src/domain/grid/metadata/*.metadata.ts`
- Enums: grid + search URL paths in `api.enum.ts`

## Naming conventions

| Artifact | Pattern |
| -------- | ------- |
| Service | `services/{domain}.service.ts` |
| Store | `stores/{domain}.store.ts` |
| Colada | `queries/{domain}.queries.ts` + `api/{domain}.api.ts` |
| View | `views/{Feature}/{Name}.vue` |
| UI API | `ui-api/{domain}/{domain}.controller.ts` |
