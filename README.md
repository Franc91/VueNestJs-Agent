# VueNestJs Agent

Cursor agent setup for **Vue 3 + NestJS full-stack monorepos** (`ui/` + `src/`, `/uiapi/` BFF). Installs into your app workspace — **not** part of the application git repo.

**Version:** [VERSION](VERSION) · **Changelog:** [CHANGELOG.md](CHANGELOG.md)

**Location:** e.g. `Desktop/VueNestJs Agent/`

## Quick start

→ **[ONBOARDING.md](ONBOARDING.md)** (3 steps)

```powershell
cd "$env:USERPROFILE\Desktop\VueNestJs Agent"
Copy-Item install.config.example.json install.config.json
# edit codeWorkspace → path to your repo root (or monorepo code/ folder)
.\install.ps1 -InstallSupplementary
.\doctor.ps1
```

## Scripts

| Script | Description |
| ------ | ------------- |
| `install.ps1` | Install into target workspace (preserves `mcp.json`) |
| `install.ps1 -InstallSupplementary` | + supplementary skills |
| `doctor.ps1` | Health check + link validator |
| `update.ps1` | `git pull` + reinstall |
| `cleanup-legacy.ps1` | Remove old nested bundle copy (if you migrated layout) |

Linux / macOS: `install.sh`, `doctor.sh`, `update.sh`

## Config

`install.config.json` (from [install.config.example.json](install.config.example.json)) — gitignored, per machine:

```json
{
  "codeWorkspace": "C:\\path\\to\\your\\project"
}
```

## Installed into target workspace

| Source | Destination |
| ------ | ----------- |
| `.cursor/` | `{codeWorkspace}/.cursor/` |
| `AGENTS.md` | `{codeWorkspace}/AGENTS.md` |
| `skills-lock.json` | `{codeWorkspace}/skills-lock.json` |

`ONBOARDING.md` stays in the bundle repo only — not copied into the app repo.

## Customize for your project

After install, edit in **your** workspace (overwritten on `update.ps1` — keep customizations in bundle or re-apply):

| File | Purpose |
| ---- | ------- |
| [`.cursor/stack-profile.md`](.cursor/stack-profile.md) | Your stack (UI lib, ORM, auth, deployment) |
| [`.cursor/skills/platform-agents/reference.md`](.cursor/skills/platform-agents/reference.md) | Layout paths, reference implementations |

## Optional: private project notes

[docs/agent/index.example.md](docs/agent/index.example.md) — template for **local** domain notes. Copy manually to `{workspace}/docs/agent/index.md`; add `docs/agent/` to project `.gitignore` if private. Not installed, not routed by agent.

## Publish (optional git remote)

```powershell
git remote add origin git@github.com:YOUR_ORG/vue-nestjs-agent.git
git push -u origin main
```

Share repo → recipient follows [ONBOARDING.md](ONBOARDING.md).

## Using agents

Open your workspace in Cursor → [AGENTS.md](AGENTS.md) or [.cursor/specialists/routing.md](.cursor/specialists/routing.md).
