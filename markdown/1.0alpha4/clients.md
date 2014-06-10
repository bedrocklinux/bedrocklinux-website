Title: Bedrock Linux 1.0alpha4 Flopsie Client Setup Instructions
Nav: flopsie.nav

Bedrock Linux 1.0alpha4 Flopsie Client Setup Instructions
=========================================================

These are instructions for installing other Linux distributions as clients
within Bedrock Linux 1.0alpha4 Flopsie.

See the [tips, tricks and troubleshooting](troubleshooting.html) page after
installing each of these for other advice about using the specific distribution
as a client.

- [Any Linux Distribution](#any)
- [Debian-based Linux distributions](#debian-based)
- [Arch Linux](#arch)
- [Gentoo Linux](#gentoo)
- [Fedora](#fedora)

## {id="any"} Any Linux Distribution

If there are no instructions below specific to a Linux distribution which you
would like to make into a client for your Bedrock Linux install, you can
usually fall back to installing the distribution through its normal
installation means. Once it is installed, you may simply copy its root
directory to ~(/mnt/bedrock~)/bedrock/clients.  When installing the Linux
distribution by its normal means, be very careful when partitioning, and be
careful to avoid having the bootloader take over your system.

For example, if you install Slackware to a USB flash drive, you can mount the
USB flash drive in Bedrock Linux and copy its contents to
~(/mnt/bedrock~)/bedrock/clients/slackware.

However, this method requires rebooting as well as provides the possibility of
unintentionally wiping something important when partitioning or forcing you to
reinstall your bootloader, and thus the distro-specific instructions described
below may be preferable if available.

## {id="debian-based"} Debian-based Linux distributions

The essentials of Debian-based Linux distributions can be installed through a
program called "debootstrap." Debootstrap is a shell script which can be easily
installed into almost every Debian-based Linux distribution, and is often
available in the repositories of non-Debian-based Linux distributions, such as
Fedora. While it is possible to install debootstrap (by first installing dpkg
and pkgdetails) into just about any other Linux distribution as well, it is not
covered here. Busybox's dpkg does not seem sufficient for debootstrap

Boot into a Linux distribution which can run debootstrap, or use an existing
client which can use debootstrap in Bedrock Linux if available. LiveCD/LiveUSBs
such as Knoppix or an Ubuntu installer should work.

Ensure the pre-requisites for debootstrap are available. This can be done by
installing debootstrap through the distribution's package manager (which should
bring in its dependencies) if available. Next, download the .deb file for the
debootstrap specific to client Linux distribution release you would like, or a
newer debootstrap .deb from the same distribution. For example, for Debian
Squeeze, grab the file made available from
[here](http://packages.debian.org/squeeze/debootstrap). If you are attempting
to use debootstrap from a non-debian-based Linux distribution, convert the .deb
file to the native package format with something such as the `alien` package.

Install the package. If on a debian-based system (as root):

	{class="rcmd"} dpkg -i debootstrap_~(VERSION~).deb

Make a directory in which to put the target client Linux distribution.  If you
are doing this from something other than Bedrock, such as a LiveUSB/LiveCD, be
sure to mount the appropriate partition which you would like to contain your
client and create the directory in there.

	{class="rcmd"} mkdir ~(/mnt/bedrock~)/bedrock/clients/~(clientname~)

Use debootstrap to download and set up the target client Linux distribution.

	{class="rcmd"} debootstrap --arch ~(ARCHITECTURE~) ~(RELEASE~) ~(PATH~) ~(REPOSITORY~)

For example, to install the (64-bit) x86_64 Debian squeeze to
`/bedrock/clients/squeeze` using `http://ftp.us.debian.org/debian`:

- {class="rcmd"}
- debootstrap --arch amd64 squeeze ~(/mnt/bedrock~)/bedrock/clients/squeeze http://ftp.us.debian.org/debian

It may take a bit to download and unpackage the various components.

Check to see if it created a non-blank `/var/lib/dpkg/statoverride` file, and
if it did, delete the content (ie, leave a blank file in its place).  See [this
troubleshooting item](troubleshooting.html#statoverride).

Don't forget to edit `/etc/apt/sources.list` and other client-specific settings.

Finally, create a /bedrock/etc/clients.d/~(clientname~).conf file as explained
in [the configuration page](configure.html).

## {id="arch"} Arch Linux

Note: Arch Linux changes rapidly, and so some of the details below may become
out of date.

There are two strategies to acquiring a Arch Linux client at this point in
time: The archbootstrap script and downloading the official arch linux image.

To try the archbootstrap script, go
[here](https://wiki.archlinux.org/index.php/Archbootstrap) and follow the
instructions to acquire the client's files.  Then proceed to configure the
client - things like setting up pacman's keys and the locale.  To utilize the
official Arch Linux image instead, follow the instructions below.

Arch Linux provides a compressed image of an environment suitable for
bootstrapping an Arch installation, similar to the typical installation
media that you can find on Arch Linux's website. Normally, this is used
to install Arch from the environment of another Linux installation, but
we're going to use it to create our chrooted Arch client. Before you begin,
take note of your architecture, and find a `pacman` mirror close to you.
This instruction will use the kernel.org mirror, although finding one
geographically close to you is recommended. More information can be
found on the [official Arch wiki](https://wiki.archlinux.org/index.php/mirrors#Unofficial_mirrors).

These instructions were tested from the core of Bedrock Linux with some
software from a Debian Squeeze client, but they should work just as well
on a LiveCD/LiveUSB.

Move into a temporary working directory:

- {class="cmd"}
- cd /tmp

Download and extract the bootstrap image:

- {class="cmd"}
- export ARCH=~(ARCH~) # Set to either "x86_64" to "i686"
- wget http://mirrors.kernel.org/archlinux/iso/~(2013.11.01~)/archlinux-bootstrap-~(2013.11.01~)-$ARCH.tar.gz
- tar xvf archlinux-bootstrap-~(2013.11.01~)-$ARCH.tar.gz

Prepare the mirrorlist:

- {class="cmd"}
- ~(vim~) root.$ARCH/etc/pacman.d/mirrorlist

Uncomment a mirror to download the base system from. It's a good idea to use
the same mirror as before here.

Chroot into the bootstrapping environment:

- {class="rcmd"}
- cp /etc/resolv.conf /tmp/root.$ARCH/etc
- mount --bind /proc /tmp/root.$ARCH/proc
- mount --bind /sys /tmp/root.$ARCH/sys
- mount --bind /dev /tmp/root.$ARCH/dev
- mount --bind /dev/pts /tmp/root.$ARCH/dev/pts
- mount --bind /run /tmp/root.$ARCH/run
- chroot /tmp/root.$ARCH/

Mount your chroot directory. These instructions will assume that this is a separate
partition, namely `/dev/sda2`. If not, mount the partition containing it on `/mnt`
and adjust the next mkdir command accordingly.

	{class="rcmd"} mount ~(/dev/sda2~) /mnt

Create a new directory in which to download and install the Arch Linux client:

	{class="rcmd"} mkdir -p ~(/mnt/arch~)

Initialize `pacman`'s gpg key database. Note that this command will take a *long time*
if you don't generate entropy for it. This usually involves randomly moving your
mouse for pressing random keyboard keys until the command completes.

	{class="rcmd"} pacman-key --init

Sync up the database to the existing Arch keys:

	{class="rcmd"} pacman-key --populate archlinux

Install the base system and dev tools to the directory specified earlier.
	
	{class="rcmd"} pacstrap -d ~(/mnt/arch~) base base-devel

After this command finishes, you can safely exit the chroot.

- {class="rcmd"}
- exit # exit chroot
- umount /tmp/root.$ARCH/dev/pts
- umount /tmp/root.$ARCH/dev
- umount /tmp/root.$ARCH/sys
- umount /tmp/root.$ARCH/proc
- umount /tmp/root.$ARCH/run

Clean up the temporary directory:

- {class="rcmd"}
- umount /tmp/root.$ARCH/mnt
- rm -rf /tmp/root.$ARCH
- rm /tmp/archlinux-bootstrap-~(2013.11.01~)-$ARCH.tar.gz

Create a /bedrock/etc/clients.d/~(clientname~).conf file as explained
in [the configuration page](configure.html).

Finally, note that the above method includes the "linux" package *but* it does
not seem to run the hook to create the initrd.  If you want to use Arch Linux's
kernel when booting, reinstall the "linux" package to have it create the initrd
for you to copy into place:

	{class="rcmd"} pacman -S linux

Or, alternatively, if you do not want to use the kernel, you can remove it to
save disk space:

	{class="rcmd"} pacman -R linux

## {id="gentoo"} Gentoo Linux

Gentoo Linux provides a tarball of the userland, which makes installing it as a
Bedrock client fairly simple. Note that this is a quick overview of the
steps required in getting Gentoo working as a Bedrock client. For more
information on configuring and using Gentoo, consult the 
[Gentoo Handbook](http://www.gentoo.org/doc/en/handbook/).

To download the tarball, navigate to the
[Gentoo mirrorlist](http://www.gentoo.org/main/en/mirrors2.xml) and choose
the mirror that is closest to you. Once you've followed the link to the mirror,
navigate to `releases/amd64/autobuilds/current-stage3` for 64-bit, or 
`releases/x86/autobuilds/current-stage3` for 32-bit, and download the
appropriate stage3 tarball to the directory that Gentoo is being installed into.

Unpack the tarball.

- {class="cmd"}
- tar -xvjpf stage3-*.tar.bz2 # Note the "-p" option

The next step is to configure `~(/bedrock/clients/gentoo~)/etc/portage/make.conf` file
so that you can compile the appropriate utilites using portage. For information
on how to optimize portage for comiplation on your machine, consult Gentoo's
[Compilation Optimization Guide](http://www.gentoo.org/doc/en/gcc-optimization.xml).

After configuring your compilation optimization variables, it is time to set up
the system so that you can chroot into it to finish the installation process.

- {class="rcmd"}
- cp /etc/resolv.conf ~(/bedrock/clients/gentoo~)/etc
- mount -t proc proc ~(/bedrock/clients/gentoo~)/proc
- mount -t sysfs sysfs ~(/bedrock/clients/gentoo~)/sys
- mount --bind /dev ~(/bedrock/clients/gentoo~)/dev
- mount --bind /dev/pts ~(/bedrock/clients/gentoo~)/dev/pts
- chroot ~(/bedrock/clients/gentoo~) /bin/sh

You will now install portage while inside the Gentoo chroot.

- {class="rcmd"}
- mkdir /usr/portage # portage will be installed here
- emerge-webrsync # download and install the latest portage snapshot
- emerge --sync # update the portage tree

Now, before installing anything with Gentoo, it is recommended that you choose
a system profile. This will set up default values for your `USE` variable, among
other things. You can view the available profiles with

- {class="rcmd"}
- eselect profile list

and set it by selecting the number associated with the desired configuration

- {class="rcmd"}
- eselect profile set ~(PROFILE~)

Finally, you may configure your `USE` flags in `/etc/portage/make.conf`. `USE`
flags are one of the most powerful features in Gentoo. They are keywords that
allow you to tell portage what dependencies and you would like to allow or
block from your system. For information on how to use `USE` flags, consult the
[USE flags](http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=2&chap=2)
section of the Gentoo Handbook.

It is recommended that you update your system to be compatible with your newly
configured `USE` flags. However before recompiling your system, you may want to
emerge `gentoolkit`, which provides the `revdep-rebuild` utility. This will
allow you to rebulid the applications that were dynamically linked to the
now-removed software but don't require them anymore.

- {class="rcmd"}
- emerge gentoolkit
- emerge --update --deep --with-bdeps=y --newuse world # update entire system
- emerge --depclean # remove orphaned dependencies
- revdep-rebuild # rebuild applications with broken dynamic links

Now that Gentoo is fully set up, exit the chroot and remove the mounts

- {class="rcmd"}
- exit   #(to leave the chroot)
- umount ~(/bedrock/clients/gentoo~)/proc
- umount ~(/bedrock/clients/gentoo~)/sys
- umount ~(/bedrock/clients/gentoo~)/dev/pts
- umount ~(/bedrock/clients/gentoo~)/dev

Create a /bedrock/etc/clients.d/~(clientname~).conf file as explained
in [the configuration page](configure.html).


## {id="fedora"} Fedora

The essentials of Fedora can be installed through the 2.X branch of a program
called `febootstrap`. Febootstrap is very similar in spirit to `debootstrap`,
simply intended for creating Fedora systems rather than Debian. Note that a 3.X
branch was created which is intended to create "supermin appliances"; use the
2.X branch instead. This may be difficult to find in the repositories of any
given Linux distribution, and thus it may be required to compile it from
source.

If you have access to a Linux distribution which has febootstrap 2.X in its
repositories, your you can find a febootstrap 2.X package which will work in a
distribution to which you have access, install it and run the following
command, at which point you will be done installing Fedora as a client (ie, you
can skip the rest of the steps below). Otherwise, you will have to skip this
step and following all of the following steps.

	{class="rcmd"} febootstrap fedora-~(RELEASE-NUMBER~)~(PATH~)

For example, to install Fedora 17 (beefy miracle) to `/bedrock/clients/beefy`:

	{class="rcmd"} febootstrap fedora-17 /bedrock/clients/beefy/

It may take a bit to download and unpackage the various components.

Boot or `brc` into a Linux distribution which will be used to compile febootstrap
and then later use febootstrap. Note that while most of the requirements for
febootstrap are fairly standard, it does require yum, which is in many but not
all of the major Linux distribution's repositories - chosing one of the
distributions which do will make things easier.

Download the latest febootstrap 2.X source from [here](http://people.redhat.com/~rjones/febootstrap/) to `/tmp`.

Untar the package.

- {class="cmd"}
- cd /tmp
- tar xvf febootstrap-~(VERSION~).tar.gz

Configure things. You may be warned you are missing requirements - install them
and try again.

- {class="cmd"}
- cd /tmp/febootstrap-~(VERSION~)
- ./configure

Compile febootstrap.

	{class="cmd"} make

If you receive an error about `-all-static`, note that at least one person who
had such an error reported some succes compiling febootstrap by commenting out
the line containing `init_LDFLAGS = -all-static` from
`/tmp/febootstrap-VERSION/helper/Makefile` and replacing it with `init_LDFLAGS
= -static.`

There is no need to properly install febootstrap, as it will run from
`/tmp/febootstrap-~(VERSION~)` just fine. However, it does depend on
executables which are found within `/tmp/febootstrap-~(VERSION~)` to be present
within the `PATH`.  Use febootstrap to download and set up the target client
Linux distribution.

	{class="rcmd"} PATH="$PATH:/tmp/febootstrap-~(VERSION~)"\
	./febootstrap fedora-~(RELEASE-NUMBER~) ~(PATH~)

For example, to install Fedora 17 (beefy miracle) to /bedrock/clients/beefy:

	{class="rcmd"} PATH="$PATH:/tmp/febootstrap-~(VERSION~)"\
	./febootstrap fedora-17 /bedrock/clients/beefy

Clean up the temporary febootstrap directory:

	{class="rcmd"} rm -rf /tmp/febootstrap-~(VERSION~)

Create a /bedrock/etc/clients.d/~(clientname~).conf file as explained
in [the configuration page](configure.html).
