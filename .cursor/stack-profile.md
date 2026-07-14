# Stack profile — your project

Default template for a **Vue 3 + NestJS** monorepo. **Edit after install** to match your app workspace.

**Not** part of `platform-agents` — applies to all agents (`vue-component-creator`, `nestjs-api-agent`, etc.).

When the stack changes, update **this file first**, then align `.cursor/rules/` and domain agent skills.

Project rules (`.cursor/rules/`) always win over generic skill advice.

Supplementary skills (`.agents/skills/`) are **explicit-read only** — routing: [specialists/README.md](specialists/README.md); active scope below. Their own `SKILL.md` may say "MUST be used"; follow this file instead.

## Frontend stack

**Single source of truth** for the active UI stack and which supplementary skill references apply. Update when migrating (e.g. to Nuxt or Quasar); then align `.cursor/rules/vue.mdc` and domain agents.

| Area           | Current choice                        | Notes                                                                      |
| -------------- | ------------------------------------- | -------------------------------------------------------------------------- |
| **Framework**  | Vue 3 + Vite SPA                      | `ui/` — not Nuxt                                                           |
| **UI library** | Vuetify 3                             | `plugins/vuetify.ts` — not Quasar                                          |
| **Routing**    | Vue Router 4                          | `router/`, `configPath.ts`, `router.enum.ts` — not Nuxt file-based routing |
| **State**      | Pinia + Pinia Colada                  | `stores/`, `queries/`                                                      |
| **HTTP**       | Axios via `services/` + Colada `api/` | `/uiapi/` proxy                                                            |
| **Mobile**     | Web SPA only                          | Capacitor / hybrid not used                                                |

### Supplementary skills — active references

| Skill | Read when | Active references / topics |
| ----- | --------- | -------------------------- |
| [`vue-best-practices`](specialists/skills/vue-best-practices.md) | Component/reactivity/SFC gotchas | `reactivity.md`, `sfc.md`, `component-data-flow.md`, `composables.md` |
| [`vue`](specialists/skills/vue.md) | Vue 3.5 API details | `script-setup-macros.md`, `core-new-apis.md`, `advanced-patterns.md` |
| [`vue-expert`](specialists/skills/vue-expert.md) | Complex composables, TypeScript, architecture | `composition-api.md`, `components.md`, `state-management.md`, `typescript.md`, `build-tooling.md` |
| [`vue-router-best-practices`](specialists/skills/vue-router-best-practices.md) | Guards, param lifecycle, redirect loops | All `reference/*.md` in skill |
| [`vue-pinia-best-practices`](specialists/skills/vue-pinia-best-practices.md) | Store reactivity gotchas | All `reference/*.md` in skill |

### Supplementary skills — inactive (frontend)

Do **not** apply these unless the table above is updated after a migration:

| Skill        | Inactive references                                    | Reason                                |
| ------------ | ------------------------------------------------------ | ------------------------------------- |
| `vue-expert` | `references/nuxt.md`                                   | Project is Vite SPA, not Nuxt SSR/SSG |
| `vue-expert` | `references/mobile-hybrid.md` (Quasar, Capacitor, PWA) | Web-only; UI is Vuetify               |

### Migrating the frontend stack

1. **This file** (`stack-profile.md` → Frontend stack) — update tables.
2. **`.cursor/rules/vue.mdc`** — Vuetify ↔ Quasar, Vue Router ↔ Nuxt routing, etc.
3. **Domain agents** — `vue-component-creator` (UI), `vue-router-agent` (routing).
4. **`AGENTS.md`** — only if skill roles change.
5. **Verify** `npx skills list` — skills stay installed; only which references you read changes.

**Nuxt:** enable `vue-expert` → `nuxt.md`; rework `vue-router-agent` for `pages/`, `definePageMeta`, middleware.
**Quasar:** enable `vue-expert` → `mobile-hybrid.md` (Quasar sections); rework `vue-component-creator` for `q-*` components.
**Capacitor / mobile:** enable `mobile-hybrid.md`; add mobile workflow to `workflows.md` if needed.

## Backend stack

**Single source of truth** for the active API stack and which supplementary skill rules apply. Update when migrating (e.g. to microservices or a different ORM); then align `.cursor/rules/nestjs.mdc` and `nestjs-api-agent`.

| Area             | Current choice                        | Notes                                                             |
| ---------------- | ------------------------------------- | ----------------------------------------------------------------- |
| **Framework**    | NestJS 11                             | `src/` — modular monolith                                         |
| **Database**     | PostgreSQL + TypeORM                  | `src/db/entities/`, migrations in `src/db/migrations/`            |
| **API surface**  | `/uiapi/` controllers                 | `src/ui-api/{domain}/` — BFF for Vue frontend                     |
| **Domain layer** | `src/domain/{domain}/`                | Business logic in `*.service.ts`                                  |
| **Auth**         | AWS Cognito                           | `CognitoAuthGuard`, `@Session() { user }` — not custom JWT module |
| **Validation**   | `class-validator` + `ValidationGroup` | DTOs in `src/ui-api/{domain}/dto/`                                |
| **Deployment**   | Docker Compose (typical)              | Or bare metal / K8s — update this row for your setup            |

### Supplementary skills — active rule categories

| Skill | Read when | Active categories / rules (`rules/*.md`) |
| ----- | --------- | ---------------------------------------- |
| [`nestjs-best-practices`](specialists/skills/nestjs-best-practices.md) | Module/DI, guards, exception filters, circular deps | **Architecture** (`arch-*`), **DI** (`di-*`), **Error** (`error-*`), **Security** (selected `security-*`, Cognito), **Performance** (`perf-*`), **Database** (`db-*`), **API** (`api-*`) |
| [`nestjs-best-practices`](specialists/skills/nestjs-best-practices.md) | Backend tests (when requested) | **Testing** (`test-*`) |
| [`nestjs-expert`](specialists/skills/nestjs-expert.md) | Complex modules, DTOs, TypeORM services | `controllers-routing.md`, `services-di.md`, `dtos-validation.md`, `testing-patterns.md` |

Load individual rule files from `.agents/skills/nestjs-best-practices/rules/` for the active prefixes above. If `rules/` is missing after `npx skills add`, copy it from the [upstream repo](https://github.com/kadajett/agent-nestjs-skills/tree/main/rules) — the installer ships only `SKILL.md` by default.

### Supplementary skills — inactive (backend)

Do **not** apply these unless the table above is updated after a migration:

| Skill                   | Inactive categories / rules                             | Reason                                                                       |
| ----------------------- | ------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `nestjs-best-practices` | **Microservices** (`micro-*`)                           | Single NestJS app + Postgres in Docker — not message queues / service mesh   |
| `nestjs-best-practices` | `security-auth-jwt`                                     | Auth is Cognito + session guard — follow `nestjs.mdc` and `CognitoAuthGuard` |
| `nestjs-best-practices` | `api-versioning`                                        | Frontend uses path enums (`UiApiUrlPathEnum`) — no URI versioning layer      |
| `nestjs-best-practices` | **DevOps** (`devops-*`) unless debugging config/logging | Docker Compose owns runtime; env in `env/`                                   |
| `nestjs-expert`         | `references/authentication.md` (JWT, Passport)          | Auth is Cognito — follow `nestjs.mdc` and `CognitoAuthGuard`                 |
| `nestjs-expert`         | `references/migration-from-express.md`                  | Greenfield NestJS codebase — not an Express migration                        |
| `nestjs-expert`         | Swagger/OpenAPI examples in skill                       | Project controllers do not use `@nestjs/swagger` — follow `nestjs.mdc`       |
| `nestjs-expert`         | Prisma patterns (if present in skill)                   | ORM is TypeORM — follow `src/db/` conventions                                |

### Migrating the backend stack

1. **This file** (`stack-profile.md` → Backend stack) — update tables.
2. **`.cursor/rules/nestjs.mdc`** and **`general.mdc`** — layers, auth, ORM, API prefix.
3. **`nestjs-api-agent`** — templates, checklists, handoff format.
4. **`AGENTS.md`** — only if skill roles change.
5. **Verify** `npx skills list` — skills stay installed; only which rules you read changes.

**Microservices:** enable `micro-*` rules; split modules/workflows; revisit `/uiapi/` boundary.
**Prisma / other ORM:** update `nestjs.mdc` + `db-*` applicability; rework `src/db/` conventions.
**Custom JWT / OAuth (non-Cognito):** enable `security-auth-jwt`; replace guard examples in `nestjs-api-agent`.
**Public REST API with versioning:** enable `api-versioning`; add versioning section to `nestjs.mdc`.

## TypeScript stack

**Single source of truth** for shared TypeScript conventions across `ui/` and `src/`. Applies to both frontend and backend agents.

| Area               | Current choice               | Notes                                                     |
| ------------------ | ---------------------------- | --------------------------------------------------------- |
| **Language**       | TypeScript (strict)          | Vue: `vue-tsc`; NestJS: `tsc` via Nest build              |
| **Frontend check** | `npm run typecheck` in `ui/` | `vue-tsc --noEmit`                                        |
| **Backend check**  | Nest build / IDE             | Path aliases: `@/` (ui), `@domain/*`, `@uiapi/*`, … (src) |
| **Lint**           | ESLint + Prettier            | Not Biome                                                 |
| **Tests**          | Jest (backend)               | Not Vitest-first                                          |

### Supplementary skills — active

| Skill | Read when | Active topics |
| ----- | --------- | --------------- |
| [`typescript-advanced-types`](specialists/skills/typescript-advanced-types.md) | Complex generics, utility/mapped/conditional types, typed props/DTOs | Full `SKILL.md`; `references/details.md` |
| [`typescript-expert`](specialists/skills/typescript-expert.md) | `tsc` / `vue-tsc` errors, tsconfig, module resolution | Type-level debugging, performance, strict options |

Use with domain agents: `vue-component-creator` / `vue-expert` (UI types), `nestjs-api-agent` / `nestjs-expert` (DTOs, services).

### Supplementary skills — inactive (TypeScript)

| Skill               | Inactive topics                                                           | Reason                                                    |
| ------------------- | ------------------------------------------------------------------------- | --------------------------------------------------------- |
| `typescript-expert` | Biome migration                                                           | Project uses ESLint + Prettier                            |
| `typescript-expert` | Nx / Turborepo monorepo setup                                             | Layout is `code/ui` + `code/src`, not Nx/Turbo workspaces |
| `typescript-expert` | JS → TS migration playbooks                                               | Codebase is already TypeScript                            |
| `typescript-expert` | `typescript-build-expert` / `typescript-module-expert` subagent redirects | Only if bundler/module crisis beyond project scope        |

### Migrating TypeScript tooling

1. **This file** (`stack-profile.md` → TypeScript stack) — update tables.
2. **`ui/tsconfig.json`** and root **`tsconfig.json`** / **`nest-cli.json`**.
3. **Domain agents** — props/DTO typing conventions in `vue.mdc` / `nestjs.mdc`.
4. **`AGENTS.md`** — if supplementary skill roles change.
