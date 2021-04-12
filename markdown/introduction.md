Title: Bedrock Linux: Introduction
Nav: home.nav

# Introduction to Bedrock Linux

TableOfContents

## {id="what"} What does it, really?

Bedrocklinux allows to run a linux system that is composed of different linux distributions. The system can boot with a bootloader, a kernel, and an init system selecting from installed distributions, and run userland packages that can be installed freely from multiple distributions.

Consequently, the running system is rooted in different linux distributions.
As such a descriptive name for bedrocklinux could actually be multi-rooted-linux.

In a pretentious language it could also have been marketed as something like "distrosnip", because, in a way, a multi-rooted system takes to an end what appimages, flatpacks or snap packages had begun.

However, instead of shipping static binary collections like the appimages, flatpacks and snap packages (the last two introducing third-party appstores) a multi-rooted system can avoid installing redundant and often outdated not well maintained binary collections. In a multi-rooted-linux system the different roots are managed by the original distribution's package managers and security update mechanisms, and a tool called *pmm*, the "package manager manager",  allows to manage the different roots in a unified way.


## {id="purpose"} Bedrock Linux's Purpose

Linux distributions take software and, in some sense or another, make it
accessible to end-users.  Some distros provide binary packages while others
distribute code in a way which ensures it is easy to automate compilation.
These services are extremely useful as it would not be practical for everyone
to compile and package all of their software directly from upstream all of the
time.

The various groups doing this packaging work do so without considering
interoperation with other groups.  This forces end-users to choose one distro
ecosystem and forgo features provided by others.  Do I want something stable
from ~+CentOS~x or ~+Debian~x?  Do I want something cutting-edge from
~+Arch~x?  ~+Ubuntu~x is quite popular and has a lot of desktop software tested
against its libraries.  ~+Gentoo~x's ability to automate compiling packages
with configured settings is also quite desirable.

Given someone already expended the effort to package the specific version of
the specific piece of software a given user desires for one distro, the
inability to use it with software from another distro seems wasteful.

~+Bedrock Linux~x provides a technical means to work around cross-distro
compatibility limitations and, in many instances, resolve this limitation.

## {id="itself"} Bedrock Linux itself

~+Bedrock Linux~x is a _meta_ Linux distribution.  Similar in spirit to ~+Linux
From Scratch~x or ~+Gentoo~x, it distributes a means to install a Linux based
operating system even if it does not distribute most of the resulting binary
files directly.

The files distributed by the ~+Bedrock Linux~x project are primarily glue for
components from other Linux distributions.  Some, such as the hijack installer
and `strat` command, are user-facing.  Others, such as `crossfs`, operate
largely behind the scenes to make as much as possible "just work."  ~+Bedrock~x
also provides some quality of life utilities for managing a system composed of
components from multiple other distros such as `brl fetch` and `pmm`.

A ~+Bedrock~x system is composed of ~{strata~}, which are collections of
interrelated files.  These are often one-to-one with traditional Linux
distribution installs: one may have an ~+Arch~x ~{stratum~}, a ~+Debian~x
~{stratum~}, a ~+Gentoo~x ~{stratum~}, etc.  ~+Bedrock~x's "glue" carefully
integrates these so that they can interact with each other without tripping on
distro compatibility concerns.

## {id="integrated-features"} Integrated features

~+Bedrock~x strives to make as many features from other distros available and
work across ~{stratum~} boundaries as possible.  A non-comprehensive list of
what is available at the time of writing includes:

- Command line commands
- Graphical applications
- `bash`, `zsh`, and `fish` tab completion
- Linux kernel firmware detection
- Xorg fonts
- Man and info pages
- Init systems
- Bootloaders

## {id="examples"} Example use cases

~+Bedrock~x's flexibility opens so many options it can be difficult to provide a
comprehensive, concrete picture of how it may be useful to potential users.
Some reported real-world use cases include:

- Access to both "stable" features from distros such as ~+Debian~x and
  ~+CentOS~x
- Access to cutting edge features from ~+Arch~x or ~+Void~x.
- A mix of source based packages, such as from ~+Gentoo~x, with binary
  packages.
- Access to ~+Arch~x's AUR.
- Access to distros where specific software is likely tested and supported,
  such as desktop software aimed at ~+Ubuntu~x or business software aimed at
  ~+CentOS~x.
- Access to distros which support specific hardware particularly well, such as
  ~+Raspbian~x.
- Access to a desired init system.
