Title: Bedrock Linux
Nav:   home.nav

Bedrock Linux
=============

Bedrock Linux is a meta Linux distribution which allows users to utilize
features from other, typically mutually exclusive distributions.  Essentially,
users can mix-and-match components as desired.  For example, one could have:

- The bulk of the system from an old/stable distribution such as CentOS or Debian.
- Access to cutting-edge packages from Arch Linux.
- Access to Arch's AUR.
- The ability to automate compiling packages with Gentoo's portage
- Library compatibility with Ubuntu, such as for desktop-oriented proprietary software.
- Library compatibility with CentOS, such as for workstation/server oriented proprietary software.

All at the same time, all working together like one, largely cohesive operating system.

A new video demonstrating such features as of the newly released Bedrock Linux
0.7 Poki is currently in development and will be listed here in the future.

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

## {id="0.7.9-released"} Bedrock Linux 0.7.9 released
<small>2019-09-20</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

This fixes a bug in 0.7.8 update code which may break crossfs access.

## {id="0.7.8-released"} Bedrock Linux 0.7.8 released
<small>2019-09-15</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added LVM support
- Added brl-fetch Arch Linux 32
- Added brl-fetch Exherbo
- Added caching support
- Added debug subsystem
	- Add etcfs debug support
	- Add brl-fetch debug support
- Added i386, i486, i586, and i686 support
- Added wait for keyboard initialisation
	- This fixed no keyboard in init selection menu issue
- Fixed brl-fetch exherbo
- Fixed crossfs handling of live bouncer changes
- Fixed etcfs file descriptor leak
	- This fixed Void init emergence shell issue
- Improved build system performance
- Restrict apt-key by default
- Restrict debuild by default

## {id="tipping"} On Tipping Bedrock Linux Developer
<small>2019-09-03</small>

There have been repeated requests for avenues to tip the lead Bedrock Linux
developer.

Bedrock Linux development is not limited by funding, and there is no intended
obligation associated with benefiting from Bedrock Linux development efforts.

If you are interested in tipping the lead developer as a thanks for his
efforts, see [here](tipping.html).

## {id="0.7.7-released"} Bedrock Linux 0.7.7 released
<small>2019-08-27</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added brl-fetch KISS Linux support
- Added brl-report check for environment variables
- Added brl-update support for verifying signature of offline updates
- Added brl-update support scanning multiple configured mirrors
- Added init message about bedrock.conf
- Added installer check for corrupt embedded tarball
- Added installer check for grub2-mkrelpath bug
- Added installer message about bedrock.conf
- Added official installer/update binaries for ppc64le
- Fixed brl-fetch arch
- Fixed brl-fetch fedora
- Fixed brl-fetch mirrors with paths in http indexes
- Fixed brl-fetch non-native void
- Fixed brl-fetch solus
- Fixed installer handling of quotes in distro name
- Fixed login.defs handling bug
- Fixed resolv.conf handling for some distros
- Fixed various shell tab completion issues
- Improved etcfs robustness to power outages
- Removed /var/tmp from share list
- Update expiration date of signing key
- Various minor fixes and improvements.

## {id="beta-channel"} Bedrock Linux beta channel available
<small>2019-08-20</small>

Bedrock Linux now offers a beta channel for those who are interested in helping
to test upcoming updates and are willing to take the associated elevated risk.
[See the documentation here.](0.7/beta-channel.html)

Future beta updates will not necessarily be announced.

## {id="0.7.6-released"} Bedrock Linux 0.7.6 released
<small>2019-05-11</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Added experimental non-native CPU architecture strata support.
	- Requires `qemu-user-static`.
- Added experimental non-native CPU capabilities to brl-fetch.
	- See new `-a` and `-A` flags in `brl fetch --help`.
- Added official installer/update binaries for additional CPU architectures.
- Fixed Firefox font handling issue.  Work-around is no longer needed.
- Various minor fixes and improvements.

## {id="0.7.5-released"} Bedrock Linux 0.7.5 released
<small>2019-04-28</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

This is a fix for an issue found 0.7.4's handling of sandboxed software whose
local files do not map directly to those of any particular stratum.  Most
notably, this fixes crashes in Chromium.

## {id="0.7.4-blocked"} Bedrock Linux 0.7.4 blocked
<small>2019-04-28</small>

The Bedrock Linux 0.7.4 update was found to cause Chromium to crash.  The update has been temporarily pulled while the issue is being investigated.

There are no known security or data-loss concerns with any 0.7.X release at this time.

## {id="0.7.4-released"} Bedrock Linux 0.7.4 released
<small>2019-04-28</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.  [See the release notes here](https://github.com/bedrocklinux/bedrocklinux-userland/blob/0.7/ReleaseNotes.md#074).

## {id="0.7.3-released"} Bedrock Linux 0.7.3 released
<small>2019-04-14</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.  [See the release notes here](https://github.com/bedrocklinux/bedrocklinux-userland/blob/0.7/ReleaseNotes.md#073).

## {id="distrowatch"} Bedrock Linux now listed on DistroWatch
<small>2019-04-08</small>

Bedrock Linux was submitted to DistroWatch on 2012-08-04, almost seven years
ago.  DistroWatch had (understandable) requirements Bedrock failed to meet
until very recently.  It is now listed
[here](https://distrowatch.com/table.php?distribution=bedrock).

[See older news items](news.html)
