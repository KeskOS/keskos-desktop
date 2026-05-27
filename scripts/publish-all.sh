#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[publish-all] %s\n' "$1"
}

fail() {
  printf '[publish-all] error: %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

main() {
  local repo_root dist_dir repo_dir package_count

  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  dist_dir="${repo_root}/dist"
  repo_dir="${KESKOS_REPO_DIR:-/var/www/downloads.keskos.org/repo/keskos/os/x86_64}"

  require_command repo-add

  [[ -d "${dist_dir}" ]] || fail "Dist directory not found: ${dist_dir}"
  package_count="$(find "${dist_dir}" -maxdepth 1 -type f -name '*.pkg.tar.zst' | wc -l)"
  [[ "${package_count}" -gt 0 ]] || fail "No .pkg.tar.zst files found in ${dist_dir}"

  mkdir -p "${repo_dir}"
  cp -f "${dist_dir}"/*.pkg.tar.zst "${repo_dir}/"

  if compgen -G "${dist_dir}/*.pkg.tar.zst.sig" >/dev/null; then
    cp -f "${dist_dir}"/*.pkg.tar.zst.sig "${repo_dir}/"
  fi

  (
    cd "${repo_dir}"
    repo-add keskos.db.tar.gz ./*.pkg.tar.zst
    ln -sf keskos.db.tar.gz keskos.db
    ln -sf keskos.files.tar.gz keskos.files
  )

  log "Published ${package_count} package archives into ${repo_dir}"
}

main "$@"
