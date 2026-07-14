#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:?Usage: install-supplementary.sh /path/to/code}"

cd "$TARGET"

pairs=(
  "hyf0/vue-skills vue-best-practices"
  "hyf0/vue-skills vue-pinia-best-practices"
  "hyf0/vue-skills vue-router-best-practices"
  "antfu/skills vue"
  "jeffallan/claude-skills vue-expert"
  "kadajett/agent-nestjs-skills nestjs-best-practices"
  "jeffallan/claude-skills nestjs-expert"
  "wshobson/agents typescript-advanced-types"
  "sickn33/antigravity-awesome-skills typescript-expert"
)

for pair in "${pairs[@]}"; do
  repo="${pair%% *}"
  skill="${pair#* }"
  echo ">> npx skills add $repo -s $skill"
  npx skills add "$repo" -s "$skill" -a cursor -y
done

echo "Supplementary skills installed under $TARGET/.agents/skills/"
