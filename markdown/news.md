Title: Bedrock Linux: News Archive
Nav: home.nav

News Archive
============

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

## {id="arch-kernel-missing-crossfs"} Arch Linux kernel results in missing crossfs entries
<small>2021-05-14</small>

Update: Bedrock 0.7.20 resolves the concern described below

The latest Arch Linux kernel, 5.12.3, appears to break Bedrock Linux.  The
symptoms appear to be missing `/bedrock/cross` entries.  The issue is currently
being investigated.  For the time being, consider avoiding this kernel; either
[use an older Arch Linux
kernel](https://wiki.archlinux.org/title/Downgrading_packages), or get your
kernel from another distro.

## {id="0.7.19-released"} Bedrock Linux 0.7.19 released
<small>2020-11-10</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.

- Add more global /etc items
- Fix brl-fetch localegen logic issue in some situations
- Improve brl-fetch `/etc/ssl` handling (fixes `brl fetch arch` for some users)
- Improve non-local cwd handling in brl code

## {id="naga-plans"} Bedrock Linux 0.8 Naga development started
<small>2020-10-20</small>

Development effort has shifted from improving 0.7 Poki toward a new major
release, 0.8 Naga.  Poki will continue to be maintain with small bug fixes and
`brl fetch` updates.  However, new features are unlikely or broad compatibility
improvements are unlikely until Naga's release.

Naga's tentative design plans can be found [here](0.8/plans.html).

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

Bedrock Linux now offers a beta channel for those who are interested in testing
upcoming updates.  [See the documentation here.](0.7/beta-channel.html)

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

## {id="0.7.2-released"} Bedrock Linux 0.7.2 released
<small>2019-03-27</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.  [See the release notes here](https://github.com/bedrocklinux/bedrocklinux-userland/blob/0.7/ReleaseNotes.md#072).

## {id="0.7.1-released"} Bedrock Linux 0.7.1 released
<small>2018-12-27</small>

A point update has been released for 0.7.  To update to it, run `{class="rcmd"} brl update` as root.  [See the release notes here](https://github.com/bedrocklinux/bedrocklinux-userland/blob/0.7/ReleaseNotes.md#071).

## {id="poki-released"} Bedrock Linux 0.7 Poki released
<small>2018-12-17</small>

Bedrock Linux 0.7 Poki has exited beta and is ready for general consumption.
See [here](0.7/index.html) for the release's documentation.

## {id="poki-public-beta"} Poki public beta testing
<small>2018-11-05</small>

Pre-release builds of Bedrock Linux 0.7 Poki are now available for testing.
See [here](0.7/beta-test.html) for further details.  If you have the time and
resources, assistance testing would be appreciated.

## {id="poki-feature-complete"} Poki feature complete, undergoing internal testing
<small>2018-09-29</small>

An internal build of the upcoming Bedrock Linux release is now feature
complete.  Internal testing and bug fixing is now underway.

A release candidate is expected to be made public sometime in October or
November for further testing.  Any assistance testing at that time will be
greatly appreciated.  The proper release will follow, likely before the end of
2018.

## {id="poki-progress-2018-05"} May 2018 Poki Progress Update
<small>2018-05-05</small>

Given the relatively long release cycle, it seems prudent to provide an
occasional progress update.  Poki's development progress, updated 2018-05-05,
can be found [here](1.0beta3/progress.html).  While a substantial amount of
work has been done, much is left to do before the release is ready.

## {id="status-2017"} Project status as of the end of 2017
<small>2017-12-10</small>

Development over the past year and a half has been very slow due to unrelated
priorities consuming Bedrock Linux development time.  These priorities are
largely passed, and development should restart in earnest within the first
half of 2018.

There has been a fair bit of research towards the upcoming 1.0beta3 Poki
release before the development stagnation.  However, there is still some
research left to do, as well as a lot of time consuming development and
testing, and so it is unlikely that Poki will be released any time soon.  It is
unclear at this time if the increased scope for Poki mentioned in the last news
item will remain in place, or if it will be scoped back to hit an earlier
release date.

Apologies for the delay.  Hang in there, we want the next release at least as
much as you do.

## {id="poki-scope-increase"} Increase in scope for upcoming Bedrock Linux 1.0beta3 Poki
<small>2017-01-14</small>

The current Bedrock Linux release, 1.0beta2 Nyla, saw a substantial increase in
community feedback.  Given the focus on accessibility of the upcoming 1.0beta3
Poki release it is likely to see an even greater increase in user base.  It is
desirable to clear the backlog of smaller issues and toughen up the project
infrastructure before this projected uptick.  While the major features planned
on the roadmap are retained as the key goals, additional work will be put in to
clean up the code base, add tests, and rework the build system, amongst other
improvements.  This will likely push back the upcoming release but will help
ensure the upcoming increased attention is manageable.

## {id="status-2017"} Project status as of the end of 2017
<small>2017-12-10</small>

Development over the past year and a half has been very slow due to unrelated
priorities consuming Bedrock Linux development time.  These priorities are
largely passed, and development should restart in earnest within the first
half of 2018.

There has been a fair bit of research towards the upcoming 1.0beta3 Poki
release before the development stagnation.  However, there is still some
research left to do and a lot of time consuming development, and so it is
unlikely that Poki will be released any time soon.  It is unclear at this time
if the increased scope for Poki mentioned in the last news item will remain in
place, or if it will be scoped back to hit an earlier release date.

Apologies for the delay.  Hang in there, we want the next release at least as
much as you do.

## {id="reddit-ama"} Bedrock Linux AMA on /r/AskLinuxUsers
<small>2016-05-21</small>

/u/ParadigmComplex represented Bedrock Linux during an "Ask Me Anything"
("AMA") session at
[http://reddit.com/r/AskLinuxUsers](http://reddit.com/r/AskLinuxUsers).  The session is now over, and the resulting discussion can be found [here](https://www.reddit.com/r/AskLinuxUsers/comments/4ke9ss/i_am_the_founder_and_lead_developer_of_bedrock/).

## {id="forums"} Bedrock Linux forum hosted on LinuxQuestions.org
<small>2016-03-01</small>

Bedrock Linux now has a forum available on linuxquestions.org at:

[http://www.linuxquestions.org/questions/bedrock-linux-118/](http://www.linuxquestions.org/questions/bedrock-linux-118/)

## {id="nyla-plans"} Bedrock Linux 1.0beta3 Poki Plans, project roadmap
<small>2016-01-23</small>

The design plans for the upcoming release of Bedrock Linux, 1.0beta3 Poki, are
available [here](1.0beta3/plans.html).

A rough roadmap for Bedrock Linux is available [here](roadmap.html).

## {id="nyla-release"} Bedrock Linux 1.0beta2 Nyla released
<small>2016-01-16</small>

The second beta of Bedrock linux, 1.0beta2 Nyla, has been released.  See the
[major features](1.0beta2/features.html), the [high-level
changelog](1.0beta2/changelog.html), and either the [full installation
instructions](1.0beta2/install.html) or, if you'd like to expedite the install
process, the [quickstart installation instructions](1.0beta2/quickstart.html).

## {id="nyla-release-soon"} Bedrock Linux 1.0beta2 Nyla in final development stages
<small>2015-10-03</small>

All major features and changes for Bedrock Linux 1.0beta2 Nyla are complete; it
is currently undergoing final testing and bug squashing.  The release should be
soon.

## {id="nyla-delay"} Bedrock Linux 1.0beta2 Nyla delayed
<small>2015-02-22</small>

A large number of complications have arisen since Nyla's original release date
was set, including the numerous hardware failures.  Moreover, while working on
Nyla many of the required changes have been found to require much more time to
implement than previously expected.  Thus, Nyla's release is being delayed.
The new tentative release date is end-of-summer 2015.

## {id="colug-slides"} Columbus Linux User Group presentation
<small>2014-11-20</small>

Slides from a presentation on Bedrock Linux to the Columbus Linux User Group on
2014-11-19 are available [here](media/bedrocklinux-colug.pdf).

## {id="nyla-plans"} Bedrock Linux 1.0beta2 Nyla Plans
<small>2014-06-28</small>

The design plans for the upcoming release of Bedrock Linux, 1.0beta2 Nyla, are
available [here](1.0beta2/plans.html).

## {id="hawky-release"} Bedrock Linux 1.0beta1 Hawky Released
<small>2014-06-17</small>

The first beta of Bedrock Linux, 1.0beta1 Hawky, has been released.
See a demonstration video [here](https://www.youtube.com/watch?v=YOXGE_oV4XU),
the high-level changelog [here](1.0beta1/changelog.html) and the installation
instructions [here](1.0beta1/install.html).

## {id="hawky-plans"} Bedrock Linux 1.0beta1 Hawky Plans and release date.
<small>2014-06-11</small>

The plans for Bedrock Linux 1.0beta1 Hawky are available
[here](http://bedrocklinux.org/1.0beta1/plans.html).  This release is planned
for July 1st, 2014.

## {id="las\_and\_lup"} Bedrock Linux on Linux Action Show, Linux Unplugged
<small>2014-06-11</small>

Bedrock Linux was discussed on [Linux Action Show
Episode 316](http://www.jupiterbroadcasting.com/59352/introducing-bedrock-linux-las-316/)
(starting at forty minutes in).  The Bedrock Linux found/lead developer was then interviewed on [Linux Unplugged Episode 44](http://www.jupiterbroadcasting.com/59617/bedrock-a-new-paradigm-lup-44/) (starting at 8 minutes 30 seconds in).

## {id="github-issues"} Repos and issues moved
<small>2014-05-21</small>

The public/centralized Bedrock Linux repositories were moved from
[http://github.com/paradigm](http://github.com/paradigm)
to
[http://github.com/bedrocklinux](http://github.com/bedrocklinux)
.  The Bedrock Linux issue trackers migrated over to GitHub's issue tracker as
well.

## {id="invite-only"} Bedrock OS Invite-only beta (April Fools 2014)
<small>2014-04-01</small>

*Below is a April Fools 2014 joke -- no closed beta, code has no use*

The Bedrock OS project has entered an invite-only beta.  This comes with
numerous new features and functionality, including:

- Support for FreeBSD and Android
- 80% of the code has been formally verified (planning on verifying the rest
  before release)
- Core utilities have been rewritten in Haskell
- New QT5-based GUI UX
- Switched to a systemd-based init

The first 50 IP addresses to reach this website should see an invite code
below:

    c135e9caef83e81f8c246229a7e371cac580f273
    
*Above is a April Fools 2014 joke -- no closed beta, code has no use*

## {id="early-2014-plans"} Early 2014 plans
<small>2014-01-14</small>

The plan for Bedrock Linux development in the coming months revolves around
functionality which can be added without significant under-the-hood changes to
Bedrock Linux.  Various ideas currently being worked on:

- Additional research on recommended/default client settings.
- Man pages for Bedrock Linux utilities.
- Tab-completion in bash and zsh for Bedrock Linux utilities.
- A replacement for the current brp which will update on-the-fly.
- A new utility, brg ("BedRock Get"), which will be used to easily acquire
  clients.
- A new utility, brm ("BedRock Manual"), which can be used to find a man page.
  available in at least one client, irrelevant of which client provides it.
- A new utility, pmm ("Package Manager Manager"), which will abstract away
  client-specific package management.
- A new utility, iss ("Init System System"), which will abstract away
  individual client init system differences.

## {id="flopsie-release"} Bedrock Linux 1.0alpha4 Flopsie released
<small>2013-12-30</small>

The fourth Bedrock Linux release, 1.0alpha4 Flopsie has been released.
See the high-level changelog [here](1.0alpha4/changelog.html) and the
installation instructions [here](1.0alpha4/install.html)

## {id="olf-2012-video"} Ohio Linuxfest 2012 Presentation Video
<small>2013-10-31</small>

The audio from the Bedrock Linux presentation at the 2012 Ohio Linuxfest was
recorded.  This has been played over the slides and is available to be viewed
as a video [here](https://www.youtube.com/watch?v=7lIWagDFm6c).  The audio
recording can be found [here](https://archive.org/details/BedrockLinux) and the
slides can be found [here](media/bedrocklinux-olf.pdf).

## {id="bosco-backport-bru"} Flopsie feature backported to Bosco
<small>2013-10-13</small>

Flopsie plans discussed [here](http://bedrocklinux.org/1.0alpha4/plans.html)
are showing promising results.  One of the features, the union filesystem intended to fix the /etc-issue, has been backported to Bosco for those who are interested in trying it out before Flopsie is ready.  See [here](http://bedrocklinux.org/1.0alpha3/backports.html) for instructions on how to install the backport.

## {id="flopsie-delay"} Bedrock Linux 1.0alpha4 "Flopsie" delayed, additional features planned
<small>2013-07-17</small>

At this point in time it does not look like Bedrock Linux 1.0alph4 "Flopsie"
will be completed by the previous target date of "end of summer 2013".  The new
target date is January 1st, 2014.

The delay is entirely due entirely to time availability expectations not being
met, and is not the result of any unforeseen technical issues; the plans for
Flopsie still seem viable at this point in time.  The additional time allows
for additional goals for the next release.  In total, expect the following:

 - A fix for the /etc issue
 - Installation scripts; much less manual installation work.
 - Moving to musl as the standard C library for core components.
 - Updates to `brs` to let it setup/teardown clients on-the-fly
 - Updates to `bri` including:
     - the ability to indicate which client is providing a given PID.
     - making `bri -w` and `bri -W` act the same (current difference is confusing)
 - Updates to `brw` (essentially aliasing `bri -w/W` if provided an argument)
 - A script to automate acquiring and setting up (some) client distributions.
 - a new `brp` which:
     - updates the BRPATH on-the-fly (no more manually running `brp`)
     - can force a given executable to always be provided by the same client (out-prioritizing local-to-client executables).
     - can force a given executable to always be provided *only* locally, even if it could be provided to another client.  Good to avoid confusion in some cases (e.g.: local `python` vs shared `python2`)

See the [Flopsie Plans page](1.0alpha4/plans.html) for more details.

## {id="lhs-podcast"} Bedrock on LHS Podcast 107 Now Available
<small>2013-06-30</small>

As was mentioned in the last news item, Bedrock Linux was on two podcasts
recently; however, only one was available online at the time.  The other
podcast is now available online, and can be found here:

http://lhspodcast.info/2013/06/lhs-episode-107-sorry-for-party-bedrocking/

## {id="tllts-podcast"} Bedrock Linux Interviews
<small>2013-05-23</small>

The founder and lead developer of Bedrock Linux was interviewed on not one, but
two Linux podcasts in the last few days:  Linux in the Ham Shack and The Linux
Link Tech Show.  If you would like to listen in, both were recorded.  Linux in
the Ham Shack's podcast is not up yet, but you can listen to TLLTS here:

http://tllts.org/rsspage.php

Look for episode 506 on May 22, 2013.  The discussion veers away from Bedrock
Linux after about the first hour.

Another news item will likely be put up once the Linux in the Ham Shack
interview, episode 107, goes up.

## {id="switch-osx"} Bedrock Switching to OSX (April Fools 2013)
<small>2013-04-01</small>

The April fools joke for 2013:

The primary complaint about the Bedrock OS project throughout its history is
that it is insufficiently user friend.  To quote Jonathan Corbert of Linux
Weekly News:

> [Bedrock Linux] may be especially well suited for those users who have gotten
> frustrated with the way distributions like Gentoo do everything for them.

Clearly, this needs to be remedied.  The Bedrock Linux developers feel very
strong that if you're going to do something, you should do it right, and no
Linux-based operation system has ever gotten the reputation for
user-friendliness that OSX has.  Switching to OSX is a necessity if the Bedrock
OS is ever going to become truly user friendly.

From a technical standpoint it seems quite doable.  The crux of how Bedrock
works under the hood - chroot() - is available on OSX as well.  Apple OSX is
UNIX.  Moreover, work to make things like CUPS or webkit work on Bedrock will
cleanly carry over.

Really, there isn't any downside.  This Linux thing was never going to catch on
anyways.  The upsides, though, are tremendous.  Consider:

- Rosetta - the PowerPC-x86 binary translator for OSX - is not supported on OSX
  as of 10.7 "Lion".  What about those poor people who bought software like
  Diablo 2 for OSX in the PowerPC days?  With Bedrock OSX, they can just use an
  older OSX release that supports Rosetta and play Diablo 2 on their shiny
  newer OSX!

- The latest version of OSX, as of the time of writing, has some applications
  crash when a user enters "FILE:///" into a number of text objects, such as a
  Finder window's search box.  Prior releases of OSX did not have this.  You
  could simply use an older Finder release until this is fixed!

- With Linux, the lack of standardization makes developing Bedrock OS a pain.
  If some obscure distro does things in a way the Bedrock developers are not
  familiar, it might not work out of the box as a client.  OSX, however, has a
  known number of releases.  We just have to support those.  Much easier.
  Bedrock development will likely speed up greatly once the switch has occurred.

However, converting the base project will take about one year.  Expect Bedrock
OSX to be available on April 1st, 2014.

## {id="bosco-update"} Bedrock Linux 1.0alpha3 Bosco update
<small>2013-01-16</small>

Bosco has been updated, fixing various issues.  If you are currently using a
Bosco installation from before 2012-01-16, it is recommended you update.
Download and untar the [userland](1.0alpha3/bedrock-userland-1.0alpha3.tar.gz)
to a temporary directory (such as `/tmp/bosco-update`), and replace the
following files from the core system with those from the userland tarball:

- /etc/init.d/rcS
- /etc/init.d/rcK
- /etc/init.d/rc.local
	- careful not to overwrite any settings you may have placed in here
- /bedrock/bin/brc
	- you'll have to compile the updated brc.c
		- `gcc -Wall brc.c -o /bedrock/brc/brc -static -lcap`
		- `{class="rcmd"} setcap cap_sys_chroot=ep /bedrock/bin/brc`
- /bedrock/sbin/bru

## {id="bosco-release"} Bedrock Linux 1.0alpha3 Bosco released
<small>2012-12-25</small>

The third Bedrock Linux release, 1.0alpha3 Bosco has been released.
See the high-level changelog [here](1.0alpha3/changelog.html)

## {id="linux.com-new-distros"} Bedrock Linux mentioned on linux.com
<small>2012-12-12</small>

Bedrock Linux was mentioned in an [article on
linux.com](https://www.linux.com/news/hardware/desktops/679646-6-linux-distros-born-in-2012/)
about new Linux distributions created in 2012.


## {id="website\_overhaul"} Website Overhaul, includes atom/rss
<small>2012-11-18</small>

Website overhauled.  Huge thanks to [simonlc](http://simon.lc/) for assisting
me with a new website design.  Note that the website now supports atom, and so
if you would like to follow Bedrock Linux development and news feel free to
point your RSS feed reader to "http://bedrocklinux.org/atom.xml".

## {id="bosco\_performance"} Bosco performance boosted; backported to Momo
<small>2012-11-16</small>

Bosco plans discussed [here](http://bedrocklinux.org/1.0alpha3/plans.html) have
been implemented and show a huge real-world performance boost.  This
functionality was backported to Momo for those who are interested in trying it
out before Bosco is ready.  See
[here](http://bedrocklinux.org/1.0alpha2/backports.html) for benchmarks and
instructions on how to install the backport update.

## {id="olf-2012"} Bedrock Linux at Ohio Linux Fest 2012
<small>2012-09-29</small>

Bedrock Linux's founder/lead dev is presenting Bedrock Linux today at [the Ohio
LinuxFest 2012](http://www.ohiolinux.org/talks#BEDROCK).  The slides for the
presentation are available [here](http://bedrocklinux.org/media/bedrocklinux-olf.pdf).

## {id="lwn"} Bedrock Linux is on LWN
<small>2012-09-13</small>

An article on Bedrock Linux is available
[here](http://lwn.net/Articles/515709/); however, it is currently only
available to LWN subscribers.  It will be made freely available to everyone on
September 20th, 2012

## {id="bosco\_plans"} Bosco Plans
<small>2012-09-03</small>

Plans for the upcoming release, 1.0alpha3 Bosco, are now available
[here](http://bedrocklinux.org/1.0alpha3/plans.html).  In summary, the next
release should be simpler and faster.

## {id="new\_domain"} Hosting and domain change
<small>2012-08-18</small>

Bedrock Linux is now at its own domain: bedrocklinux.org

## {id="linux\_action\_show"} Bedrock Linux mentioned on Linux Action Show
<small>2012-08-14</small>

Bedrock Linux is on [the Linux Action Show](
http://www.youtube.com/watch?v=9ca_Tm9cv1g&t=11m15s).  Relevant section goes
from 11:15-16:41.  "One of the most fascinating Linux distributions we've heard
of in years."

## {id="momo\_release"} Bedrock Linux 1.0alpha2 Momo releasd
<small>2012-08-13</small>

The second Bedrock Linux release, 1.0alpha2 "Momo" has been released.
This release primarily addresses issues brought up from the prior release as
well as contributions from others.

## {id="slashdot"} Short video demonstration of Bedrock Linux
<small>2012-08-09</small>

A short video demonstration of Bedrock Linux can be found
[here](http://www.youtube.com/watch?v=MuYMBCcgs98)
## {id="slashdot"} Bedrock Linux on Wired's website
<small>2012-08-05</small>

Bedrock Linux was very briefly mentioned on Wired magazine's website [here](http://www.wired.com/wiredenterprise/elsewhere/bedrock-linux-combines-benefits-of-other-linux-distros-20120805/)

## {id="slashdot"} Bedrock Linux on Slashdot
<small>2012-08-05</small>

Bedrock Linux is on
[Slashdot](http://linux.slashdot.org/story/12/08/05/1211244/bedrock-linux-combines-benefits-of-other-linux-distros).

## {id="momo\_release"} First public Bedrock Linux release out
<small>2012-08-03</small>

The first release of Bedrock Linux, 1.0alpha1 "Appa," is now out.
