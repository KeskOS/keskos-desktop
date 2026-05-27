# keskos-plymouth

KeskOS Plymouth boot splash assets and placeholder theme staging.

This package now lives in the consolidated `KeskOS/keskos-desktop` desktop stack repository at `packages/keskos-plymouth/`.

## Build

```bash
cd packages/keskos-plymouth
makepkg -s --noconfirm
```

## Notes

- Pacman package name stays `keskos-plymouth`.
- Source assets live under `src/`.
- The package stages splash assets without forcing Plymouth activation automatically.
