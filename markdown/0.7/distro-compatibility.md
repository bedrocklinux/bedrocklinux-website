Title: Bedrock Linux 0.7 Poki Distro Support
Nav: poki.nav

# Bedrock Linux 0.7 Poki Distro Compatibility

| Linux Distro     | Community Usage/Reports | Known Issues | Fetch Support  | Maintainer |
| ~+Alpine Linux   | ~^Low                   | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Arch Linux     | ~%Very High             | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Artix Linux    | ~!Very Low              | ~%N/A        | ~^Unmaintained | ~!N/A      |
| ~+CentOS         | ~!Very Low              | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Clear Linux    | ~!Very Low              | ~!Many issues [†](https://github.com/bedrocklinux/bedrocklinux-userland/issues/124) | ~^Unmaintained | ~!N/A |
| ~+CRUX           | ~!None                  | ~!BSD-style SysV init [†](feature-compatibility.html#bsd-style-sysv) | ~^Unmaintained | ~!N/A |
| ~+Debian         | ~%Very High             | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Devuan         | ~^Low                   | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Elementary OS  | ~!Very Low              | ~%N/A        | ~!No           | ~!N/A      |
| ~+Exherbo        | ~^Medium                | ~%N/A        | ~%Yes          | ~%Wulf C. Krueger |
| ~+Fedora         | ~^Medium                | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Gentoo Linux   | ~%High                  | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+GoboLinux      | ~!None                  | ~%N/A        | ~!No           | ~!N/A      |
| ~+GuixSD         | ~!None                  | ~%N/A        | ~!No           | ~!N/A      |
| ~+KISS           | ~!Very Low              | ~%N/A        | ~^Unmaintained | ~!N/A      |
| ~+Linux Mint     | ~^Low                   | ~%N/A        | ~!No           | ~!N/A      |
| ~+Manjaro        | ~!Very Low              | ~!pamac/octopi [†](feature-compatibility.html#pamac) | ~^Unmaintained | ~!N/A |
| ~+MX Linux       | ~!None                  | ~!systemd-shim [†](feature-compatibility.html#systemd-shim) | ~!No | ~!N/A |
| ~+NixOS          | ~!Very Low              | ~!many [†](#nixos) | ~!No    | ~!N/A      |
| ~+OpenSUSE       | ~!Very Low              | ~!defaults to grub+btrfs [†](feature-compatibility.html#grub-btrfs-zfs) | ~!No    | ~!N/A      |
| ~+OpenWRT        | ~!Very Low              | ~%N/A        | ~^Unmaintained | ~!N/A      |
| ~+Pop!\_OS       | ~^Low                   | ~^hidden init menu [†](#popos) | ~!No           | ~!N/A      |
| ~+QubesOS        | ~!None                  | ~%N/A        | ~!No           | ~!N/A      |
| ~+Raspbian       | ~!Medium                | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Slackware      | ~^Low                   | ~!BSD-style SysV init [†](feature-compatibility.html#bsd-style-sysv) | ~^Unmaintained | ~!N/A |
| ~+Solus          | ~!Very Low              | ~!stateless [†](#solus) | ~^Unmaintained | ~!N/A |
| ~+Ubuntu         | ~%Very High             | ~%N/A        | ~%Yes          | ~%paradigm |
| ~+Void Linux     | ~%Very High             | ~%N/A        | ~%Yes          | ~%paradigm |

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
