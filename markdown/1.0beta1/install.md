Title: Bedrock Linux 1.0beta1 Hawky Installation Instructions
Nav: hawky.nav

Bedrock Linux 1.0beta1 Hawky Installation Instructions
=======================================================

Before beginning installation, be sure to at least skim [the other
pages](index.html) for this release of Bedrock Linux (1.0beta1 Hawky).  Make
sure you know, for example, the [terminology used here](concepts.html), are
aware of the [known issues](knownissues.html) and [troubleshooting
advice](troubleshooting.html) before you begin following the instructions
below.

If you are currently using a previous version of Bedrock Linux, note that many
of the existing directories from your current installation may be used in this
release unaltered: `/home`, `/root`, `/boot`, and `/bedrock/clients`.  Be sure
to also bring along `/etc/passwd`, `/etc/group` and `/etc/shadow` so the
UID/GIDs on disk in the ~{clients~} match up.

Additionally, it could be useful to keep your configuration files to reference

- [Installation Host Environment](#installer-host)
- [Partitioning](#partitioning)
- [Mounting Bedrock's partitions](#mounting)
- [Creating the Userland](#userland)
- [Acquiring source files](#acquiring-source)
	- [musl](#src-musl)
	- [linux headers](#src-linux)
	- [fuse](#src-fuse)
	- [busybox](#src-busybox)
	- [Linux capabilities](#src-cap)
- [Building the userland](#build-userland)
- [Acquiring a client](#acquire-client)
- [Install the Linux kernel](#kernel)
- [Install a bootloader](#bootloader)
- [Fsck](#fsck)
- [Configuration](#configuration)
	- [Add users](#add-users)
	- [Hostname](#hostname)
	- [Bedrock-Specific Configuration](#bedrock-specific-config)
	- [Post-Reboot](#post-reboot)

## {id="installer-host"} Installation Host Environment

First, boot a Linux distribution from a device/partition other than the one on
which you wish to install Bedrock Linux. This will be called the "installer
host." The installer host can be a LiveCD or LiveUSB Linux distribution (such
as Knoppix or an Ubuntu installer), or simply a normal Linux distribution on
another device or another partition on the same device.

Most major Linux distributions will work for installer host, provided they
support compiling tools such as `make`.  Distributions with ready access to
`debootstrap` (such as most major Debian-based distributions, Arch Linux
through AUR, Fedora, and others) are preferable if you would like a
Debian-based ~{client~}, as they will make it relatively easy to acquire said
~{client~} through `debootstrap`.  The installer host should also have internet
access.

Be sure the installer host uses the same instruction set as you wish Bedrock
Linux to use. Specifically, watch out for (32-bit) x86 live Linux distribution
if you wish to make Bedrock Linux (64-bit) x86-64. While it is possible have
the installer host use a different instruction set from the targeted Bedrock,
it is a bit more work and not covered in these instructions.

If the computer on which you wish to install Bedrock Linux is slow, you may
find it preferable to use another computer to do the CPU-intensive compiling.
These instructions do not cover compiling on a separate machine from the one on
which you wish to install.

**There have been reports of issues with hardened gcc toolchains, use a
"normal" gcc.**

**gcc 4.8.2 and 4.9.0 both contain an optimization bug which results in
difficulties with the libc library Bedrock Linux is using, musl.  At the time
of writing, Arch Linux has 4.9.0 and Ubuntu Trusty has 4.8.2; it is best to
avoid these.  Try to use an older gcc for the time being, such as from Ubuntu
Raring or the `gcc47` package in Arch's AUR.**

**If you are using a distro/release such as Arch which has gcc-4.7 available
but not as the "main" gcc, try setting the following environmental variables
before running any `bedrocklinux-installer` commands:**

- {class="cmd"}
- export CC=~(/usr/bin/gcc-4.7~)
- export GCC=$CC
- export REALGCC=$CC

**Some people have reported success with gcc 4.9.0 using
`CFLAGS=-fno-toplevel-reorder`, but this does not seem to work consistently.
Alternatively, you could disable all optimization with `CFLAGS=-O0`, which
should work more reliably but will also result in slower executables.  At the
moment using an older gcc without this bug is recommended instead of attempting
to disable optimization, but if you would like to stick with a gcc release
hampered by this bug and simply disable optimizations prepend the `CFLAGS` item
from above to every `./bedrocklinuxinstaller make` command.  For example:
`CFLAGS=-O0 ./bedrocklinuxinstaller make all`**

**See [here](http://www.openwall.com/lists/musl/2014/05/15/1) and
[here](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61144) for details.**

## {id="partitioning"} Partitioning

Using partitioning software such as gparted or fdisk, partition the device on
which you wish to install Bedrock Linux. Be very careful to only format bits
and bytes which you no longer need - a mistake here could blow away another
operating system with which you intended to dual-boot with Bedrock.

For the most part you are free to partition the system however you please. If
you are unsure of how to partition it, it is reasonable to use only two
partitions:

1. Your main partition for mounting the root directory (ie, `/`)
2. A swap partition.  Recommendations for swap sizes usually vary between equal
to your RAM size to two-and-a-half times your RAM size.

If you are comfortable with typical partitioning schemes for Linux - such as
making `/boot`, `/home`, etc their own partitions - you are free to do so.
Before doing so, note some unusual aspects of Bedrock's layout:

- `/usr` is not heavily used.  Rather, most of the software usually in `/usr`
  will be accessed from ~{client~} Linux distributions.
- You may want to consider making `/bedrock/clients` its own partition and
  giving it a lot of space, as this is where the ~{clients~} are stored.
- The root directory contains the "shared" items from the ~{clients~} in
  `/bedrock/clients`.  For example, in a typical Bedrock Linux setup `/tmp/`
  for the ~{clients~} is stored in the root's `/tmp`  Thus, you may still wish to
  provide a decent amount of space for the root and not assume everything will
  go into `/bedrock/clients`.

Note which devices files correspond to which partitions of the Bedrock Linux
filesystem. These are normally located in `/dev`, and called `sdXN`, where `X` is a
letter a-z and `N` is a digit 0-9. This information will be used later to mount
these partitions.

Hawky has only been tested with the ext2 and ext3 filesystems, but any
Linux-supported filesystem should work fine. If you choose to use something
other than ext2/3/4, be sure you know where to find (and how to set up)
corresponding fsck software and a bootloader which can work with that
filesystem, as these instructions will only cover ext2/3/4.

If you are dual-booting with another Linux distribution, wish to use that
distribution's bootloader, and know how to add Bedrock Linux to that
distribution's bootloader, be sure to keep the boot flag on the other
distribution's boot partition. If you would like to use Bedrock's bootloader,
be sure to set the boot flag on the proper partition (ie, either the Bedrock's
main/root partition or, if you made a special `/boot` partition, then the
`/boot` partition you made).

## {id="mounting"} Mounting Bedrock's partitions

Make a directory in which to mount Bedrock Linux's fresh partition(s). These
instructions assume you are using ~(/mnt/bedrock~) for this. If you would like
to use something else, be sure to change ~(/mnt/bedrock~) accordingly whenever
it comes up in these instructions. In general, when you see anything formatted
~(like this~) that is a reminder that you should consider changing the content
rather than typing/copying it verbatim.

Note that this will become Bedrock Linux's root directory when you are done. As
root:

	{class="rcmd"} mkdir -p ~(/mnt/bedrock~)

Mount the newly-created main/root partition. Replace ~(sdXN~) with the
corresponding device file to the main/root partition. As root:

	{class="rcmd"} mount /dev/~(sdXN~) ~(/mnt/bedrock~)

If you created more than one partition (other than swap) for Bedrock Linux,
make the corresponding directories and mount them.  If you are upgrading from a
prior release of Bedrock Linux, and you have partitions which contain *only* a
subset of the following, they are probably safe to mount and use.  Be sure to
back up nonetheless - using pre-existing partitions has not been well tested
and a command below may wipe them.

- `/home`
- `/root`
- `/boot`
- `/bedrock/clients`

## {id="userland"} Creating the Userland

The Bedrock Linux userland repository contains build scripts to install much of
the Bedrock Linux operating system.  Clone the latest version of the 1.0beta1
branch from git into ~(/mnt/bedrock~).  You may use a non-root user (as
permissions will be fixed later) for this.

- {class="cmd"}
- sudo chmod a+rwx ~(/mnt/bedrock~)
- git clone --branch 1.0beta1 https://github.com/bedrocklinux/bedrocklinux-userland.git ~(/mnt/bedrock~)/repo
- cp -r ~(/mnt/bedrock~)/repo/\* ~(/mnt/bedrock~)
- rm -rf ~(/mnt/bedrock/~)repo

## {id="acquiring-source"} Acquiring source files

The Bedrock Linux userland repository comes with a script,
`bedrocklinux-installer`, which in addition to compiling and installing the
userland can also acquire the required source code for you.  Note, however,
that the version of the files it gets are largely hardcoded and, if has not
been updated recently, may be lacking security or other important patches.
It may be advisable to find the upstream source code yourself.  However, newer
versions could change APIs and break things as well.

If you would like to have the installer get the source code for you, run

- {class="cmd"}
- cd ~(/mnt/bedrock~)
- ./bedrocklinux-installer source all

Once you've done that, you can skip on to [Building the userland](#build-userland").

If you'd like to hunt down the source yourself, continue reading this section.

All of the source code should be placed in `~(/mnt/bedrock~)/src`.  They can be
either in their own directory next to the existing directories for `brc`,
`bru`, etc, or in a (optionally compressed) tarball which, if you have GNU tar,
will be automatically untarred when needed.  Just make sure the directory or
tarball has the component's name it it.  For example, musl's source should have
a directory/tarball name containing "musl".

The musl libc library is required.  The project's website is available at:

[http://www.musl-libc.org/](http://www.musl-libc.org/)

Use the newest version from the 1.0.X series you can find here:

[http://www.musl-libc.org/download.html](http://www.musl-libc.org/download.html)

For example, at the time of writing the newest is 1.0.3:

    http://www.musl-libc.org/releases/musl-1.0.3.tar.gz

No testing has been done to see if the Bedrock Linux software works against
1.1.X or newer.

### {id="src-linux"} linux headers

The Linux kernel repository is required for the Linux header files.  A tarball
containing the latest Linux kernel should be found here:

[https://www.kernel.org/](https://www.kernel.org/)

### {id="src-fuse"} fuse

FUSE is required.  The project's website is available at:

[http://fuse.sourceforge.net/](http://fuse.sourceforge.net/)

At the time of writing, the 3.X version is still pre-release and has been found
to have some problems, and the 2.9.X release - 2.9.3 - was cut *just* before
the commit which includes support for musl.  Use the latest from the
`fuse_2_9_bugfix` branch - which should include the musl patch - or a tarball
of 2.9.4 or later.

Tarballs can be found here:

[http://sourceforge.net/projects/fuse/files/](http://sourceforge.net/projects/fuse/files/)

And the git repository should be available here:

    git clone git://git.code.sf.net/p/fuse/fuse fuse-fuse

### {id="src-busybox"} busybox

Busybox is required.  Tarball releases can be found here:

[http://www.busybox.net/](http://www.busybox.net/)

And the git repository should be available here:

    git clone git://busybox.net/busybox.git

### {id="src-cap"} Linux capabilities

The Linux Capabilities libraries and utilities are required.  The project's
website is at:

[https://sites.google.com/site/fullycapable/](https://sites.google.com/site/fullycapable/)

You can get a tarball here:

    https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2

Or use the git repo here:

- {class="cmd"}
- git clone git://git.kernel.org/pub/scm/linux/kernel/git/morgan/libcap.git

This release of Bedrock Linux was tested with version 2.24.

## {id="build-userland"} Building the userland

You will need the following items to build the userland:

- A typical Linux build stack with gcc and make
- libattr1-dev (for libcap)
- autoconf (for fuse)
- automake (for fuse)
- libtool (for fuse)
- gettext (for fuse)

On a Debian-based system, this should install everything required:

- {class="rcmd"} 
- apt-get install build-essential libattr1-dev libtool autoconf automake gettext

If you are on another system, install the equivalent packages.

To compile everything, run

- {class="cmd"}
- cd ~(/mnt/bedrock~)
- ./bedrocklinux-installer make all

If it does not complete successfully, look at the output the script generates
as well as the logs in the location indicated.  You may simply be missing a
dependency or third party source code.

To install everything, run (as root)

- {class="rcmd"}
- cd ~(/mnt/bedrock~)
- ./bedrocklinux-installer install all

You should now have everything required to use Bedrock Linux except the
following:

- ~{clients~}
- a kernel, modules, etc
- a bootloader
- fsck utility
- configuration

This process leaves a handful of files left over which are not used when
running the Bedrock Linux system, such as source code.  You may keep them if
you like - for example, to easily recompile a component.  If you would rather
remove them, run the following as root:

- {class="rcmd"}
- cd ~(/mnt/bedrock~)
- ./bedrocklinux-installer hard-clean


## {id="acquire-client"} Acquiring a client

Acquire at least one ~{client~} as described on [the client page](clients.html) and
return here.

## {id="kernel"} Install the Linux kernel

The ~{client~} acquired in the last step will provide the kernel for Bedrock Linux.

Most non-live distro's kernels will work.  The notable exception is
grsec-hardened ones.  grsec changes aspects of `chroot()` that Bedrock Linux's
design depends on.

Check your client came with a kernel:

	ls ~(/mnt/bedrock~)/bedrock/clients/~(client~)/boot

If so, you may skip this next step (up until "resume here").  Otherwise, chroot
into the ~{client~} and acquire a ~{client~} through its package manager:

- {class="rcmd"}
- export CLIENT=~(clientname~)
- cp /etc/resolv.conf ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/etc
- mount -t proc proc ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/proc
- mount -t sysfs sysfs ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/sys
- mount --bind /dev ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev
- mount --bind /dev/pts ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev/pts
- mount --bind /run ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/run
- chroot ~(/mnt/bedrock~)/bedrock/clients/$CLIENT /bin/sh

From here, run whatever commands are necessary to install the kernel.  For
example, on x86\_64 Debian-based ~{clients~}, run:

	{class="rcmd"} apt-get install linux-image-amd64

or for an Arch Linux ~{client~} run

	{class="rcmd"} pacman -S linux

When you have finished, run the following to clean up:

- {class="rcmd"}
- exit   #(to leave the chroot)
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/proc
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/sys
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev/pts
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/run

If you already had a kernel installed in the ~{client~}, resume here.

Next, you must copy the relevant files from the location in the ~{client~} into the
core of Bedrock Linux so they can be accessed while booting.

- The kernel image itself.  This is usually located in the `/boot`
  directory and called something along the lines of ~(vmlinuz-VERSION-ARCH~).
- If the distribution from which you are getting the kernel uses a initrd (as
  most major broad-audience do), you will probably also want to copy that over
  as well.  This is often called something along the lines of
  ~(initrd.img-VERSION-ARCH~) and located with the image in `/boot`.
- Optionally, the system map file.  Like the kernel image, this is usually
  located in the `/boot` directory next to the kernel image.  It is called
  something along the lines of ~(System.map-VERSION~).  Some Linux
  distributions provide this in the same package as the kernel image while
  others do not.  If you do not know what it is, you probably do not need it.
- Optionally, the `.config` file for the kernel.  This file is useful for
  creating a new kernel based on the previous kernel's configuration.  Like the
  last few items, this is usually located in the `/boot` directory. It is
  usually called something along the lines of ~(config-VERSION-ARCH~).  Like
  the system map, if you do not know what it is you probably do not need it.
- The modules.  You will want to copy this even if you are sharing
  `/lib/modules` with this ~{client~} (as you will otherwise be sharing the core's
  *empty* `/lib/modules` with the ~{client~}).  Shared items from ~{clients~} only
  propogate if they are installed *while sharing is in place after booting into
  Bedrock Linux itself*.  The directory you are looking for is usually in
  `/lib/modules` and called something along the lines of the version of the
  kernel they match.  Thus, if you grabbed `vmlinuz-2.6.32-5-686` from a ~{client~}
  earlier for the image, you will want to copy the `/lib/modules/2.6.32-5-686`
  directory from the ~{client~} into the same place in the core Bedrock Linux.
- Optionally, the firmware.  Many Linux modules (such as wireless card drivers)
  require firmware which is usually installed into `/lib/firmware`.  Simply
  copy the contents of this directory in the ~{client~} into the core's
  `/lib/firmware`.

## {id="bootloader"} Install a bootloader

Next you will need to setup Bedrock Linux to boot, either with its own
bootloader, dual-booting with another operating system's bootloader, or without
a bootloader.

If you have another operating system installed which can boot a Linux
distribution and know how to add Bedrock Linux to it, feel free to do so.

If you know how to boot Linux distributions without a bootloader (leveraging
EFI, for example), you can set that up instead of installing a bootloader.

Otherwise, you should install a bootloader.  If you have a preferred bootloader
which you know how to install, go ahead and use that one.  If you do not,
limited instructions for [installing syslinux/extlinux are available
here](syslinux.html).  Follow those instructions then return here.

## {id="fsck"} Fsck

The typical `fsck` executable itself is a front-end for filesystem-specific
executables.  If you want to have Bedrock Linux run `fsck` on boot as most
other major Linux distributions do, you will need to install the
filesystem-specific executable fsck should call for your filesystem(s).  Note
that while this is recommended, it is optional - you can set "FSCK=0" in your
rc.conf to disable `fsck`, in which case you do not need to install `fsck`.

For ext2, ext3 and ext4, you can find the source for the fsck executable at
[the sourceforge page](http://e2fsprogs.sourceforge.net/). If you would like
to use another filesystem, it should not be difficult to find the fsck for it
and install it instead, but these instructions do not cover it.

Change to the directory in which you placed the downloaded source, untar it and
enter the resulting directory:

- {class="cmd"}
- cd ~(/mnt/bedrock~)/src
- tar xvf e2fsprogs-~(VERSION~).tar.gz
- cd e2fsprogs-~(VERSION~)

Create a build directory and change directory into it:

- {class="cmd"}
- mkdir build
- cd build

Compile the fsck executables:

- {class="cmd"}
- LDFLAGS=-static ../configure
- LDFLAGS=-static make

To confirm that the desired executable was compiled statically, run

- {class="cmd"}
- ldd e2fsck/e2fsck

and check that the output is "not a dynamic executable".

To install the filesystem specific executable, simply copy it to what will be
Bedrock's `/sbin` with the names of the filesystems it supports (as root):

- {class="rcmd"}
- cp e2fsck/e2fsck ~(/mnt/bedrock~)/sbin/fsck.ext2
- cp e2fsck/e2fsck ~(/mnt/bedrock~)/sbin/fsck.ext3
- cp e2fsck/e2fsck ~(/mnt/bedrock~)/sbin/fsck.ext4

## {id="configuration"} Configuration

All of the major components should be installed at this point; all that remains
is to edit the configuration files as desired.  The instructions to do so are
broken up into two parts:

- The instructions which are applicable to most Linux distributions - such as
  how to add users and set the system's hostname - are are below.
- The instructions which are wholly unique to Bedrock Linux - such as
  configuration for ~{clients~} - are on another page (so that they can be
  referenced more conveniently outside of the context of installation).

### {id="add-users"} Add users

The userland repository defaults to having two users, "root" and "brroot".
"root" is the normal root user.  "brroot" is actually the same user (both have
UID 0); it is simple an alternative login which will always log in to Bedrock
Linux's core rather than a shell from a ~{client~}.  While "brroot" is not
required, it is quite useful as a fall-back in case the you would like to use a
shell from a ~{client~} for root and that ~{client~} breaks.

The next handful of command should be run in a chroot:

	{class="rcmd"} chroot ~(/mnt/bedrock~) /bin/sh

The root user (and brroot) both have default passwords of "bedrock".  To change
this to something else, run

	{class="rcmd"} passwd -a sha512

Note that this will only change root's password; the brroot login for the same
user will still have the default password.  To change brroot password to the
same thing, run:

- {class="rcmd"}
- cat /etc/shadow | awk '!/^brroot:/{print$0}/^root:/{print "br"$0}' > /tmp/tmpshadow; mv /tmp/tmpshadow /etc/shadow

Next, add normal user(s) as desired:

- {class="rcmd"}
- adduser -s /bedrock/bin/brsh -D ~(username~)
- passwd -a sha512 ~(username~)

Note that this seems to `chmod g+s /home/~(username~)`.  While this is not
necessarily a bad default, not everyone is a fan.  If you would rather not have
this, consider running `chmod -R g-s /home/~(username~)` now while there are
still only a few files in there.

If you would like to create a "br-" version of these users which will use the
same password to log in but will always log in to the core of Bedrock Linux,
run the following for each user *once*:

- {class="rcmd"}
- sed -n 's/^~(USERNAME~):/br&/p' /etc/passwd | sed 's,:[^:]\*$,:/bin/sh,' >> /etc/passwd
- sed -n 's/^~(USERNAME~):/br&/p' /etc/shadow >> /etc/shadow

Once you have completed adding all of the desired users and setting their
passwords, you may exit the chroot

	{class="rcmd"} exit

### {id="hostname"} Hostname

The default hostname is "bedrock-box".  To change this, edit
`~(/mnt/bedrock~)/etc/hostname` as desired.

Change "bedrock-box" in `~(/mnt/bedrock~)/etc/hosts` to your desired hostname
as well.

### {id="bedrock-specific-config"} Bedrock-Specific Configuration

See [the Hawky configuration page](configure.html) for instructions on how to
configure Bedrock Linux specific functionality such as ~{clients~}.

Note that Bedrock Linux uses mdev by default, not udev, and that many programs
- such as xorg and SDL2 programs - rely on udev to act as one would expect.
Seriously consider using udev [as described here](configure.html#udev).

### {id="Reboot"} Reboot

At this point, everything should be good to go.  Just reboot into Bedrock Linux
and enjoy!

If you run into any difficulties, try reviewing the relevant documentation
pages for this release, and if that doesn't help sufficiently, don't hesitate
to drop into the [IRC channel](https://webchat.freenode.net/?channels=bedrock).
