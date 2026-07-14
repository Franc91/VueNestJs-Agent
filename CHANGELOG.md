# Changelog

## 1.1.0 — 2026-07-14

- Flattened layout: bundle root is `VueNestJs Agent/` (removed nested `dealer-platform-cursor/` folder)

## 1.0.0 — 2026-07-14

- Initial distributable bundle (platform-agents, specialists, domain agents)
- Install via `install.config.json` + `install.ps1`
- Supplementary skills via `install-supplementary.ps1`
- Local link validator `validate-agent-links.mjs`
- `doctor.ps1` health checks, `update.ps1` (git pull + reinstall)
- MCP preserved across reinstall (`mcp.json` backup)
