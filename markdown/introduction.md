Title: Bedrock Linux: Introduction
Nav: home.nav

# Introduction to Bedrock Linux

- [Search for the Perfect Linux Distribution](#search)
	- [What Bedrock Linux Does](#what_bedrock_does)
- [Real-World Examples of where Bedrock Linux Shines](#real_world)
- [How Bedrock Linux Works](#how_bedrock_works)
	- [Chroot](#chroot)
	- [Bind Mounts](#bind_mounts)
	- [PATH](#path)
- [Design Choices](#design_choices)
	- [Simplicity](#simplicity)
	- [Minimalism and Deferring Features](#minimalism)
	- [Statically-linked Executables](#statically_linked)
	- [Manual Client Init Scripts](#manual_ini)
	- [Self-sufficient Booting](#self-sufficient)
- [Package choices](#package_choices)
	- [Kernel: Linux](#linux)
	- [Bootloader: Syslinux](#syslinux)
	- [Userland: Busybox](#busybox)
	- [Chroot: brc ("BedRock Chroot")](#brc)
	- [Shell scripts](#shell_scripts)
- [Bedrock Linux Commands](#commands)
	- [brc ("BedRock Chroot")](#brc)
	- [brp ("BedRock Path")](#brp)
	- [brl ("BedRock aLl")](#brl)
	- [bru ("Bedrock Update")](#bru)
	- [brs ("BedRock Setup")](#brs)
	- [brsh ("BedRock SHell")](#brsh)
	- [bri ("BedRock Information")](#bri)
	- [brw ("Bedrock Where")](#brw)

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

### {id="what\_bedrock\_does"} What Bedrock Linux Does

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

### {id="bedrock\_only"} Bedrock-Only Features

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

## {id="real\_world"} Real-World Examples of where Bedrock Linux Shines

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

## {id="how\_bedrock\_works"} How Bedrock Linux Works

Bedrock's magic is based around filesystem and PATH manipulation.

### {id="chroot"} Chroot

A *chroot* changes the apparent filesystem layout from the point of view of
programs running within it. Specifically, it makes a chosen directory appear to
be the root of the filesystem. Think of it as prepending a given string to the
beginning of every filesystem call. For example:

- Firefox is located in `/var/chroot/arch/user/bin/firefox`.
- The following code is run: `chroot /var/chroot/arch /usr/bin/firefox`.
- The newly launched Firefox *thinks* it is located at `/usr/bin/firefox`
- When Firefox tries to load a file at `/usr/lib/libgtk2.0-0`,`
  /var/chroot/arch` is prepended to the call, and thus it actually gets the
  file located at `/var/chroot/arch/usr/lib/libgtk2.0-0`

Bedrock Linux retains within its own filesystem the full filesystems of other
Linux distros, each in their own directory. These other Linux distributions are
referred to as clients. If one would like to run a program from any given
client, via chroot, the program can be tricked into thinking that is running in
its native Linux distribution. It would read the proper libraries and support
programs and, for the most part, just work.

### {id="bind\_mounts"} Bind Mounts

Linux can take mountable devices (such as usb sticks) and make their
filesystems accessible at any folder on the (virtual) filesystem. Mounting usb
sticks to places such as `/media/usbstick` or `/mnt/usbstick` is typical, but
not required - just about any directory will work. Linux can also mount virtual
filesystems, such as `/proc` and `/sys`. These do not actually exist on the
harddrive - they are simply a nice abstraction.

Moreover, Linux can *bind mount* just about any directory (or file, actually) to
any other directory (or file). Think of it as a shortcut. This can "go through"
chroots to make files outside of a chroot accessible inside (unlike symlinks).

With bind mounts you can, for example, ensure you only have to maintain a
single `/home` on Bedrock. That `/home` can be bind mounted into each of the
chrooted client filesystems so that they all share it. If you decide to stop
using one client's firefox and start using another's, you can keep using your
same `~/.mozilla` - things will "just work."

Through proper usage of chroots and bind mounts, Bedrock Linux can tweak the
filesystem from the point of view of any program to ensure they have access to
the files they need to run properly while ensuring the system feels integrated
and unified.

### {id="path"} PATH

Programs read your `$PATH` environmental variable to see where to look for
executables, and your `$LD_LIBRARY_PATH` for libraries. For example, with
`PATH="/usr/local/bin:/usr/bin:/bin"`, when you attempt to run `firefox`, the
system will check for an executable named "firefox" in the following locations
(in the following order):

- `/usr/local/bin/firefox`
- `/usr/bin/firefox`
- `/bin/firefox`

Using a specialized `$PATH` variable, Bedrock Linux can have a program attempt to
run a (chrooted) program in another client Linux distribution rather than only
looking for its own versions of things. By changing the order of the elements
in the `$PATH` variable, search order can be specified. 

## {id="design\_choices"} Design Choices

Due to Bedrock's unusual goals, several unusual design choices were made. These
choices were the reason Bedrock Linux needs to be its own distribution rather
than simply a system grafted onto another Linux distribution.

### {id="simplicity"} Simplicity

Understanding Bedrock's filesystem layout (with the chroots, bind mounts, and
dynamic `$PATH`) can be quite confusing. Additionally, no user-friendly
standalone installer with pre-compiled packages will be available for quite
some time; users will be required to compile Bedrock Linux "from scratch."
Moreover, users will have to maintain things on a very low level; they will be
expected to, for example, hand-edit the init files (reasoning explained later).
In order to ensure Bedrock Linux is viable for as many users as possible,
everything which does not have to be confusing or complicated should be made as
simple as possible.

Bedrock Linux thus chooses some unusual packages. GRUB, the de-facto bootloader
for most major Linux distributions, is a tad complicated. Syslinux is
significantly easier to setup and maintain by hand, and thus is the "official"
choice for Bedrock. However, GRUB should work fine, if the user wants to figure
out how to install and manage it himself.

### {id="minimalism"} Minimalism and Deferring Features

Most major Linux distributions have much larger and more experienced teams.
Where directly comparable, they are most likely better than the Bedrock Linux
developer at Linux-distribution-making. Thus, where possible, it is preferable
to use functionality from a client rather than Bedrock Linux itself. If
something can be deferred to a client it will be; Bedrock Linux only does what
it has to do to enable the integration of other Linux distributions. 

### {id="statically\_linked"} Statically-linked Executables

Typically, most executables refer to other libraries for their components. If
this is done at runtime, this is known as *dynamic linking*. By contrast, one
can (sometimes) *statically link* the libraries into the executable when
compiling.

When using dynamically linked executables, the libraries for the executable
must be available at run time. This is why you can not simply take an
executable from one Linux distribution and run it on another - if the libraries
do not match what it was compiled against, it will not work. Statically linked
executables can, however, run just about anywhere irrelevant of libraries (of
course, one still needs the same kernel, CPU instruction set, etc).

In order to ensure the following items, Bedrock's core components are all
statically linked:

- It should be possible to run a core Bedrock Linux executable directly in any
  of the clients without worrying about chroots. This is especially important
  for the chroot program itself.
- It should be possible to compile a core Bedrock Linux component in any client
  Linux distribution which supports compiling statically-linked executables and
  simply dump it into place to update the component.

Note that clients may freely use dynamically linked executables; this is only
important for core Bedrock Linux components.

It should be noted that statically linked compiling is frowned upon by many
people who are knowledgeable on the subject. For example, [Red Hat is staunchly
against
it](https://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Developer_Guide/lib.compatibility.static.html):

> Static linking is emphatically discouraged for all Red Hat Enterprise Linux
> releases. Static linking causes far more problems than it solves, and should
> be avoided at all costs. 

Ulrich Drepper, notable glibc contributor and maintainer, [stated
emphatically](http://www.akkadia.org/drepper/no_static_linking.html):

> Never use static linking!

The Bedrock Linux developer believes that Bedrock's unique situation creates a
justifiable exemption, but do your own research. 

It should be noted that another Linux-distribution-in-progress, [stali from
suckless](http://dl.suckless.org/stali/clt2010/stali.html), also makes heavy
use of static compilition.

### {id="manual\_init"} Manual Client Init Scripts

Most Linux distributions automatically manage the programs which are run at
startup and shutdown, but Bedrock Linux will not be one of them for the
foreseeable future. It is quite possible (and, in fact, likely) that multiple
clients will have startup and shutdown scripts which conflict with those from
other clients. Moreover, there are a variety of Linux init systems, each of
which have their own system for ensuring the programs are launched in the
proper order to meet their prerequisites.

The Bedrock Linux developer has been unable to think of any sane way of
determining which init script to run when the clients conflict (which CUPS
daemon should run, if multiple are available?). Additionally, an automated way
to determine the launch order from all of the possible systems it will run into
seems far too challenging of a project. Thus, Bedrock Linux requires manually
setting which programs from which client's init is launched when.

### {id="self-sufficient"} Self-sufficient Booting

The Bedrock Linux developer feels strongly that

- Bedrock Linux should be able to boot and do (very) basic tasks without any
  clients.
- Bedrock Linux should be able to boot even if a client unexpectedly breaks.

This means that if one would like a client to do something required when
booting (for example, manage `/dev`), core Bedrock Linux will have to do this
first itself. Only later, after the essentials are done and the system is
functional, will the core Bedrock Linux stop its management of `/dev` and let a
client take over.

## {id="package\_choices"} Package choices

### {id="kernel\_linux"} Kernel: Linux

No other operating system kernel has such a great variety of userland options
which could benefit from Bedrock's unique userland sharing system.

### {id="bootloader\_syslinux"} Bootloader: Syslinux

This is the simplest bootloader the Bedrock Linux developer knows of. Setting
it up is just a handful of commands.

### {id="userland\_busybox"} Userland: Busybox

Busybox is an all-in-one solution for a minimal(/embedded) Linux userland. It
is significantly smaller and easier to set up than most of its alternatives.
Statically-linking it is relatively common, and it can be found in many Linux
distribution client repositories statically-compiled.

### {id="chroot\_brc"} Chroot: brc ("BedRock Chroot")

The standard `chroot` command requires root. If setuid'd or cap_sys_chroot'd it
is possible to use `chroot` to escalate privileges. Thus, Bedrock Linux
requires a specialized chroot command intended to be used by non-root users.
Moreover, it is beneficial to also have this program break out of a chroot
before entering another one to allow one chroot'd program launch a program in
another chrooted environment.  No existing command did both of these things,
and thus Bedrock Linux had to create its own, `brc`.  `brc` is largely based on
[capchroot](https://mailman.archlinux.org/pipermail/arch-dev-public/2009-July/012552.html).

### {id="shell\_scripts"} Shell scripts

Additionally, Bedrock Linux uses some of its own shell scripts (using
busybox's `/bin/sh`) for things such as booting and integrating the system.
Since busybox was already chosen, using its shell scripting option was an
obvious choice.

## {id="commands"} Bedrock Linux Commands

Note that these are the commands as they are at the time of writing (where
Bedrock Linux 1.0alpha2 is current release).  Since Bedrock Linux is still in
alpha, all of these are subject to change - in fact, there are plans to change
them for the next release.

### {id="brc"} brc ("BedRock Chroot")

`brc` provides the ability to run commands in clients, properly chrooting to
avoid conflicts.  Once Bedrock Linux is properly set up, it will allow the user
to transparently run commands otherwise not available in a given client.  For
example, if `firefox` is installed in a Arch client but not in a Debian client,
and a program from the Debian client tries to execute `firefox`, the Arch
`firefox` will be executed as though it were installed locally in Debian.

If `firefox` is installed in multiple clients (such as Arch and Fedora), and
the user would like to specify which is to run (rather than allowing Bedrock
Linux to chose the default), one can explicitly call `brc`, like so: `brc
fedora firefox`.

If no command is given, `brc` will attempt to use the user's current `$SHELL`.
If the value of `$SHELL` is not available in the client it will fail.


### {id="brp"} brp ("BedRock Path")

Very early (before any public release) versions of Bedrock Linux would try to
detect if you tried to run a command which isn't available and, on the fly,
attempt to find the command in a client. This proved to slow. Instead,
Bedrock's `brp` command will search for all of the commands available and store
them in directories which can be included in one's `$PATH` so that those
commands work transparently.  `/etc/profile` should include the relevant
directories in the `$PATH` automatically.


### {id="brl"} brl ("BedRock aLl")

The `brl` command will run its argument in all available clients. If, for
example, you want to test to ensure that all of your clients have internet
access, you could run the following: `brl ping -c 1 google.com`

### {id="bru"} bru ("Bedrock Update")

Updating all of the clients is a very common task, and so `bru` was created to
make it a simple one. `bru` can be used to update all of the clients in a
single command.  Note that eventually this will likely be replaced by a more
comprehensive package manager manager (not a typo) command.

### {id="brs"} brs ("BedRock Setup")

`brs` will set up the `share` items from `brclients.conf` in the client(s)
provided as (an) argument(s).  In Bedrock Linux 1.0alpha3, this is automatically
used at boot and rarely needs to be run by the user.  The exception is if a new
client is added or a share mount point accidentally removed, in which case the
user can simply call `brs ~(clientname~)`.  Unlike prior versions, this will
not check if a client has already been set up - do not run in a client which
has already been set up.

### {id="brsh"} brsh ("BedRock SHell")

Due to its purposeful minimalism, the core Bedrock Linux install only includes
busybox's very limited shells; users will most likely want to use a client's
shells by default. However, this raises three problems:

- What if the user needs to log into the core Bedrock's busybox's `/bin/sh`? For
  example, maybe the chroot system broke, or he/she is debugging a busybox
  update.
- What if the chroot system is fine but the client breaks? What if the user
  forgets that he/she uses the client's shell and removes the client?
- The typical Unix system used to determine which shell to run requires the
  full page to shells to be set within `/etc/passwd`. However, this path will
  likely change depending on which client is attempting to run the shell. For
  example, the core Bedrock Linux see `zsh` located at `/var/local/brpath/zsh`, but
  a Debian client will see the same `zsh` located at `/bin/zsh`. Having two
  differing paths for zsh like this will not work with a single login and the
  traditional Unix `/etc/passwd` system.

Bedrock Linux provides two options to resolve these issues:

1. Bedrock Linux has its own meta-shell, `brsh`, which will log in to a
configured client's shell, if available. If it is not available, it will
automatically drop to `/bin/sh` if it is available in the client, and if not,
then it drops down to the core Bedrock's `/bin/sh`. The path to `brsh` should
remain in the same location irrelevant of which client is running it, meaning
it will work in /etc/passwd while still allowing access to shells which have
changing paths.
2. The traditional Unix /etc/passwd allows creating multiple entries with
different login names and different shells but same password, home, etc, for
the same user. For example:

		root:x:0:0:root:/root:/opt/bedrock/bin/brsh
		brroot:x:0:0:root:/root:/bin/sh

This can be advantageous over `brsh` as (1) it should work if `brsh` fails to
detect a client has broken, and (2) it does not require logging in, changing
the `brsh` configuration file, then logging back out, and logging back in
again, if the user wants to directly log into the core Bedrock shell.


### {id="bri"} bri ("BedRock Information")

The `bri` command will provide information about the clients based on which
flag is used.

- `bri -l` will print a List of clients.
- `bri -n` will print the name of the client in which the command is run.
- `bri -p` will print the path of the client in which the command is run *if*
  no arguments are given.  Otherwise, it will print the paths of the clients
  provided in the argument.
- `bri -s` will print the shared mount points for a client.  It does not check
  if these are actually set up yet (from [brs](#brs)); it only prints the items
  listed in the brclients.conf for the respective client(s).  If no argument is
  provided, it will print for the client in which the command is run;
  otherwise, it will print for all clients.
- `bri -w` will print the client which will provide the command if it is not
  available locally.
- `bri -W` will print the client which will provides the command - either the
  client it is run in (ie, `bri -n`) if it is available locally or the output
  of `bri -w` if it is available in the brpath.
- `{class="rcmd"} bri -c` will cache the values of `-n` and `-p` to speed up
  future requests.  Note that this requires root.  It is recommended that this
  is run in newly made clients immediately after they are made.

### {id="brw"} brw ("Bedrock Where")

The `brw` command is simply an alias to `bri -n` for convenience.
