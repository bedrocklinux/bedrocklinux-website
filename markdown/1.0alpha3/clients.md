Title: Bedrock Linux 1.0alpha3 Bosco Client Setup Instructions
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Bosco Client Setup Instructions
=======================================================

These are instructions for installing other Linux distributions as clients
within Bedrock Linux 1.0alpha3.

See the [tips, tricks and troubleshooting](troubleshooting.html) page after
installing each of these for other advice about using the specific distribution
as a client.

- [Any Linux Distribution](#any)
- [Debian-based Linux distributions](#debian-based)
- [Arch Linux](#arch)
- [Fedora](#fedora)

## {id="any"} Any Linux Distribution

If there are no instructions below specific to a Linux distribution which you
would like to make into a client for your Bedrock Linux install, you can
usually fall back to installing the distribution through its normal
installation means. Once it is installed, you may simply copy its root
directory to where you would like the client to reside within Bedrock. When
installing the Linux distribution by its normal means, be very careful when
partitioning, and be careful to avoid having the bootloader take over your
system.

For example, if you install Slackware to a USB flash drive, you can mount the
USB flash drive in Bedrock Linux and copy its contents to
/var/chroot/slackware.

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

	{class="rcmd"} mkdir ~(/mnt/bedrock/var/chroot/clientname~)

Use debootstrap to download and set up the target client Linux distribution.

	{class="rcmd"} debootstrap --arch ~(ARCHITECTURE~) ~(RELEASE~) ~(PATH~) ~(REPOSITORY~)

For example, to install the (64-bit) x86_64 Debian squeeze to
`/var/chroot/squeeze` using `http://ftp.us.debian.org/debian`:

- {class="rcmd"}
- debootstrap --arch amd64 squeeze /var/chroot/squeeze http://ftp.us.debian.org/debian

It may take a bit to download and unpackage the various components.

Check to see if it created a non-blank `/var/lib/dpkg/statoverride` file, and
if it did, delete the content (ie, leave a blank file in its place).  See [this
troubleshooting item](troubleshooting.html#statoverride).

Don't forget to edit `/etc/apt/sources.list` and other client-specific settings.

## {id="arch"} Arch Linux

Arch Linux's package manager, `pacman`, can be used to setup a new Arch Linux
install in a folder in a manner similar to Debian's `debootstrap`. It is
possible to setup `pacman` and its requirements in a folder and then use it
through chroot, largely independent of the host Linux environment. From there,
it can be used to setup a new Arch Linux client for Bedrock Linux. This should
work from a client Linux distribution for Bedrock Linux or from a
LiveCD/LiveUSB.  Whether this works from the core of Bedrock Linux remains
untested.

Create and move into a temporary working directory:

- {class="cmd"}
- mkdir /tmp/archbootstrap
- cd /tmp/archbootstrap

Download and the required software.

- {class="cmd"}
- export ARCH=~(ARCH~) # Set to either "x86_64" to "i686"
- wget https://www.archlinux.org/packages/core/any/pacman-mirrorlist/download --trust-server-names
- for PACKAGE in pacman glibc gcc-libs binutils libssh2 curl gcc libarchive openssl xz expat gpgme zlib libassuan libgpg-error acl attr bzip2
- do
- wget https://www.archlinux.org/packages/core/$ARCH/$PACKAGE/download/ --trust-server-names
- done

Unpackage all packages

- {class="cmd"}
- `for PACKAGE in *.pkg.tar*`
- do
- tar xvf $PACKAGE
- done

Uncomment a mirror in `/tmp/archbootstrap/etc/pacman.d/mirrorlist` to use to
download Arch Linux.

Disable signiture verification. Open `/tmp/archbootstrap/etc/pacman.conf`, find
the line containing `SigLevel` under `[core]` and change the value to `Never`.
Note that this is only for the initial download of Arch Linux - it can continue
to use signiture verification like normal once installed as a Bedrock Linux
client.

Copy `/etc/resolv.conf` into the archbootstrap environment so it can resolve DNS.

	{class="cmd"} cp /etc/resolv.conf /tmp/archbootstrap/etc/

Update the archboostrap we've set up, just in case 

	{class="rcmd"} chroot /tmp/archbootstrap pacman -Syu

Create a new directory in which to download and install the Arch Linux client.
Note that this has to be within `/tmp/archbootstrap`. You can later move the
contents to where you prefer, or you can make a bind mount so everything
installed into this new directory actually goes where you want it to. Moreover,
ensure it includes the location for pacman's databases within it.

	{class="cmd"} mkdir -p /tmp/archbootstrap/arch/var/lib/pacman/local

Have pacman download its database information into the new directory. Note that
we are stripping off `/tmp/archbootstrap` because this is being run in a
chroot.

	{class="rcmd"} chroot /tmp/archbootstrap pacman -Sy -r /arch

By default, pacman checks if enough free space is available before unpackaging
things. However, the chroot and heavily-used bindmount environment seem to
confuse it. Comment out `CheckSpace` from `/tmp/archbootstrap/etc/pacman.conf`.
Despite doing that, however, it might still want to check to the filesystem
mounts. To ensure it doesn't error and abort when doing so, make the mount
information available:

	{class="rcmd"} cp /proc/mounts /tmp/archbootstrap/etc/mtab

Finally, mount a few key directories:

- {class="rcmd"}
- mkdir -p /tmp/archbootstrap/proc
- mount -t proc proc /tmp/archbootstrap/proc
- mkdir -p /tmp/archbootstrap/sys
- mount -t sysfs sysfs /tmp/archbootstrap/sys
- mkdir -p /tmp/archbootstrap/dev
- mount --bind dev /tmp/archbootstrap/dev
- mkdir -p /tmp/archbootstrap/dev/pts
- mount -t devpts devpts /tmp/archbootstrap/dev/pts

Install Arch Linux's base:

	{class="rcmd"} chroot /tmp/archbootstrap pacman -Su base -r /arch

It may take a bit to download and unpackage the various components. 

Unmount the mounts we created just before the install:

- {class="rcmd"}
- umount /tmp/archbootstrap/dev/pts
- umount /tmp/archbootstrap/dev
- umount /tmp/archbootstrap/sys
- umount /tmp/archbootstrap/proc

If you did not bind-mount `/tmp/archbootstrap/arch`, move
`/tmp/archbootstrap/arch` to where you would like the Arch client to reside.
Otherwise, unmount it so it is no longer accessible within
`/tmp/archbootstrap.`

	{class="rcmd"} mv /tmp/archbootstrap/arch ~(/var/chroot/arch~)

Clean up the temporary archbootstrap directory:

	{class="rcmd"} rm -rf /tmp/archbootstrap

Arch Linux is now installed as a client.  However, `pacman` still needs to be
set up.  Once you've added the client to `brclients.conf`, set up `pacman` by
running `brc`'ing into the client and running:

- uncomment a mirror in /etc/pacman.d/mirrorlist
- set up the pacman signiture keys via `{class="rcmd"} pacman-key --init`
  (while entering random characters into your keyboard in another window to
  generate entropy)
- populate the keys with `{class="rcmd"} pacman-key --populate archlinux`
- run your first update via `{class="rcmd"} pacman -Syu`

Finally, note that the above method includes the "linux" package *but* it does
not seem to run the hook to create the initrd.  If you want to use Arch Linux's
kernel when booting, reinstall the "linux" package to have it create the initrd
for you to copy into place:

	{class="rcmd"} pacman -S linux

Or, alternatively, if you do not want to use the kernel, you can remove it to
save disk space:

	{class="rcmd"} pacman -R linux

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

For example, to install Fedora 17 (beefy miracle) to `/var/chroot/beefy`:

	{class="rcmd"} febootstrap fedora-17 /var/chroot/beefy/

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

For example, to install Fedora 17 (beefy miracle) to /var/chroot/beefy:

	{class="rcmd"} PATH="$PATH:/tmp/febootstrap-~(VERSION~)"\
	./febootstrap fedora-17 /var/chroot/beefy

Clean up the temporary febootstrap directory:

	{class="rcmd"} rm -rf /tmp/febootstrap-~(VERSION~)
