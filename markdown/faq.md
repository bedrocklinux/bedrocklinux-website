Title: Bedrock Linux: Frequently Asked Questions
Nav:   home.nav

# Frequently Asked Questions

- [What is Bedrock Linux?](#what_is_bedrock)
- [How does Bedrock Linux work?](#how_bedrock_work)
- [Why should I use Bedrock?](#why_use_bedrock)
- [Why should I not use Bedrock?](#why_not_use_bedrock)
- [How secure is Bedrock Linux?](#security)
- [How stable is Bedrock Linux?](#stability)
- [Is Bedrock Linux far enough along for me to use?](#ready_status)
- [How can I contribute?](#contribute)
- [How is this different from/preferable to using a virtual machine?](#vs_virtual_machine)
- [How is this different from/preferable to containers (Docker/LXC/OpenVZ/etc)?](#vs_container)
- [When will $RELEASE be released?](#when_release)
- [Why that name?](#why_name)
- [Where do the release names come from?](#release_names)
- [What are the system requirements?](#system_requirements)
- [Why does this need to be its own distribution?](#why_own_distro)
- [On which distribution is Bedrock Linux based?](#on_which_distro)
- [This sounds overly-ambitious. Do you really think you can pull this off?](#overly-ambitious)
- [What about Bedrock BSD or Bedrock Android or Bedrock Something-Else?](#other-os)
- [Is Bedrock Linux practical?](#practicality)
- [Why was Bedrock Linux started?](#why-started)
- [What distros do Bedrock Linux support as strata?](#supported-distros)
- [Why did the versioning system change?](#version-system)
- [Why can't I un-hijack my install?](#unhijack)
- [How can I tip the lead developer?](#tipping)

## {id="what\_is\_bedrock"} What is Bedrock Linux?

See the Introduction to [Bedrock](introduction.html).

## {id="how\_bedrock\_work"} How does Bedrock Linux Work?

The exact details may change drastically from release-to-release.  Broadly, it
uses various virtual filesystem layer tools such as `chroot`, `pivot_root`,
bind mounts (including shared subtree control), and FUSE filesystems, and
symlinks to control exactly which instance of a file a given process sees in a
given situation.  It also manipulates various files to enforce configuration
and controls the init system to set things up before handing control off to the
desired init.

## {id="why\_use\_bedrock"} Why should I use Bedrock?

- If you would like features or packages available in Linux distributions, but
not all available in the same Linux distribution at the same time. For example,
if you would like your system to be mostly stable and unchanging, like Debian
or a Red Hat Enterprise Linux clone, but would like access to cutting-edge
packages from Arch, Bedrock Linux can provide this simultaneously and
transparently.
- If you would like to have access to other Linux distributions readily
available for purposes other than access to their functionality. For example,
if you regularly assist people who use a variety of Linux distributions and
would like to be able to test possible solutions on your own box without using
virtual machines.
- If you have issues with packages from Linux distributions that are unique to
that distribution and would rather simply use another distribution's package
for this specific issue than debug the root of the problem.
- If you want a toy with which to play.

## {id="why\_not\_use\_bedrock"} Why should I not use Bedrock?

- If you are happy with all of the functionality provided by another Linux
  distribution, and you have no interest in features it does not provide, it
  would likely be best to simply use that other Linux distribution.

- Bedrock Linux is still in deep development with a relatively small community.
  While stability, reliability, and accessibility are high priorities for the
  eventual "stable" release, they may be lacking in the project's current place
  in the development cycle.  If you are willing to put up with some rough edges
  more testers are certainly welcome, but if you are looking for a stable,
  well-proven or user-friendly distro Bedrock Linux may not yet meet your
  needs.  See the [stability FAQ entry below](#stability).

- While Bedrock Linux can acquire beneficial attributes of other distributions,
  it can also take in some negative attributes, namely *lax security*.  A
  Bedrock Linux system composed of carefully chosen, curated components from
  other distributions with properly configured hardening techniques may be more
  secure than most other distros out there; however, one composed of a
  cacophony of overly-complicated insecure packages from poorly designed and
  ill maintained distros could easily be much worse than most other distros.
  In other words, Bedrock Linux's flexibility lets you shoot yourself in the
  foot in wholly new and unique ways.  See the [security FAQ entry
  below](#security).

- Just as security issues are additive, so is complexity.  Any two distros *x*
  and *y* would each be, individually, simpler than a Bedrock Linux system
  which is composed of packages from both distros *x* and *y*.  While this
  complexity is manageable in practice, those looking for extreme
  minimal/simple distros may prefer to look elsewhere.

- Bedrock Linux uses a non-negligible amount of disk over traditional distros.

## {id="security"} How secure is Bedrock Linux?

A Bedrock Linux system is composed of packages from other distributions.  If
you limit yourself to packages from secure, well-proven, hardened distros,
security could be comparable to those distros themselves.  If you use less
secure packages from less secure distros, Bedrock Linux's security will suffer
accordingly.  In theory Bedrock Linux allows one to build a system out of every
package from every major distro without any access controls in place, which
would have an incredible attack surface and be a terrible idea.  Don't do that.

Bedrock Linux does offer some minor theoretical security benefits over
traditional distros:

- If a distro does not provide a desired version of a desired package, a user
  is typically expected to go acquire it outside of the distro's repositories.
  It then falls on the user to maintain the package himself/herself.  While it
  is possible a given user is extremely diligent about maintaining such
  packages, there is a strong possibility the user may fail to follow proper
  diligence and let security updates languish.  With Bedrock Linux, the package
  may be acquired from another, maintained distribution whose security team the
  user can depend on.

- Some hardening techniques from one distro may protect software from others.
  For example, a hardened kernel from one distro may be used with packages from
  another distro that does not provide such a hardened kernel.

There are also some downsides to Bedrock Linux from a security
point-of-view:

- `chroot()`-hardening techniques will break Bedrock Linux.  Some people
  attempt to misuse `chroot()` as a security tool, unaware of the many ways
  `chroot()` "contained" things can influence the rest of the system.  These
  hardening techniques attempt to shore up these limitations of using
  `chroot()` as a pseudo-container.  Bedrock Linux uses `chroot()` to a nuanced
  degree, taking advantage of the areas where it does *not* contain things;
  changes there will break Bedrock Linux.  If you need to lock down `chroot()`,
  consider changing or expanding your strategy to include things such as using
  `pivot_root` and namespaces.

- Some distros provide security mechanisms such as SELinux policies or
  intrusion detection systems which may not "just work" across packages from
  different, unrelated distros in a Bedrock Linux system.  It may be possible
  to manually extend such policies and mechanisms to cover the entirety of a
  Bedrock Linux system composed of packages from a variety of distros, but
  additional work would be required; it won't "just work".

## {id="stability"} How stable is Bedrock Linux?

Stability and, where that fails, resilience to otherwise potentially breaking
issues, is a high priority for the project. The original reason Bedrock Linux
started was to allow access to newer packages without the sacrifice in
stability provided by distros such as Debian and RHEL

However, at the moment, Bedrock Linux is in deep development and it is very
possible that stability issues may arise.  Moreover, the community is
relatively small, limiting our ability to properly test and quality-assure
the project in its current state.  While stability is a valued eventual
goal, it may be lacking to some degree or another at the current time.

Even when 1.0 stable is reached, Bedrock Linux's flexibility may allow for
unstable configurations.  A Bedrock Linux system is composed of packages from
other distributions.  If you limit yourself to packages from stable,
well-proven distros, stability will follow. If you use less stable packages
packages from less stable distros, Bedrock Linux's stability will suffer
accordingly.

Neither an all-very-stable package collection nor an all-bleeding-edge
package collection is required.  Rather, a blend of the two is where
Bedrock Linux is able to excel.  In such a setup, a user can keep around
and depend on stable software while still having access to less dependable,
more cutting edge software.  Should some software fail - most likely the
bleeding-edge software, but not impossibly the older software software -
packages from other distros can fill the functionality gap, minimizing the
hit.  This even works with things such as init systems: should an init
system fail, traditional distros would be rendered unbootable without
manual efforts to resolve.  With Bedrock Linux one can simply chose
an init system from another distro.

## {id="ready\_status"} Is Bedrock Linux far enough along for me to use?

Difficult to say.  Typically issues become evident in relatively early use, and
if early experimentation proves fruitful with your workflow it will likely
continue to work.  Consider trying Bedrock Linux in a VM or on a spare machine
and exercise your general workflow as a test.

## {id="contribute"} How can I contribute?

See [the contributing page](contributing.html).

## {id="vs\_virtual\_machine"} How is this different from/preferable to using a virtual machine?

Bedrock Linux's functionality differs from virtual machines in three key ways:

- Bedrock's ability to access programs from other Linux distributions is
largely transparent once set up. One can, for example, have a RSS feed reader
from one Linux distribution open a link in a browser in another Linux
distribution, all running in an X11 server from a third Linux distribution.
This all happens transparently; it all feels like one single cohesive Linux
distribution. Virtual machines cannot do this type of transparency nearly as
well.
- Bedrock's ability to access software from other Linux distributions has
significantly less overhead than virtual machines do. This is especially
true with respect to 3D/video acceleration, which "just works" (assuming no
proprietary driver issues) as well as it does in a normal Linux distribution.
Such things typically do not work very well at all in virtual machines.
- Bedrock, by its very design, interweaves other Linux distributions together;
it ensures they share quite a bit. This means if there is a security
vulnerability in one of the ~{strata~}, there is little to stop it from affecting
the rest of the system. Virtual machines, by their very design, sandbox the
VMs such that an attack on one of them will have a difficult time
propagating to others.

## {id="vs\_container"} How is this different from/preferable to containers (Docker/LXC/OpenVZ/etc)?

Containers contain things.  They, purposefully, keep the contained software
from interacting with the rest of the system.  This has numerous benefits:

- If something goes wrong - an innocent bug or a malicious attacker - the
  damage done is (ideally) restricted to the container.
- Software in the container is largely self-sufficient and can be easily made
  to run on a variety of Linux distributions without worry about things
  conflicting.  If one has an older distribution such as a RHEL clone but wants
  a newer version of some software, it could be provided via a container.

However, containers have disadvantages as well:

- Things within containers are kept from interacting with each other.  For
  things which run as stand-alone services, such as web servers like apache and
  nginx, this is not a problem.  However, other software is intended to coexist
  with like software.  Containing things such as `mkdir` and `rmdir` in
  separate containers would significantly reduce the benefit of each.

- Services such as Docker can be used to create what are effectively very
  portable packages.  However, someone has to do some work to create these
  packages.  One cannot simply grab a .deb or .tar.gz from the repositories of
  other Linux distributions, drop them in a container and expect them to work.

Where containers are useful, one is certainly encouraged to use them.  However,
one cannot be realistically expected to contain everything independently.  What
most Linux distributions *do* is provide software that can interact natively
for when that is useful.  Bedrock Linux is no different here, conceptually,
from other major distributions.  What makes Bedrock Linux unique is that the
software it can install natively is provided from a very large variety of
sources.  If one wants to use `mkdir` from one distribution and `rmdir` from
another, for whatever reason, Bedrock Linux, for the most part, can make this
happen.  A more realistic example would be utilizing xorg from one distribution
and a window manager or desktop environment from another - neither is good
alone, they need to interact, but there could be legitimate reasons to want
them from different distributions.  See the compiz story
[here](http://bedrocklinux.org/introduction.html#real_world), for example.

Containers and Bedrock Linux have very different goals and go about them by
largely different means.  The two are not in competition in any way; in fact,
one could run Bedrock Linux in a container, or run containers on top of Bedrock
Linux, no different than any other distribution.

## {id="when\_release"} When will $RELEASE be released?

If there is an estimate for a release, it will be stated in the index page for
the specific release. If not, then it will be released when it is done.

## {id="why\_name"} Why that name?

Bedrock Linux does not do very much by itself; rather, it is the foundation
upon which parts of other Linux distributions are placed. Initial ideas for a
name were intent on reflecting this fact. Other proposed names included
"Foundation Linux", "Frame Linux" and "Scaffolding Linux". The choice was made
without consideration of the television show *The Flintstones*.

## {id="release\_names"} Where do the release names come from?

All of the Bedrock Linux releases are named after characters from the
Nickelodeon television programs *Avatar: The Last Air Bender* and *The Legend
of Korra*.

## {id="system\_requirements"} What are the system requirements?

The system requirements are not closely tracked.  Bedrock has been found to
work adequately on relatively low end machines such as a Raspberry Pi 3b+ and
Eeepc 701.  Generally, Bedrock requires a handful of megabytes more RAM than
the traditional distros that make up its strata, but a non-trivial amount of
extra disk.

## {id="why\_own\_distro"} Why does this need to be its own distribution?

This question is a bit difficult to answer, as Bedrock Linux somewhat blurs the
definition of what constitutes a "Linux distribution".

If someone is using equal parts of multiple different distributions, what
should one call the resulting operating system?  Say, for example, that exactly
one third of the installed and in use for a given Linux distro install comes
from Arch Linux, another third from Alpine Linux, and the last third from
Gentoo Linux.  Which distro is the user running?  Answering the question with a
simple "Arch," "Alpine," or "Gentoo" would be misleading.  One cannot tie it to
typically firm concepts such as the init system or the kernel, as these are
fluid concepts in Bedrock Linux.  It is possible to switch any of those with a
reboot while still using the *exact* same rest of the system.  Instead of
expecting people to answer the question of "which distro are you running?" with
a long explanation going into the intricacies of how things are intermixed
between multiple distributions, someone could simply answer "Bedrock Linux".

People have proposed having Bedrock Linux act as a meta package manager which
sits on top of another distro.  By virtue of its meta-distro nature, Bedrock
Linux supports this workflow, while not being constrained to it.  You can
install Bedrock Linux by hijacking another distro's install.  If you would
like, you are then free to continue using the original distro's software while
utilizing Bedrock Linux to access software from other distros.  Functionally,
this is very similar to installing some other package manager into a distro.
The key difference is that, from Bedrock Linux's point of view, there is no
major difference between the files from the distro install you've hijacked and
the files from the other distros.  You're free to remove all of the original
install's files .  [If you install some distro, such as Slackware, then hijack
it into Bedrock Linux, then remove all of the files of the original Slackware
install, are you still running the original
distro?](https://en.wikipedia.org/wiki/Ship_of_Theseus)

Bedrock Linux is described as a (meta) Linux distribution because this is the
most accurate answer when restricted to preexisting concepts.  It does not need
to be treated as such; the system is sufficiently flexible to fill other
workflows, such as acting as though it is a package installed onto some other
distribution.  However, describing it by these other workflows alone would be
misleading.

## {id="on\_which\_distro"} On which distribution is Bedrock Linux based?

Bedrock Linux is not based on or an offshoot of any other Linux distribution;
it was written from scratch. Or, if you prefer to look at it from another point
of view, it is based on every other major distribution, as that is where it
gets the majority of its software.

## {id="overly-ambitious"} This sounds overly-ambitious. Do you really think you can pull this off?

An argument could be made either way if Bedrock Linux was still in the planning
stages, prior to any functional release, but since Bedrock Linux was publicly
announced along with a functional (if unpolished) alpha: yes. Not only is it
possible, it has been done, and the necessities for you to see this for
yourself have been made available if you don't want to take my word for it.
Much work needs to be done such as polish and the addition of many features,
but the core idea has been proven quite definitively to work.

## {id="other-os"} What about Bedrock BSD or Bedrock Android or Bedrock Something-Else?

The techniques Bedrock Linux utilizes are fairly specific to Linux.  While it
may possible to create a similar meta-distro for other kernels, they would
require substantial new R&D and are not being pursued by anyone on the Bedrock
Linux team.  While Android does use the Linux kernel, its userland is
sufficiently distant that it, too, would require substantial R&D and is not
currently being pursued.

## {id="practicality"} Is Bedrock Linux practical?

Bedrock Linux is not intended as an academic exercise or a purely research
project.  It aims to result in a functional, practical system which solves
[real-world problems](#introduction.html#real_world).  However, the
requirements to be practically useful varies across people and purposes.
Bedrock Linux may not be useful for everyone.

## {id="why-started"} Why was Bedrock Linux started?

What ended up becoming Bedrock Linux was originally a series of experiments and
exercises with various Linux subsystems and technologies which did not have a
specific collective name or ultimate end-goal in mind.  It was not until:

- Answering the question "What distro do you run?" became difficult to answer
  due to the fact the resulting system was equal parts of various other distros
  and that none of the original "underlying" distro remained.
- It became evident that the proto-Bedrock Linux system solved real world
  problems and would be worth further pursuit.

that the project became organized with a specific name and drive.

## {id="supported-distros"} What distros do Bedrock Linux support as strata?

Broadly support falls into two categories:

- Distros Bedrock can hijack.  Generally, most traditional distros work fine,
  and so it's shorter to list those that do not.  At the time of wring, Bedrock
  has known issues with: Slackware, CRUX, GoboLinux, NixOS, GuixSD, and live
  distros such as Knoppix or Slax.
- Distros Bedrock can fetch.  At the time of writing, Bedrock knows how to
  fetch (on `x86_64`): Alpine, Arch, Centos, Debian, Devuan, Fedora, Gentoo,
  Ubuntu, and Void (both glibc and musl).  More may have been added since this
  was written.

## {id="version-system"} Why did the version system change?

Bedrock Linux's early version numbers were chosen under the assumption that remaining open problems were unlikely to be solved in the near future.  Thus, the versions pressed towards a `1.0 stable` release.  However, over the years major issues were resolved over and over, each with a substantial under-the-hood rework.  It became evident that semantic versioning's pre-1.0 non-alpha/beta/rc releases better express Bedrock's state, and the version system was updated accordingly.

## {id="unhijack"} Why can't I un-hijack my install?

The central idea behind Bedrock Linux is to offer a way to get features from a mix of other distributions.  This includes not only things like the kernel, init, and web browser, but also the install process.  In order to utilize another distribution's install process, one first installs that distro, then runs a Bedrock script which converts the install into a Bedrock Linux install.  While most of the original install's files are (optionally) retained for use by the resulting Bedrock system, the system is arguably no longer running the original distro anymore.

After the hijack process is completed, the hijacked install's files are no longer in any way special; it's simply another Bedrock stratum.  One may remove the hijacked install's files with `brl remove $(brl deref hijacked)`.  At this point there is nothing to "un-hijack" *to*.

It is inadvisable to model Bedrock as something which is installed "on top" of another distro.  This is comparable to modelling a hypervisor as something which is installed "on top" of a VM; it's functionally backwards.  Rather, is often best modelled Bedrock as a(n unusual) Linux distribution.  With most distros - Arch, Debian, CentOS, etc - installing is a destructive operation and removes data which previously existed on the installed-to medium.  If you want to retain the option to revert to what you had before installing Arch, Debian, CentOS, etc, you need to back up before you install over it.  Bedrock should be treated similarly here.

## {id="tipping"} How can I tip the lead developer?

Bedrock Linux development is not limited by funding, and there is no intended
obligation associated with benefiting from Bedrock Linux development efforts.

If you are interested in tipping the lead developer as a thanks for his
efforts, see [here](tipping.html).
