#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DUB_JSON="${SCRIPT_DIR}/dub.json"

die() {
  echo "Error: $*" >&2
  exit 1
}

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "required command '$1' not found"; }

extract_version_from_dub() {
  need_cmd jq
  jq -r '.version' "$DUB_JSON" 2>/dev/null || die "failed to extract version from $DUB_JSON"
}

main() {
  local version
  version="$(extract_version_from_dub)"
  [[ -n "$version" ]] || die "version not found in $DUB_JSON"
  
  echo "Extracted version $version from dub.json"
  
  cd libstemmer
  ./install.sh "$version"
  
  cd src
  make clean
  make -j2 libstemmer.a
}

main "$@"
