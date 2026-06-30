# keskos-theme

KeskOS desktop themes, color schemes, and default visual assets.

This package now lives in the consolidated `KeskOS/keskos-desktop` desktop stack repository at `packages/keskos-theme/`.

## Build

```bash
cd packages/keskos-theme
makepkg -s --noconfirm
```

## Notes

- Pacman package name stays `keskos-theme`.
- Source assets live under `src/`.
- Installed Plasma, Kvantum, Konsole, and default-theme paths remain unchanged.

## Plasma panel/taskbar styling

The bottom KDE Plasma panel uses the `keskos-shell` Plasma desktop theme assets under:

```txt
src/configs/plasma/desktoptheme/keskos-shell/widgets/
```

- `panel-background.svg` provides the near-black panel frame and the thin `#ce6a35` top edge line. The same asset is also shipped in `opaque/`, `translucent/`, and `solid/` variants so Plasma keeps the line after screen-size or transparency-mode changes.
- `tasks.svg` restyles Icons-only Task Manager states so running apps use a small bottom orange indicator, focused apps use a thin orange outline, and hover stays subtle.
- The panel layout remains owned by `keskos-plasma-layout`; the theme does not replace widgets, reorder the launcher, or touch the top panel.

After updating these assets, rebuild and reinstall `keskos-theme`, then restart Plasma or log out/in.
