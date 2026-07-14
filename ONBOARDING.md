# Onboarding — 3 steps

For **Dealer Platform** (`dealer-platform-docker/code/`). Agent bundle: **`Desktop/VueNestJs Agent/`**.

## Step 1 — Config

```powershell
cd "$env:USERPROFILE\Desktop\VueNestJs Agent"
Copy-Item install.config.example.json install.config.json
```

Edit `install.config.json` — path to **your** `code/` folder:

```json
{
  "codeWorkspace": "C:\\Users\\Szymon\\Desktop\\dealer-platform-docker\\code"
}
```

## Step 2 — Install

```powershell
.\install.ps1 -InstallSupplementary
```

Copies `.cursor/`, `AGENTS.md`, and `skills-lock.json` into `code/` and installs 9 supplementary skills.

## Step 3 — Verify & use

```powershell
.\doctor.ps1
```

Open **`code/`** in Cursor (not parent docker folder). Start at:

- [AGENTS.md](AGENTS.md) or
- [.cursor/specialists/decision.md](.cursor/specialists/decision.md)

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
| Old copy under `dealer-platform-docker\dealer-platform-cursor` | `.\cleanup-legacy.ps1` |

## Give to another dev

1. Share this repo (zip or git clone).
2. They complete Steps 1–3 with **their** `codeWorkspace` path.
3. Optional: own `mcp.example.json` → `code/.cursor/mcp.json`.
