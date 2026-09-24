# Conventions cache

Read this file **once** per task. It replaces `stack-profile.md`, `reference.md`, `workflows.md`, and full `.cursor/rules/*.mdc` reads.

Open a rule file only when a detail below is missing. Do not open `.agents/skills/**` unless the task is **Substantial** or you are blocked on a framework gotcha. Do not open review or performance skills unless the user asked.

Bundle **1.1.4**. If you edit a source rule, update this file in the same change. Do not rebuild this file during ordinary feature work.

## Stack

Vue 3 + Vite SPA (`ui/`), Vuetify 3, Vue Router 4, Pinia + Pinia Colada, Axios via `services/` and Colada `api/`. Web SPA only.

NestJS 11 (`src/`), PostgreSQL + TypeORM, `/uiapi/` BFF, Cognito (`CognitoAuthGuard`, `@Session()`), `class-validator` + `ValidationGroup`.

TypeScript strict, ESLint + Prettier, Jest on the backend. Not Nuxt, Quasar, Prisma, custom JWT, Swagger, or Nx.

## Layout

- `@/` → `ui/src/`
- Frontend REST: `/uiapi/` (Vite proxy → NestJS `:3000`)
- Paths: `ui/src/enums/api.enum.ts` · Routes: `ui/src/enums/router.enum.ts`
- Locales: `src/global/locales/` — `useI18n` / `MessageSchema`, keys in English files
- Backend aliases: `@domain/*`, `@uiapi/*`, `@db/*`, `@global/*`, `@infrastructure/*`

## Data layers

| Need | Where |
| ---- | ----- |
| Mutations and legacy reads | `ui/src/services/{domain}.service.ts` — static class, `ServiceHelper.requestWrapper`, `UiApiUrlPathEnum` |
| Selection, wizard, UI flags | Pinia setup store in `ui/src/stores/` |
| New cached GET | `ui/src/queries/` + thin `ui/src/api/` — key includes every param, `enabled` when params are missing |

No HTTP from components, views, or stores. Do not add a new store cache for reads. Do not migrate an old store to Colada unless asked.

## Vue (new code)

`<script setup lang="ts">`. Typed `defineProps` / `defineEmits`; destructure props (defaults in the pattern). `defineModel` for `v-model`. Prefer `computed` over `watch`. `storeToRefs` when destructuring Pinia state. VueUse (`@vueuse/core`) instead of manual `addEventListener`. Keep single-use logic in the SFC — extract `composables/useXxx.ts` only when two or more consumers need it.

Navigation: `useRouter` / `useRoute`, named routes via `RouterName`. Do not hardcode URL strings.

Vuetify forms in this project usually use `variant="underlined"`, `color="#48a0cc"`, `class="font-size-input input-style"`, `v-form` + `useCheckValidation`. Match the file you are editing when it already differs. Code and comments in English.

## Nest (new code)

Thin controller in `src/ui-api/{domain}/`, logic in `src/domain/{domain}/`. `@Controller('/uiapi/...')`, `@UseGuards(CognitoAuthGuard)`, default exports. DTOs in `dto/` with `class-validator` and `ValidationGroup`. Register the module in `src/ui-api/ui-api.module.ts`. New frontend paths go in `api.enum.ts`. Search lists use `FilterParams` and `GridService` — open `data-grid.mdc` only for grid work.

## Read budget

1. This file.
2. **One** domain skill under `.cursor/skills/<name>/SKILL.md`.
3. Neighbouring source files. Match them.
4. Stop. No Handoff section. No `platform-review-agent`. No `platform-performance-agent`.

| Task | Skill |
| ---- | ----- |
| `.vue` UI, copy, cosmetic | `vue-component-creator` |
| Route, guard, navigation | `vue-router-agent` |
| Store shape, selection, flags | `pinia-architect` |
| New cached read | `pinia-colada-expert` |
| `/uiapi` endpoint, DTO, domain | `nestjs-api-agent` |
| List / grid | `data-grid-agent` |

Typo, i18n, or a one-line edit: skill only if needed — match the open file and stop.

More than one layer (new screen, API + UI, grid + route): open [routing.md](../specialists/routing.md) and follow **one** row. Still skip `.agents/skills` and review/perf unless the user asked or the work is Substantial (new domain module, complex composable, architecture).

## Full rule — only if this file is not enough

[vue.mdc](../rules/vue.mdc) · [nestjs.mdc](../rules/nestjs.mdc) · [pinia-stores.mdc](../rules/pinia-stores.mdc) · [pinia-colada.mdc](../rules/pinia-colada.mdc) · [services.mdc](../rules/services.mdc) · [data-grid.mdc](../rules/data-grid.mdc) · [i18n.mdc](../rules/i18n.mdc)
