# VueNestJs Agent

Cursor agent setup for **Dealer Platform** (Vue 3 + NestJS full-stack). Installs into `dealer-platform-docker/code/` locally — **not** part of the application git repo.

**Version:** [VERSION](VERSION) · **Changelog:** [CHANGELOG.md](CHANGELOG.md)

**Location:** `Desktop/VueNestJs Agent/`

## Quick start

→ **[ONBOARDING.md](ONBOARDING.md)** (3 steps)

```powershell
cd "$env:USERPROFILE\Desktop\VueNestJs Agent"
Copy-Item install.config.example.json install.config.json
# edit codeWorkspace
.\install.ps1 -InstallSupplementary
.\doctor.ps1
```

## Scripts

| Script | Description |
| ------ | ------------- |
| `install.ps1` | Install into `code/` (preserves `mcp.json`) |
| `install.ps1 -InstallSupplementary` | + supplementary skills |
| `doctor.ps1` | Health check + link validator |
| `update.ps1` | `git pull` + reinstall |
| `cleanup-legacy.ps1` | Remove old copy under `dealer-platform-docker/` |

Linux / macOS: `install.sh`, `doctor.sh`, `update.sh`

## Config

`install.config.json` (from [install.config.example.json](install.config.example.json)) — gitignored, per machine:

```json
{
  "codeWorkspace": "C:\\Users\\Szymon\\Desktop\\dealer-platform-docker\\code"
}
```

## Installed into `code/`

| Source | Destination |
| ------ | ----------- |
| `.cursor/` | `code/.cursor/` |
| `AGENTS.md` | `code/AGENTS.md` |
| `skills-lock.json` | `code/skills-lock.json` |

`ONBOARDING.md` stays in the bundle repo only — not copied into `code/`.

## Publish (optional git remote)

```powershell
git remote add origin git@github.com:YOUR_ORG/vue-nestjs-agent.git
git push -u origin main
```

Share repo → recipient follows [ONBOARDING.md](ONBOARDING.md).

## Using agents

Open `code/` in Cursor → [AGENTS.md](AGENTS.md) or [.cursor/specialists/decision.md](.cursor/specialists/decision.md).
