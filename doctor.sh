#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  CONFIG="$ROOT/install.config.json"
  [[ -f "$CONFIG" ]] || { echo "Missing install.config.json" >&2; exit 1; }
  TARGET="$(node -e "console.log(JSON.parse(require('fs').readFileSync('$CONFIG','utf8')).codeWorkspace)")"
fi

echo "Agent bundle: $ROOT"
echo "Code workspace: $TARGET"
echo ""

ok=true
check() {
  local label="$1" pass="$2" hint="${3:-}"
  if [[ "$pass" == "true" ]]; then
    echo "[OK]   $label"
  else
    echo "[FAIL] $label"
    [[ -n "$hint" ]] && echo "       $hint"
    ok=false
  fi
}

[[ -f "$ROOT/install.config.json" ]] && c1=true || c1=false
check "install.config.json exists" "$c1" "Copy install.config.example.json"
[[ -d "$TARGET" ]] && c2=true || c2=false
check "code workspace exists" "$c2" "Fix codeWorkspace"
[[ -f "$TARGET/AGENTS.md" ]] && c3=true || c3=false
check "AGENTS.md installed" "$c3" "Run ./install.sh"
[[ -f "$TARGET/.cursor/rules/general.mdc" ]] && c4=true || c4=false
check ".cursor/ installed" "$c4" "Run ./install.sh"

has_supp=false
if [[ -d "$TARGET/.agents/skills" ]]; then
  for d in "$TARGET/.agents/skills"/*/; do
    [[ -f "${d}SKILL.md" ]] && has_supp=true && break
  done
fi
check "supplementary skills installed" "$has_supp" "Run ./install.sh --supplementary"

echo ""
(cd "$TARGET" && node .cursor/scripts/validate-agent-links.mjs) && v=true || v=false
check "link validator" "$v" "Fix bundle, reinstall"

echo ""
if $ok && $v; then
  echo "All checks passed."
  exit 0
fi
echo "Some checks failed."
exit 1
