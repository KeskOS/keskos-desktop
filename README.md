# keskos-desktop

`keskos-desktop` is the consolidated desktop-stack repository for KeskOS. It keeps the user-facing visual identity and shell pieces in one Git repo while still producing separate pacman packages for each desktop component.

## What this is

This repository is the source of truth for the branding, theme, login, boot splash, Plasma layout, Quickshell HUD, launcher, workspace switcher, and browser startpage packages used by KeskOS.

## Role in KeskOS

Desktop package monorepo.

## Package name

```txt
Packages built here:
keskos-branding
keskos-theme
keskos-sddm-theme
keskos-plymouth
keskos-plasma-layout
keskos-quickshell-hud
keskos-kickoff
keskos-workspace-switcher
keskos-browser-startpage
```

## What it installs or provides

- `packages/` contains one buildable pacman package directory per desktop component.
- `shared/` holds reusable desktop assets and style primitives for future cleanup and deduplication.
- `scripts/` provides batch build, clean, validate, list, and publish helpers for the desktop stack.
- `docs/` describes the package layout, desktop stack, and migration plan.

## Commands and launchers

- `./scripts/build-all.sh` builds every package and collects artifacts in `dist/`.
- `./scripts/list-packages.sh` lists package folders and package versions.
- `./scripts/validate-desktop.sh` checks package folders, PKGBUILDs, assets, and obvious repo layout issues.
- `./scripts/clean-all.sh` removes build artifacts without deleting source assets.
- `KESKOS_REPO_DIR=/path ./scripts/publish-all.sh` copies built packages into a local pacman repo and runs `repo-add`.

## Config, logs, and state

- Desktop package sources live under `packages/<package-name>/`.
- Built package artifacts are collected in `dist/`.
- Shared assets and future dedup targets live under `shared/`.
- This repo does not ship runtime logs by itself; logs belong to the installed packages and the package manager.

## Dependencies

- Core repo tooling: `bash`, `makepkg`, and `repo-add`.
- Each package has its own runtime and makedepends declared in `packages/<name>/PKGBUILD`.
- Publishing to a repo mirror requires filesystem access to the target pacman repo directory.

## Build

```bash
./scripts/validate-desktop.sh
./scripts/build-all.sh
cd packages/keskos-theme && makepkg -s --noconfirm
```

## Packaging notes

- This repo does not create one giant pacman package; every folder under `packages/` keeps its own package name and PKGBUILD.
- The ISO builder repo should consume these package names from `[keskos]` or `[keskos-local]` during development.
- The legacy standalone desktop repos are kept only for history and should point back here.

## Troubleshooting

- If a package folder is missing or a PKGBUILD was not imported correctly, run `./scripts/validate-desktop.sh` first.
- If a built package changed contents after being published, bump `pkgrel` before republishing so pacman caches stay consistent.
- If only one package is broken, build it directly inside its package directory before retrying `build-all.sh`.

## Docs website export notes

- This README should become the landing page for the desktop section of the docs site.
- Package-specific docs can be split out from the `packages/` list into dedicated website pages without changing pacman package names.
