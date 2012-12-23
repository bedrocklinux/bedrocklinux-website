Title: Bedrock Linux 1.0alpha3 Installation Instructions
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Installation Instructions
=================================================

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
release unaltered:

- `/home`
- `/root`
- `/boot`
- `/bin`
- `/sbin`
- `/usr/bin`
- `/usr/sbin`

When these directories come up in the following instructions, consider simply
copying the old values over the ones created here.

Additionally, it could be useful to keep your configruation files, such as
`brclients.conf` and `/etc/passwd`, to reference.

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
access.

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
However, you may first want to skip down to [Creating the directory
structure](#directory-structure) before doing so to note some unusual aspects
of Bedrock's layout. Specifically, note that `/usr` is not heavily used.
Rather, most of the software usually in `/usr` will be accessed from client
Linux distributions. You may want to consider making `/var/chroot` its own
partition and giving it a lot of space, as this is the recommended location for
storing the client Linux distributions.

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
directory when we are done. As root:

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
`/mnt/bedrock` and run the following to set it up:

- {class="rcmd"}
- tar xvf bedrock-userland-1.0alpha3.tar.gz
- make
- make install

If you receive errors about a missing library, such as `sys/capability.h`, or a
missing executable such as `setcap`, install the package which contains the
library or executable and try again.  At the time of writing on most major
Debian-based Linux distributions, these packages are `libcap-dev` and
`libcap2-bin`, respectively.

Once you have run all of these command successfully, you can clean up
extraneous files with:

    {class="rcmd"} make remove-unnecessary

## {id="initial-client"} Initial Client(s)

New to Bosco is experimental support for using components from other Linux
distributions such as (and in fact, preferably from) clients.  It would thus be
useful to acquire your first client before continuing with creating the rest of
Bedrock Linux.  Instructions to acquire and set up clients are available
[here](clients.html).  After you have at least one client (although more is
fine), continue reading below.

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
- mount -- bind /dev ~(/mnt/bedrock/var/chroot/client~)/dev
- mount -- bind /dev/pts ~(/mnt/bedrock/var/chroot/client~)/dev/pts
- chroot ~(/mnt/bedrock/var/chroot/client~) /bin/sh

From there, run whatever commands are necessary to install the kernel.  When
you have finished, run the following commands:

- {class="rcmd"}
- exit   #(to leave the chroot)
- umount ~(/mnt/bedrock/var/chroot/client~)/proc
- umount ~(/mnt/bedrock/var/chroot/client~)/sys
- umount ~(/mnt/bedrock/var/chroot/client~)/dev/pts
- umount ~(/mnt/bedrock/var/chroot/client~)/dev

Next, you must copy the relevant files from the location in the other Linux
distribution into the core of Bedrock Linux so they can be accessed whiel
booting.  If you are getting them from a client, they will likely be somewhere
such as ~(/mnt/bedrock/var/chroot/client~).  If you are using another source
such as the installer host you will have to determine where they are located.
The files are:

- The kernel image itself.  This is usually located in the `/boot`
  directory and called something along the lines of ~(vmlinuz-VERSION-ARCH~).
- The system map file.  Like the last item, this is usually located in the
  `/boot` directory next to the kernel image.  It is and called something along
  the lines of ~(System.map-VERSION~).
- If the distribution from which you are getting the kernel uses a initrd (as
  most major broad-audience and live distros do), you will probably also want to copy
  that over as well.  This is often called something along the lines of
  ~(initrd.img-VERSION-ARCH~) and located with the image in `/boot`.
- Optionally, the `.config` file for the kernel.  This file is useful for
  creating a new kernel based on the previous kernel's configuration.
  Like the last few items items, this is usually located in the `/boot`
  directory. It is usually called something along the lines of ~(config-VERSION-ARCH~).
- The modules.  You will want to copy this even if you are sharing
  `/lib/modules` with this client (as you will otherwise be sharing the core's
  *empty* `/lib/modules` with the client).  Shared items from clients only
  propogate if they are installed *while sharing is in place after booting into
  Bedrock Linux itself*.  The directory you are looking for is usually in
  `/lib/modules` and called something along the lines of the version of the
  kernel they match.  Thus, if you grabbed `vmlinuz-2.6.32-5-686` from a client
  earlier for the image, you will want the `/lib/modules/2.6.32-5-686`
  directory.
- Optionally, the firmware.  Many linux modules (such as wireless card drivers)
  require firmware which is usually installed into `/lib/firmware`.  Simply
  copy the contents of this directory in the client into the core's
  `/lib/firmware`.

## {id="busybox"} Busybox

Like with the kernel, Bedrock Linux now has experimental support for using
kernels from other Linux distributions such as (in fact, preferably) from a
client.

If you would prefer to compile your own Busybox, the instructions from the
previous release to [download the source]( ../1.0alpha2/install.html#DOWNLOAD Busybox)
and
[compile/install the kernel]( ../1.0alpha2/install.html#COMPILE Busybox)
are still valid; follow those.  When you have completed them, skip the
rest of this section and continue in the [next section below](#syslinux).  If
you would prefer to use Busybox from another Linux distribution, continue
reading here.

Static busyboxes from a number of Linux distributions have been tested, but
potential remains for untested ones to have problems.  If you try this out with
a static Busybox not mentioned below, jumping into [#bedrock on
freenode](http://webchat.freenode.net/?channels=bedrock) or [the
subreddit](http://reddit.com/r/bedrocklinux) to report success or failure with
any given Linux distribution's static busybox would be appreciated.

- **Works:**
	- Knoppix 7.04 (Busybox 1.20.2)
	- Debian Sid (on 2012-12-22) (Busybox 1.20.0-7)

- **Does not work**
	- Debian 6 Squeeze (Busybox 1.17.1-8)
		- (`getty` seems to fail to call `login`)
	- Ubuntu 12.10 Precise Pangolin (Busybox 1.18.5-1ubuntu4)
		- (`getty` seems to fail to call `login`)

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

From there, run whatever commands are necessary to install busybox.  Note we
are looking for a *static* busybox - the package might be called something such
as `busybox-static`.  When you have finished, run the following commands:

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

You should now have a candidate busybox; either one you compiled from source,
one from a client or one from another distribution.

To make sure it will work, we need to run three tests.  First, we have to ensure it is static.  `cd` to the directory containing busybox and run the following:

	ldd ./busybox

If the output is `not a dynamic executable`, it is statically compiled.
Otherwise, you will have to find another busybox.  Next, we need to make sure
it has the minimum required applets.  To test for this, run:

	export MISSINGAPPLETS=""
	for APPLET in "\[" ar awk basename cat chmod chroot chvt clear cmp cp cut dd df dirname echo ed env expand expr false find free fsck getty grep head hostname hwclock id init install kill last length ln ls mdev mkdir more mount mt od passwd printf ps readlink reset rm route sed seq sh sleep sort split stat swapon sync tail time top touch true tty umount uname vi wc wget which xargs yes
	do
		if busybox | awk 'p==1{print$0}/^Currently/{p=1}' | grep "^$APPLET$"
		then
			MISSINGAPPLETS="$APPLET "
		fi
	done
	if [ -z "$MISSINGAPPLETS" ]
	then
		echo "OKAY"
	else
		echo "Missing: $MISSINGAPPLETS"
	fi

If the output is `OKAY`, this busybox has all of the required applets.
Otherwise you will have to find another busybox.

Finally, we need to ensure it has the `--install` argument.  Run:

	./busybox | grep -q -- "--install" | echo $?

If the output is `0`, it does; if it outputs `1` does not (unless it
is an older busybox, pre-1.20, in which case you can proceed pretending as
though it did succeed.)

If all three of the above tests turned out well, you can install this busybox.
Assuming your current working directory is still next to the busybox
executable, run:

- {class="rcmd"}
- cp ./busybox ~(/mnt/bedrock/~)/bin
- chroot ~(/mnt/bedrock~) /bin/busybox --install

If you received an error about `--install` not being available, you'll have to
find another busybox and repeat the tests.  Otherwise, if this command worked,
busybox is now installed.

## {id="syslinux"} Syslinux
