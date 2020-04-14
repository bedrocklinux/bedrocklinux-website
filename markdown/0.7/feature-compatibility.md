Title: Bedrock Linux 0.7 Poki Compatibility and workarounds
Nav: poki.nav

# Bedrock Linux 0.7 Poki Feature Compatibility

| Feature                            | How well it works   | Notes |
| cross-stratum `bash` completion    | ~%Mostly Works      | Install `bash-completion` in all ~{strata~}; some completions fail |
| cross-stratum `fish` completion    | ~%Just Works        | |
| cross-stratum `zsh` completion     | ~%Mostly Works      | Install `zsh` in all ~{strata~}; some completions fail |
| cross-stratum applications         | ~^Minor Work-around | [Clear cache to update application menu](#application-launchers) |
| cross-stratum dbus                 | ~%Just Works        | |
| cross-stratum desktop environments | ~!Works Manually    | Sometimes works if launched manually.  DM detection does not work. |
| cross-stratum executables          | ~%Just Works        | |
| cross-stratum firmware             | ~%Mostly Works      | Kernel will detect firmware across strata, initrd-building software needs investigation |
| cross-stratum info pages           | ~%Just Works        | |
| cross-stratum init configuration   | ~!Works Manually    | [Works with hand-crafted, ~+Bedrock~x-aware configuration.](#init-configuration) |
| cross-stratum libraries            | ~!Does Not Work     | Theoretically possible but unsupported due to complexity/messiness concerns |
| cross-stratum login shells         | ~%Just Works        | [specifying stratum requires special configuration](#login-shells) |
| cross-stratum man pages            | ~%Just Works        | |
| cross-stratum themes               | ~%Mostly Works      | Works work themes that support `$XDG_DATA_DIRS` |
| cross-stratum vt fonts             | ~!Does Not Work     | Needs research |
| cross-stratum Wayland Fonts        | ~^Needs Testing     | Needs research |
| cross-stratum Xorg fonts           | ~^Reports of inconsistency | Deeper investigation needed |
| ACLs                                             | ~!Mostly Works       | Does not work in `/etc` |
| Any stratum's init                               | ~%Mostly Works       | Select init at init-selection menu during boot; [see BSD style SysV notes](#bsd-style-sysv) |
| Any stratum's kernel                             | ~%Mostly Works       | Install kernel from ~{stratum~} then update bootloader |
| AppArmor, TOMOYO, SMACK                          | ~^Needs Testing      | Default profiles unlikely to work |
| BSD-style SysV init                              | ~!Major Issue        | [Freezes on shutdown](#bsd-style-sysv) |
| build tools (e.g. make, configure scripts, etc)  | ~^Minor Work-around  | Often confused without `strat -r` |
| grubs+btrfs/zfs                                  | ~!Major Issue        | [GRUB miss-updates `grub.cfg` on btrfs/zfs in ~+Bedrock~x](#grub-btrfs-zfs) |
| nVidia proprietary drivers                       | ~^Manual Work-around | [Manually install drivers in relevant ~{strata~}](#nvidia-drivers) |
| pamac/octpoi                                     | ~!Inconsistent Reports | [Inconsistent reports](#pamac) |
| ptrace (e.g. gdb, strace)                        | ~^Minor Work-around  | Install in same ~{stratum~} as traced program, `strat -r` |
| SELinux                                          | ~!Does Not Work      | ~+Bedrock~x disabled on hijack |
| systemd-shim                                     | ~!Major Issue        | [logind access denied](#systemd-shim) |
| timeshift                                        | ~!Major Issue        | Confused by filesystem layout; do not use with ~+Bedrock~x |

### {id="application-launchers"} Application Launchers

Many application launchers cache known applications and/or their icons.  Some
may fail to recognize new applications in `/bedrock/cross/applications` or icons
in `/bedrock/cross/icons`.

Some such applications can be prompted to build the cache by removing
`~/.cache` and restarting the application menu provider (e.g. logging out and
back in).

Application Launcher specific cache updating techniques:

- KDE: Run `kbuildsycoa5` or `kbuildsycoa5 --nonincremental`

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

On MX Linux, the logged in user is expected to get certain permissions granted
from systemd-logind, such as the ability to use the desktop environment's menu
to reboot the system.

When running in ~+Bedrock~x, this does not appear to work.  This is likely due
to MX Linux's use of SysV _and_ systemd-logind via systemd-shim.  The issue does
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

GRUB's logic to populate these fields via `grub-mkrelatph`/`grub2-mkrelpath`
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
- strat -r ~(stratum~) sh ./NVIDIA-Linux-~(arch~)-~(versino~).run --no-kernel-module

for all remaining ~(strata~) that require graphics drivers.

The `bedrock` stratum and other strata that do not utilize the graphics
acceleration do not require the Nvidia drivers.
