#!/usr/bin/env bash
set -euo pipefail

extract_scalar() {
  local pkgbuild="$1"
  local field="$2"

  sed -nE "s/^${field}=['\"]?([^'\"]+)['\"]?$/\\1/p" "${pkgbuild}" | head -n 1
}

main() {
  local repo_root packages_root package_dir pkgbuild folder pkgname pkgver pkgrel status

  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  packages_root="${repo_root}/packages"

  printf '%-30s %-30s %-12s %s\n' "FOLDER" "PKGNAME" "VERSION" "PKGBUILD"

  while IFS= read -r package_dir; do
    folder="$(basename "${package_dir}")"
    pkgbuild="${package_dir}/PKGBUILD"
    status="missing"
    pkgname="-"
    pkgver="-"
    pkgrel="-"

    if [[ -f "${pkgbuild}" ]]; then
      status="yes"
      pkgname="$(extract_scalar "${pkgbuild}" pkgname || true)"
      pkgver="$(extract_scalar "${pkgbuild}" pkgver || true)"
      pkgrel="$(extract_scalar "${pkgbuild}" pkgrel || true)"
    fi

    printf '%-30s %-30s %-12s %s\n' "${folder}" "${pkgname:--}" "${pkgver:--}-${pkgrel:--}" "${status}"
  done < <(find "${packages_root}" -mindepth 1 -maxdepth 1 -type d | sort)
}

main "$@"

