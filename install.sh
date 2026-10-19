#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET=""
INSTALL_SUPP=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --supplementary) INSTALL_SUPP=true; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  CONFIG="$ROOT/install.config.json"
  [[ -f "$CONFIG" ]] || { echo "Missing install.config.json" >&2; exit 1; }
  TARGET="$(node -e "const p=require('path');const c=require('fs').readFileSync(p.join('$ROOT','install.config.json'),'utf8');console.log(JSON.parse(c).codeWorkspace)")"
fi

[[ -d "$TARGET" ]] || { echo "Target not found: $TARGET" >&2; exit 1; }

node "$ROOT/scripts/sync-cursor.mjs" --target "$TARGET"

if $INSTALL_SUPP; then
  bash "$ROOT/install-supplementary.sh" "$TARGET"
fi

(cd "$TARGET" && node .cursor/scripts/validate-agent-links.mjs)
echo "Done. Open code/ in Cursor -> AGENTS.md or .cursor/specialists/routing.md"
