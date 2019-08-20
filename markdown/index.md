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
