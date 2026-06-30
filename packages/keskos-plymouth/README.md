# keskos-plymouth

KeskOS BIOS-terminal Plymouth boot splash theme and curated boot milestone helpers.

This package now lives in the consolidated `KeskOS/keskos-desktop` desktop stack repository at `packages/keskos-plymouth/`.

## What this is

`keskos-plymouth` installs the `keskos` Plymouth theme under `/usr/share/plymouth/themes/keskos/`. The theme uses a pure black background, orange KeskOS terminal framing, static POST-style firmware text, a top-right KeskOS logo, a wide bordered boot log panel, an animated scrollbar, footer status text, and curated all-caps boot milestones.

## Package name

```txt
Package: keskos-plymouth
Repo: [keskos]
Architecture: any
```

## Runtime files

- `/usr/share/plymouth/themes/keskos/keskos.plymouth`
- `/usr/share/plymouth/themes/keskos/keskos.script`
- `/usr/share/plymouth/themes/keskos/kesk_os_logo_text.png`
- `/usr/share/plymouth/themes/keskos/kesk_os_logo_text_large.png`
- `/usr/bin/keskos-plymouth-message`
- `/usr/bin/keskos-plymouth-boot-status`
- `/usr/bin/keskos-plymouth-wait`
- `/usr/lib/systemd/system/keskos-plymouth-boot-status.service`
- `/usr/lib/systemd/system/keskos-plymouth-min-duration.service`
- `/etc/keskos/boot.conf`

## Build

```bash
cd packages/keskos-plymouth
makepkg -s --noconfirm
```

## Activation

The package selects the `keskos` theme when installed. The ISO installer also sets the theme and rebuilds initramfs after package install when possible.

Manual activation:

```bash
sudo plymouth-set-default-theme -R keskos
```

## Notes

- Pacman package name stays `keskos-plymouth`.
- The splash hides raw kernel/systemd noise when the installer adds the matching GRUB kernel parameters.
- Curated status lines are sent with `plymouth display-message` by the installed helper scripts.
