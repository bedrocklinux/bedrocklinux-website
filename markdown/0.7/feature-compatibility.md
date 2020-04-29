Title: Bedrock Linux 0.7 Poki Compatibility and workarounds
Nav: poki.nav

# Bedrock Linux 0.7 Poki Feature Compatibility

| Feature                            | How well it works    | Notes |
| cross-stratum `bash` completion    | ~%Mostly Works~x       | Install `bash-completion` in all ~{strata~}; some completions fail |
| cross-stratum `fish` completion    | ~%Just Works~x         | |
| cross-stratum `zsh` completion     | ~%Mostly Works~x       | Install `zsh` in all ~{strata~}; some completions fail |
| cross-stratum applications         | ~^Minor Work-around~x  | [Clear cache to update application menu](#application-launchers) |
| cross-stratum dbus                 | ~%Just Works~x         | |
| cross-stratum desktop environments | ~!Major Issues~x       | [Requires hand-crafted, ~+Bedrock~x-aware configuation.](#desktop-environments) |
| cross-stratum dkms                 | ~^Mostly Works~x       | [Sometimes must pair dkms and kernel](#dkms) |
| cross-stratum executables          | ~%Just Works~x         | |
| cross-stratum firmware             | ~%Mostly Works~x       | Kernel will detect firmware across strata, initrd-building software needs investigation |
| cross-stratum info pages           | ~%Just Works~x         | |
| cross-stratum init configuration   | ~!Major issues~x       | [Requires hand-crafted, ~+Bedrock~x-aware configuration.](#init-configuration) |
| cross-stratum libraries            | ~!Does Not Work~x      | Theoretically possible but unsupported due to complexity/messiness concerns |
| cross-stratum login shells         | ~%Just Works~x         | [Specifying stratum requires special configuration](#login-shells) |
| cross-stratum man pages            | ~%Just Works~x         | |
| cross-stratum themes               | ~%Mostly Works~x       | Works work themes that support `$XDG_DATA_DIRS` |
| cross-stratum vt fonts             | ~!Does Not Work~x      | Needs research |
| cross-stratum Wayland Fonts        | ~^Needs Testing~x      | Needs research |
| cross-stratum Xorg fonts           | ~^Reports of inconsistency | Deeper investigation needed |
| ACLs                                             | ~!Mostly Works~x       | Does not work in `/etc` |
| Any stratum's init                               | ~%Mostly Works~x       | Select init at init-selection menu during boot; [see BSD style SysV notes](#bsd-style-sysv) |
| Any stratum's kernel                             | ~%Mostly Works~x       | Install kernel from ~{stratum~} then update bootloader |
| AppArmor, TOMOYO, SMACK                          | ~^Needs Testing~x      | Default profiles unlikely to work |
| BSD-style SysV init                              | ~!Major Issue~x        | [Freezes on shutdown](#bsd-style-sysv) |
| build tools (e.g. make, configure scripts, etc)  | ~^Minor Work-around~x  | Often confused without `strat -r` |
| grubs+btrfs/zfs                                  | ~!Major Issue~x        | [GRUB miss-updates `grub.cfg` on btrfs/zfs in ~+Bedrock~x](#grub-btrfs-zfs) |
| nVidia proprietary drivers                       | ~^Manual Work-around~x | [Manually install drivers in relevant ~{strata~}](#nvidia-drivers) |
| pamac/octpoi                                     | ~!Inconsistent Reports~x | [Inconsistent reports](#pamac) |
| ptrace (e.g. gdb, strace)                        | ~^Minor Work-around~x  | Install in same ~{stratum~} as traced program, `strat -r` |
| SELinux                                          | ~!Does Not Work~x      | ~+Bedrock~x disabled on hijack |
| systemd-shim                                     | ~!Major Issue~x        | [logind access denied](#systemd-shim) |
| timeshift                                        | ~!Major Issue~x        | Confused by filesystem layout; do not use with ~+Bedrock~x |

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

~{Cross~}-~{stratum~} `dkms` usage on Bedrock _almost_ always works, with one
exception.

`dkms` needs to see two code bases to work:

- The `dkms` module source.
- The current kernel's headers.

Bedrock can make the former work across ~{stratum~} boundaries.  A `dkms` from
any ~{stratum~} will automatically be able to pick up and use things like
nVidia or Virtualbox module code from other ~{strata~}.

Bedrock's ability to make the latter work across ~{strata~} depends on how the
kernel-providing distro sets up its kernel headers.  Some distros place the
header source directly at

	~(/usr~)/lib/modules/~(version~)/build/

For example, Arch Linux does this.  If such a distro provides your kernel,
`dkms` from non-kernel ~{strata~} can detect the kernel's headers.

Other distros make the kernel header source directory a symlink to a ~{local~}
location.  For example, Debian symlinks them into `/usr/src/`.  `dkms` from
other non-kernel ~{strata~} will be unable to follow such symlinks.

In practice, this means:

- Installing or updating a kernel with `dkms` installed in the kernel stratum
  should just work.
- Installing or updating a dkms package, such as a VirtualBox host modules
  package, will only create the dkms modules if the kernel providing
  ~{stratum~} is a non-header-symlink distro.

In the scenario where `dkms` does not detect headers ~{cross~}-~{stratum~}, one
may manually run the kernel stratum's `dkms` with `strat` to build and install
the module:

`strat -r ~(target-kernel-stratum~) dkms install ~(module~)/~(module-version~) -k ~(target-kernel-version~)`

#### Table

| `dkms` binary is from kernel stratum | `dkms` module is from kernel stratum | kernel headers are ~{local~} symlink | Just Works |
| Yes                                  | Yes                                  | Yes                                  | ~%Yes~x    |
| Yes                                  | Yes                                  | No                                   | ~%Yes~x    |
| Yes                                  | No                                   | Yes                                  | ~%Yes~x    |
| Yes                                  | No                                   | No                                   | ~%Yes~x    |
| No                                   | Yes                                  | Yes                                  | ~!No~x     |
| No                                   | Yes                                  | No                                   | ~%Yes~x    |
| No                                   | No                                   | No                                   | ~%Yes~x    |
| No                                   | No                                   | Yes                                  | ~!No~x     |

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
- strat -r ~(stratum~) sh ./NVIDIA-Linux-~(arch~)-~(version~).run --no-kernel-module

for all remaining ~(strata~) that require graphics drivers.

The `bedrock` stratum and other strata that do not utilize the graphics
acceleration do not require the Nvidia drivers.
