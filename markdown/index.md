Title: Bedrock Linux
Nav:   home.nav

Bedrock Linux
=============

## {id="0.7.22-released"} Bedrock Linux 0.7.22 released
<small>2021-07-28</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added code to handle errant program clearing modules.dep
- Fixed brl-fetch debian for bullseye
- Fixed hijacked GRUB theme handling
- Fixed resolv.conf on some distros

~+Bedrock Linux~x is a meta Linux distribution which allows users to
mix-and-match components from other, typically incompatible distributions.
~+Bedrock~x integrates these components into one largely cohesive system.

For example, one could have:

- ~+Debian~x's stable coreutils
- ~+Arch~x's cutting edge kernel
- ~+Void~x's runit init system
- A pdf reader with custom patches automatically maintained by ~+Gentoo~x's portage
- A font from ~+Arch~x's AUR
- Games running against ~+Ubuntu~x's libraries
- Business software running against ~+CentOS~x's libraries

All at the same time and working together mostly as though they were packaged
for the same distribution.

## {id="zstd-modules"} PSA on new kernels, zstd, and inits
<small>2021-07-26</small>

Some distros are now distributing Linux kernels with zstd-compressed modules.
For everything to work, these must be paired with inits (more specifically
device managers such as udev) from distros which also support this
functionality.  A zstd kernel, such as from Arch, paired with a pre-zstd
init/udev, such as from Debian, may result in apparent hardware issues as
modules fail to dynamically load.

## {id="0.7.21-released"} Bedrock Linux 0.7.21 released
<small>2021-07-19</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

Some distros are now compressing their kernel modules with zstd.  Bedrock users
are encouraged to update to at least this Bedrock release before booting into
such a kernel.

- Added automatic restriction of cmake, dkms
- Added brl-fetch alma
- Added brl-fetch artix-s6
- Added brl-fetch rocky
- Added pmm upgrade-packages*,remove-orphans operations
- Added zstd support to modprobe
- Fixed Gentoo/portage attempting to write to /bedrock/cross/info
- Fixed booting with s6 breaking Bedrock's /run setup
- Fixed brl-fetch artix
- Fixed brl-fetch debian
- Fixed brl-fetch ubuntu

## {id="0.7.20-released"} Bedrock Linux 0.7.20 released
<small>2021-05-16</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

This includes a work around for the aforementioned Linux 5.12.3 FUSE bug.

- Added brl-import command
- Fixed brl-fetch centos
- Fixed brl-fetch localegen logic issue in some situations
- Fixed brl-fetch solus
- Fixed various pmm issues
- Improved brl SSL handling portability
- Worked around Linux kernel FUSE atomic write bug

## {id="avoid-linux-5.12.3"} Apparent FUSE bug in Linux 5.12.3 and up
<small>2021-05-14</small>

Update: Bedrock 0.7.20 resolves the concern described below

The aforementioned Arch Linux kernel issue was traced to a narrow window of
Linux kernel commits.  This cannot be cleanly worked around in Bedrock's code.
Bedrock Linux users should avoid Linux 5.12.3 and up from all distros until a
kernel fix is in place.

[See older news items](news.html)
