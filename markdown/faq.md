Title: Bedrock Linux: Frequently Asked Questions
Nav:   home.nav

# Frequently Asked Questions

TableOfContents

## {id="what-is-bedrock"} What is Bedrock Linux?

~+Bedrock Linux~x is a meta Linux distribution which mixes-and-matches components
from other distributions and integrates them into one largely cohesive system.

## {id="what-is-meta"} What is meant by "meta" Linux distribution?

Traditional Linux distributions _distribute_ software which includes the Linux
kernel.  This is done with the aim of providing users a Linux based operating system.

_Meta_ Linux distributions share the eventual goal of a Linux based operating
system, but do so in a means other than distributing the end-goal software
itself.

Other meta Linux distributions include:

- [Linux From Scratch](http://www.linuxfromscratch.org/) which provides a set
  of instructions to build a Linux system.
- [Gentoo Linux](https://www.gentoo.org/) which provides a flexible system
  which can compile the user's desired Linux system.  [Gentoo describes itself
  as a _metadistribution_](https://www.gentoo.org/get-started/about/).

~+Bedrock~x provides a means to compose a target the user's desired system from a
potentially eclectic mix of parts of other distros.

## {id="on-top"} Does Bedrock install on top of other distros?

No.  Rather, ~+Bedrock~x's install process _replaces_ another distro install
then adds the previous install as a new ~+Bedrock~x ~{stratum~}.  It does this
sufficiently quickly and smoothly that it is easy to misinterpret the process.

The significance here is that ~+Bedrock~x becomes integral to the system after
the install while the ~{hijacked~} ~{stratum~}'s files may be trivially swapped
out and removed.

When one installs a traditional distro, the preceding install is wiped.  It is
best to model installing ~+Bedrock~x as similar, even if the process to get
there is unusual.  Along these lines, consider the ~{hijacked~} ~{stratum~}
simply a default collection of software, where any and all may be replaced.

## {id="install-process"} Why does Bedrock install by replacing another distro?

~+Bedrock~x's goal is to provide users access to features of other distros.
For example, ~+Bedrock~x makes other distro init systems and fonts available.
~+Bedrock~x itself is unopinionated about the choices; it doesn't care which
init system or font the user wants.

To ~+Bedrock~x, the install process is another feature that ~+Bedrock~x should
make available from other distros.  It achieves this by having users first
install a distro that has the install process he or she prefers, then providing
a low-friction method of converting that install into a ~+Bedrock~x install.

This process is referred to as ~{hijacking~} to emphasize the forceful way
~+Bedrock~x takes control from the previous install.

## {id="how-work"} How does Bedrock Linux Work?

The exact details may change drastically from release-to-release.  A detailed
white paper is planned once things stabilize around a 1.0 release.

~+Bedrock~x has different strategies for different subsystems.  Its most
widely used strategy is to:

- Organize the system's files and processes into units called ~{strata~}.  Think
  of these as `chroot`s with selective holes punched in them.
- Make resources such as executables and fonts available across ~{stratum~}
  boundaries via a FUSE filesystem called `crossfs` that alters files
  on-the-fly to make them portable across ~{stratum~} boundaries.
- Resources producers - namely package managers - are not told about the
  `crossfs`.  This way they usually cannot conflict with each other.
- Resource consumers are configured to consider `crossfs`.  For example, cross
  binary locations are added to the `$PATH` so that `bash` can find them.

Please note that this is not the only strategy ~+Bedrock~x leverages, and that
different subsystems may require radically different strategies to provide
cross-distro features.  See the planned white paper once it releases for a
comprehensive and detailed explanation.

## {id="why-use-bedrock"} Why should I use Bedrock?

If you have experience with a number of Linux distributions and find whenever
you're on one distro you miss a feature provided by another, ~+Bedrock~x may
provide a suitable means of getting the best of multiple worlds.

## {id="why-not-use-bedrock"} Why should I not use Bedrock?

- Fundamental to its nature, it's more complicated than traditional distros.
  More to learn, more that could go wrong, and more to wrestle with if
  something does go wrong. It's perfectly manageable for adequately experienced
  Linux users, but not necessarily for everyone.
- Fundamental to its nature, it has a greater attack surface and is more
  difficult to harden than traditional distros.  For particularly security
  sensitive needs, it may be wise to sacrifice the associated convenience.
- ~+Bedrock~x makes a lot "just work" between components from multiple distros, but
  not everything. Some things that don't just work have easy work arounds, some
  don't. It is possible the particular combination of features you're after
  isn't feasible on ~+Bedrock~x. At least not yet - things are always improving.
- The community is small and there are limited resources for supporting users
  compared to larger distros.
- Until 1.0, there's no guarantee "major" updates can be applied in-place.
  ~+Bedrock~x's research heavy nature means it may require major, unforeseeable
  changes to its underlying architecture to resolve open inter-distro
  compatibility issues.  That having been said, efforts are made to minimize
  the frequency of such breaking updates and some degree of support for those
  who have not migrated is usually available for a reasonable period of time.
- ~+Bedrock~x does not de-duplicate files across ~{strata~}.  It may result in
  noticeable disk overhead compared to traditional distros.
- While it is not a problem in most work flows, ~+Bedrock~x does have some
  runtime overhead, such as in `/etc` access.  Workflows which access `/etc`
  excessively (e.g. hundreds of times a second) may exhibit noticeable
  slowdown.  Don't run a performance sensitive database out of `/etc`.

## {id="security"} How secure is Bedrock Linux?

A ~+Bedrock Linux~x system is composed of software from other distributions.  If
you limit yourself to packages from secure, well-proven, hardened distros,
security could be comparable to those distros themselves.  If you use less
secure packages from less secure distros, Bedrock Linux's security will suffer
accordingly.

In addition to code from other distros, ~+Bedrock~x's own code introduces a
couple theoretical potential weak points:

- The `strat` command is `cap_sys_chroot=ep`.  This means it can call
  `chroot()` irrelevant of the user that runs it.  It takes great care to
  ensure it is only used per root-set configuration.
- ~+Bedrock~x introduces two FUSE filesystems which run as root, `etcfs` and
  `crossfs`.  Both of these take efforts to reduce their own permissions to
  those of the caller before taking actions.

Additionally, ~+Bedrock~x provides a `brl fetch` command which bootstraps
minimal sets of files from other distros.  To get around a catch-22 of needing
a distro's packages to bootstrap the distro, an early part this bootstrap
process may occur without cryptographic signature checking.

Moreover, ~+Bedrock~x's efforts to make things work cross-distro breaks
expectations from many Linux hardening techniques.  It is possible to create
Mandatory Access Control policies for ~+Bedrock~x, but policies written for
other distros will not work as-is on ~+Bedrock~x.


## {id="stability"} How stable is Bedrock Linux?

Since ~+Bedrock~x's first public release in 2012 there have been:

- Exactly one bug that caused a ~+Bedrock~x component to crash.
- Exactly one bug that caused potentially undesired data loss (by removing a
  subdirectory of `/run`).

Generally, once a ~+Bedrock~x install is running well, it keeps running well.

However, ~+Bedrock~x _does_ have a number of [known compatibility
issues](0.7/feature-compatibility.html), and likely some unknown ones as well.
It is wise to install ~+Bedrock~x in a VM or spare machine and exercise your
expected workflow to shake these out before installing it on a production
machine.

## {id="ready-status"} Is Bedrock Linux far enough along for me to use?

While ~+Bedrock~x just work for many work flows, others require further
development effort.  How things align for your particular workflow is difficult
to predict without exercising it and finding out.

Typically issues become evident in relatively early use.  Consider trying ~+Bedrock~x
in a VM or on a spare machine and exercise your expected workflow as a test.
If that goes smoothly, ~+Bedrock~x may indeed be suitable for you.  Otherwise,
consider revisiting it down the line.

## {id="contribute"} How can I contribute?

See [the contributing page](contributing.html).

## {id="why-name"} Why that name?

~+Bedrock Linux~x does not do very much by itself; rather, it is the foundation
upon which parts of other Linux distributions are placed. Initial ideas for a
name were intent on reflecting this fact. Other proposed names included
"Foundation Linux", "Frame Linux" and "Scaffolding Linux". The choice was made
without consideration of the television show *The Flintstones* or videogame
*Minecraft*.

## {id="release\_names"} Where do the release names come from?

All of the ~+Bedrock Linux~x releases are named after characters from the
Nickelodeon television programs *Avatar: The Last Air Bender* and *The Legend
of Korra*.

## {id="other-os"} What about Bedrock BSD or Bedrock Android or Bedrock Something-Else?

The techniques ~+Bedrock Linux~x utilizes are fairly specific to Linux.  While
it may possible to create a similar meta-distro for other kernels, they would
require substantial new R&D and are not being pursued by anyone on the
~+Bedrock Linux~x team.

While Android does use the Linux kernel, its userland is sufficiently distant
that it, too, would require substantial R&D and is not currently being pursued.

## {id="supported-distros"} What distros do Bedrock Linux support as strata?

See [the distro compatbility page](0.7/distro-compatibility.html)

## {id="when-start"} When did Bedrock Linux start?

~+Bedrock~x development officially started on the 9th of June, 2009.

The first internal release occurred 2011.

The first public release occurred the third of August, 2012.

## {id="how-start"} How did Bedrock Linux start?

In 2008, paradigm experimented with creating a Linux sandbox technology.
Particular focus was given to fluidly transitioning resources between security
contexts to minimize friction without opening exploitable security holes.

In 2009, it became evident that [Tomoyo
Linux](https://tomoyo.osdn.jp/index.html.en) would be mainlined into the Linux
kernel.  Tomoyo was found to be a greatly preferable to paradigm's experimental
sandbox system, and so the sandbox effort was abandoned.

Also around this time, paradigm became frustrated with the amount of packages
he had to compile and maintain himself, as no distro provided everything desired.

Serendipitously, the technologies developed to fluidly transition between
security contexts were found to be perfect for fluidly transitioning between
Linux distro contexts.  Further experimentation here lead to paradigm founding
~+Bedrock Linux~x.
