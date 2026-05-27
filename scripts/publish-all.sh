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

sha256_file() {
  sha256sum "$1" | awk '{print $1}'
}

copy_package_archive() {
  local src_file="$1"
  local dest_file repo_name src_sum dest_sum

  dest_file="${repo_dir}/$(basename "${src_file}")"
  if [[ ! -e "${dest_file}" ]]; then
    cp -f "${src_file}" "${dest_file}"
    return 0
  fi

  src_sum="$(sha256_file "${src_file}")"
  dest_sum="$(sha256_file "${dest_file}")"
  if [[ "${src_sum}" == "${dest_sum}" ]]; then
    log "Unchanged package already present: $(basename "${src_file}")"
    return 0
  fi

  repo_name="$(basename "${repo_root}")"
  if [[ "${KESKOS_ALLOW_REPLACE_PUBLISHED_PKGS:-0}" == "1" ]]; then
    log "Replacing existing package archive with KESKOS_ALLOW_REPLACE_PUBLISHED_PKGS=1: $(basename "${src_file}")"
    cp -f "${src_file}" "${dest_file}"
    return 0
  fi

  fail "Refusing to replace existing published package archive $(basename "${src_file}") with different contents. Bump pkgrel first, then rebuild and publish again. Set KESKOS_ALLOW_REPLACE_PUBLISHED_PKGS=1 only for an intentional recovery override in ${repo_name}."
}

main() {
  local repo_root dist_dir repo_dir package_count
  local package_file=""

  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  dist_dir="${repo_root}/dist"
  repo_dir="${KESKOS_REPO_DIR:-/var/www/downloads.keskos.org/repo/keskos/os/x86_64}"

  require_command repo-add

  [[ -d "${dist_dir}" ]] || fail "Dist directory not found: ${dist_dir}"
  package_count="$(find "${dist_dir}" -maxdepth 1 -type f -name '*.pkg.tar.zst' | wc -l)"
  [[ "${package_count}" -gt 0 ]] || fail "No .pkg.tar.zst files found in ${dist_dir}"

  mkdir -p "${repo_dir}"
  while IFS= read -r package_file; do
    [[ -n "${package_file}" ]] || continue
    copy_package_archive "${package_file}"
  done < <(find "${dist_dir}" -maxdepth 1 -type f -name '*.pkg.tar.zst' | sort)

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
