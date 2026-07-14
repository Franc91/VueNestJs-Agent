# Changelog

## 1.1.4 — 2026-07-14

- Renamed `.cursor/specialists/decision.md` → **`routing.md`** (agent workflow routing — avoids confusion with project notes)
- Renamed template `docs/agent/decisions.example.md` → **`index.example.md`** (private domain index)

## 1.1.3 — 2026-07-14

- Neutralized bundle docs for any Vue + NestJS monorepo (removed Dealer Platform–specific branding and file paths)
- Generic `reference.md`, `examples.md`, `stack-profile.md` — customize after install
- Neutral `install.config.example.json` path

## 1.1.2 — 2026-07-14

- Removed `docs/agent/decisions.md` from bundle **routing** and **install** — project-local, private
- Kept generic template: `docs/agent/decisions.example.md` (manual copy only)

## 1.1.1 — 2026-07-14

- Slim `general.mdc` and `AGENTS.md` (token-efficient always-on context)
- `decision.md` §0 — optional link to project `docs/agent/decisions.md`
- `reference.md` — project-specific notes section
- `install.ps1` — seed `docs/agent/decisions.md` from template when missing

## 1.1.0 — 2026-07-14

- Flattened layout: bundle root is `VueNestJs Agent/` (removed nested `dealer-platform-cursor/` folder)

## 1.0.0 — 2026-07-14

- Initial distributable bundle (platform-agents, specialists, domain agents)
- Install via `install.config.json` + `install.ps1`
- Supplementary skills via `install-supplementary.ps1`
- Local link validator `validate-agent-links.mjs`
- `doctor.ps1` health checks, `update.ps1` (git pull + reinstall)
- MCP preserved across reinstall (`mcp.json` backup)
