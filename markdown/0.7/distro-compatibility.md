Title: Bedrock Linux 0.7 Poki Distro Support
Nav: poki.nav

# Bedrock Linux 0.7 Poki Distro Compatibility

The "Community Usage" column is a subjective rating of how heavily the given
distro is used in ~+Bedrock Linux~x community intended to provide a level of
confidence in the "Known Issues" column's accuracy and recency.

| Linux Distro          | Community Usage   | Known Issues | Fetch Support    | Maintainer   |
| ~+Alpine Linux~x      | ~^Medium~x        | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Arch Linux~x        | ~%Very High~x     | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Artix Linux~x       | ~!Low~x           | ~%None~x     | ~^Unmaintained~x | ~!None~x     |
| ~+CentOS~x            | ~!Very Low~x      | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Clear Linux~x       | ~!Very Low~x      | ~!Many issues~x [†](https://github.com/bedrocklinux/bedrocklinux-userland/issues/124) | ~^Unmaintained~x | ~!N/A~x |
| ~+CRUX~x              | ~!None~x          | ~!BSD-style SysV init~x [†](feature-compatibility.html#bsd-style-sysv) | ~^Unmaintained~x | ~!N/A~x |
| ~+Debian~x            | ~%Very High~x     | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Devuan~x            | ~^Low~x           | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Elementary OS~x     | ~!Very Low~x      | ~%None~x     | ~!No~x           | ~!None~x     |
| ~+Exherbo~x           | ~^Medium~x        | ~%None~x     | ~%Yes~x          | ~%Wulf C. Krueger~x |
| ~+Fedora~x            | ~^Medium~x        | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Fedora Silverblue~x | ~!None~x          | ~!Read-only root~x [†](#silverblue) | ~!No~x | ~!None~x |
| ~+Gentoo Linux~x      | ~%High~x          | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+GoboLinux~x         | ~!None~x          | ~%None~x     | ~!No~x           | ~!None~x     |
| ~+GuixSD~x            | ~!None~x          | ~%None~x     | ~!No~x           | ~!None~x     |
| ~+KISS~x              | ~!Very Low~x      | ~!Escapes restriction~x [†](#kiss) | ~^Unmaintained~x | ~!None~x |
| ~+Linux Mint~x        | ~^Low~x           | ~%None~x     | ~!No~x           | ~!None~x     |
| ~+Manjaro~x           | ~!Very Low~x      | ~!pamac/octopi~x [†](feature-compatibility.html#pamac) | ~^Unmaintained~x | ~!None~x |
| ~+MX Linux~x          | ~!None~x          | ~!systemd-shim~x [†](feature-compatibility.html#systemd-shim) | ~!No~x | ~!None~x |
| ~+NixOS~x             | ~!Very Low~x      | ~!many~x [†](#nixos) | ~!No~x   | ~!None~x     |
| ~+OpenSUSE~x          | ~!Very Low~x      | ~!defaults to grub+btrfs~x [†](feature-compatibility.html#grub-btrfs-zfs) | ~!No~x | ~!None~x |
| ~+OpenWRT~x           | ~!Very Low~x      | ~%None~x     | ~^Unmaintained~x | ~!None~x     |
| ~+Pop!\_OS~x          | ~^Medium~x        | ~^hidden init menu~x [†](#popos) | ~!No~x | ~!None~x |
| ~+QubesOS~x           | ~!None~x          | ~%None~x     | ~!No~x           | ~!None~x   |
| ~+Raspbian~x          | ~^Medium~x        | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Slackware~x         | ~^Low~x           | ~!BSD-style SysV init~x [†](feature-compatibility.html#bsd-style-sysv) | ~^Unmaintained~x | ~!None~x |
| ~+Solus~x             | ~!Very Low~x      | ~!stateless~x [†](#solus) | ~^Unmaintained~x | ~!None~x |
| ~+Ubuntu~x            | ~%Very High~x     | ~%None~x     | ~%Yes~x          | ~%paradigm~x |
| ~+Void Linux~x        | ~%Very High~x     | ~%None~x     | ~%Yes~x          | ~%paradigm~x |

## {id="nixos"} NixOS

One effort to add `brl fetch` support involved bootstrapping via the
stand-alone `Nix` package manager, which itself was installed via
`https://nixos.org/nix/install`.  However, `Nix` apparently disliked running in
the limited `brl fetch` environment.  This might be related to Nix sandboxing
efforts.  More investigation is needed.

`Nix` requires a runtime daemon.  Proper support for ~+NixOS~x might require `brl
enable` support for pre/post enable hooks to launch the daemon when the
~{stratum~} is ~{enabled~}.

It is unclear if ~+NixOS~x design assumptions will result in it becoming upset at
non-local components, such as `/etc` files, changing out from under it.

## {id="solus"} Solus

~+Solus~x's "stateless" concept means it does not create various files in
`/etc` ~+Bedrock~x expects.  This might be done to avoid fighting with users
over `/etc` file changes.

~+Solus~x _does_ provide default versions of these files, but outside of
`/etc`.  The expectation might be that the user copies them over at his/her
whim.

This is likely removable with adequate effort.  ~+Bedrock~x could be configured
to understand this concept via `bedrock.conf` lists of stateless copy
locations.  If the required file is missing but another location has it,
~+Bedrock~x would then copy it over when ~{enabling~} the ~{stratum~}.

~+Clear Linux~x also calls itself "stateless."  Efforts here should be tested
against ~+Clear~x as well.

## {id="popos"} Pop!\_OS

Users have reported that on EFI systems Pop!\_OS's boot time splash screen
hides the init selection menu.  To make the init selection menu visible, run

	{class="rcmd"} kernelstub -d splash

Ideally things should work without alterations to the bootloader.  Rather than
disabling splash via configuration, the init selection menu should stop it at
runtime to reveal the menu.  This is an open research item.

## {id="kiss"} KISS

KISS Linux's package manager, `kiss`, detects available executables on-the-fly
rather than via its own dependency and package availability management.
Consequently, it must be restricted to avoid accidentally jumping across
strata.  As of 0.7.16, Bedrock's default/recommended configuration restricts
`kiss`.

`kiss` may call `sudo` under-the-hood.  At the time of writing, using `sudo` on
Bedrock escapes restriction, as using `sudo` resets the `$PATH` without
conditionally checking if the new `$PATH` should be restricted or not.  This
may result in Bedrock-specific error messages when using `kiss`.

To properly support KISS Linux, Bedrock's `sudo` restriction escape hole should
be resolved.

## {id="silverblue"} Fedora Silverblue

Fedora Silverblue uses a read-only root by default, which keeps the hijack
installer from being able to do things like extract `/bedrock` onto the root
directory.  Investigation needs to be done to understand the ramifications of
simply remounting the root directory read-write for the duration of the
install.  Silverblue's non-traditional nature will likely raise other issues as
well.
