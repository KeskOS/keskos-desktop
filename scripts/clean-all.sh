#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[clean-all] %s\n' "$1"
}

fail() {
  printf '[clean-all] error: %s\n' "$1" >&2
  exit 1
}

main() {
  local repo_root packages_root dist_root package_dir

  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  packages_root="${repo_root}/packages"
  dist_root="${repo_root}/dist"

  [[ -d "${packages_root}" ]] || fail "Packages directory not found: ${packages_root}"

  while IFS= read -r package_dir; do
    [[ -d "${package_dir}" ]] || continue
    rm -rf "${package_dir}/pkg"
    find "${package_dir}" -maxdepth 1 -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.zst.sig' -o -name '*.log' \) -delete
  done < <(find "${packages_root}" -mindepth 1 -maxdepth 1 -type d | sort)

  rm -rf "${dist_root}"

  log "Removed generated package artifacts and dist/"
  log "Tracked packages/*/src/ trees were preserved because they are the source assets in this monorepo."
}

main "$@"

