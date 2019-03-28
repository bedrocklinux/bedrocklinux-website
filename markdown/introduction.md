Title: Bedrock Linux: Introduction
Nav: home.nav

# Introduction to Bedrock Linux

- [Introduction](#introduction)
	- [What Bedrock Linux Does](#what_bedrock_does)
	- [Additional functionality](#additional_functionality)
- [Real-World Examples of where Bedrock Linux Shines](#real_world)
- [Concepts and Terminology](#concepts)

## {id="introduction"} Introduction

Linux distributions take software available and, in some sense or another,
prepare it for end-users.  Some distros compile the software and provide binary
packages while others distribute the code in a way which ensures it is easy to
automate compilation.  These services are extremely useful; it would not be
practical for everyone to compile and package all of their software directly
from upstream all of the time.

However, the various groups doing this packaging work do so with limited focus
on having their packages directly interoperate with those from other groups.
End-users are forced to choose between the available sets of packages.  Do I
want something stable from a CentOS or Debian?  Do I want something
cutting-edge from Arch?  Ubuntu is quite popular and has a lot of software
tested against its libraries - maybe that would be best.  Gentoo's ability to
automate compiling packages with configured settings is also quite desirable.
The list goes on.  Typically, any Linux user would have to chose *one* of the
available distros and either get all of their packages from that distribution
or fall back to taking the distribution developer's job of preparing software
for their environment.

This seems silly - if someone already packaged the specific version of the
specific package desired, why not just use that?  Sadly, there are various
technical reasons one cannot directly install software from one release of one
distribution onto another release of another distribution.  Bedrock Linux
provides technical means to work around these problems.  On a Bedrock Linux
system an end user should be able to install most of the software available
from most of the other traditional Linux distributions so that it works just as
well as one would have expected had the package been intended for the
distribution.  Bedrock Linux should allow its end-users to get most of his or
her system from something rock solid such as CentOS or Debian, while still
retaining access to cutting-edge packages from Arch and its AUR, library
compatibility with Ubuntu, the ability to leverage Gentoo's portage, and so
forth, all at the same time on the same distribution.

## {id="real\_world"} Real-World Examples of Bedrock Linux

These are all examples of real-world situations which benefited from Bedrock
Linux.

- With only a few minutes to go before presenting Compiz at a local Free/Open
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
- When developing Bedrock Linux 0.7 Poki, `libfuse` required `meson` to build.
  Debian Stable's `meson` was too old, and Arch's was to new.  Debian Testing
  had a goldilocks version which worked.

## {id="concepts"} Concepts and Terminology

Bedrock Linux is still in heavy development, and specific underlying concepts
and terminology change from release to release.  At the time of writing,
documentation for the current release (0.7 Poki) corresponding to
underlying concepts and terminology can be found [here](0.7/concepts-and-terminology.html).
