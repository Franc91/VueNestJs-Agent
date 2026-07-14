---
name: nestjs-api-agent
description: Adds or changes NestJS ui-api endpoints — controllers, DTOs, domain services, entities, and module wiring. Use when creating or fixing backend API, /uiapi routes, search endpoints, DTOs, or domain logic in code/src.
---

# NestJS API Agent

Designs and wires backend endpoints in `code/src/`. Frontend paths must stay in sync with `ui/src/enums/api.enum.ts`.

**Canonical rules:** `.cursor/rules/nestjs.mdc`, `.cursor/rules/general.mdc`
Frontend HTTP: `.cursor/rules/services.mdc` (when adding matching service methods)
Project summary: [../platform-agents/reference.md](../platform-agents/reference.md)

## Prefer latest patterns

Follow `nestjs.mdc` — thin controllers, domain services, DTO validation, `CognitoAuthGuard`. Match `customer.controller.ts` and `customer.service.ts`.

## Rule

Do not write code if information is missing.
Ask questions first.

## When to use this skill vs frontend agents

| Task                                       | Skill                                                         |
| ------------------------------------------ | ------------------------------------------------------------- |
| New `/uiapi` endpoint, DTO, domain logic   | `nestjs-api-agent`                                            |
| Frontend service calling existing endpoint | `vue-component-creator` + `services.mdc`                      |
| New cached read on frontend                | `pinia-colada-expert` + `nestjs-api-agent` if endpoint is new |
| Entity/migration design                    | `nestjs-api-agent` — confirm migration scope with user        |

## Full-stack flow (new endpoint)

```
1. nestjs-api-agent     → controller + DTO + domain service + module
2. services.mdc layer   → UiApiUrlPathEnum + CustomerService / api helper
3. pinia-colada-expert  → if read-heavy cached data on frontend
4. vue-component-creator → UI consumption
```

## Adding an endpoint (checklist)

1. **Domain** — method on `src/domain/{domain}/{domain}.service.ts` (or new domain module)
2. **DTO** — `src/ui-api/{domain}/dto/` with `class-validator` + `ValidationGroup` if create/update
3. **Controller** — `@Controller('/uiapi/...')`, guard, pipes, delegate to service
4. **Module** — wire in `{domain}.ui-api.module.ts`; register in `ui-api.module.ts` if new domain
5. **Frontend enum** — add `ApiBaseUrl` / `UiApiUrlPathEnum` entry in `ui/src/enums/api.enum.ts`
6. **Frontend HTTP** — `XxxService` static method or `api/` helper (see `services.mdc`)
7. **DataGrid** — if list screen: hand off to `data-grid-agent` for metadata + view wiring

## Controller template

```ts
@UseGuards(CognitoAuthGuard)
@Controller('/uiapi/my-domain')
export default class MyDomainController {
  constructor(private readonly myDomainService: MyDomainService) {}

  @Post('search')
  @HttpCode(200)
  public async search(
    @Body() params: FilterParams,
    @Session() { user }: SessionData,
  ): Promise<SearchResponse<MyEntity>> {
    return this.myDomainService.search(params, user);
  }
}
```

## UI API module template

```ts
@Module({
  imports: [MyDomainDomainModule, TypeOrmModule.forFeature([Repository<MyEntity>])],
  controllers: [MyDomainController],
})
export default class MyDomainUiApiModule {}
```

## Handoff to frontend

When endpoint is ready, hand off with:

```markdown
## Handoff

- **Endpoint**: POST /uiapi/my-domain/search
- **UiApiUrlPathEnum**: MY_DOMAIN_SEARCH (added in api.enum.ts)
- **Next**: vue-component-creator or pinia-colada-expert for UI wiring
```

## Supplementary (specialists)

Classify **backend tier** in [backend-tier.md](../../specialists/backend-tier.md) before coding. **Default when unsure:** Standard.

**Cards:** [nestjs-best-practices](../../specialists/skills/nestjs-best-practices.md), [nestjs-expert](../../specialists/skills/nestjs-expert.md), [typescript-advanced-types](../../specialists/skills/typescript-advanced-types.md) · routing: [by-agent.md](../../specialists/by-agent.md).

**Orchestration:** [Backend only](../platform-agents/workflows.md#backend-only) · pre-step for API reads/lists. Hand off UI to `pinia-colada-expert` or `vue-component-creator`.

## Checklist before finishing

- [ ] Controller thin — logic in domain service
- [ ] DTO validated (`CustomValidationPipe` / `ValidationGroup` where neighbours use it)
- [ ] `CognitoAuthGuard` on protected routes
- [ ] Module registered in `ui-api.module.ts`
- [ ] `UiApiUrlPathEnum` updated for new paths
- [ ] No business logic duplicated between controller and service
