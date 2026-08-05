# OpenBSD dotfiles

This repository installs a personal OpenBSD/Xenocara desktop based on `ksh`, `xenodm`, `spectrwm` and `dunst`. It is an opinionated workstation configuration, not a generic unattended installer.

## What the installer changes

Run it from the repository root:

```sh
$ doas ./install.ksh
```

The script requires root and requires an existing, non-root target account. When invoked through `doas`, `DOAS_USER` is offered as the default. It then:

- installs every non-comment entry in `packages.txt` with `pkg_add`;
- optionally adds `permit persist user as root` to `/etc/doas.conf`, after checking the complete candidate file with `doas -C`;
- installs the spectrwm and dunst files under the target user's `~/.config`;
- installs `.xsession`, `.Xresources` and `.profile` for that user;
- replaces `/etc/X11/xenodm/Xsetup_0` with the included neutral root-weave setup;
- changes the user's login shell to the base-system `/bin/ksh`.

Existing target files are backed up with the `.old` suffix by OpenBSD `install(1)`. Unrelated files in `~/.config` are preserved, and ownership changes are limited to files and directories installed by this script. Review `.old` files before a later installation overwrites an earlier backup.

The doas rule is deliberately interactive because it grants broad root access. Decline it if the account should have command-specific rules instead. The package installation and login-shell change are not separately prompted.

## Session behaviour

`.xsession` selects a Spanish keyboard layout, loads X resources, starts `openbsd-wallpaper` and `dunst` when present, then executes spectrwm. It does not disable the X screen saver or DPMS. `Mod4+Shift+L` invokes `xlock`; no automatic idle lock is configured.

The spectrwm clipboard command explicitly uses `sh -c` because spectrwm executes configured programs directly and does not interpret a pipeline itself. Screenshots use `Mod4+Print` for all monitors and `Mod4+Shift+Print` for an interactive selection.

The configuration assumes the package prefix `/usr/local`. Dunst uses its recursive Freedesktop icon lookup with the `hicolor` theme instead of a Linux-specific `/usr/share/icons` path.

## Static maintenance checks

On OpenBSD, useful non-executing checks are:

```sh
$ ksh -n install.ksh .profile.ksh .xsession.ksh \
    .config/spectrwm/initscreen.ksh .config/spectrwm/screenshot.ksh
$ sh -n xenodm/Xsetup_0.sh
$ doas -C /etc/doas.conf
```

Spectrwm and Dunst should also be started from a terminal after upgrades so that either program can report configuration keys removed by a newer package version.

## References

- [doas(1)](https://man.openbsd.org/doas.1) and [doas.conf(5)](https://man.openbsd.org/doas.conf.5)
- [install(1)](https://man.openbsd.org/install.1)
- [spectrwm upstream manual](https://github.com/conformal/spectrwm/blob/master/spectrwm.1)
- [Dunst configuration manual](https://github.com/dunst-project/dunst/blob/master/docs/dunst.5.pod)

## License

See [LICENSE](LICENSE).
