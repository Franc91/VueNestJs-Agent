# Agent notes (optional, private) — template

**Not** in `.cursor/specialists/` (bundle agent routing). **Not** installed by `install.ps1`.

## Suggested layout in your workspace

```
docs/agent/
  README.md              # how to use
  index.md               # domain index with links only (optional)
  domains/
    data-layers.md
    {your-domain}.md     # one file per module
```

1. Create `docs/agent/` in your app repo
2. Add `/docs/agent/` to `.gitignore` if private
3. `@docs/agent/domains/{name}.md` in chat — never auto-loaded

## Example domain file (`domains/orders.md`)

```markdown
# Orders

**Entry:** `ui/src/views/Orders/Orders.vue`
**Store:** `useOrdersStore` — via `OrdersService`
**Do not:** migrate to Colada unless asked
```

## Data layers (copy to `domains/data-layers.md`)

| Layer | When to use |
| ----- | ----------- |
| `ui/src/services/` + `ServiceHelper` | Default HTTP |
| `ui/src/stores/` | Domain state + mutations |
| `ui/src/queries/` + `ui/src/api/` | New read-heavy cached data |
