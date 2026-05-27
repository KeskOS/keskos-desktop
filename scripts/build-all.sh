#!/usr/bin/env bash
set -euo pipefail

TEMP_ROOT=""

log() {
  printf '[build-all] %s\n' "$1"
}

warn() {
  printf '[build-all] warning: %s\n' "$1" >&2
}

fail() {
  printf '[build-all] error: %s\n' "$1" >&2
  exit 1
}

cleanup() {
  if [[ -n "${TEMP_ROOT}" && -d "${TEMP_ROOT}" ]]; then
    rm -rf "${TEMP_ROOT}"
  fi
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

main() {
  local repo_root packages_root dist_root temp_root package_dir package_name work_dir
  local -a built_packages=()
  local -a failed_packages=()
  local -a archives=()

  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  packages_root="${repo_root}/packages"
  dist_root="${repo_root}/dist"

  [[ -d "${packages_root}" ]] || fail "Packages directory not found: ${packages_root}"
  require_command makepkg

  mkdir -p "${dist_root}"
  TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/keskos-desktop-build.XXXXXX")"
  trap cleanup EXIT

  while IFS= read -r package_dir; do
    [[ -d "${package_dir}" ]] || continue
    package_name="$(basename "${package_dir}")"

    if [[ ! -f "${package_dir}/PKGBUILD" ]]; then
      warn "Skipping ${package_name}: no PKGBUILD"
      continue
    fi

    work_dir="${TEMP_ROOT}/${package_name}"
    cp -a "${package_dir}" "${work_dir}"

    log "Building ${package_name}"
    if (
      cd "${work_dir}"
      makepkg -s --noconfirm
    ); then
      built_packages+=("${package_name}")
      mapfile -t archives < <(find "${work_dir}" -maxdepth 1 -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.zst.sig' \) | sort)
      if (( ${#archives[@]} == 0 )); then
        warn "No package archives were produced for ${package_name}"
      else
        cp -f "${archives[@]}" "${dist_root}/"
      fi
    else
      failed_packages+=("${package_name}")
      warn "Build failed for ${package_name}"
    fi
  done < <(find "${packages_root}" -mindepth 1 -maxdepth 1 -type d | sort)

  log "Build summary"
  log "Built packages: ${#built_packages[@]}"
  log "Failed packages: ${#failed_packages[@]}"
  log "Dist directory: ${dist_root}"

  if (( ${#built_packages[@]} > 0 )); then
    printf '%s\n' "${built_packages[@]}"
  fi

  if (( ${#failed_packages[@]} > 0 )); then
    warn "Failed package directories:"
    printf '%s\n' "${failed_packages[@]}" >&2
    exit 1
  fi
}

main "$@"
