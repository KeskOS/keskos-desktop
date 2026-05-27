# Desktop Stack

KeskOS keeps the desktop stack modular even though the source now lives in one repository.

## Base Platform

- KDE Plasma provides the desktop shell.
- KWin provides window management and effects.

## KeskOS Identity Layer

- `keskos-branding` provides logos, wallpapers, icons, and branded asset files.
- `keskos-theme` provides the Plasma, Kvantum, Konsole, Aurorae, and general visual theme layer.
- `keskos-sddm-theme` provides the branded login screen.
- `keskos-plymouth` provides the boot splash asset staging package.

## Shell And Layout Layer

- `keskos-plasma-layout` provides the default panel and layout template.
- `keskos-quickshell-hud` provides the industrial HUD/top bar layer built on Quickshell.
- `keskos-kickoff` provides the branded launcher experience.
- `keskos-workspace-switcher` provides the custom workspace widget.

## Browser Surface

- `keskos-browser-startpage` provides the branded startpage and browser theming assets.
- Browser binaries themselves stay outside this repo and are selected during first boot by `keskos-welcome`.

## Design Direction

The stack targets the existing KeskOS identity:

- black/orange industrial aesthetic
- terminal-inspired HUD presentation
- branded login and boot surfaces
- a consistent Plasma session layout

This repo is a packaging and source-organization consolidation, not a redesign or a KDE fork.

