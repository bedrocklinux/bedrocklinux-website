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
