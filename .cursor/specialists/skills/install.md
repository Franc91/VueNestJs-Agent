# Supplementary skills — install (SSOT)

Locked sources: [`skills-lock.json`](../../../skills-lock.json). Cards: [README.md](README.md).

Verify install: `npx skills list`.

### vue-best-practices

`npx skills add hyf0/vue-skills -s vue-best-practices -a cursor -y`

### vue-pinia-best-practices

`npx skills add hyf0/vue-skills -s vue-pinia-best-practices -a cursor -y`

### vue-router-best-practices

`npx skills add hyf0/vue-skills -s vue-router-best-practices -a cursor -y`

### vue

`npx skills add antfu/skills -s vue -a cursor -y`

### vue-expert

`npx skills add jeffallan/claude-skills -s vue-expert -a cursor -y`

### nestjs-best-practices

`npx skills add kadajett/agent-nestjs-skills -s nestjs-best-practices -a cursor -y`

### nestjs-expert

`npx skills add jeffallan/claude-skills -s nestjs-expert -a cursor -y`

### typescript-advanced-types

`npx skills add wshobson/agents -s typescript-advanced-types -a cursor -y`

### typescript-expert

`npx skills add sickn33/antigravity-awesome-skills -s typescript-expert -a cursor -y`

## Adding a new supplementary skill

1. `npx skills add …` → update [`skills-lock.json`](../../../skills-lock.json)
2. Add [card](.) (`{name}.md`), row in [AGENTS.md](../../../AGENTS.md), [stack-profile.md](../../stack-profile.md), [by-agent.md](../by-agent.md) if needed
