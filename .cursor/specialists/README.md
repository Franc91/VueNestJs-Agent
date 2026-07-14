# Supplementary specialists index

**When to read** which skills from `.agents/skills/` after a domain agent pass.

This folder is **not** the specialist skills themselves — those live in [`.agents/skills/`](../../.agents/skills/) (installed via `npx skills add`). These files are the **routing index** only.

Full-stack — Vue, NestJS, TypeScript, Pinia, Vue Router, Colada, DataGrid.

## Related docs

- Skill chains: [workflows.md](../skills/platform-agents/workflows.md)
- Bugfix routing: [bugfix.md](../skills/platform-agents/bugfix.md)
- Orchestration: [platform-agents/SKILL.md](../skills/platform-agents/SKILL.md)
- Active scope per skill: [stack-profile.md](../stack-profile.md)
- Index: [AGENTS.md](../../AGENTS.md)
- Trigger rule: [specialists.mdc](../rules/specialists.mdc)

## When to read

1. **Read** the domain agent (`.cursor/skills/{agent}/SKILL.md`).
2. **Classify tier** — [vue-tier.md](vue-tier.md) or [backend-tier.md](backend-tier.md).
3. **Read** only the supplementary skills listed for that agent + tier — see [by-agent.md](by-agent.md) and [skills/](skills/).
4. Implement the layer; continue the workflow chain.

**Do not** load every specialist per task.

## Index

| Topic | File |
| ----- | ---- |
| **Intent → which doc** (read first when unsure) | [decision.md](decision.md) |
| Vue tier (Simple / Standard / Substantial) | [vue-tier.md](vue-tier.md) |
| Backend tier (Simple / Standard / Substantial) | [backend-tier.md](backend-tier.md) |
| Domain agent → supplementary map | [by-agent.md](by-agent.md) |
| Per-skill cards (paths, when to read) | [skills/README.md](skills/README.md) — full list |

Skill cards link to `.agents/skills/{name}/SKILL.md` paths. Install / update: [skills/install.md](skills/install.md) (SSOT from `skills-lock.json`).
