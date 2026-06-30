#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[validate-desktop] %s\n' "$1"
}

warn() {
  printf '[validate-desktop] warning: %s\n' "$1" >&2
}

fail() {
  printf '[validate-desktop] error: %s\n' "$1" >&2
  exit 1
}

main() {
  local repo_root packages_root package_name package_dir pkgbuild asset_path broken_link
  local -a expected_packages=(
    keskos-branding
    keskos-theme
    keskos-sddm-theme
    keskos-plymouth
    keskos-plasma-layout
    keskos-quickshell-hud
    keskos-kickoff
    keskos-workspace-switcher
    keskos-browser-startpage
  )
  local -a critical_issues=()
  local -a warning_issues=()
  declare -A asset_checks=(
    [keskos-branding]="src/assets/wallpaper.jpg"
    [keskos-theme]="src/configs/kde/KeskOSDark.colors"
    [keskos-sddm-theme]="src/configs/sddm/keskos/Main.qml"
    [keskos-plymouth]="src/themes/keskos/keskos.script"
    [keskos-plasma-layout]="src/configs/plasma/keskos-bottom-panel.js"
    [keskos-quickshell-hud]="src/configs/quickshell/main.qml"
    [keskos-kickoff]="src/configs/plasmoids/org.kde.plasma.simplekickoff/metadata.json"
    [keskos-workspace-switcher]="src/configs/plasmoids/com.keskos.workspaceswitcher/metadata.json"
    [keskos-browser-startpage]="src/browser-home/index.html"
  )

  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  packages_root="${repo_root}/packages"
  [[ -d "${packages_root}" ]] || fail "Packages directory not found: ${packages_root}"

  for package_name in "${expected_packages[@]}"; do
    package_dir="${packages_root}/${package_name}"
    pkgbuild="${package_dir}/PKGBUILD"
    asset_path="${package_dir}/${asset_checks[${package_name}]}"

    if [[ ! -d "${package_dir}" ]]; then
      critical_issues+=("Missing package directory: ${package_name}")
      continue
    fi

    if [[ ! -f "${pkgbuild}" ]]; then
      critical_issues+=("Missing PKGBUILD: ${package_name}")
    fi

    if [[ ! -e "${asset_path}" ]]; then
      critical_issues+=("Missing key asset for ${package_name}: ${asset_checks[${package_name}]}")
    fi

    if [[ ! -f "${package_dir}/README.md" ]]; then
      warning_issues+=("Missing package README: ${package_name}")
    fi

    if ! find "${package_dir}" -type f \( -iname 'LICENSE*' -o -iname 'COPYING*' \) | grep -q .; then
      warning_issues+=("No obvious license file found in ${package_name}")
    fi

    while IFS= read -r broken_link; do
      [[ -n "${broken_link}" ]] || continue
      warning_issues+=("Broken symlink: ${broken_link}")
    done < <(find "${package_dir}" -xtype l -print)
  done

  for subdir in logos icons fonts colors style-tokens; do
    if [[ ! -d "${repo_root}/shared/${subdir}" ]]; then
      warning_issues+=("Missing shared/${subdir} directory")
    fi
  done

  log "Validation summary"
  log "Critical issues: ${#critical_issues[@]}"
  log "Warnings: ${#warning_issues[@]}"

  if (( ${#critical_issues[@]} > 0 )); then
    printf '%s\n' "${critical_issues[@]}" >&2
  fi

  if (( ${#warning_issues[@]} > 0 )); then
    printf '%s\n' "${warning_issues[@]}" >&2
  fi

  if (( ${#critical_issues[@]} > 0 )); then
    exit 1
  fi
}

main "$@"

