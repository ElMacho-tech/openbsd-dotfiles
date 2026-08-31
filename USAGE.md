# spectrwm Usage

This document describes how to operate and customize the spectrwm
configuration shipped in this dotfiles repository. It is based strictly on
[`.config/spectrwm/spectrwm.conf`](.config/spectrwm/spectrwm.conf), the
scripts it references, and the session files that surround it
([`.xsession`](.xsession.ksh)). Every shortcut listed here was taken from the
configuration and cross-checked against the spectrwm compiled-in defaults.

The configuration is written for OpenBSD/Xenocara with a Spanish (Spain)
keyboard layout. Bindings that spectrwm provides by default and that this
configuration does not change are explicitly marked as defaults.

## Overview

The general design of this setup:

* **Primary modifier:** `Mod4`, which is the Super/Windows-logo key on most
  keyboards. Every binding in the configuration uses it (shown as `Mod`
  below).
* **Keyboard-oriented workflow:** vi-style keys for navigation
  (`Mod+j`/`Mod+k` to change focus, `Mod+h`/`Mod+l` to resize the master
  area), tiling with a master/stack arrangement, and a program launcher
  bound to `Mod+p`.
* **Workspace organization:** 22 workspaces are available
  (`workspace_limit = 22`). Workspaces 1-10 are bound to `Mod+1` through
  `Mod+0`; 11-22 remain reachable through the spectrwm defaults on the F-keys.
* **Window management style:** classic tiling (master window plus a stack),
  starting in the default vertical stack layout. Floating, maximized and
  fullscreen modes are bound directly.
* **Application launchers:** `dmenu_run` for the program menu, plus dedicated
  spawns for the terminal, browser, file manager, clipboard helper, screen
  lock and screenshots (see [Application Launchers and Menus](#application-launchers-and-menus)).
* **Menus:** `dmenu`, styled with the same Dracula-like colors and font as the
  rest of the desktop.
* **Status bar:** enabled, at the bottom of every region, with a workspace
  indicator on the left, the focused window title centered, and the date and
  time on the right (see [Status Bar](#status-bar)).
* **Startup:** spectrwm runs [`initscreen.ksh`](.config/spectrwm/initscreen.ksh)
  via `autorun` to configure displays with `xrandr`; the rest of the session
  (keyboard, X resources, wallpaper, notification daemon) is started by
  [`.xsession`](.xsession.ksh) before spectrwm is executed.
* **External tools in use:** `dmenu`, `xterm`, `xlock`, `xclip`, `scrot`,
  `vifm`, `chromium` (as `chrome`), `xrandr`, `dunst` and
  `openbsd-wallpaper`.

## Key Conventions

* `Mod` always means `Mod4` = the Super/Windows-logo key (the
  `modkey = Mod4` directive).
* `Mod+Shift+X` means: hold `Mod` and `Shift`, then press `X`.
* `Mod+Shift+Return` means: hold `Mod` and `Shift`, then press Enter.
* `Button1` / `Button3` mean the left / right mouse buttons.

The bindings assume a Spanish (Spain) keyboard. Several of them use keysym
names that correspond to physical keys on that layout:

| Keysym in the config | Physical key (Spanish layout)            |
| -------------------- | ---------------------------------------- |
| `exclamdown`         | Far-right key of the number row          |
| `apostrophe`         | The `'`/`?` key, right of `0`            |
| `masculine`          | The masculine-ordinal key, left of `1`   |
| `grave`              | The `` ` ``/`^` key, right of `p`        |
| `plus`               | The `+`/`*` key, right of the grave key  |
| `ccedilla`           | The cedilla key, where a US keyboard has `\` |

The session enables the `es` layout with `nodeadkeys`
(`setxkbmap es nodeadkeys` in [`.xsession`](.xsession.ksh)). Bindings that
use the grave key are written with the `grave` keysym because under
`nodeadkeys` that key reports `grave`; with the plain `es` layout (dead keys
enabled) it reports `dead_grave` instead, which is why the old `dead_grave`
bindings were replaced (see [Troubleshooting](#troubleshooting)).

## Essential Shortcuts

The shortcuts needed for normal daily use:

| Shortcut          | Action                                        |
| ----------------- | --------------------------------------------- |
| `Mod+Shift+Return` | Open a terminal (`xterm +sb`)                 |
| `Mod+p`            | dmenu application launcher                    |
| `Mod+c`            | Open the browser (`chrome`)                   |
| `Mod+Shift+f`      | Open the file manager (`vifm` in `xterm`)     |
| `Mod+f`            | Search window titles                          |
| `Mod+g`            | Search workspaces (jump to workspace)         |
| `Mod+j` / `Mod+k`  | Focus next / previous window                  |
| `Mod+Return`       | Swap focused window into the master area      |
| `Mod+Shift+j` / `Mod+Shift+k` | Swap with next / previous window   |
| `Mod+e`            | Toggle maximized state                        |
| `Mod+Shift+e`      | Toggle fullscreen                             |
| `Mod+t`            | Toggle floating mode                          |
| `Mod+w` / `Mod+Shift+w` | Iconify / uniconify a window              |
| `Mod+x` / `Mod+Shift+x` | Delete (close) / kill a window            |
| `Mod+space`        | Cycle layout                                  |
| `Mod+1` - `Mod+0`  | Switch to workspace 1-10                      |
| `Mod+Shift+1` - `Mod+Shift+0` | Move focused window to workspace 1-10 |
| `Mod+Shift+l`      | Lock the screen (`xlock`)                     |
| `Mod+Print`        | Screenshot of all monitors                    |
| `Mod+Shift+Print`  | Screenshot of a selected window/area          |
| `Mod+Shift+c`      | Copy PRIMARY selection to the clipboard       |
| `Mod+q`            | Restart spectrwm                              |
| `Mod+Shift+q`      | Quit spectrwm                                 |
| `Mod+b`            | Toggle the status bar                         |

## Window Management

Focus, movement and window-state behavior as configured:

* **Change focus:** `Mod+j` / `Mod+Tab` focus the next window;
  `Mod+k` / `Mod+Shift+Tab` the previous one. `Mod+m` focuses the master
  window and `Mod+u` jumps to the window that raised the urgency hint.
  `Mod+masculine` (the key left of `1`) focuses the window currently in
  free (always-visible) mode.
* **Swapping:** `Mod+Return` swaps the focused window with the master window.
  `Mod+Shift+j` / `Mod+Shift+k` swap it with the next/previous window in the
  stack.
* **Moving windows (stack order):** `Mod+grave` (the grave key) moves a
  window left in the stack, `Mod+plus` (the `+` key) moves it right;
  `Mod+Shift+grave` and `Mod+Shift+plus` move it up/down. `Mod+grave` and
  `Mod+Shift+grave` replace spectrwm's default `focus_free` and `free_toggle`
  bindings, which is why this configuration re-binds those actions to
  `Mod+masculine` and `Mod+Shift+masculine`.
* **Master/stack behavior:** the default vertical stack layout keeps the
  master window on the left and tiles the remaining windows on the right.
  `Mod+l` grows and `Mod+h` shrinks the master area; `Mod+comma` adds windows
  to the master area and `Mod+period` removes them.
  The spectrwm defaults `Mod+Shift+comma` / `Mod+Shift+period` add or remove
  columns/rows in the stacking area and remain active.
* **Cycling layouts:** `Mod+space` cycles through vertical, horizontal,
  maximized and floating layouts. `Mod+ccedilla` (the cedilla key) selects
  the centered master/stack layout and `Mod+Shift+ccedilla` flips the
  master/stack sides; that key occupies the position of `\` on a US
  keyboard, which was the original default.
* **Floating windows:** `Mod+t` toggles the focused window between tiled and
  floating. `Mod+Shift+masculine` toggles free mode; free-mode windows stay
  visible on every workspace.
* **Maximize/fullscreen:** `Mod+e` maximizes the focused window,
  `Mod+Shift+e` toggles fullscreen. `Mod+Shift+t` toggles the below state
  (window always at the bottom of the stack).
* **Iconify/uniconify:** `Mod+w` iconifies (minimizes) the focused window;
  `Mod+Shift+w` restores it.
* **Closing windows:** `Mod+x` deletes the window (sends a close request);
  `Mod+Shift+x` kills it (terminates the client without a graceful close).

The mouse-related defaults (`Mod+Button1` to move, `Mod+Button3` to resize)
are unchanged; see [Mouse Behavior](#mouse-behavior).

## Workspaces

* **Numbering:** 22 workspaces are configured (`workspace_limit = 22`).
  No `name` directives are set, so workspaces are unnamed and the bar shows
  their index only.
* **Switching:** `Mod+1` through `Mod+0` switch to workspaces 1-10.
  Workspaces 11-22 are reachable with `Mod+F1` through `Mod+F12`, and
  `Mod+Left` / `Mod+Right` step to the previous/next workspace. These
  bindings come from spectrwm defaults and are not explicitly defined in
  this repository; they are documented here as defaults and may change
  between spectrwm versions.
* **Sending windows:** `Mod+Shift+1` through `Mod+Shift+0` move the focused
  window to workspaces 1-10. The defaults `Mod+Shift+F1` through
  `Mod+Shift+F12` move to workspaces 11-22, and `Mod+Shift+Up` /
  `Mod+Shift+Down` move the window and follow it. These also come from
  spectrwm defaults and are not explicitly defined in this repository.
* **Workspace-specific layouts:** none are configured (no `layout` lines);
  every workspace starts in the default vertical stack layout.
* **Application-to-workspace rules:** none are configured (no `quirk`
  entries). The only workspace-related automation is the `autorun` entry that
  launches `initscreen.ksh` with the `ws[-1]` free-mode specifier (see
  [Startup](#startup)).
* **Multi-monitor behavior:** each connected monitor is one region (the
  default; no `region` lines are configured). `initscreen.ksh` places the
  first external output to the right of the internal panel at startup, so the
  desktop extends across both screens. The default keypad bindings for
  regions (`Mod+KP_1` ... `Mod+KP_9`, `Mod+Shift+KP_1` ... `Mod+Shift+KP_9`)
  remain active.

## Layouts

The layouts available through `Mod+space` (`cycle_layout`), in cycle order:

| Layout             | Behavior                                          |
| ------------------ | ------------------------------------------------- |
| vertical (default) | Master window on the left, stack on the right     |
| horizontal         | Master window on top, stack at the bottom         |
| max                | Focused window occupies the whole region          |
| floating           | Windows are not tiled; manual placement           |

* `Mod+space` cycles forward through that list.
* `Mod+ccedilla` selects the centered master/stack layout
  (`center_layout`) and `Mod+Shift+ccedilla` flips the master and stack
  areas (`flip_layout`). `ccedilla` is the keysym of the cedilla key, the
  physical key that is `\` on a US keyboard, so the geometry matches the
  original spectrwm defaults.
* Fullscreen is not part of the cycle; it is toggled separately with
  `Mod+Shift+e`.
* No custom defaults are set for the master width or master count (no
  `layout` directive), so spectrwm's built-in defaults apply: vertical stack
  at startup and one master window.

## Application Launchers and Menus

All launchers are defined as `program[...]` spawns in `spectrwm.conf` and
invoked with the listed bindings:

| Shortcut          | Program | Command                                          | Purpose / dependency |
| ----------------- | ------- | ------------------------------------------------ | -------------------- |
| `Mod+Shift+Return` | `term` | `xterm +sb`                                      | Terminal; `xterm` is Xenocara base |
| `Mod+p`            | `menu` | `dmenu_run -fn 'Noto Sans Mono:size=10' -nb '#282a36' -nf '#f8f8f2' -sb '#bd93f9' -sf '#282a36'` | Application launcher; needs `dmenu` (package) |
| `Mod+c`            | `browser` | `chrome --disable-features=UseOzonePlatform`   | Browser; the `chrome` binary comes from the `chromium` package |
| `Mod+Shift+f`      | `fileman` | `xterm -e vifm`                                 | File manager; needs `vifm` (package) |
| `Mod+Shift+l`      | `lock`  | `xlock`                                          | Lock screen; `xlock` is Xenocara base |
| `Mod+Shift+c`      | `clip`  | `sh -c 'xclip -selection primary -o \| xclip -selection clipboard'` | Copies the PRIMARY selection to the clipboard; needs `xclip` (package). `sh -c` is required because spectrwm executes programs directly and does not interpret the pipeline itself |
| `Mod+Print`        | `screenshot_all` | `ksh ~/.config/spectrwm/screenshot.ksh full` | Full screenshot; see [screenshot.ksh](.config/spectrwm/screenshot.ksh) |
| `Mod+Shift+Print`  | `screenshot_wind` | `ksh ~/.config/spectrwm/screenshot.ksh window` | Interactive selection screenshot; same script |

The two screenshot bindings run
[`.config/spectrwm/screenshot.ksh`](.config/spectrwm/screenshot.ksh), which
requires `scrot`, saves PNGs to `~/Pictures/Screenshots/`, and shows a
notification through `notify-send` when that command exists.

`Mod+f` (`search_win`) and `Mod+g` (`search_workspace`) use spectrwm's
built-in dmenu searches over window titles and workspaces; `Mod+g` is used
instead of the spectrwm default `Mod+slash` because `/` is only reachable as
`Shift+7` on the Spanish layout. `Mod+Shift+n` names the current workspace
with a dmenu prompt (`name_workspace`), replacing the default
`Mod+Shift+slash` for the same reason.

## Status Bar

The bar is enabled (`bar_enabled = 1`) and placed at the bottom of every
region (`bar_at_bottom = 1`), in the Dracula-like color scheme shared with
`.Xresources` and `dunstrc`.

* **Font:** `bar_font = xft:Noto Sans Mono:style=Regular:size=10`
  (the `noto-fonts` package).
* **Format:** `bar_justify = center` with the three-section format

  ```
  bar_format = +|2L +I:+D (+w) +|3C +W +|2R %Y-%m-%d %H:%M
  ```

  * `+|2L` - left-justified section (weight 2): `+L` renders the workspace
    list indicator (one marker per workspace, with current/urgent markers).
  * `+I` - current workspace index, followed by `:+D` (a colon and the
    workspace name, empty unless a workspace has been named) and
    `(+w)` - the number of windows in the current workspace.
  * `+|3C` - centered section (weight 3): `+W` renders the focused window's
    title.
  * `+|2R` - right-justified section (weight 2): the literal
    `%Y-%m-%d %H:%M` is expanded by `strftime(3)` into the date and time.
    There is no `+A` component because no `bar_action` script is configured
    (an earlier revision had one; its output slot was removed with it).

* **Colors** (semantics only; values are Dracula palette entries):
  * `bar_color` / `bar_color_unfocus` - bar background for the focused and
    unfocused regions; `bar_color_free` - bar background while a
    workspace-free window is focused.
  * `bar_border`, `bar_border_unfocus`, `bar_border_free` - the 2-pixel bar
    border (`bar_border_width = 2`) in the same three states; the free
    variant is green.
  * `bar_font_color`, `bar_font_color_unfocus`, `bar_font_color_free` - text
    colors for those states; `bar_font_color_selected` - foreground of the
    currently selected item in spectrwm menus.
  * `color_focus` / `color_unfocus` / `color_urgent` - window border colors
    (2-pixel borders, `border_width = 2`) for focused, unfocused and urgent
    windows.
* `bar_padding_horizontal` and `bar_padding_vertical` (both `0`) are
  supported since spectrwm 3.7; the configuration targets that version (the
  current OpenBSD package). On older spectrwm releases these lines are
  reported as unknown options and ignored, which is harmless.
* The bar is toggled with `Mod+b`; `Mod+Shift+b` toggles it only for the
  current workspace.

## Mouse Behavior

* **Focus:** `focus_mode = default`, spectrwm's default value: focus follows
  the pointer when it crosses window borders and when windows are clicked.
  The default click-to-raise behavior is unchanged.
* **No pointer warping:** `warp_pointer = 0`; keyboard-driven focus changes,
  workspace switches and layout changes do not move the pointer.
* **Button bindings** (spectrwm defaults, unchanged by this configuration):
  * `Button1` - focus the window under the pointer.
  * `Mod+Button1` - drag to move a floating window.
  * `Mod+Button3` - drag to resize a floating window.
  * `Mod+Shift+Button3` - drag to resize, keeping the window centered.

## Application Rules

This configuration defines no application-specific rules:

* no `quirk[...]` lines (no floating/fullscreen/workspace assignments for
  specific programs),
* no `name` lines (no workspace names),
* no `layout` lines (no per-workspace layouts),
* no `region` lines (one region per monitor).

The only workspace-related automation is the `autorun` entry
(`ws[-1]:ksh ~/.config/spectrwm/initscreen.ksh`), which uses spectrwm's
special workspace index `-1` (free mode: windows stay always mapped); since
that script only runs `xrandr` and creates no windows, the free-mode aspect
has no visible effect. If per-application behavior is ever needed, add
`quirk[...]` entries; no WM_CLASS identifiers are currently referenced
anywhere in this repository.

## Startup

What happens when the session starts, in order:

1. `xenodm` runs [`xenodm/Xsetup_0.sh`](xenodm/Xsetup_0.sh), which only
   paints the login screen's root window with the gray root-weave bitmap.
2. After login, `xenodm` executes `~/.xsession` (installed from
   [`.xsession.ksh`](.xsession.ksh)):
   * exports the locale `es_ES.UTF-8` and XDG base directories;
   * sets the keyboard layout with `setxkbmap es nodeadkeys`;
   * merges [`~/.Xresources`](.Xresources) with `xrdb` (Dracula-like colors
     and xterm settings, including the Noto Sans Mono 10 font);
   * sets the root cursor to `left_ptr` with `xsetroot`;
   * starts `openbsd-wallpaper` in the background when
     `/usr/local/bin/openbsd-wallpaper` exists (the `openbsd-backgrounds`
     package);
   * starts `dunst` in the background when it is installed (its
     configuration is [`.config/dunst/dunstrc`](.config/dunst/dunstrc));
   * `exec`s spectrwm with this repository's configuration:
     `spectrwm -c "$HOME/.config/spectrwm/spectrwm.conf"`.
3. spectrwm itself runs one `autorun` entry:
   `ws[-1]:ksh ~/.config/spectrwm/initscreen.ksh`, which executes
   [`.config/spectrwm/initscreen.ksh`](.config/spectrwm/initscreen.ksh).
   That script uses `xrandr` to enable the internal panel (any of
   `eDP`, `eDP-1`, `eDP-0`, `LVDS`, `LVDS-1`, `LVDS-0`, otherwise the first
   connected output) and places the first other connected output to its
   right. `autorun` entries only run at start-of-day: they are not re-run
   after `Mod+q` (restart), by design.

The login shell profile (installed from [`.profile.ksh`](.profile.ksh)) is
not part of the spectrwm startup chain; it sets `PATH`, the prompt,
`LANG`/`LC_CTYPE`, and the `EDITOR`/`VISUAL`/`PAGER` environment for
terminals opened inside the session.

## Dependencies

### OpenBSD base system / Xenocara

These are used by the configuration and need no package installation:

* `spectrwm` is itself a package, but the following helpers are base:
  `xterm`, `xlock`, `xrandr`, `xrdb`, `setxkbmap`, `xsetroot`,
  `/bin/sh` and `/bin/ksh`, and the standard tools used by the scripts
  (`awk`, `grep`, `head`, `printf`, `date`, `mkdir`, `sleep`).

### Packages (ports)

All of these appear in [`packages.txt`](packages.txt) unless noted:

* `spectrwm` - the window manager.
* `dmenu` - program menu (`Mod+p`), window/workspace searches, and the
  default `name_workspace` prompt.
* `chromium` - provides the `chrome` binary used by `Mod+c`.
* `vifm` - file manager used by `Mod+Shift+f`.
* `xclip` - clipboard helper used by `Mod+Shift+c`.
* `scrot` - screenshot backend used by `screenshot.ksh`.
* `noto-fonts` - the `Noto Sans Mono` font used by the bar, dmenu and xterm.
* `dunst` - notification daemon (optional at runtime; started from
  `.xsession` only when installed).
* `openbsd-backgrounds` - provides `openbsd-wallpaper` (optional at
  runtime; started from `.xsession` only when installed).

Optional and not listed in `packages.txt`: the `libnotify` package, which
provides `notify-send`; `screenshot.ksh` uses it for post-screenshot
notifications when present and silently skips the notification otherwise.

## Configuration Files

| File                                        | Purpose                                            |
| ------------------------------------------- | -------------------------------------------------- |
| [`.config/spectrwm/spectrwm.conf`](.config/spectrwm/spectrwm.conf) | Main spectrwm configuration: programs, bar, colors, `autorun`, `modkey` and all key bindings |
| [`.config/spectrwm/screenshot.ksh`](.config/spectrwm/screenshot.ksh) | Screenshot helper called by the two screenshot bindings |
| [`.config/spectrwm/initscreen.ksh`](.config/spectrwm/initscreen.ksh) | Display setup script run by spectrwm's `autorun` at start-of-day |
| [`.xsession.ksh`](.xsession.ksh)            | X session script (installed as `~/.xsession`); starts the session and execs spectrwm |
| [`.Xresources`](.Xresources)                | Dracula-like colors and xterm settings (font, no scrollbar, save lines) |
| [`.config/dunst/dunstrc`](.config/dunst/dunstrc) | Notification daemon configuration, matching Dracula theme |
| [`xenodm/Xsetup_0.sh`](xenodm/Xsetup_0.sh)  | Login-screen root window setup (installed as `/etc/X11/xenodm/Xsetup_0`) |
| [`.profile.ksh`](.profile.ksh)              | Login shell profile (environment for terminals, not spectrwm-specific) |
| [`packages.txt`](packages.txt)              | Package list installed by the installer |
| [`install.ksh`](install.ksh)                | Installer that copies the above files into place with the right modes |

## Customization

Where to change the most important settings, all in
[`.config/spectrwm/spectrwm.conf`](.config/spectrwm/spectrwm.conf) unless
noted:

* **Modifier key:** `modkey` (currently `Mod4`). All bindings use the `MOD`
  alias, so changing this one line re-points every binding.
* **Terminal:** `program[term]` (currently `xterm +sb`).
* **Application launcher:** `program[menu]` (dmenu arguments, including
  font and colors).
* **Browser / file manager / lock / clipboard:** `program[browser]`,
  `program[fileman]`, `program[lock]`, `program[clip]`.
* **Screenshots:** `program[screenshot_all]` / `program[screenshot_wind]`
  and the script [`.config/spectrwm/screenshot.ksh`](.config/spectrwm/screenshot.ksh)
  (output directory is set in the script).
* **Bar:** `bar_enabled`, `bar_at_bottom`, `bar_font`, `bar_format`,
  `bar_justify`, `bar_border_width`, `bar_padding_*`.
* **Colors:** the `bar_color*`, `bar_font_color*`, `bar_border*`,
  `color_focus`, `color_unfocus` and `color_urgent` directives. Terminal and
  notification colors live in [`.Xresources`](.Xresources) and
  [`.config/dunst/dunstrc`](.config/dunst/dunstrc) respectively.
* **Borders:** `border_width` (window borders) and `bar_border_width`.
  There is no gap/padding option configured; spectrwm 3.7 supports
  `region_padding` if desired.
* **Workspaces:** `workspace_limit`, and the `bind[ws_n]` / `bind[mvws_n]`
  lines. Workspace names or per-workspace layouts would be added with
  `name = ws[n]:...` and `layout = ws[n]:...` lines.
* **Startup:** the `autorun` line (spectrwm) and [`.xsession.ksh`](.xsession.ksh)
  for session-level startup (keyboard layout, wallpaper, dunst).
* **Focus behavior:** `focus_mode` and `warp_pointer`.

## Troubleshooting

Issues that can realistically arise from this specific configuration:

* **`Mod+grave` / `Mod+Shift+grave` (move left/up) require `es nodeadkeys`.**
  These bindings use the `grave` keysym because `.xsession` runs
  `setxkbmap es nodeadkeys`. If the session is switched to the plain `es`
  layout (dead keys enabled), the same key reports `dead_grave` and the
  bindings are silently not registered; in that case the bindings would need
  to use `dead_grave` instead. Diagnose with
  `xmodmap -pke | grep -i grave` or with `xev` while pressing the key (see
  the runtime checks below).
* **Launchers fail silently.** spectrwm spawns programs without a shell and
  only reports failures to its standard error (visible in
  `~/.xsession-errors` under xenodm). If `Mod+c`, `Mod+Shift+f` or
  `Mod+Shift+c` do nothing, check the package is installed:
  `command -v chrome vifm xclip scrot dmenu_run`.
* **Screenshots do not work.** `screenshot.ksh` requires `scrot` and must be
  executable (`chmod +x ~/.config/spectrwm/screenshot.ksh`; the installer
  sets mode 755). Output goes to `~/Pictures/Screenshots/`. The
  post-screenshot notification only appears when `notify-send` (package
  `libnotify`) is installed.
* **`Mod+Shift+i` does nothing useful.** It is a spectrwm default
  (`initscr`) that runs an `initscreen.sh` script which is not installed in
  this repository; this setup's equivalent is
  [`initscreen.ksh`](.config/spectrwm/initscreen.ksh), run via `autorun`.
  Rebinding or unbinding the default is safe.
* **External monitor not enabled after restart.** `autorun` entries only run
  at start-of-day, so `Mod+q` does not re-run `initscreen.ksh`. Run
  `ksh ~/.config/spectrwm/initscreen.ksh` manually or log out and back in.
* **"unknown option" warnings when starting spectrwm from a terminal.**
  `bar_padding_horizontal` / `bar_padding_vertical` are only understood by
  spectrwm 3.7 or newer; older OpenBSD packages log them as unknown options
  and continue. Starting spectrwm from a terminal after package upgrades is
  the easiest way to see such configuration notices.
* **Application rules would not match.** No rules exist today; when adding
  `quirk[...]` entries, identify applications with
  `xprop WM_CLASS` (the class string is what `quirk` matches), not the
  window title.

### Runtime verification on OpenBSD

The Spanish-layout bindings were checked statically against the compiled
`es nodeadkeys` XKB map, but verify them once on the real OpenBSD graphical
session:

1. `setxkbmap -query` - confirm `layout: es` and `variant: nodeadkeys`.
2. `xmodmap -pk | grep -iE 'grave|plus|masculine|ccedilla|exclamdown|apostrophe'`
   - check that the grave key, the `+` key, the key left of `1`, the cedilla
   key and the two far-right number-row keys are mapped as expected.
3. `xev`, then press each bound key while holding Mod4 and confirm the
   `keysym` line:
   * grave key (right of `p`) must report `grave` (0x60), not `dead_grave`;
   * `+` key (right of the grave key) must report `plus`;
   * cedilla key (where a US keyboard has `\`) must report `ccedilla`;
   * the key left of `1` must report `masculine`;
   * `g` and `n` must report plain `g` / `n` with Mod held.
4. Confirm that `Mod+g` opens the workspace search and that
   `Mod+Shift+n` opens the workspace-name prompt.

## Complete Key Binding Reference

All bindings explicitly defined in `spectrwm.conf`. Every entry here uses
the `MOD` alias, which is `Mod4` (Super/Windows key).

### Applications

| Shortcut            | Action                              | Command                                        |
| ------------------- | ----------------------------------- | ---------------------------------------------- |
| `Mod+Shift+Return`  | Open terminal (`term`)              | `xterm +sb`                                    |
| `Mod+p`             | Program menu (`menu`)               | `dmenu_run` (Dracula colors, Noto font)        |
| `Mod+c`             | Browser (`browser`)                 | `chrome --disable-features=UseOzonePlatform`   |
| `Mod+Shift+f`       | File manager (`fileman`)            | `xterm -e vifm`                                |
| `Mod+Shift+l`       | Lock screen (`lock`)                | `xlock`                                        |
| `Mod+Shift+c`       | Copy PRIMARY to clipboard (`clip`)  | `sh -c 'xclip -selection primary -o \| xclip -selection clipboard'` |
| `Mod+Print`         | Screenshot all monitors             | `ksh ~/.config/spectrwm/screenshot.ksh full`   |
| `Mod+Shift+Print`   | Screenshot selection (`window` mode)| `ksh ~/.config/spectrwm/screenshot.ksh window` |

### Window management

| Shortcut             | Action                                     |
| -------------------- | ------------------------------------------ |
| `Mod+j` / `Mod+Tab`  | Focus next window                          |
| `Mod+k` / `Mod+Shift+Tab` | Focus previous window                  |
| `Mod+m`              | Focus master window                        |
| `Mod+masculine`      | Focus free-mode window (key left of `1`)   |
| `Mod+Shift+masculine`| Toggle free mode                           |
| `Mod+u`              | Focus urgent window                        |
| `Mod+Return`         | Swap focused window into master area       |
| `Mod+Shift+j`        | Swap with next window                      |
| `Mod+Shift+k`        | Swap with previous window                  |
| `Mod+w`              | Iconify (minimize) focused window          |
| `Mod+Shift+w`        | Uniconify window                           |
| `Mod+x`              | Delete (close) focused window              |
| `Mod+Shift+x`        | Kill focused window                        |
| `Mod+e`              | Toggle maximized                           |
| `Mod+Shift+e`        | Toggle fullscreen                          |
| `Mod+t`              | Toggle floating                            |
| `Mod+Shift+t`        | Toggle below state                         |
| `Mod+f`              | Search windows (dmenu)                     |
| `Mod+g`              | Search workspaces (dmenu)                  |

### Moving and resizing (Spanish-layout keys)

| Shortcut                       | Action                              |
| ------------------------------ | ----------------------------------- |
| `Mod+grave` (grave key)        | Move window left in the stack       |
| `Mod+plus` (`+` key)           | Move window right in the stack      |
| `Mod+Shift+grave`              | Move window up in the stack         |
| `Mod+Shift+plus`               | Move window down in the stack       |
| `Mod+exclamdown`               | Grow window width (floating)        |
| `Mod+apostrophe`               | Shrink window width (floating)      |
| `Mod+Shift+exclamdown`         | Grow window height (floating)       |
| `Mod+Shift+apostrophe`         | Shrink window height (floating)     |

The keys map to the Spanish physical layout as listed in
[Key Conventions](#key-conventions). The two `grave` entries use the
`grave` keysym (not `dead_grave`) because the session uses
`es nodeadkeys`; they replace the default `focus_free` and `free_toggle`
bindings, which this configuration re-assigns to the `masculine` key.

### Layouts and master area

| Shortcut                 | Action                                        |
| ------------------------ | --------------------------------------------- |
| `Mod+space`              | Cycle layout (vertical, horizontal, max, floating) |
| `Mod+ccedilla`           | Center layout (the key that is `\` on a US keyboard) |
| `Mod+Shift+ccedilla`     | Flip layout                              |
| `Mod+l`                  | Grow master area                              |
| `Mod+h`                  | Shrink master area                            |
| `Mod+comma`              | Add window to master area                     |
| `Mod+period`             | Remove window from master area                |

### Workspaces

| Shortcut          | Action                          |
| ----------------- | ------------------------------- |
| `Mod+1` - `Mod+0` | Switch to workspace 1-10        |
| `Mod+Shift+1` - `Mod+Shift+0` | Move window to workspace 1-10 |
| `Mod+Shift+n`     | Name current workspace (dmenu)  |

### Bar and session

| Shortcut          | Action                              |
| ----------------- | ----------------------------------- |
| `Mod+b`           | Toggle status bar                   |
| `Mod+Shift+b`     | Toggle status bar on current workspace |
| `Mod+q`           | Restart spectrwm                    |
| `Mod+Shift+q`     | Quit spectrwm                       |
| `Mod+Shift+v`     | Show spectrwm version               |
| `Mod+d`           | Toggle debug mode (debug builds only) |

### Spectrwm defaults that remain active

These bindings are spectrwm built-ins that this configuration does not
rebind or disable, so they keep working. They are compiled into spectrwm
and may change between spectrwm versions; treat them as defaults, not as
part of this repository's configuration:

* Mouse: `Button1` focus; `Mod+Button1` move; `Mod+Button3` resize;
  `Mod+Shift+Button3` centered resize.
* `Mod+s` / `Mod+Shift+s` - screenshot all / selection (they run the same
  `program[screenshot_all]` / `program[screenshot_wind]` commands as
  `Mod+Print` / `Mod+Shift+Print`).
* `Mod+Shift+Delete` - lock (in addition to `Mod+Shift+l`).
* `Mod+Shift+a` - focus previously focused window.
* `Mod+r` / `Mod+Shift+r` - raise / always raise.
* `Mod+v` - button2 equivalent (perform window action under pointer).
* `Mod+-` / `Mod+Shift+-` - width shrink / height shrink (the `-` key is an
  unshifted key on the Spanish layout, so these two work); `Mod+=` /
  `Mod+Shift+=` - width grow / height grow (the `=` keysym exists only as
  the shifted level of the `0` key, so these two do not match).
* `Mod+[` / `Mod+]` and shifted variants - move window (these also cannot
  fire on the Spanish layout, where the brackets only exist on AltGr
  levels).
* `Mod+Shift+comma` / `Mod+Shift+period` - add/remove columns or rows in
  the stacking area.
* `Mod+Shift+space` - reset stacking.
* `Mod+Left` / `Mod+Right` - previous/next workspace; `Mod+Up` /
  `Mod+Down` - next/previous workspace on all regions; `Mod+a` - prior
  workspace.
* `Mod+Shift+Up` / `Mod+Shift+Down` - move window to next/previous
  workspace.
* `Mod+F1` - `Mod+F12` - workspaces 11-22; `Mod+Shift+F1` -
  `Mod+Shift+F12` - move window to workspaces 11-22.
* Keypad: `Mod+KP_1` - `Mod+KP_9` select regions; `Mod+Shift+KP_1` -
  `Mod+Shift+KP_9` move windows across regions.
* `Mod+Shift+i` - run `initscreen.sh` (not installed; see
  [Troubleshooting](#troubleshooting)).

Bindings whose defaults were replaced by this configuration:

* The default `Mod+grave` (`focus_free`) is overridden by the explicit
  `move_left` binding; `focus_free` remains available on `Mod+masculine`.
* The default `Mod+Shift+grave` (`free_toggle`) is overridden by the
  explicit `move_up` binding; `free_toggle` is re-assigned to
  `Mod+Shift+masculine`.
* The default `Mod+slash` (`search_workspace`) and
  `Mod+Shift+slash` (`name_workspace`) cannot fire on the Spanish layout
  and are functionally replaced by `Mod+g` and `Mod+Shift+n`.
* The default `Mod+backslash` / `Mod+Shift+backslash` (`center_layout` /
  `flip_layout`) also cannot fire on the Spanish layout and are
  functionally replaced by `Mod+ccedilla` / `Mod+Shift+ccedilla`.

Bindings that the configuration re-states with the same keys (for example
`Mod+p` for the menu or `Mod+x` for wind_del) simply confirm the defaults
and do not create conflicts; spectrwm replaces the default entry for the
same key combination.
