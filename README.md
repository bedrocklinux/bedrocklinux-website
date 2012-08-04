Bedrock Linux
=============

Bedrock Linux is a Linux distribution created with the aim of making most of
the (often seemingly mutually-exclusive) benefits of various other Linux
distributions available simultaneously and transparently.

If one would like a rock-solid stable base (for example, from Debian or a RHEL
clone) yet still have easy access to cutting-edge packages (from, say, Arch
Linux), automate compiling packages with Gentoo's portage, and ensure that
software aimed only for the ever popular Ubuntu will run smoothly - all at the
same time, in the same distribution - Bedrock Linux will provide a means to
achieve this.

See [the official Bedrock Linux
webpage](http://opensource.osu.edu/~paradigm/bedrock/) for installation
instructions, FAQ, known issues, etc.

The Perfect Linux Distribution
------------------------------


So you've decided to give this Linux thing a try. Which Linux distribution
should you choose? Do you want...

- Something extremely stable, such as Debian or a Red Hat Enterprise Linux clone?
- Something cutting-edge, such as Arch, Debian Sid, or Fedora Rawhide?
- Something extremely customizable, such as Gentoo or LinuxFromScratch?
- Something minimal, such as Tinycore or SliTaz?
- Something user-friendly, such as Mint?
- Something popular with lots of software developed with it in mind, such as Ubuntu?

Which features are important, and which are you willing to give up? If you want
(almost[^1l) everything - stable and cutting edge, customizable and minimal,
with access to popular-distro-only packages - Bedrock Linux is the Linux
distribution for you.

[^1]: Well, everything except for user-friendly. At the moment, Bedrock Linux
can not honestly be considered "user-friendly." 

Bedrock-Only Features
---------------------

In addition to doing (almost) anything any other Linux distribution can do,
there are a number of things Bedrock Linux can do which no other distribution
can.

- You can do a distro-upgrade (Debian 5 to 6, Ubuntu 12.04 to 12.10, etc),
  live, with almost no downtime. No need to stop your apache server, reboot,
  configure things while the server is down, etc.
- If a distro-upgrade breaks anything, no problem - the old release's program
  and settings can still be there, ready to go to pick up what it was doing
  before the distro-upgrade broke anything.
- Minimal stress from any given package failing to work - just use one from
  another Linux distribution. Packages feel disposable, like toothpicks. No
  need to fret over one breaking; just use another.


Real-World Examples Of Where Bedrock Linux Shines
-------------------------------------------------

These are all examples of real-world situations which came up while Bedrock
Linux was in development which showed quite clearly Bedrock's strength.

- When Quake Live's Linux release came out, there was a bug which only seemed
  to manifest itself against Debian's X11. The development team most likely
  tested against Ubuntu, and so the situation was resolved by using Ubuntu's
  X11 (and only that from Ubuntu, with the majority of the rest of the system
  remained Debian). Just as Debian was overly old for Quake Live at its
  release, Arch Linux users later faced the flip side of that coin: their
  cutting-edge libraries were causing issues with Quake Live. One way this was
  resolved was to play with LD_PRELOAD. Bedrock Linux users, however, could
  continue using Arch Linux's cutting-edge packages and use Quake Live without
  having to touch LD_PRELOAD.
- With only a few days to go before presenting Compiz at a local Free/Open
  Source Software enthusiast club, the presenter found Debian's video drivers
  for his laptop were overly old to support the 3D acceleration needed for
  Compiz. While Arch Linux's X11 video drivers were new enough, its Compiz
  package did not work at the time. Bedrock Linux allowed for a quick and easy
  solution: use Arch Linux's X11 with Debian's Compiz.
- Arch Linux was one of the few Linux distributions with the mathematics
  program Sage available in its repository. However, for a period of time Sage
  was dropped from the repository due to compatibility issues with Arch Linux.
  Sage is only pre-packaged for and tested against a handful of Linux
  distributions, one of which is Ubuntu. Thus all Bedrock Linux users had to do
  was to download it for Ubuntu. Arch Linux users had to struggle with the
  compatibility issues, and Ubuntu users never benefited from the period of
  time when Sage was available from a repository.

How Bedrock Linux Works
-----------------------

Bedrock's magic is based around filesystem and PATH manipulation.

### Chroot

A chroot changes the apparent filesystem layout from the point of view of
programs running within it. Specifically, it makes a chosen directory appear to
be the root of the filesystem. Think of it prepending a given string to the
beginning of every filesystem call. For example: 


- Firefox is located in /var/chroot/arch/user/bin/firefox.
- The following code is run: chroot /var/chroot/arch /usr/bin/firefox.
- To any executables launched as children of this one, all of their filesystem
  calls will have /var/chroot/arch added to their beginnings. That directory
  will be treated as though it is the root directory.
- As an initial child program, what would be located at /usr/bin/firefox if
  /var/chroot/arch is root is run. /usr/bin/firefox with /var/chroot/arch
  prepended to the front of it yields /var/chroot/arch/usr/bin/firefox, and
  thus the firefox executable located there is run.
- The newly launched firefox thinks it is located at /usr/bin/firefox
- When Firefox tries to load a file at /usr/lib/libgtk2.0-0, /var/chroot/arch
  is prepended to the call, and thus it actually gets the file located at
  /var/chroot/arch/usr/lib/libgtk2.0-0

Bedrock Linux retains within its own filesystem the full filesystems of other
Linux , each in their own directory. These other Linux distributions are
refered to as clients. If one would like to run a program from any given
client, via chroot, the program can be tricked into thinking that is running in
its native Linux distribution. It would read the proper libraries and support
programs and, for the most part, just work. 

### Bind Mounts

Linux can take mountable devices (such as usb sticks) and make their
filesystems accessible at any folder on the (virtual) filesystem. Mounting usb
sticks to places such as /media/usbstick or /mnt/usbstick is typical, but not
required - just about any directory will work. Linux can also mount virtual
filesystems, such as /proc and /sys. These do not actually exist on the
harddrive - they are simply a nice abstraction

Moreover, Linux can bind mount just about any directory (or file, actually) to
any other directory (or file). Think of it as a shortcut. This can "go through"
chroots to make files outside of a chroot accessible inside (unlike symlinks).

With bind mounts you can, for example, ensure you only have to maintain a
single /home on Bedrock. That /home can be bind mounted into each of the
chrooted client filesystems so that they all share it. If you arbitrarily
decide to stop using one client's firefox and start using another's, you can
keep using your same ~/.mozilla - things will "just work."

Through proper usage of chroots and bind mounts, Bedrock Linux can tweak the
filesystem from the point of view of any program to ensure they have access to
the files they need to run properly while ensuring the system feels integrated
and unified.

### PATH

Programs read your $PATH environmental variable to see where to look for
executables, and your $LD_LIBRARY_PATH for libraries. For example, with
PATH="/usr/local/bin:/usr/bin:/bin", when you attempt to run firefox, the
system will check for an executable named firefox in the following locations
(in the following order):

- /usr/local/bin/firefox
- /usr/bin/firefox
- /bin/firefox

Using a specialized $PATH variable, Bedrock Linux can have a program attempt to
run a (chrooted) program in another client Linux distribution rather than only
looking for its own versions of things. By changing the order of the elements
in the $PATH variable, search order can be specified. 

Design Choices
--------------

Due to Bedrock's unusual goals, several unusual design choices were made. These
choices were the reason Bedrock Linux needs to be its own distribution rather
than simply a system grafted onto another Linux distribution.

### Simplicity

Understanding Bedrock's filesystem layout (with the chroots, bind mounts, and
dynamic $PATH) can be quite confusing. Additionally, no user-friend standalone
installer with pre-compiled packages will be available for quite some time;
users will be required to compile Bedrock Linux "from scratch." Moreover, users
will have to maintain things on a very low level; they will be expected to, for
example, hand-edit the init files (reasoning explained later). In order to
ensure Bedrock Linux is viable for as many users as possible, everything which
does not have to be confusing or complicated should be made as simple as
possible.

Bedrock Linux thus choses some unusual packages. GRUB, the de-facto bootloader
for the vast majority of major Linux distributions, is a tad complicated.
Syslinux is significantly easier to setup and maintain by hand, and thus is the
"official" choice for Bedrock. However, GRUB should work fine, if the user
wants to figure out how to install and manage it himself. 

### Minimalism and Deferring Features

Most major Linux distributions have much larger and more experienced teams.
Where directly comparable, they are most likely better than the Bedrock Linux
developer at Linux-distribution-making. Thus, where possible, it is preferable
to use functionality from a client rather than Bedrock Linux itself. If
something can be deferred to a client it will be; Bedrock Linux only does what
it has to do to enable the integration of other Linux distributions.

### Statically-linked Executables

Typically, most executables refer to other libraries for their components. If
this is done at runtime, this is known as dynamic linking. By contrast, one can
(sometimes) statically link the libraries into the executable when compiling.

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
very people who are knowledgeable on the subject. For example, [Red Hat is
staunchly against it](https://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Developer_Guide/lib.compatibility.static.html):

> Static linking is emphatically discouraged for all Red Hat Enterprise
> Linux releases. Static linking causes far more problems than it solves,
> and should be avoided at all costs.

[Another link](http://www.akkadia.org/drepper/no_static_linking.html):

> Conclusion: Never use static linking!

The Bedrock Linux developer believes that Bedrock's unique situation creates a
justifiable exemption, but do your own research.

It should be noted that another Linux-distribution-in-progress, [stali from suckless](http://dl.suckless.org/stali/clt2010/stali.html)
, also makes heavy use of static compilition.

### Manual Client Init Scripts

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
seems far to challenging of a project. Thus, Bedrock Linux requires manually
setting which programs from which client's init is launched when. 

### Self-sufficient Booting

The Bedrock Linux developer feels strongly that


- Bedrock Linux should be able to boot and do (very) basic tasks without any
  clients.
- Bedrock Linux should be able to boot even if a client unexpectedly break.

This means that if one would like a client to do something required when
booting (for example, manage /dev), core Bedrock Linux will have to do this
first itself. Only later, after the essentials are done and the system is
functional, will the core Bedrock Linux stop its management of /dev and let a
client take over.

Package choices
---------------

### Kernel: Linux

No other operating system kernel has such a great variety of userland options
which could benefit from Bedrock's unique userland sharing system.

### Bootloader: Syslinux

This is the simplest bootloader the Bedrock Linux developer knows of. Setting
it up is just a handful of commands.

### Userland: Busybox

Busybox is an all-in-one solution for a minimal(/embedded) Linux userland. It
is significantly smaller and easier to set up than most of its alternatives.
Statically-linking it is relatively common, and it can be found in many Linux
distribution client repositories statically-compiled.

### Chroot: Capchroot

The standard chroot command requires root. If setuid'd it is quite possible to
use chroot to escalate privileges. Thus, Bedrock Linux requires a specialized
chroot package intended to be used by non-root users. The typical choice for
such things, schroot, was found to be overly large, complicated, and difficult
to compile statically. Instead, Bedrock Linux uses a little-known program
called capchroot. This still requires some patches to be compiled statically
linked against glibc, but is otherwise ideal.

### Shell scripts

Additionally, Bedrock Linux uses some of its own shell scripts (using busybox's
/bin/sh) for things such as booting and integrating the system. Since busybox
was already chosen, using its shell scripting option was an obvious choice. 

Bedrock Linux scripts
---------------------

### brc

brc is a front-end for capchroot and is the main way users will manually run
commands from clients. For example, brc fedora firefox will run Fedora's
firefox, even if the firefox command would normally default to another client's
firefox. brc will detect when preparation for setting up a client is needed and
automatically default to running a shell if no arguments are given.

### brs

brs will set up clients. This can be set to run automatically to avoid any
delay that would occure when trying to run brc to access a not-yet-setup
client.

### brp

Early versions of Bedrock Linux would try to detect if you tried to run a
command which isn't available and, on the fly, attempt to find the command in a
client. This proved to slow. Instead, Bedrock's brp command will hash the
available commands from within the client is run in.

### brl

The brl command will run its argument in all available clients. If, for
example, you want to test to ensure that all of your clients have internet
access, you ccould run the following: brl ping -c 1 google.com

### bru

Updating all of the clients is a very common task, and so bru was created to
make it a simple one. bru can be used to update all of the clients in a single
command.
