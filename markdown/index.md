Title: Bedrock Linux
Nav:   home.nav

Bedrock Linux
=============

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

## {id="0.7.28-released"} Bedrock Linux 0.7.28 released
<small>2022-08-11</small>

- Improved brl-fetch handling of GPT and multi-partition images
- Removed redundant Ubuntu vt.handoff hack handling
- Fixed brl-fetch arch, artix, gentoo, exherbo

## {id="0.7.27-released"} Bedrock Linux 0.7.27 released
<small>2022-03-02</small>

- Fixed brl-fetch arch

## {id="0.7.26-released"} Bedrock Linux 0.7.26 released
<small>2022-01-21</small>

- Fixed GRUB+BTRFS check false-positives.

## {id="0.7.25-released"} Bedrock Linux 0.7.25 released
<small>2022-01-10</small>

- Fixed brl-fetch centos
- Fixed brl-fetch fedora
- Fixed brl-fetch gentoo
- Improved brl-fetch error message
- Improved systemd 250 shutdown performance
- Increased hijack-time GRUB+BTRFS detection sensitivity

## {id="0.7.24-released"} Bedrock Linux 0.7.24 released
<small>2021-11-16</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added pmm zsh completion
- Fixed brl zsh completion
- Fixed brl-fetch centos
- Fixed brl-fetch fedora locale
- Fixed brl-fetch ubuntu
- Fixed resolve.conf handling with some distros/inits
- Improved theoretical robustness of init selection menu

## {id="0.7.23-released"} Bedrock Linux 0.7.23 released
<small>2021-08-26</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Add support for s6
- Security updates for openssl

## {id="0.7.22-released"} Bedrock Linux 0.7.22 released
<small>2021-07-28</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added code to handle errant program clearing modules.dep
- Fixed brl-fetch debian for bullseye
- Fixed hijacked GRUB theme handling
- Fixed resolv.conf on some distros

## {id="zstd-modules"} PSA on new kernels, zstd, and inits
<small>2021-07-26</small>

Some distros are now distributing Linux kernels with zstd-compressed modules.
For everything to work, these must be paired with inits (more specifically
device managers such as udev) from distros which also support this
functionality.  A zstd kernel, such as from Arch, paired with a pre-zstd
init/udev, such as from Debian, may result in apparent hardware issues as
modules fail to dynamically load.
