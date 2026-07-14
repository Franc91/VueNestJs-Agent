# Onboarding — 3 steps

For any **Vue 3 + NestJS** monorepo. Agent bundle: **`VueNestJs Agent/`** (e.g. on Desktop).

## Step 1 — Config

```powershell
cd "$env:USERPROFILE\Desktop\VueNestJs Agent"
Copy-Item install.config.example.json install.config.json
```

Edit `install.config.json` — absolute path to **your** app workspace (git root or `code/` folder):

```json
{
  "codeWorkspace": "C:\\path\\to\\your\\project"
}
```

## Step 2 — Install

```powershell
.\install.ps1 -InstallSupplementary
```

Copies `.cursor/`, `AGENTS.md`, and `skills-lock.json` into the target workspace and installs supplementary skills.

## Step 3 — Verify & customize

```powershell
.\doctor.ps1
```

Open the **target workspace** in Cursor (the folder set in `codeWorkspace`). Start at:

- [AGENTS.md](AGENTS.md) or
- [.cursor/specialists/routing.md](.cursor/specialists/routing.md)

Then align [stack-profile.md](.cursor/stack-profile.md) and [reference.md](.cursor/skills/platform-agents/reference.md) with your repo layout.

---

## Daily workflow

| Task | Command |
| ---- | ------- |
| Health check | `.\doctor.ps1` |
| Update bundle | `.\update.ps1` |
| Reinstall only | `.\install.ps1` |

## Troubleshooting

| Problem | Fix |
| ------- | --- |
| `Missing install.config.json` | Step 1 |
| `Target path not found` | Fix `codeWorkspace` (use `\\` on Windows) |
| Supplementary check fails | `.\install.ps1 -InstallSupplementary` |
| Lost MCP config | `mcp.json` preserved on reinstall — else copy from `mcp.example.json` |
| Old nested bundle copy | `.\cleanup-legacy.ps1` |

## Give to another dev

1. Share this bundle (zip or git clone).
2. They complete Steps 1–3 with **their** `codeWorkspace` path.
3. They customize `stack-profile.md` / `reference.md` for their stack.
4. Optional: own `mcp.example.json` → `{workspace}/.cursor/mcp.json`.
