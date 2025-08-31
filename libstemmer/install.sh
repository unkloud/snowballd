#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/.build"

usage() {
  echo "Usage: $(basename "$0") [version]"
  echo "  version: 3.0.0 | 3.0.1 (default: 3.0.1)"
  echo "Example: $(basename "$0") 3.0.1"
}

die() {
  echo "Error: $*" >&2
  exit 1
}

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "required command '$1' not found"; }

main() {
  local version="${1:-3.0.1}"
  case "$version" in
    3.0.0|3.0.1) ;;
    *) usage; die "unsupported libstemmer version '$version'; supported versions are 3.0.0 and 3.0.1" ;;
  esac
  local install_dir="${SCRIPT_DIR}/src"

  need_cmd tar
  local dl=""
  if command -v curl >/dev/null 2>&1; then dl="curl"; elif command -v wget >/dev/null 2>&1; then dl="wget"; else die "need curl or wget"; fi

  # ensure clean build dir at each run
  if [[ -d "${BUILD_DIR}" ]]; then rm -rf "${BUILD_DIR}"; fi

  local url="https://snowballstem.org/dist/libstemmer_c-${version}.tar.gz"
  local workdir="${BUILD_DIR}/${version}"
  local tarball_name="libstemmer_c-${version}.tar.gz"

  mkdir -p "${workdir}"

  rm -f "${workdir}/${tarball_name}" || true
  if [[ "$dl" == "curl" ]]; then
    curl -fsSL --retry 3 -o "${workdir}/${tarball_name}" "$url"
  else
    wget -q -O "${workdir}/${tarball_name}" "$url"
  fi

  rm -rf "${workdir}/src"
  mkdir -p "${workdir}/src"
  tar -xzf "${workdir}/${tarball_name}" -C "${workdir}/src"

  local src_dir
  src_dir="$(find "${workdir}/src" -maxdepth 1 -type d -name 'libstemmer_c-*' | head -n 1)"
  if [[ -z "${src_dir:-}" ]]; then die "source directory not found after extract"; fi

  # Clean existing installation but preserve install.sh and version subdirectories
  find "${install_dir}" -mindepth 1 -maxdepth 1 ! -name "install.sh" ! -name "3.0.0" ! -name "3.0.1" ! -name ".build" -exec rm -rf {} +
  cp -R "${src_dir}"/* "${install_dir}/"

  rm -rf "${workdir}"
  if [[ -d "${BUILD_DIR}" ]] && [[ -z "$(ls -A "${BUILD_DIR}")" ]]; then rmdir "${BUILD_DIR}"; fi
  echo $version>.version
}

main "$@"
