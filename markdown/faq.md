Title: Bedrock Linux: Frequently Asked Questions
Nav:   home.nav

# Frequently Asked Questions

- [What is Bedrock Linux?](#what_is_bedrock)
- [How does Bedrock Linux work?](#how_bedrock_work)
- [Why should I use Bedrock?](#why_use_bedrock)
- [Why should I not use Bedrock?](#why_not_use_bedrock)
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

## {id="what\_is\_bedrock"} What is Bedrock Linux?

See the Introduction to [Bedrock](introduction.html).

## {id="how\_bedrock\_work"} How does Bedrock Linux Work?

The exact details may change drastically from release-to-release, but the
general concept is explained [here](introduction.html#how_bedrock_works).

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
- If you would like to try for extremely high uptime while still doing
distro-upgrades if you are limited yourself to a single machine. See [Why
should I not use Bedrock?](#why\_not\_use\_bedrock) below for the catch.
- If you want a toy with which to play.

## {id="why\_not\_use\_bedrock"} Why should I not use Bedrock?

- If you are happy with all of the functionality provided by another Linux
distribution, and you have no interest in features it does not provide, it
would likely be best to simply use that other Linux distribution.
- If you value stability/reliability, note that while this is a priority for
Bedrock Linux, Bedrock Linux is still largely new and untested; a
tried-and-true stable/reliable Linux distribution such as Debian or a Red Hat
Enterprise Linux clone would likely be better suited.
- If you value security, note that Bedrock Linux probably has the highest
attack surface of just about any Linux distribution, mostly because its attack
surface is the sum of the attack surfaces of just about every other Linux
distribution combined. While steps can be taken to alleviate this to some
degree, ultimately, a locked-down Bedrock Linux can never truly reach the
security offered by a locked-down standard Linux distribution.

## {id="contribute"} How can I contribute?

- Pop into [IRC](http://webchat.freenode.net/?channels=bedrock) and ask around.
- Take a look at the
  [issues](https://github.com/bedrocklinux/bedrocklinux-userland/issues) and,
  if you feel you can tackle something, mention it in the issue tracker or
  discuss it with "paradigm" in
  [IRC](http://webchat.freenode.net/?channels=bedrock).  Or make a new issue if
  you have an idea.
- There is always a need to improve the documentation.  For example, you could
  add instructions for setting up an obscure distro as a client Bedrock Linux,
  or something as simple as fixing typos.  Once you have something to submit,
  stop by the [website git
  repo](https://github.com/bedrocklinux/bedrocklinux-website).

## {id="vs\_virtual\_machine"} How is this different from/preferable to using a virtual machine?

Bedrock Linux's functionality differs from virtual machines in three key ways:

- Bedrock's ability to access programs from other Linux distributions is
largely transparent once set up. One can, for example, have a RSS feed reader
from one Linux distribution open a link in a browser in another Linux
distribution, all running in an X11 server from a third Linux distribution.
This all happens transparently; it all feels like one single cohesive Linux
distribution. Virtual machines cannot do this type of transparency nearly as
well.
- Bedrock's ability to access programs from other Linux distributions has
extremely minimal overhead as compared to virtual machines. This is especially
true with respect to 3D/video acceleration, which "just works" (assuming no
proprietary driver issues) as well as it does in a normal Linux distribution.
Such things typically do not work very well at all in virtual machines.
- Bedrock, by its very design, interweaves other Linux distributions together;
it ensures they share quite a bit. This means if there is a security
vulnerability in one of the clients, there is little to stop it from affecting
the rest of the system. Virtual machines, by their very design, sandbox the
clients, such that an attack on one of them will have a difficult time
propagating to others.

## {id="vs\_container"} How is this different from/preferable to containers (Docker/LXC/OpenVZ/etc)?

Containers contain things.  They, purposefully, keep the contained software
from interacting with the rest of the system.  This has numerous benefits:

- If something goes wrong - an innocent bug or a malicious attacker - the
  damage done is restricted to the container.
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
upon which other Linux distributions are placed. Initial ideas for a name were
intent on reflecting this fact. Other proposed names included "Foundation
Linux", "Frame Linux" and "Scaffolding Linux". The name chosen has nothing to
do with the television show *The Flintstones*.

## {id="release\_names"} Where do the release names come from?

All of the Bedrock Linux releases are named after characters from the
Nickelodeon television program *Avatar: The Last Air Bender.*

## {id="system\_requirements"} What are the system requirements?

The system requirements are listed in the specific pages for each release. This
is done in case changes between versions alter the system requirements. The
system requirements for the initial alpha can be found
[here](http://bedrocklinux.org/1.0alpha1/systemrequirements.html).

## {id="why\_own\_distro"} Why does this need to be its own distribution?

For much of Bedrock Linux's development, it was simply a set of scripts on top
of Debian. It became apparent, after months of using it, that there would be a
number of benefits to make this its own Linux distribution. If you do not find
any value in the items listed here you're more than welcome to try to use the
Bedrock Linux utilities on top of another distribution.

- The base distribution should require minimal maintenance over long periods of
  time. Ultimately, even long-term supported Linux distributions will lose
  support and have to be upgraded or replaced eventually. One of the advantages
  of Bedrock Linux is that these distro-upgrade situations can be significantly
  less painful when the distro is a client; however, this advantage is not
  available for the base itself. If the base is made to be as minimal as
  possible, this should decrease the amount of things that need to be updated
  and maintained. As Bedrock Linux approaches maturity, this could
  theoretically be brought down to perhaps one or two executables other than
  the Linux kernel itself. It is difficult to properly express just how nice it
  is to never worry about how a major change to how things work under the hood
  of your Linux distribution could possibly take down your system, as the
  vitals of the system remain relatively static.
- The base distribution is effectively entirely overhead. Ideally any resource
  usage (disk space, RAM, CPU, etc) should be minimized. Most major
  distributions available are far larger than necessary as a base on which
  other distros should be placed as Bedrock Linux clients, and most minimal
  distributions were found to lack features Bedrock would need (as they were
  intended to be entirely minimal, rather than the basis for a full-blown
  desktop/server/etc). This is particularly important on resource-limited
  devices, such as ASUS Eee PC's, where Bedrock Linux's early development and
  usage took place.
- Much of what Bedrock Linux needs to do to properly utilize clients requires
  direct control over key files, such as /etc/profile. While many Linux
  distributions do offer means to properly remove individual files from the
  package manager's control, such as utilizing dpkg-divert, as the number of
  files which need this treatment grow the advantages of using an existing
  distribution shrink.
- Much of what Bedrock Linux needs to do to properly utilize clients requires
  direct control over what happens during boot. For example, if one would like
  to be able to choose which device manager to use from which client, special
  functionality must be built into the boot process to properly handle deciding
  which device manager to call when, if any. Attempting to integrate such
  functionality into existing boot systems is not an appealing task when a
  (very simple) home-grown init could suffice instead.

## {id="on\_which\_distro"} On which distribution is Bedrock Linux based?

Bedrock Linux is not based on or an offshoot of any other Linux distribution;
it was written "from scratch." It has unusual twin goals of needing to be as
minimal as possible while supporting the features necessary for a full-blown
desktop. Rather than attempting to tweak an existing distribution into such a
shape a new one was made from the ground up.

## {id="overly-ambitious"} This sounds overly-ambitious. Do you really think you can pull this off?

An argument could be made either way if Bedrock Linux was still in the planning
stages, prior to any functional release, but since Bedrock Linux was publicly
announced along with a functional (if unpolished) alpha: yes. Not only is it
possible, it has been done, and the necessities for you to see this for
yourself have been made available if you don't want to take my word for it.
Much work needs to be done such as polish and the addition of many features,
but the core idea has been proven quite definitively to work.

## {id="other-os"} What about Bedrock BSD or Bedrock Android or Bedrock Something-Else?

It should be noted that no other operating system family has such a disparate
variety of userlands which all run on the same kernel.  Bedrock Linux's
strengths wouldn't be nearly as beneficial anywhere else.  Attempting to do
something such as Bedrock Linux will inherently require leveraging
operating-system-specific tools, and so it may require a fair bit of additional
research to port Bedrock Linux's tools to another platform.
Bedrock Linux is still under heavily development and changes quite a bit
between releases.  It may be best to first wait for Bedrock Linux to settle on
one strategy before putting the efforts to port it elsewhere to avoid wasted effort.

BSD:

- Porting Bedrock Linux to one or more of the BSD operating systems may be
possible.
- Differences in things such as chroot(), namespaces, cgroup, etc may
make it take a fair bit of work.
- The Bedrock Linux FUSE utilites may "just work" on the BSDs.

Traditional-Linux-and-Android:

- Android's utilities may be dependent on Android's patches to the Linux
  kernel.  However, "traditional" Linux programs seem to run fine on the
  Android kernel.  Thus, any port of Bedrock Linux to android would likely
  require an Android kernel to be used.

- The Android file system layout is significantly different from traditional
  Linux distributions.  PATH and bind-mount system changes may be required.

- Android does some unusual things with its UID/GIDs.  For example, does not
  seem to be a UID-username map at /etc/passwd as one would expect from other
  Linux-based operating systems.  UID namespaces and brc-style translation
  programs may be necessary.

Android-on-Android:

- This may be possible.  Most of the issues mentioned for the other platforms
  are unlikely to happen here.

Windows:

- The low-level differences between Windows and Linux are quite significant,
  and thus the possibility does not seem promising; however, no serious
  investigation has been done to confirm this.

OSX:

- No investigation has been done into porting Bedrock Linux to OSX.
- If the BSDs look promising, at least Darwin could be possible.
