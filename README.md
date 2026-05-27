# keskos-desktop

`keskos-desktop` is the consolidated KeskOS desktop stack repository.

It is the source of truth for the user-facing desktop shell and visual identity packages:

- `keskos-branding`
- `keskos-theme`
- `keskos-sddm-theme`
- `keskos-plymouth`
- `keskos-plasma-layout`
- `keskos-quickshell-hud`
- `keskos-kickoff`
- `keskos-workspace-switcher`
- `keskos-browser-startpage`

Important:

- This repository is not the ISO builder.
- This repository is not one giant pacman package.
- Each folder under `packages/` still builds its own pacman package.
- The main `KeskOS/keskos` ISO repo should consume these packages from the KeskOS pacman repo or a local `[keskos-local]` repo during development.

## Layout

```text
keskos-desktop/
├── packages/
├── shared/
├── scripts/
└── docs/
```

- `packages/<pkgname>/` contains the package-specific `PKGBUILD`, package README, and source assets under `src/`.
- `shared/` is reserved for future deduplicated logos, icons, fonts, colors, and style tokens.
- `scripts/` provides monorepo-level build, clean, publish, list, and validation helpers.
- `docs/` explains the package layout, migration plan, build flow, and desktop stack.

## Development Workflow

1. Edit the relevant package under `packages/<pkgname>/src/`.
2. Run `./scripts/validate-desktop.sh`.
3. Build everything with `./scripts/build-all.sh`, or build one package manually with `cd packages/<pkgname> && makepkg -s --noconfirm`.
4. Publish built packages from `dist/` with `./scripts/publish-all.sh`.
5. Update the main `KeskOS/keskos` repo only where ISO-side package references or docs need to point at this repo.

## Migration Status

This repo consolidates the following former standalone package-source repos:

- `KeskOS/keskos-branding`
- `KeskOS/keskos-theme`
- `KeskOS/keskos-sddm-theme`
- `KeskOS/keskos-plymouth`
- `KeskOS/keskos-plasma-layout`
- `KeskOS/keskos-quickshell-hud`
- `KeskOS/keskos-kickoff`
- `KeskOS/keskos-workspace-switcher`
- `KeskOS/keskos-browser-startpage`

Those repos should remain public for history until this repo has been validated, built, and published successfully. Future desktop work happens here.

See:

- [docs/package-layout.md](docs/package-layout.md)
- [docs/migration-plan.md](docs/migration-plan.md)
- [docs/build-and-publish.md](docs/build-and-publish.md)
- [docs/desktop-stack.md](docs/desktop-stack.md)

