Title: Bedrock Linux 1.0alpha3 Bosco Installation Instructions
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Bosco Installation Instructions
=======================================================

Before beginning installation, be sure to at least skim [the other
pages](index.html) for this release of Bedrock Linux (1.0alpha3 Bosco).  Make
sure you're aware of, for example, the [known issues](knownissues.html) and
[troubleshooting advice](troubleshooting.html) before you begin following the
instructions below.

Note that there is no proper installer for this release of Bedrock Linux
(1.0alpha3 Bosco). Installation is done by manually collecting and compiling
the components, laying out the filesystem, adding the users, etc. Experienced
Linux users - those who are comfortable compiling their own software, know the
significance of the various parts of the filesystem directory layout, etc -
should not have overly much trouble, but those new to Linux or those who don't
want to get their hands dirty may wish to seek another Linux distribution for
their needs.

If you are currently using a previous version of Bedrock Linux, note that many
of the existing directories from your current installation may be used in this
release unaltered: `/home`, `/root`, `/boot`, `/bin`, `/sbin`, `/usr/bin`,
`/usr/sbin`, `/var/chroot` (or wherever you kept your clients). When these
directories come up in the following instructions, consider simply copying the
old values over the ones created here.  Additionally, it could be useful to
keep your configuration files, such as `brclients.conf` and `/etc/passwd`, to
reference.

- [Installation Host Environment](#installer-host)
- [Partitioning](#partitioning)
- [Mounting Bedrock's partitions](#mounting)
- [Creating the Userland](#userland)
- [Initial Client(s)](#initial-client)
- [Linux Kernel](#kernel)
- [Busybox](#busybox)
	- [Busybox test](#busybox-test)
- [Syslinux](#syslinux)
- [Fsck](#fsck)
- [Configuration](#configuration)
	- [Add users](#add-users)
	- [Hostname](#hostname)
	- [Bedrock-Specific Configuration](#bedrock-specific-config)
- [Post-reboot](#post-reboot)

## {id="installer-host"} Installation Host Environment

First, boot a Linux distribution from a device/partition other than the one on
which you wish to install Bedrock. This will be called the "installer host."
The installer host can be a LiveCD or LiveUSB Linux distribution (such as
Knoppix or an Ubuntu installer), or simply a normal Linux distribution on
another device or another partition on the same device.

Most major Linux distributions will work for installer host, provided they
support compiling tools such as `make`.  Distributions with ready access to
`debootstrap` (such as most major Debian-based distributions, Arch Linux
through AUR, Fedora, and others) are preferable if you would like a
Debian-based client, as they will make it relatively easy to acquire said
client through `debootstrap`.  The installer host should also have internet
access.  Arch Linux users have reported difficulties statically compiling with
libcap - if you are using Arch Linux, you might have to compile your own libcap
(perhaps with ABS) which supports statically compiling.

Be sure the installer host uses the same instruction set as you wish Bedrock
Linux to use. Specifically, watch out for (32-bit) x86 live Linux distribution
if you wish to make Bedrock Linux (64-bit) x86-64. While it is possible have
the installer host use a different instruction set from the targeted Bedrock,
it is a bit more work and not covered in these instructions.

If the computer on which you wish to install Bedrock Linux is slow, you may
find it preferable to use another computer to do the CPU-intensive compiling.
However, this will make some things - such as choosing which modules to compile
into the kernel - more difficult. These instructions do not cover compiling on
a separate machine from the one on which you wish to install.

## {id="partitioning"} Partitioning

Using partitioning software such as gparted or fdisk, partition the device on
which you wish to install Bedrock. Be very careful to only format bits and
bytes which you no longer need - a mistake here could blow away another
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
  will be accessed from client Linux distributions.
- You may want to consider making `/var/chroot` its own partition and giving it
  a lot of space, as this is the recommended location for storing the client
  Linux distributions.

Note which devices files correspond to which partitions of the Bedrock Linux
filesystem. These are normally located in `/dev`, and called `sdXN`, where `X` is a
letter a-z and `N` is a digit 0-9. This information will be used later to mount
these partitions.

Bosco has only been tested with the ext2 and ext3 filesystems, but any
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

Make a directory in which to mount Bedrock's fresh to partition(s). These
instructions assumes you are using ~(/mnt/bedrock~) for this. If you would like
to use something else, be sure to change ~(/mnt/bedrock~) accordingly whenever
it comes up in these instructions. In general, when you see anything formatted
~(like this~) that is a reminder that you should consider changing the content
rather than typing/copying it verbatim.

Note that this will become Bedrock's root
directory when you are done. As root:

	{class="rcmd"} mkdir -p ~(/mnt/bedrock~)

Mount the newly-created main/root partition. Replace ~(sdXN~) with the
corresponding device file to the main/root partition. As root:

	{class="rcmd"} mount /dev/~(sdXN~) ~(/mnt/bedrock~)

If you created more than one partition (other than swap) for Bedrock, make the
corresponding directories and mount them.  If you are upgrading from a prior
release of Bedrock Linux, and you have partitions which contain *only* a subset
of the following, they are probably safe to mount and use.  Be sure to back up
nonetheless - using pre-existing partitions has not been well tested and a
command below may wipe them.

- `/home`
- `/root`
- `/boot`
- `/bin`
- `/sbin`
- `/usr/bin`
- `/usr/sbin`

## {id="userland"} Creating the Userland

All of the Bedrock Linux userland which does not come from upstream is
available in a single tarball which you can download and untar.  Download the
[userland tarball from here](bedrock-userland-1.0alpha3.tar.gz) into
~(/mnt/bedrock~) and run the following to set it up:

- {class="rcmd"}
- tar xvf bedrock-userland-1.0alpha3.tar.gz
- make
- make install

If you receive errors about a missing library, such as `sys/capability.h`, or a
missing executable such as `setcap`, install the package which contains the
library or executable and try again.  At the time of writing on most major
Debian-based Linux distributions, these packages are `libcap-dev` and
`libcap2-bin`, respectively.  Arch Linux users have reported difficulties
statically compiling with `-lcap` - if you are using Arch Linux, you may have
to recompile libcap to support statically compiling.

Once you have run all of these command successfully, you can clean up
extraneous files with:

	{class="rcmd"} make remove-unnecessary

## {id="initial-client"} Initial Client(s)

New to Bosco is experimental support for using components from other Linux
distributions such as (and in fact, preferably from) clients.  It would thus be
useful to acquire your first client before continuing with creating the rest of
Bedrock Linux.  Instructions to acquire and set up clients are available
[here](clients.html).  You do not (yet) have to worry about configuring the
client - simply install it so that it is on disk (and its files are accessible)
After you have at least one client (although more is fine), continue reading
below.

## {id="kernel"} Linux Kernel

As was mentioned in the previous section, Bedrock Linux now has experimental
support for using a pre-existing kernel from another Linux distribution.
Kernels (along with their initrd and other files) from a number of Linux
distributions have been tested, but potential remains for untested ones to have
problems.  If you try this out with a kernel not mentioned below, jumping into [#bedrock on
freenode](http://webchat.freenode.net/?channels=bedrock) or [the
subreddit](http://reddit.com/r/bedrocklinux) to report success or failure with
any given Linux distribution's kernel would be appreciated.

- **Works**
	- Debian 6 Squeeze (Linux 2.6.32-5): `works`
	- Ubuntu 12.10 Precise Pangolin (Linux 3.2.0-23): `works`
	- Arch Linux (2012-12-22) (Linux 3.6.10-1): `works`
	- Gentoo (2012-12-29): `works`
	- Knoppix 7.0.4CD (Linux 3.4.9): `works`
		- Note: the initrd (minird) will attempt to load the knoppix userland from an image.  However, Knoppix's kernel (with the modules in `/lib/modules` seems to work fine without an initrd.
- **Does not work**
	- (N/A)

If you would prefer to compile your own kernel, the instructions from the
previous release to [download the source]( ../1.0alpha2/install.html#DOWNLOAD
Linux Kernel) and [compile/install the kernel](
../1.0alpha2/install.html#COMPILE Linux Kernel) are still valid; follow those.
When you have completed them, skip the rest of this section and continue in the
[next section below](#busybox).  If you would prefer to use the kernel from
another Linux distribution, continue reading here.

Using a kernel from a client is preferable to using one from a Linux
distribution which is not a client so that you can continue to use that client
as a source for the kernel as it updates the kernel, but non-clients should
work as well.

If you would like to use the kernel from a client you have but the client does
not (yet) have a kernel installed, you can access the client's package manager
by running the commands below.  Be sure to change
~(/mnt/bedrock/var/chroot/client~) to where you have placed the client in which
you would like to install the kernel.

- {class="rcmd"}
- cp /etc/resolv.conf ~(/mnt/bedrock/var/chroot/client~)/etc
- mount -t proc proc ~(/mnt/bedrock/var/chroot/client~)/proc
- mount -t sysfs sysfs ~(/mnt/bedrock/var/chroot/client~)/sys
- mount --bind /dev ~(/mnt/bedrock/var/chroot/client~)/dev
- mount --bind /dev/pts ~(/mnt/bedrock/var/chroot/client~)/dev/pts
- chroot ~(/mnt/bedrock/var/chroot/client~) /bin/sh

From there, run whatever commands are necessary to install the kernel.  For
example, for x86_64 Debian-based client run 
`{class="rcmd"} apt-get install linux-image-amd64`, or for an Arch Linux client run
`{class="rcmd"} pacman -S linux`. When you have finished, run the following
commands to clean up:

- {class="rcmd"}
- exit   #(to leave the chroot)
- umount ~(/mnt/bedrock/var/chroot/client~)/proc
- umount ~(/mnt/bedrock/var/chroot/client~)/sys
- umount ~(/mnt/bedrock/var/chroot/client~)/dev/pts
- umount ~(/mnt/bedrock/var/chroot/client~)/dev

Next, you must copy the relevant files from the location in the client Linux
distribution into the core of Bedrock Linux so they can be accessed while
booting.  If you are getting them from a client, they will likely be somewhere
such as ~(/mnt/bedrock/var/chroot/client~).  If you are using another source
such as the installer host you will have to determine where they are located.
The files are:

- The kernel image itself.  This is usually located in the `/boot`
  directory and called something along the lines of ~(vmlinuz-VERSION-ARCH~).
- If the distribution from which you are getting the kernel uses a initrd (as
  most major broad-audience and live distros do), you will probably also want to copy
  that over as well.  This is often called something along the lines of
  ~(initrd.img-VERSION-ARCH~) and located with the image in `/boot`.
- Optionally, the system map file.  Like the the kernel image, this is usually
  located in the `/boot` directory next to the kernel image.  It is and called
  something along the lines of ~(System.map-VERSION~).  Some Linux
  distributions provide this in the same package as the kernel image while
  others do not.  If you do not know what it is, you probably do not need it.
- Optionally, the `.config` file for the kernel.  This file is useful for
  creating a new kernel based on the previous kernel's configuration.  Like the
  last few items items, this is usually located in the `/boot` directory. It is
  usually called something along the lines of ~(config-VERSION-ARCH~).  Like
  the system map, if you do not know what it is you probably do not need it.
- The modules.  You will want to copy this even if you are sharing
  `/lib/modules` with this client (as you will otherwise be sharing the core's
  *empty* `/lib/modules` with the client).  Shared items from clients only
  propogate if they are installed *while sharing is in place after booting into
  Bedrock Linux itself*.  The directory you are looking for is usually in
  `/lib/modules` and called something along the lines of the version of the
  kernel they match.  Thus, if you grabbed `vmlinuz-2.6.32-5-686` from a client
  earlier for the image, you will want to copy the `/lib/modules/2.6.32-5-686`
  directory from the client into the same place in the core Bedrock Linux.
- Optionally, the firmware.  Many linux modules (such as wireless card drivers)
  require firmware which is usually installed into `/lib/firmware`.  Simply
  copy the contents of this directory in the client into the core's
  `/lib/firmware`.

## {id="busybox"} Busybox

Like with the kernel, Bedrock Linux now has experimental support for using
Busybox binaries from other Linux distributions such as (in fact, preferably)
from a client.

If you would prefer to compile your own Busybox, the instructions from the
previous release to [download the source]( ../1.0alpha2/install.html#DOWNLOAD Busybox)
and
[compile/install Busybox]( ../1.0alpha2/install.html#COMPILE Busybox)
are still valid; follow those until you get to

	{class="cmd"} ldd busybox

When you get there, return to this page and skip down to [busybox test
section](#busybox-test) below.  If you would prefer to use Busybox from another
Linux distribution (or just have difficulty statically compiling busybox),
continue reading here.

Static busyboxes from a number of Linux distributions have been tested, but
potential remains for untested ones to have problems.  If you try this out with
a static Busybox not mentioned below, jumping into [#bedrock on
freenode](http://webchat.freenode.net/?channels=bedrock) or [the
subreddit](http://reddit.com/r/bedrocklinux) to report success or failure with
any given Linux distribution's static busybox would be appreciated.

- **Works:**
	- Knoppix 7.04 (Busybox 1.20.2)
	- Debian Sid (on 2012-12-22) (Busybox 1.20.0-7)
	- Arch Linux (on 2012-12-22) (Busybox 1.20.0-7)
	- Gentoo (2012-12-29): `works`

- **Does not work**
	- Debian 6 Squeeze (Busybox 1.17.1-8)
		- `getty` seems to fail to call `login`
	- Ubuntu 12.10 Precise Pangolin (Busybox 1.18.5-1ubuntu4)
		- `getty` seems to fail to call `login`

There seems to be a trend where Busyboxes from Debian-based Linux distributions
prior to 1.20 have a bug with `getty/login`.  Presumably any 1.20 Busybox or
later will no longer have this issue.

If you would like to use a Busybox from a client you have but the client does
not (yet) have Busybox installed, you can access the client's package manager
by running the commands below.  Be sure to change
~(/mnt/bedrock/var/chroot/client~) to where you have placed the client in which
you would like to install the kernel.

- {class="rcmd"}
- cp /etc/resolv.conf ~(/mnt/bedrock/var/chroot/client~)/etc
- mount -t proc proc ~(/mnt/bedrock/var/chroot/client~)/proc
- mount -t sysfs sysfs ~(/mnt/bedrock/var/chroot/client~)/sys
- mount -- bind /dev ~(/mnt/bedrock/var/chroot/client~)/dev
- mount -- bind /dev/pts ~(/mnt/bedrock/var/chroot/client~)/dev/pts
- chroot ~(/mnt/bedrock/var/chroot/client~) /bin/sh

From there, run whatever commands are necessary to install busybox.  Note you
are looking for a *static* busybox - the package might be called something such
as `busybox-static`, although it might just be called `busybox`.  When you have
finished, run the following commands:

- {class="rcmd"}
- exit   #(to leave the chroot)
- umount ~(/mnt/bedrock/var/chroot/client~)/proc
- umount ~(/mnt/bedrock/var/chroot/client~)/sys
- umount ~(/mnt/bedrock/var/chroot/client~)/dev/pts
- umount ~(/mnt/bedrock/var/chroot/client~)/dev

The just-installed busybox is probably at
~(/mnt/bedrock/var/chroot/client/bin/busybox~).

If all of your clients have bad busyboxes, you could try using the installer
host's, or you could download a package containing a known good one and extract
busybox from the package.  For example, to download Debian Sid's busybox:

- Visit [The package page for Debian Sid's busybox-static](http://packages.debian.org/sid/busybox-static)
- Click the link for your architecture under `Download busybox-static` (e.g.: `amd64`)
- Download the package from one of the provided links provided to a directory you don't mind getting dirty such as ~(/tmp/busybox~)
- Run the following commands
	- {class="cmd"}
	- cd ~(/tmp/busybox~)
	- ar x busybox-static_~(version~).deb
	- tar xvf data.tar.gz
- Busybox will be available at ~(/tmp/busybox~)/bin/busybox
- You may move busybox out of ~(/tmp/busybox~) and remove that directory.

### {id="busybox-test"} Busybox test

You should now have a candidate busybox; either one you compiled from source,
one from a client or one from another distribution.

To make sure it will work, you need to test for four things:

1. That it is statically compiled
2. That it contains all of the required applets
3. That it supports "--install"
4. That it does not have a specific bug which appears to have been fixed in
Busybox 1.20.0

To test for these things, download [this script](busybox-test-1.0alpha3.sh),
set it to be executable (`chmod +x busybox-test-1.0alpha3.sh`) and run it with
the location of the busybox you are testing as an argument.  For example, if the
current working directory contains the busybox executable you are going to test,
download the test script there and run:

	{class="cmd"} ./busybox-test-1.0alpha3.sh ./busybox

If a test failed, you will have to find or compile another busybox.  See the
known-good busyboxes listed towards the top of [the busybox section](#busybox).

If all of the tests pass, you can continue by installing this busybox
executable into ~(/mnt/bedrock~).  `cd` into the directory which contains the
busybox executable and run:

- {class="rcmd"}
- cp ./busybox ~(/mnt/bedrock/~)/bin
- chroot ~(/mnt/bedrock~) /bin/busybox --install

Busybox should now be installed.

## {id="syslinux"} Syslinux

The exact choice of bootloader makes very little difference.  Syslinux is the
official Bedrock Linux bootloader primarily due to the fact it is relatively
simple and easy to set up by hand.  If you would prefer a different bootloader,
such as GRUB or LILO, and you are confident you are able to set it up (with
documentation from another source), you are welcome to use another bootloader.
If you are dual booting with another operating system which has its own
bootloader and you know how to add Bedrock Linux to the other operating
system's bootloader, you are welcome to do that as well.

Syslinux is both the name of a project which contains multiple bootloaders and
the name of one of the bootloaders within the project.  If you are using ext2,
ext3, ext4 or BTRFS as your filesystem, the "extlinux" bootloader from Syslinux
should suffice.  If you are using another filesystem which another filesystem
you can either look at another member of the Syslinux family which supports
your filesystem and continue below altering `extlinux` as necessary or find a
completely different bootloader.

Quick update notes: Syslinux seems to move files around between releases
without necessarily documenting it in the first place you'd look.  The
instructions here may be out-of-date and you may have to poke around.  For
example, since the time these instructions support for EFI has been added.  To
build for a BIOS (pre-EFI system), compile with `make bios` and look around in
a `bios` folder for mentioned files.  Look for `bios/extlinux/extlinux` and
`bios/mbr/mbr.bin` instead of whatever is mentioned below.

The following instructions are assuming you are using the extlinux member of
the Syslinux family.  If you are using another bootloader for whatever reason,
follow instructions for setting it up elsewhere and skip the rest of this
section.

Download Syslinux from [the official syslinux
website](http://www.syslinux.org/).  Bosco was tested successfully with
Syslinux 3.86 but newer versions should work.  If you are using BTRFS, you need
at least version 4.0.

If you are not using a LiveUSB/LiveCD but are using another partition on the
same machine as the one on which you are installing Bedrock Linux, avoid
shutting down the installer host part-way through these instructions to avoid
leaving yourself without a successfully set up bootloader and may have
difficulty resuming installation.

Change to the directory in which you placed downloaded Syslinux source.

	{class="cmd"} cd ~(/mnt/bedrock/src~)

Unpackage syslinux and change directories into the extlinux subdirectory in it:

- {class="cmd"}
- tar xvf syslinux-VERSION.tar.gz
- cd syslinux-VERSION

If you are using (32-bit) x86, you may use the compiled binary the package
which comes with the package. Otherwise, you will have to compile extlinux it
yourself. If you are not using (32-bit) x86 (or you would like to compile
syslinux for another reason), run the following:

	{class="cmd"} make clean; make

You may receive an error about lacking `nasm` or some other packages.  If so,
install those packages and try again.  If you receive other errors, note that
this will compile a number of things you do not need and there is a good chance
that the error was not with regards to extlinux. Check to see if extlinux
compiled successfully:

	{class="cmd"} ls extlinux/extlinux

If this returns a file, it compiled successfully, and you are free to install
extlinux. As root:

	{class="rcmd"} extlinux/extlinux --install ~(/mnt/bedrock~)/boot/extlinux

Although syslinux is installed on the partition, it still needs to be properly
set up on the harddrive itself. Find the corresponding device file for device
you made bootable when you partitioned/formatted earlier. Note that here we
aren't looking for the partition device file - `/dev/sd~(XN~)` - but rather the
device's file - `/dev/sd~(X~)`. There should be no 0-9 digit in the filename. As
root:

	{class="rcmd"} cat mbr/mbr.bin > /dev/sd~(X~) # change X accordingly

You may now want to copy several files to `~(/mnt/bedrock~)/boot/extlinux` which
syslinux needs for some of its features.

To use a simple menu when booting (as opposed to a commandline), copy `menu.c32`

	{class="rcmd"} cp com32/menu/menu.c32 ~(/mnt/bedrock~)/boot/extlinux

Or, if you'd prefer a fancy graphical menu, copy `vesamenu.c32`

	{class="rcmd"} cp com32/menu/vesamenu.c32 ~(/mnt/bedrock~)/boot/extlinux

To be able to poweroff from the boot menu (or commandline), copy `poweroff.com`:


	{class="rcmd"} cp com32/modules/reboot.c32 ~(/mnt/bedrock~)/boot/extlinux

Note that you can reboot with ctrl-alt-delete without `reboot.c32`.

To chain-load another operating system's bootloader (such as Microsoft
Windows), you will need `chain.c32`.

	{class="rcmd"} cp com32/modules/chain.c32 ~(/mnt/bedrock~)/boot/extlinux

Now you should create the configuration file for syslinux. Unlike GRUB,
syslinux must be configured by hand. Assuming you want a graphical menu, run
the following to get a basic menu in syslinux:

	{class="rcmd"} cat > /mnt/bedrock/boot/extlinux/extlinux.conf << EOF
	UI ~(menu.c32~)
	MENU TITLE Syslinux Bootloader
	DEFAULT Bedrock
	PROMPT 0
	TIMEOUT 50
	LABEL Bedrock
		MENU LABEL Bedrock Linux 1.0alpha3 Bosco
		LINUX ../~(vmlinuz-KERNEL-VERSION~)
		APPEND root=/dev/sd~(XN~) quiet ro
		~(INITRD ../initrd.img-VERSION~)
	EOF

Consider changing the following:

- Change ~(vmlinuz-KERNEL-VERSION~) to the filename of kernel image that you
  either compiled from source or acquired from another Linux distribution
- Change the `/dev/sd~(XN~)` to the partition you set to boot - either
  Bedrock's main/root partition or its `/boot` partition if you made one.
- If you either compiled an initrd or are using a kernel from another
  distribution which uses an initrd, you should probably include the ~(INITRD
  ../initrd.img-VERSION~) line, changing the filename to the filename of the
  initrd.  If you are not using an initrd and you are sure you have all of the
  modules required to boot built into the kernel you may leave the initrd line
  out of the file.
- You may also change ~(menu.c32~) to ~(vesamenu.c32~) for a fancier menu or
  remove the `UI ~(menu.c32~)` line completely for a command line interface.

If you would like to dual-boot with another operating system such as Windows,
append the following:

	{class="rcmd"} cat >> /mnt/bedrock/boot/extlinux/extlinux.conf << EOF
	LABEL ~(LABEL NAME~)
		MENU LABEL ~(Operating System Name~)
		COM32 chain.c32
		APPEND hd~(N N~)
	EOF

Consider changing the following from this addition:

- The ~(LABEL NAME~) is what Syslinux refers to this item - something short and
  simple such as "win7" should suffice.
- The ~(Operating System Name~) is what you will see for the item in the menu
  if you are using `menu.c32` or `vesamenu.c32`.  Something such as "Windows 7"
  should be fine.
- Finally, `hd~(N N~)` refers to the hard drive (the first number) and partiton
  (the second number) on which the bootloader you are chainloading is
  installed.  It appears both numbers are zero-indexed, but if this does not
  work for you try with them either or both of them being one-indexed.  For
  example, if the target operating system's bootloader is on `/dev/sda1` (the
  first partition on the first harddrive), you will want `hd0 0`.

## {id="fsck"} Fsck

The typical `fsck` executable itself is a front-end for filesystem-specific
executables.  If you want to have Bedrock Linux run `fsck` on boot as most
other major Linux distributions do, you will need to install the both the fsck
front-end and filesystem-specific executable(s) for your filesystem(s).  Note
that while this is recommended, it is optional - you can set "FSCK=0" in your
rc.conf to disable `fsck`, and in this case you do not need to install `fsck`.

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

To confirm that they were compiled statically, run

- {class="cmd"}
- ldd e2fsck/e2fsck
- ldd misc/fsck

and check that both commands output "not a dynamic executable".

To install the filesystem specific executable, simply copy it to what will be
Bedrock's `/sbin` with the names of the filesystems it supports (as root):

- {class="rcmd"}
- cp e2fsck/e2fsck ~(/mnt/bedrock/~)sbin/fsck.ext2
- cp e2fsck/e2fsck ~(/mnt/bedrock/~)sbin/fsck.ext3
- cp e2fsck/e2fsck ~(/mnt/bedrock/~)sbin/fsck.ext4

Busybox may or may not come with `fsck`.  The busybox tests above did not
ensure it existed.  If it does exist, you should have a file called `fsck` at
~(/mnt/bedrock/sbin/fsck~).  If this exists you may use it; otherwise, install
the `fsck` front-end you just compiled:

	{class="rcmd"} cp misc/fsck ~(/mnt/bedrock/~)sbin/fsck

## {id="configuration"} Configuration

All of the major components should be installed at this point; all that remains
is to edit the configuration files as desired.  The instructions to do so are
broken up into two parts:

- The instructions which are applicable to most Linux distributions - such as
  how to add users and set the system's hostname - are are below
- The instructions which are wholly unique to Bedrock Linux - such as
  configuration for clients - are on another page (so that they can be
  refrenced more conveniently outside of the context of installation).

### {id="add-users"} Add users

The userland tarball you installed earlier with two users, "root" and "brroot".
"root" is the normal root user.  "brroot" is actually the same user (both have
UID 0); it is simple an alternative login which will always log in to Bedrock
Linux's core rather than a shell from a client.  While "brroot" is not
required, it is quite useful as a fall-back in case the you would like to use a
shell from a client for root and that client breaks.

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

*If* the busybox you installed has the `adduser` command, you can run the
following to install additional users:

- {class="rcmd"}
- adduser ~(USERNAME~) -s /bedrock/bin/brsh -D
- passwd -a sha512 ~(USERNAME~)

If it does not, you will have to manually add the new users:

- {class="rcmd"}
- USERNAME=~(desired username~)
- UID=~(desired UID~)
- GID=~(desired GID~)
- echo "$USERNAME:x:$UID:$GID::/home/$USERNAME:/bedrock/bin/brsh" >> /etc/passwd
- echo "$USERNAME:x:15699:0:99999:7:::" >> /etc/shadow
- echo "$USERNAME:x:$GID:" >> /etc/group
- mkdir /home/$USERNAME
- chown $USERNAME:$USERNAME /home/$USERNAME
- passwd -a sha512 $USERNAME

If you are not sure what to put for `UID` or `GID`, note that both
traditionally start at `1000` for regular users and increment upwards as new
users are added.  Look at the contents of `/etc/passwd` and `/etc/group` to
find the lowest used `UID` and `GID` of at least `1000` already in use (if any)
and pick the next integer above that.

If you would like to create a "br-" version of these users which will use the
same password to log in but will always log in to the core of Bedrock Linux,
run the following for each user *once*:

- {class="rcmd"}
- cat /etc/passwd | sed 's/^~(USERNAME~):/br&/' | sed 's,:[^:]\*$,:/bin/sh,' >> /etc/passwd
- cat /etc/shadow | sed 's/^~(USERNAME~):/br&/' >> /etc/shadow

Once you have completed adding all of the desired users and setting their passwords, you may exit the chroot

	{class="rcmd"} exit

### {id="hostname"} Hostname

The default hostname is "bedrock-box".  To change this, edit
`~(/mnt/bedrock~)/etc/hostname` as desired.

Additionally, change "bedrock-box" in `~(/mnt/bedrock~)/etc/hosts` to your
desired hostname as well.

### {id="bedrock-specific-config"} Bedrock-Specific Configuration

See [the bosco configuration page](configure.html) for instructions on how to
configure Bedrock Linux specific functionality such as clients.


## {id="post-reboot"} Post-Reboot

Reboot into Bedrock Linux and run the last few commands to set it up.  Log in
as root and run:

	{class="rcmd"} brp

This will make commands from clients - such as `bash` - available both from the
core and other clients, assuming everything is set up properly.

Lastly, you might have to re-set capabilities on `brc`.  Earlier when you ran
`{class="rcmd"} make install`, make attempted to set the chroot capability on
`brc` to allow non-root users to use `chroot()` through `brc`.  For some reason
this may not stick; if that is the case, you'll have to re-do it here.  Try to
run a `brc` command (for example, `brc bedrock cat /etc/issue`) as a non-root
user.  If this gives you an error about setcap, install the relevant packages
into a client to provide the `setcap` command, possibly run
`{class="rcmd"} brp -a`, (or just `{class="rcmd"} brp`) and then run:

	{class="rcmd"} setcap cap_sys_chroot=ep /bedrock/bin/brc

Everything should be good to go.  If you run into any difficulties, try
reviewing the relevant documentation pages for this release, and if that
doesn't help sufficiently, don't hesitate to drop into the IRC channel or
subreddit.

Enjoy!
