#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET=""
INSTALL_SUPP=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --supplementary) INSTALL_SUPP=true; shift ;;
    *) shift ;;
  esac
done

if [[ -d "$ROOT/.git" ]]; then
  git -C "$ROOT" pull --ff-only
fi

args=()
[[ -n "$TARGET" ]] && args+=(--target "$TARGET")
$INSTALL_SUPP && args+=(--supplementary)
bash "$ROOT/install.sh" "${args[@]}"
