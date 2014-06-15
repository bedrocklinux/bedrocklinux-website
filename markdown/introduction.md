Title: Bedrock Linux: Introduction
Nav: home.nav

# Introduction to Bedrock Linux

- [Introduction](#introduction)
	- [What Bedrock Linux Does](#what_bedrock_does)
	- [Additional functionality](#additional_functionality)
- [Real-World Examples of where Bedrock Linux Shines](#real_world)
- [Bedrock Linux Concepts and Terminology](#concepts)
	- [Clients](#clients)
	- [Local and Global files](#local-and-global)
	- [Direct, Implicit and Explicit file eaccess](#direct-implicit-explicit)

## {id="introduction"} Introduction

Linux distributions take software available and, in some sense or another,
prepare it for end-users.  This typically means compiling and packaging it,
however that is not always true; distros such as gentoo prepare source code for
easy and automated compilation by the end user.  This is an extremely useful
service; it would not be practical for everyone to compile and package all of
their software directly from upstream all of the time.

However, the various groups doing this packaging do so with limited focus on
having their packages directly inter-operate with those from other groups.
End-users are forced to choose between the available sets of packages.  Do I
want something stable from a RHEL clone or Debian?  Do I want something
cutting-edge from Arch?  Ubuntu is quite popular and has a lot of software
tested against its libraries - maybe that would be best.  Gentoo's ability to
automate compiling packages with configured settings is also quite desirable.
The list goes on.  Typically, any Linux user would have to chose *one* of the
available distros and either get all of their packages from that distribution
or fall back to taking the distribution developer's job of compiling and
packaging software.

This seems silly - if someone already packaged the specific version of the
specific package desired, why not just use that?  Sadly, there are various
technical reasons one cannot directly install software from one release of one
distribution onto another release of another distribution.  Bedrock Linux aims
to find a technical solution to remove these problems.  On a Bedrock Linux
system, an end user should be able to install most of the software available
from most of the other Linux distributions so that it works just as well as one
would have expected had the package been intended for the distribution.
Bedrock Linux should allow its end-users to get most of his or her system from
something rock solid such as a RHEL clone or Debian, while still retaining
access to cutting-edge packages from Arch and its AUR, library compatibility
with Ubuntu, the ability to leverage Gentoo's portage, and so forth, all at the
same time on the same distribution.


### {id="what\_bedrock\_does"} What Bedrock Linux does

Bedrock Linux manipulates the virtual filesystem such that processes from
different distributions which would typically conflict work with each
other (further details [below](#how_bedrock_works)) can play along.  With this
system, for example, one could have an RSS feed reader from Arch Linux's AUR
open a webpage in a web browser from Ubuntu's repos while both of them are
running in an X11 server from Fedora.  These interactions feels as though all
of the packages were from the same repository; for day-to-day activity, Bedrock
Linux feels like any other Linux distribution.  The typical concerns for things
such as library conflicts are a non-issue with Bedrock Linux's design - if
there is a package out there for a Linux distribution on your CPU architecture,
it will most likely work with Bedrock Linux.

### {id="additional\_functionality"} Additional Functionality

As a side-effect of the way Bedrock Linux ensure packages from different
distributions can coexist, Bedrock has some unusual additional functionality:

- You can effectively do a distro-upgrade (Debian 5 to 6, Ubuntu 12.04 to
  12.10, etc), *live, with almost no downtime*. No need to stop your apache
  server, reboot, configure things while the server is down, etc.
- If a distro-upgrade breaks anything, no problem - the old release's program
  and settings can still be there, ready to go to pick up what it was doing
  before the distro-upgrade broke anything.
- Minimal stress from any given package failing to work - just use one from
  another Linux distribution. Packages feel disposable, like toothpicks. No
  need to fret over one breaking; just use another.

## {id="real\_world"} Real-World Examples of where Bedrock Linux Shines

These are all examples of real-world situations which came up while Bedrock
Linux was in development which showed quite clearly Bedrock's strength.

- With only a few days to go before presenting Compiz at a local Free/Open
  Source Software enthusiast club, the presenter found Debian's video drivers
  for his laptop were overly old to support the 3D acceleration needed for
  Compiz. While Arch Linux's X11 video drivers were new enough, its Compiz
  package did not work at the time. Bedrock Linux allowed for a quick and easy
  solution: use Arch Linux's X11 with Debian's Compiz. 
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
- Arch Linux is one of the few Linux distributions with the mathematics program
  Sage available in its repository. However, for a period of time Sage was
  dropped from the repository due to compatibility issues with Arch Linux. Sage
  is only pre-packaged for and tested against a handful of Linux distributions,
  one of which is Ubuntu. Thus, when Sage mathematics was dropped for a period
  of time from the Arch Linux repository, all Bedrock Linux users had to do was
  to download it for Ubuntu. When it was returned, it was trivial to again get
  it from the Arch Linux repository. Arch Linux temporarily lost access to
  Sage, and Ubuntu users never benefited having Sage in a repository.

## {id="concepts"} Bedrock Linux Concepts

### {id="clients"} Clients

Most Linux distributions have *packages* which contain the software the distros
provide.  There are also *meta-packages* which do not contain anything
themselves but rather refer to other packages to group or redirect packages
conceptually.  Packages are typically collected and made available through
*repositories*.  Moreover, distributions typically provide *package managers*:
tools to automate installation, removal, acquisition and other details of
managing packages

A Bedrock Linux *client* is a collection of the above concepts.  The defining
feature of a client is that all of the software in the client is intended to
work together.  A client's package manager can manage the particular type of
package format used by the packages in the client.  Any dependencies packages
in the client may have should be met by other packages in the same client.  The
repositories should provide packages which make the same assumptions about the
filesystem as other packages; most of the packages which depend on a standard C
library will likely depend on the same exact one.

A typical Bedrock Linux system will have multiple clients, usually from
different distributions.  However, one is certainly welcome to have multiple
clients from different releases of the same distribution, or even multiple
clients corresponding to the exact same release of the exact same distribution.

Bedrock Linux, itself, is very small.  It is intended to only provide enough
software to bootstrap and manage the software provided by the clients.

### {id="local-and-global"} Local and Global files

The fundamental problem with running software intended for different
distributions is that the software may make mutually exclusive assumptions
about the filesystem.  For example, two programs may both expect different,
incompatible versions of a library at the same exact file path.  Or two
programs may expect `/bin/sh` to be implemented by different *other* programs.
One could have, for example, a `#!/bin/sh` script that uses bash-isms.  If
`/bin/sh` is provided by `/bin/bash`, this will work fine, but if it is
provided by another program it may not.

Bedrock Linux's solution is to have multiple instances of any of the files
which could cause such conflicts.  Such files are referred to as *local* files.
Which version of any given local file is being accessed is differentiated by
client.  In contrast, files which do not result in such conflicts are *global*
files.  A Bedrock Linux system will only have one instance of any given global
file.

By default, all files are local.  This way if some client distribution is doing
something unusual with its file system it will not confuse other clients.  What
files should be global - which tends to be the same across most Linux
distributions - are listed in configuration files.  This way Bedrock Linux can
provide a sane set of default configuration files which *typically* just work,
even against client distributions against which they were not explicitly
designed.

### {id="direct-implicit-explicit"} Direct, Implicit and Explicit file access

One potential problem with having multiple copies of any given local file is
determining which should be accessed when, and how to specify and configure
this.  Bedrock Linux provides three separate methods of accessing local files.

The first method is *direct*.  When any given process tries to read a local
file at its typical location it will get the same version of the file it would
have gotten had it done so on its own distribution.  For example, if a process
provided by a Fedora client tries to access a library, it will see that Fedora
release's version of the libary.  If another process from OpenSUSE runs a
`#!/bin/sh` script, it will be run by the same `/bin/sh` that comes with its
release of OpenSUSE.  The primary reason for direct file access is to ensure
dependencies are resolved correctly at runtime.

If a file is not available directly, it will be accessed *implicitly*.  In an
implicit file access, if any one client provides a given file, that version of
the file will be returned.  If multiple clients can provide a file, they are
ordered by a certain configured priority and the highest priority client which
can provide a given file will.  For example, if a process from Arch Linux tries
to run `firefox`, but the Arch client does not have firefox installed, but a
Gentoo client *does* have firefox installed, the Gentoo client's firefox will
run.  If the `man` executable from Mint looks for the man page for `yum`, it
probably won't see it *directly* because Mint typically does not use the yum
package manager.  However, if a Fedora client is installed, Mint's `man` can
*implicitly* read Mint's man page.  This implicit file access is largely
automatic.  The primary reason for implicit file access is to have things "just
work" across clients.

Finally, if a user would like to *explicitly* specify which version of a local
file to access, this can be done through the *explicit* file access.  For
example, if multiple clients can provide the vlc media player, an end user can
specify exactly which one to use.

Between these three file access types, most things just work as one would
expect despite the fact that they are not intended to work together.
