Title: Bedrock Linux 0.7 Poki Compatibility and workarounds
Nav: poki.nav

# Bedrock Linux 0.7 Poki Feature Compatibility

- [Cross-Stratum Features](#cross-stratum-features)
- [Any-Stratum Features](#any-stratum-features)
- [Miscellaneous-Feature-Issues](#miscellaneous-feature-issues)

## {id="cross-stratum-features"} Cross-Stratum Features

Features you can install in one stratum and use with programs from another.

If a given feature does not work ~{cross~}-~{stratum~}, you may be able to get the desired effect by installing it redundantly in every corresponding ~{stratum~}.

| Category           | Feature    | How well it works          | Notes |
| 2#Docs             | info pages | ~%Just Works~x             | |
|                      man pages  | ~%Mostly Works~x           | [mandoc man executable cannot read Gentoo man pages](#man) |
| 3#Fonts            | vt         | ~!Does Not Work~x          | Needs research |
|                      Wayland    | ~^Needs Testing~x          | Needs research |
|                      Xorg       | ~^Reports of inconsistency | Deeper investigation needed |
| 10#Misc            | applications         | ~^Minor Work-around~x | [Clear cache to update application menu](#application-launchers) |
|                      dbus                 | ~%Just Works~x        | |
|                      desktop environments | ~!Major Issues~x      | [Requires hand-crafted, ~+Bedrock~x-aware configuation.](#desktop-environments) |
|                      dkms                 | ~!Major issues~x      | [Must manually pair dkms and kernel](#dkms) |
|                      executables          | ~%Just Works~x        | |
|                      fcitx                | ~%Mostly Works~x      | communication just-works, cross-stratum libraries don't; install fcitx in relevant strata |
|                      firmware             | ~%Mostly Works~x      | Kernel will detect firmware across strata, initrd-building software needs investigation |
|                      init configuration   | ~!Major issues~x      | [Requires hand-crafted, ~+Bedrock~x-aware configuration.](#init-configuration) |
|                      libraries            | ~!Does Not Work~x     | Theoretically possible but unsupported due to complexity/messiness concerns |
|                      login shells         | ~%Just Works~x        | [Specifying stratum requires special configuration](#login-shells) |
| 3#Shell Completion | `bash`     | ~%Mostly Works~x           | Install `bash-completion` in all ~{strata~} |
|                      `fish`     | ~%Just Works~x             | |
|                      `zsh`      | ~%Mostly Works~x           | Install `zsh` in all ~{strata~} |
| 5#Themes           | Cursor     | ~!Does Not Work~x          | Needs research |
|                      Icon       | ~%Just Works~x             | |
|                      GTK2       | ~^Minor Work-around~x      | [export `GTK2_RC_FILES`, install theme engine ](#gtk2-themes) |
|                      GTK3       | ~%Just Works~x             | |
|                      Qt         | ~^Needs Testing~x          | Needs research |

## {id="any-stratum-features"} Any-Stratum Features

Features you can install from any stratum and use system-wide.

| Feature    | How well it works | Notes |
| bootloader | ~%Mostly Works~x  | install over other copies; never uninstall; [GRUB+btrfs/zfs specific issue](#grub-btrfs-zfs) |
| init       | ~%Mostly Works~x  | select init at init-selection menu during boot; [BSD style SysV notes](#bsd-style-sysv) |
| kernel     | ~%Minor Issue~x   | [if non-bootloader stratum, manually update bootloader](#bootloader) |

## {id="miscellaneous-feature-issues"} Miscellaneous Feature Issues

Miscellaneous known feature-specific issues and limitations.

| Feature                                         | How well it works        | Notes |
| ACLs                                            | ~%Mostly Works~x         | Does not work in `/etc` |
| AppArmor, TOMOYO, SMACK                         | ~^Needs Testing~x        | Default profiles unlikely to work |
| BSD-style SysV init                             | ~!Major Issue~x          | [Freezes on shutdown](#bsd-style-sysv) |
| build tools (e.g. make, configure scripts, etc) | ~^Minor Work-around~x    | Often confused without `strat -r` |
| grubs+btrfs/zfs                                 | ~!Major Issue~x          | [GRUB miss-updates `grub.cfg` on btrfs/zfs in ~+Bedrock~x](#grub-btrfs-zfs) |
| nVidia proprietary drivers                      | ~^Manual Work-around~x   | [Manually install drivers in relevant ~{strata~}](#nvidia-drivers) |
| pamac/octpoi                                    | ~!Inconsistent Reports~x | [Inconsistent reports](#pamac) |
| ptrace (e.g. gdb, strace)                       | ~^Minor Work-around~x    | Install in same ~{stratum~} as traced program, `strat -r` |
| SELinux                                         | ~!Does Not Work~x        | ~+Bedrock~x disabled on hijack |
| systemd-shim                                    | ~!Major Issue~x          | [logind access denied](#systemd-shim) |
| timeshift                                       | ~!Major Issue~x          | Confused by filesystem layout; do not use with ~+Bedrock~x |

## Details

### {id="application-launchers"} Application Launchers

Many application launchers cache known applications and/or their icons.  Some
may fail to recognize new applications in `/bedrock/cross/applications` or icons
in `/bedrock/cross/icons`.

Some such applications can be prompted to build the cache by removing
`~/.cache` and restarting the application menu provider (e.g. logging out and
back in).

Application Launcher specific cache updating techniques:

- KDE: Run `kbuildsycoca5` or `kbuildsycoca5 --nonincremental`

### {id="login-shells"} Login shells

Linux systems typically store *the full path* to a login shell in
`/etc/passwd`.  Default login shell paths are ~{local~} and will not be visible
to another ~{stratum~}'s init system.  ~+Bedrock~x automatically changes any
~{local~} login shell to a ~{cross~} path in `/bedrock/cross/bin/` to work
around this concern.

If you would like to use a *specific* ~{stratum~}'s shell [rather than the
highest priority one](configuration.html#cross-priority), [create a pin entry
in cross-bin](workflows.html#pinning) with the desired shell.  After `brl
apply`ing the new configuration, add the new pin path to `/etc/shells` and
`chsh` to it.

### {id="init-configuration"} Init configuration

Every ~{stratum~} sees its own init configuration and only its own init
configuration.  By default, an init from one ~{stratum~} will not know how to
manage a service from another ~{stratum~}'s init.

It is possible to work around this by hand crafting init configuration.  For
example, one may make a runit run directory whose `run` file calls `strat`.
For another example, one may make a systemd unit file whose `Exec=` line calls
`strat`.

If you find hand creating init configuration is intimidating or bothersome,
consider simply picking one ~{stratum~} to provide your init and get all
init-related services from that ~{stratum~}.

### {id="desktop-environments"} Desktop Environments

Generally, getting:

- Init system
- Display Manager
- Desktop Environment

all from the same ~{stratum~} works as expected, and is the recommended
workflow for most users.

The wiring between these components does not work automatically register across
~{stratum~} boundaries.  There are two components to this issue:

- DMs are typically launched by an init system, and DEs often depend on other
  services launched by an init system.  However, [cross-stratum init
  configuration also remains an open research problem](#init-configuration).
- DMs learn about DEs via files in `/usr/share/xsessions/` and only in that
  location.  Unlike other resources, there does not appear to be a standard way
  to to extend the list of resource look-up locations.  Consequently, there's
  no obvious way to add cross-stratum DE registration without risking upsetting
  a package manager.

It is possible to make cross-stratum desktop environments work if the relevant
init configuration is made by hand to launch all of the DE's dependencies.
Whether `/usr/share/xsessions` changes are also needed depends on the specific
init configuration strategy utilized.  This may be difficult for some users and
is not broadly recommended.

### {id="dkms"} dkms

~+Bedrock~x supports ~{cross~}-~{stratum~} `dkms` given the following constraints:

- The `dkms` executable should come from the kernel-providing stratum.
- The `dkms` module version plays nicely with the kernel version.

~+Bedrock~x does not enforce either of these constraints; the user must handle
them manually.

The expected user workflow is to:

- Install desired `dkms` modules in providing ~{strata~}.  Package managers may
  try to compile these for the kernel and error; that's okay, ignore the error.
- Install `dkms` in the kernel ~{stratum~}.  When this ~{stratum~} updates the
  kernel, it should detect cross-strata module source and compile accordingly.

If package managers are not automating `dkms`, one may manually tell `dkms` to
build and install a module:

`strat -r ~(target-kernel-stratum~) dkms install ~(module~)/~(module-version~) -k ~(target-kernel-version~)`

### {id="bsd-style-sysv"} BSD Style SysV

BSD-style SysV init systems, such as used by Slackware and CRUX, freeze on shutdown when run on ~+Bedrock~x.

The leading theory is:

- ~+Bedrock~x mounts a FUSE filesystem, `etcfs`, on `/etc/`
- SysV sends `etcfs` `SIGTERM` during shutdown
- For some reason, `etcfs` crashes instead of umounts.  This makes all programs
  which read `/etc` hang.
- SysV proceeds to read another shutdown script out of `/etc`.

Quick and dirty tests show `etcfs` _normally_ umounts on `SIGTERM` from root.
It is not clear why this might not be happening during SysV shutdown.
~+Bedrock~x's `etcfs` code does not do any direct signal handling.  Debugging
this may require digging into `libfuse`'s code to see how it handles signals.

### {id="systemd-shim"} systemd-shim

On ~+MX Linux~x, the logged in user is expected to get certain permissions granted
from systemd-logind, such as the ability to use the desktop environment's menu
to reboot the system.

When running in ~+Bedrock~x, this does not appear to work.  This is likely due
to ~+MX Linux~x's use of SysV _and_ systemd-logind via systemd-shim.  The issue does
not occur either on pure systemd systems nor on pure SysV systems.

Investigation found some process was reading ~{local~} copies of what should
have been ~{global~} `/etc` files.  This process was somehow reading `/etc`
content _under_ the `etcfs` mount.  It is not clear what process was doing
this, nor how it was doing so.

Manually writing through global `/etc` files to the init ~{stratum~} (and
consequently, `systemd-logind`'s and `systemd-shim`'s ~{stratum~}) resolved the
issue.  However, automating this is not suitable as a general solution due to
both performance and implementation complexity concerns.

### {id="grub-btrfs-zfs"} Grub with BTRFS or ZFS

When GRUB updates `grub.cfg` on BTRFS it adds a `subvol=` field.  Similarly, on
ZFS it adds a `ZFS=` field.

GRUB's logic to populate these fields via `grub-mkrelpath`/`grub2-mkrelpath`
appears to be confused under ~+Bedrock~x and mis-populate the BTRFS and ZFS
fields.  This will cause boot failures.

Until this is resolved, it is strongly recommended not to use ~+Bedrock~x,
GRUB, and BTRFS/ZFS.  Any two of the three is fine; consider another bootloader
or filesystem.

Some quick digging into `grub-mkrelpath`'s source found:

- `grub-mkrelpath` gets the major:minor number of the root directory via
  `stat()`
- `grub-mkrelpath` then parses `/proc/self/mountinfo` to find a line with the
  same major:minor number.

This is fine on most distros which only mount the root partition once.
However, ~+Bedrock~x's use of bind-mounts results in multiple
`/proc/self/mountinfo` entries with the same major:minor number, which in turn
means `grub-mkrelpath` may grab the wrong one.

### {id="pamac"} Pamac and Octopi

Inconsistent reports have been provided for how well `pamac` and `octopi` work
on ~+Bedrock~x, both on ~+Manjaro~x and ~+Arch~x via AUR.  Investigation may be
needed.

### {id="nvidia-drivers"} Nvidia proprietary drivers

Most Linux graphics drivers have two components:

- A kernel module
- A userland component

Most F/OSS Linux graphics drivers strive to make the two components forward and
backward compatible such that their versions do not have to sync up perfectly.
This allows a kernel from one ~{stratum~} to work with an Xorg server from
another ~{stratum~}.  However, the proprietary Nvidia drivers require these two
components be in sync.  Since the kernel module is shared across ~{strata~},
this means every ~{stratum~} that does anything with the graphics card requires
the exact same version.  Bedrock does not know how to enforce this itself.  To
work around this, one must manually install distro-agnostic portable
proprietary Nvidia in all ~{strata~}.

[Download the proprietary Nvidia driver](https://www.nvidia.com/object/unix.html).  Then run

- {class="rcmd"}
- strat -r ~(kernel-stratum~) sh ./NVIDIA-Linux-~(arch~)-~(version~).run

where ~(kernel-stratum~) is the ~{stratum~} providing your kernel.  This may
require a `linux-headers` package be installed in the ~(kernel-stratum~).  Note
the `-r`: this is important to keep the Nvidia driver installer from "cleaning"
graphics related files in other ~{strata~}.

Next, run

- {class="rcmd"}
- strat -r ~(stratum~) sh ./NVIDIA-Linux-~(arch~)-~(version~).run --no-kernel-module

for all remaining ~(strata~) that require graphics drivers.

The `bedrock` stratum and other strata that do not utilize the graphics
acceleration do not require the Nvidia drivers.

### {id="man"} Man pages

Many Linux distros provide the `man` executable via one of the following:

- [man-db](https://www.nongnu.org/man-db/)
- [mandoc](https://mandoc.bsd.lv/)
- [busybox](https://www.busybox.net/)

For the most part, any of those three can read man pages from any distro.  One may use Debian's `man` to read ~+Void Linux~x's `xbps-install` man page and one may use ~+Void Linux~x's `man` to read Debian's `apt` man page, for example, despite the fact that Debian uses `man-db` and ~+Void~x uses `mandoc`.

There is one discovered exception: `mandoc` `man` executable, as provided by distros like ~+Alpine Linux~x and ~+Void Linux~x, cannot seem to read ~+Gentoo~x's man pages.

Work arounds include:

- Manually call `strat gentoo man` when you want to read a ~+Gentoo~x man page.
- [Pin a man-db or busybox `man`](https://bedrocklinux.org/0.7/workflows.html#pinning).
- Uninstall all `mandoc` man executables and install at least one other `man`.

### {id="gtk2-themes"} GTK2 themes

#### GTK2\_RC\_FILES

GTK2 themes provide a `gtkrc` file.  Export the `GTK2_RC_FILES` environment
variable to a ~{cross path~} for this file.  For example, ~+Arch Linux~x's
`materia-gtk-theme` package provides a `Materia-dark-compact` theme whose `gtkrc` file is at

```
/usr/share/themes/Materia-dark-compact/gtk-2.0/gtkrc
```

which is visible to all strata at

```
/bedrock/strata/arch/usr/share/themes/Materia-dark-compact/gtk-2.0/gtkrc
```

assuming `arch` is the stratum name.  To make this one's GTK2 theme, export
`GTK2_RC_FILES` to this location in one's environment setup (e.g. `.bashrc`):

```
export GTK2_RC_FILES="/bedrock/strata/arch/usr/share/themes/Materia-dark-compact/gtk-2.0/gtkrc"
```

#### GTK2 engines

GTK2 has a concept called "theme engines" which do not work cross-stratum.  These must be installed in all corresponding strata.  Running a GTK2 application without produce warnings such as

```
Gtk-WARNING **: 19:01:13.566: Unable to locate theme engine in module_path: "industrial",
```

These are trivially fixed by installing the corresponding engine package in the gtk2 application's stratum.

#### R&D

The GTK2 ecosystem does not appear to support `$XDG_DATA_DIRS`.  It looks like [NixOS explicitly patches support for `$XDG_DATA_DIRS` in](https://github.com/NixOS/nixpkgs/pull/25881), and [gtk2 documentation mentions only using it for _icon_ themes, not widget or cursor themes](https://developer.gnome.org/gtk2/stable/gtk-running.html).  Thus, we cannot simply point `$XDG_DATA_DIRS` to look into crossfs.

However, GTK2 appears to follow `$GTK_DATA_PREFIX`.  It might be possible to point this to crossfs to make this feature just-work ~{cross~}-~{stratum~}.  More investigation is needed.

### {id="bootloader"} Bootloader

Most distros have hooks which will update bootloader configuration when a kernel is installed or updated.  If the kernel and bootloader providing strata are the same, should work as expected.  However, if they differ, the hook will not trigger upon kernel installation/update and the bootloader will not be automatically updated.

If you would like to get your kernel and bootloader from different strata, either create such a hook yourself or manually update the bootloader configuration when the kernel updates.
