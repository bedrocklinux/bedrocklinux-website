Title: Bedrock Linux
Nav:   home.nav

Bedrock Linux
=============

~+Bedrock Linux~x lets users manage their own distro-blend on their computers, usually by mixing-in components packaged by readily existing linux distributions.
* Runs a linux system that gets assembled from multiple filesystem roots.
* Integrates typically incompatible components into one largely cohesive system.

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

## {id="naga-plans"} Bedrock Linux 0.8 Naga development started
<small>2020-10-20</small>

Development effort has shifted from improving 0.7 Poki toward a new major
release, 0.8 Naga.  Poki will continue to be maintain with small bug fixes and
`brl fetch` updates.  However, new features are unlikely or broad compatibility
improvements are unlikely until Naga's release.

Naga's tentative design plans can be found [here](0.8/plans.html).

## {id="0.7.19-released"} Bedrock Linux 0.7.19 released
<small>2020-11-10</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Add more global /etc items
- Fix brl-fetch localegen logic issue in some situations
- Improve brl-fetch `/etc/ssl` handling (fixes `brl fetch arch` for some users)
- Improve non-local cwd handling in brl code

## {id="0.7.18-released"} Bedrock Linux 0.7.18 released
<small>2020-10-20</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added automatic restriction of CRUX's prt-get, pkgmk
- Added code to load modules on init to help with keyboard detection
- Added crossfs support for wayland-sessions
- Added envvar crossfs settings
- Added more setfattr hijack sanity checks
- Added pmm support for dnf short aliases
- Added retention of BEDROCK_RESTRICTION across sudo call
- Added themes, backgrounds to crossfs defaults
- Fixed /bedrock/cross/bin/X11 self-reference loop
- Fixed brl fetch --list tab completion comment
- Fixed brl priority color handling when brl colors are disabled
- Fixed brl-fetch Alpine
- Fixed brl-fetch Fedora
- Fixed brl-fetch Gentoo
- Fixed brl-fetch KISS
- Fixed brl-fetch centos
- Fixed brl-fetch devuan detection of stable release
- Fixed brl-fetch manjaro
- Fixed brl-strat completion
- Fixed detection of package manager user interface at hijack
- Fixed fish envvar handling
- Fixed overwriting system and user-set PATH entries
- Fixed pmm creation of redundant items when superseding
- Fixed pmm support for pacman,yay search-for-package-by-name
- Fixed pmm support for portage which-packages-provide-file
- Fixed pmm using supersede logic when unneeded
- Fixed portage is-file-db-available noise
- Fixed restriction of XDG_DATA_DIRS
- Fixed zprofile restriction check
- Improved brl-fetch handling of different ssl standards
- Improved brl-fetch locale-gen failure handling
- Improved brl-fetch void to use smaller base-minimal
- Improved crossfs multithread performance if openat2 available (Linux 5.6 and up)
- Improved env-var handling
- Improved etcfs debug output
- Improved plymouth handling

## {id="0.7.17-released"} Bedrock Linux 0.7.17 released
<small>2020-04-30</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Fix sudoers injection return value

## {id="0.7.16-released"} Bedrock Linux 0.7.16 released
<small>2020-04-29</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Add cross-stratum /etc/crypttab support
- Add cross-stratum /etc/profile.d/*.sh support
- Add cross-stratum dkms support
- Fix brl-fetch fedora, void, void-musl
- Improve brl-fetch error messages
- Improve pmm pacman/yay handling to only supersede identical commands
- Restrict kiss package manager

## {id="0.7.15-released"} Bedrock Linux 0.7.15 released
<small>2020-04-16</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Add pmm to brl-tutorial
- Fix brl-tutorial typo
- Fix pmm apt no-cache package availability check

## {id="0.7.14-released"} Bedrock Linux 0.7.14 released
<small>2020-04-14</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Add ppc and ppc64 support
- Add Package Manager Manager ("pmm")
- Add code to recover from bad bedrock.conf timezone values
- Add sanity check against GRUB+BTRFS/ZFS issue
- Fix Path and TryExec handling in crossfs ini filter
- Fix brl-fetch centos, kiss, void, void-musl, and debian sid

## {id="0.7.13-released"} Bedrock Linux 0.7.13 released
<small>2020-01-06</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Fixed brl-fetch arch
- Fixed brl-fetch kiss

## {id="0.7.12-released"} Bedrock Linux 0.7.12 released
<small>2019-12-16</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Fixed brl-fetch artix
- Fixed bash completion for brl-tutorial

## {id="0.7.11-released"} Bedrock Linux 0.7.11 released
<small>2019-12-14</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added brl-tutorial command
- Added basics tutorial
- Added brl-fetch tutorial
- Added brl-fetch support for Fedora 31
- Added brl-fetch support for Manjaro
- Fixed brl-fetch debug handling
- Fixed brl-disable handling of invalid stratum

## {id="0.7.10-released"} Bedrock Linux 0.7.10 released
<small>2019-10-21</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Add Artix fetch support
- Add brl-fetch CentOS support for CentOS 8 and 8-stream
- Fix brl-fetch debian, devuan, raspbian and ubuntu libapt-pkg.so warning
- Fix ubuntu default release detection considering "devel" a release
- Improve hijack warning to better explain what it will do

[See older news items](news.html)
