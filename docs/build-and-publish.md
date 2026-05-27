# Build And Publish

## Build All Packages

From the repo root:

```bash
./scripts/build-all.sh
```

Built package archives are collected into `dist/`.

## Build One Package Manually

```bash
cd packages/keskos-theme
makepkg -s --noconfirm
```

The monorepo helper builds in temporary copies. Manual `makepkg` runs work too, but they will create local build artifacts in the package folder unless you clean them afterward.

## Clean Build Artifacts

```bash
./scripts/clean-all.sh
```

This removes generated `pkg/`, package archives, logs, and `dist/`. It intentionally preserves tracked `packages/*/src/` directories because they are the package sources in this monorepo.

## List Packages

```bash
./scripts/list-packages.sh
```

This prints the package folder name, `pkgname`, `pkgver`, `pkgrel`, and whether a `PKGBUILD` exists.

## Validate The Desktop Monorepo

```bash
./scripts/validate-desktop.sh
```

Validation checks:

- expected desktop package folders
- expected `PKGBUILD` files
- representative key assets
- missing package README or license hints
- broken symlinks

## Publish Built Packages To A Repo Directory

Default publish target:

```text
/var/www/downloads.keskos.org/repo/keskos/os/x86_64
```

Publish with the default:

```bash
./scripts/publish-all.sh
```

Override the repo directory:

```bash
KESKOS_REPO_DIR=/some/path ./scripts/publish-all.sh
```

The script copies `dist/*.pkg.tar.zst` into the target repo directory, runs `repo-add`, and refreshes `keskos.db` and `keskos.files` symlinks.

Important:

- Do not silently republish changed package contents under the same package filename.
- If the package content changed after a package was already published, bump `pkgrel`, rebuild, and publish again.
- The publish helper now refuses to replace an existing package archive with different contents unless you explicitly set `KESKOS_ALLOW_REPLACE_PUBLISHED_PKGS=1`.

This prevents pacman cache checksum mismatches where users already have an older archive with the same version cached locally.

## Test A Local Repo In A VM

1. Publish packages into a test directory.
2. Serve that directory over `file://`, `python -m http.server`, or your normal web stack.
3. Add a temporary pacman repo entry pointing at that path.
4. Install or upgrade one desktop package in a VM.
5. Validate the package installs cleanly and that the KDE session still picks up the assets or shell behavior as expected.

## Update Package Versions

- Change `pkgver` only when the package version itself changes.
- Bump `pkgrel` when package metadata or packaging changes but the upstream content version does not.
- Keep package names stable.
