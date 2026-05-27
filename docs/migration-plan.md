# Migration Plan

## Repositories Merged Into `keskos-desktop`

- `KeskOS/keskos-branding`
- `KeskOS/keskos-theme`
- `KeskOS/keskos-sddm-theme`
- `KeskOS/keskos-plymouth`
- `KeskOS/keskos-plasma-layout`
- `KeskOS/keskos-quickshell-hud`
- `KeskOS/keskos-kickoff`
- `KeskOS/keskos-workspace-switcher`
- `KeskOS/keskos-browser-startpage`

## Repositories Intentionally Kept Separate

- `KeskOS/keskos`
- `KeskOS/keskos-tools`
- `KeskOS/keskos-settings`
- `KeskOS/keskos-welcome`
- `KeskOS/keskos-release`
- `KeskOS/keskos-mirrorlist`
- `KeskOS/keskos-desktop-meta`
- `KeskOS/keskos-browsers-meta`
- `KeskOS/keskos-gaming-meta`
- `KeskOS/keskos-office-meta`
- `KeskOS/keskos-social-meta`
- `KeskOS/keskos-dev-meta`
- `KeskOS/keskos-system-tools-meta`
- `KeskOS/keskos-hardware-meta`
- `KeskOS/keskos-installer-debug-log`

## Migration Phases

### Phase 1: Consolidate the desktop package sources

- Create `KeskOS/keskos-desktop`.
- Import the nine desktop-facing package repos into `packages/`.
- Keep package names unchanged.
- Keep one `PKGBUILD` per package.

### Phase 2: Add shared tooling and docs

- Add monorepo scripts for build, clean, list, validate, and publish.
- Document the package layout and desktop stack.
- Reserve `shared/` for later safe deduplication.

### Phase 3: Redirect source-of-truth references

- Update old desktop repos with migration notes in `README.md`.
- Update the main `KeskOS/keskos` repo so it expects desktop packages from the pacman repo instead of ISO-side source copies where possible.
- Update `KeskOS/keskos-desktop-meta` to depend on the consolidated desktop package outputs.

### Phase 4: Stabilize and archive later

- Build and publish the packages from `keskos-desktop`.
- Verify ISO installs and desktop behavior.
- Keep old repos public for history until the new flow has proven itself.
- Archive old desktop repos later, after package publishing and ISO consumption are stable.

## Avoiding Package Name Breakage

- Keep pacman package names exactly the same.
- Keep install paths exactly the same unless a specific package fix requires otherwise.
- Use `pkgrel` bumps when package metadata changes because of the move to `keskos-desktop`.
- Do not collapse the desktop packages into one monolithic package.

## Updating the ISO Repo

- Keep the desktop package names in `packages.x86_64`.
- Consume desktop packages from `[keskos]` or `[keskos-local]`.
- Do not vendor the desktop package source trees into the ISO repo as the long-term source of truth.
- Keep `keskos` focused on ISO assembly, package selection, and release workflows.

## Old Repos To Archive Later

- `keskos-branding`
- `keskos-theme`
- `keskos-sddm-theme`
- `keskos-plymouth`
- `keskos-plasma-layout`
- `keskos-quickshell-hud`
- `keskos-kickoff`
- `keskos-workspace-switcher`
- `keskos-browser-startpage`

## GitHub Repo Description Updates

After migration is stable, update descriptions roughly like this:

- Old repos: “Migrated into `KeskOS/keskos-desktop`; kept for history.”
- New repo: “KeskOS desktop package source monorepo for branding, theme, shell, layout, login, boot, and startpage packages.”

