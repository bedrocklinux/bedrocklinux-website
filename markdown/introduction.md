Title: Introduction to Bedrock Linux
Nav: home.nav

Introduction to Bedrock Linux
=============================

- [Search for the Perfect Linux Distribution](#search)
  - [What Bedrock Linux Does](#what_bedrock_does)
- [Real-World Examples of where Bedrock Linux Shines](#real_world)
- [How Bedrock Linux Works](#how_bedrock_works)
  - [Chroot](#chroot)

## {id="search"} Search for the Perfect Linux Distribution

So you've decided to give this Linux thing a try. Which Linux distribution
should you choose? Do you want...

- Something extremely stable, such as Debian or a Red Hat Enterprise Linux clone?
- Something cutting-edge, such as Arch, Debian Sid, or Fedora Rawhide?
- Something extremely customizable, such as Gentoo or LinuxFromScratch?
- Something minimal, such as Tinycore or SliTaz?
- Something user-friendly, such as Mint?
- Something popular with lots of software developed with it in mind, such as Ubuntu?

Which features are important, and which are you willing to give up? If you want
<small>(almost<sup>1</sup>)</small> everything - stable and cutting edge,
customizable and minimal, with access to popular-distro-only packages - Bedrock
Linux is the Linux distribution for you.

<small><sup>1</sup>Well, everything except for user-friendly. At the moment,
Bedrock Linux can not honestly be considered "user-friendly."</small>

### {id="what_bedrock_does"} What Bedrock Linux Does

Bedrock Linux uniquely manipulates the filesytem and PATH to allow software
from various other Linux distributions to coexist as though they were all from
the same single, cohesive Linux distribution.  With Bedrock Linux, for example,
one could have an RSS feed reader from Arch Linux's AUR open a webpage in a web
browser from Ubuntu's repos while both of them are running in an X11 server
from Fedora.  Moreover, this interactions feels as though all of the packages
were from the same repository; for day-to-day activity, Bedrock Linux feels
like any other Linux distribution.  The typical concerns for things such as
library conflicts are a non-issue with Bedrock Linux's design - if there is a
package out there for a Linux distribution on your CPU architecture, it will
most likely work with Bedrock Linux.

### {id="bedrock_only"} Bedrock-Only Features

In addition to doing <small>(almost)</small> anything any other Linux
distribution can do, there are a number of things Bedrock Linux can do which no
other distribution can.

- You can do a distro-upgrade (Debian 5 to 6, Ubuntu 12.04 to 12.10, etc),
  *live, with almost no downtime*. No need to stop your apache server, reboot,
  configure things while the server is down, etc.
- If a distro-upgrade breaks anything, no problem - the old release's program
  and settings can still be there, ready to go to pick up what it was doing
  before the distro-upgrade broke anything.
- Minimal stress from any given package failing to work - just use one from
  another Linux distribution. Packages feel disposable, like toothpicks. No
  need to fret over one breaking; just use another.

## {id="real_world"} Real-World Examples of where Bedrock Linux Shines

These are all examples of real-world situations which came up while Bedrock
Linux was in development which showed quite clearly Bedrock's strength.

- When Quake Live's Linux release came out, there was a bug which only seemed
  to manifest itself against Debian's X11. The development team most likely
  tested against Ubuntu, and so the situation was resolved by using Ubuntu's
  X11 (and only that from Ubuntu, with the majority of the rest of the system
  remained Debian). Just as Debian was too old for Quake Live at its release,
  Arch Linux users later faced the flip side of that coin: their cutting-edge
  libraries were causing issues with Quake Live. One way this was resolved was
  to play with `LD_PRELOAD`. Bedrock Linux users, however, could continue using
  Arch Linux's cutting-edge packages and use Quake Live without having to touch
  `LD_PRELOAD`.
- With only a few days to go before presenting Compiz at a local Free/Open
  Source Software enthusiast club, the presenter found Debian's video drivers
  for his laptop were overly old to support the 3D acceleration needed for
  Compiz. While Arch Linux's X11 video drivers were new enough, its Compiz
  package did not work at the time. Bedrock Linux allowed for a quick and easy
  solution: use Arch Linux's X11 with Debian's Compiz. 
- Arch Linux is one of the few Linux distributions with the mathematics program
  Sage available in its repository. However, for a period of time Sage was
  dropped from the repository due to compatibility issues with Arch Linux. Sage
  is only pre-packaged for and tested against a handful of Linux distributions,
  one of which is Ubuntu. Thus, when Sage mathematics was dropped for a period
  of time from the Arch Linux repository, all Bedrock Linux users had to do was
  to download it for Ubuntu. When it was returned, it was trivial to again get
  it from the Arch Linux repository. Arch Linux temporarily lost access to
  Sage, and Ubuntu users never benefited having Sage in a repository.

## {id="how_bedrock_works"} How Bedrock Linux Works

Bedrock's magic is based around filesystem and PATH manipulation.

### {id="chroot"} Chroot

A *chroot* changes the apparent filesystem layout from the point of view of
programs running within it. Specifically, it makes a chosen directory appear to
be the root of the filesystem. Think of it as prepending a given string to the
beginning of every filesystem call. For example:
