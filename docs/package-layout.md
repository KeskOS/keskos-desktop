# Package Layout

Each package in `keskos-desktop` keeps its own pacman identity and installs to the same runtime paths it used before the repository consolidation.

## Package Overview

### `keskos-branding`

- Purpose: shared KeskOS logos, wallpapers, panel icons, and desktop branding assets.
- Installs into: `/usr/share/keskos/assets`, `/usr/share/keskos/panel-icons`, `/usr/share/icons/hicolor`, `/usr/share/backgrounds/keskos`, `/usr/share/pixmaps`.
- Dependency notes: visual-only asset package that other desktop components can use.

### `keskos-theme`

- Purpose: Plasma, Kvantum, Konsole, Aurorae, look-and-feel, Dunst, and Fastfetch theme stack.
- Installs into: `/usr/share/color-schemes`, `/usr/share/Kvantum`, `/usr/share/plasma/desktoptheme`, `/usr/share/plasma/look-and-feel`, `/usr/share/aurorae/themes`, `/usr/share/kwin/decorations`, `/usr/share/keskos/defaults`.
- Dependency notes: visual-only package, but it shapes the default KDE session look and feel.

### `keskos-sddm-theme`

- Purpose: the branded SDDM login theme plus packaged default SDDM snippets.
- Installs into: `/usr/share/sddm/themes/keskos`, `/usr/share/keskos/defaults/sddm`, `/usr/share/keskos/source/airootfs/etc/sddm.conf.d`.
- Dependency notes: depends on `sddm` because it ships a login theme.

### `keskos-plymouth`

- Purpose: the active KeskOS BIOS-terminal Plymouth boot splash and curated boot milestone helpers.
- Installs into: `/usr/share/plymouth/themes/keskos`, `/usr/bin/keskos-plymouth-*`, `/usr/lib/systemd/system`, `/etc/keskos/boot.conf`, `/usr/share/doc/keskos-plymouth`.
- Dependency notes: depends on `plymouth` and `systemd`; the installer sets the theme, adds silent boot parameters, and rebuilds initramfs when possible.

### `keskos-plasma-layout`

- Purpose: the default Plasma bottom panel layout template and branded desktop launchers.
- Installs into: `/usr/share/keskos/plasma`, `/usr/share/plasma/layout-templates`, `/usr/share/applications`.
- Dependency notes: references `keskos-kickoff` and `keskos-workspace-switcher` in `optdepends`.

### `keskos-quickshell-hud`

- Purpose: the Quickshell HUD, top bar, overlays, and autostart entries.
- Installs into: `/usr/share/keskos/quickshell`, `/etc/xdg/autostart`, `/etc/skel/.config/autostart`.
- Dependency notes: depends on `quickshell`, `networkmanager`, and `playerctl`.

### `keskos-kickoff`

- Purpose: the branded custom SimpleKickoff launcher plasmoid.
- Installs into: `/usr/share/plasma/plasmoids`, `/usr/share/keskos/source/configs/plasmoids`.
- Dependency notes: visual and shell behavior package; `keskos-branding` remains an `optdepends`.

### `keskos-workspace-switcher`

- Purpose: the custom Plasma workspace switcher plasmoid.
- Installs into: `/usr/share/plasma/plasmoids`, `/usr/share/keskos/source/configs/plasmoids`.
- Dependency notes: integrates with the default panel layout and the `keskos-tools` workspace helper.

### `keskos-browser-startpage`

- Purpose: branded browser homepage/startpage assets and packaged browser theme files.
- Installs into: `/usr/share/keskos/startpage`, `/usr/share/keskos/browser/startpage`, `/usr/share/keskos/browser-themes`, `/usr/share/keskos/first-run`, `/usr/share/applications`.
- Dependency notes: depends on `xdg-utils`; used by `keskos-welcome` but does not install browser binaries itself.

## Visual-Only vs Behavior-Shaping Packages

Mostly visual-only packages:

- `keskos-branding`
- `keskos-theme`
- `keskos-sddm-theme`
- `keskos-plymouth`
- `keskos-browser-startpage`

Packages that also shape shell behavior or session layout:

- `keskos-plasma-layout`
- `keskos-quickshell-hud`
- `keskos-kickoff`
- `keskos-workspace-switcher`

## Source Layout Inside Each Package

Each package folder follows this pattern:

```text
packages/<pkgname>/
├── PKGBUILD
├── README.md
└── src/
```

The `src/` directory in this repo is canonical package source content, not disposable build output. Monorepo build helpers copy package trees into temporary work directories before running `makepkg` so those tracked assets stay intact.

