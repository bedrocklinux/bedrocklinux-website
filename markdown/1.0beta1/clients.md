Title: Bedrock Linux 1.0beta1 Hawky Client Setup Instructions
Nav: hawky.nav

Bedrock Linux 1.0beta1 Hawky Client Setup Instructions
======================================================

These are instructions for installing other Linux distributions as ~{clients~}
within Bedrock Linux 1.0beta1 Hawky.

If you are reading this file while still going through the installation
instructions, the root of the Bedrock Linux system is mounted at
~(/mnt/bedrock~), and so you will want to install the ~{client~} into:

    ~(/mnt/bedrock~)/bedrock/clients/~(clientname~)

If you are reading while running a Bedrock Linux system, the root of the system
is mounted on the root directory, and so the ~{client~} should go in:

    /bedrock/clients/~(clientname~)

That directory should be ~{global~}, so you should be able to drop the files there
irrelevant of what ~{client~} accesses it.

See the [tips, tricks and troubleshooting](troubleshooting.html) page after
installing each of these for other advice about using the specific distribution
as a ~{client~}.

- [Any Linux Distribution](#any)
- [Debian-based Linux distributions](#debian-based)
- [Arch Linux](#arch)
- [Fedora](#fedora)
- [Gentoo Linux](#gentoo)

## {id="any"} Any Linux Distribution

If there are no instructions below specific to a Linux distribution which you
would like to make into a ~{client~} for your Bedrock Linux install, you can
usually fall back to installing the distribution through its normal
installation means. Once it is installed, you may simply copy its root
directory to `~(/mnt/bedrock~)/bedrock/clients`.  When installing the Linux
distribution by its normal means, be very careful when partitioning, and be
careful to avoid having the bootloader take over your system.

For example, if you install Slackware to a USB flash drive, you can mount the
USB flash drive in Bedrock Linux and copy its contents to
`~(/mnt/bedrock~)/bedrock/clients/slackware`.

However, this method requires rebooting as well as provides the possibility of
unintentionally wiping something important when partitioning or forcing you to
reinstall your bootloader, and thus the distro-specific instructions described
below may be preferable if available.

You may also be able to install a ~{client~} distribution in a virtual machine
which you can mount and copy the files out, or you can use a scripts or tools
used to build containers such as LXC.

## {id="debian-based"} Debian-based Linux distributions

The essentials of Debian-based Linux distributions can be installed through a
program called "debootstrap." Debootstrap is a shell script which can be easily
installed into almost every Debian-based Linux distribution, and is often
available in the repositories of non-Debian-based Linux distributions, such as
Fedora. While it is possible to install debootstrap (by first installing dpkg
and pkgdetails) into just about any other Linux distribution as well, it is not
covered here. Busybox's dpkg does not seem sufficient for debootstrap.

Boot into a Linux distribution which can run debootstrap, or use an existing
~{client~} which can use debootstrap in Bedrock Linux if available. LiveCD/LiveUSBs
such as Knoppix or an Ubuntu installer should work.

Ensure the pre-requisites for debootstrap are available. This can be done by
installing debootstrap through the distribution's package manager (which should
bring in its dependencies) if available. Next, download the .deb file for the
debootstrap specific to ~{client~} Linux distribution release you would like, or a
newer debootstrap .deb from the same distribution. For example, for Debian
Squeeze, grab the file made available from
[here](http://packages.debian.org/squeeze/debootstrap). If you are attempting
to use debootstrap from a non-debian-based Linux distribution, convert the .deb
file to the native package format with something such as the `alien` package.

Install the package. If on a debian-based system (as root):

	{class="rcmd"} dpkg -i debootstrap_~(VERSION~).deb

Make a directory in which to put the target ~{client~} Linux distribution.  If you
are doing this from something other than Bedrock, such as a LiveUSB/LiveCD, be
sure to mount the appropriate partition which you would like to contain your
~{client~} and create the directory in there.

	{class="rcmd"} mkdir ~(/mnt/bedrock~)/bedrock/clients/~(clientname~)

Use debootstrap to download and set up the target ~{client~} Linux distribution.

	{class="rcmd"} debootstrap --arch ~(ARCHITECTURE~) ~(RELEASE~) ~(PATH~) ~(REPOSITORY~)

For example, to install the (64-bit) x86\_64 Debian squeeze to
`/bedrock/clients/squeeze` using `http://ftp.us.debian.org/debian`:

- {class="rcmd"}
- debootstrap --arch amd64 squeeze ~(/mnt/bedrock~)/bedrock/clients/squeeze http://ftp.us.debian.org/debian

It may take a bit to download and unpackage the various components.

Check to see if it created a non-blank `/var/lib/dpkg/statoverride` file, and
if it did, delete the content (ie, leave a blank file in its place).  See [this
troubleshooting item](troubleshooting.html#statoverride).

- {class="rcmd"}
- echo -n "" > ~(/mnt/bedrock~)/bedrock/clients/~(clientname~)/var/lib/dpkg/statoverride

Don't forget to edit `/etc/apt/sources.list` and other ~{client~}-specific settings.

Finally, create a `/bedrock/etc/clients.d/~(clientname~).conf` file as explained
in [the configuration page](configure.html).

## {id="arch"} Arch Linux

There are three strategies to acquiring an Arch Linux ~{client~} at this point in
time.  Follow any of the methods below to acquire the files for Arch Linux,
placing them into `~(/mnt/bedrock~)/bedrock/clients/~(arch~)`.  Once you have
done so, you may still have to set up pacman - continue reading below.

- The archlinux-bootstrap tarballs.  Go to your favorite [Arch Linux
  mirror](https://www.archlinux.org/mirrors/status/) and look in the
  `iso/latest/` directory.  You should see two tarballs - one for i686 and the
  other for x86\_64.  Download and untar the one you want.  It will give you a
  "root.~(ARCH~)" directory - more/rename this to the name/location of the
  ~{client~} you want.
- The archbootstrap script, available [here](https://github.com/tokland/arch-bootstrap).
- The
  [arch-install-scripts](https://www.archlinux.org/packages/?name=arch-install-scripts)
  package contains a `pacstrap` script which can be used to bootstrap a Arch
  Linux system.  This is useful if you already have an Arch Linux system on
  hand to bootstrap another one.  Once you have pacstrap, you can install the
  arch ~{client~} with `{class="rcmd"} pacstrap -d ~(/mnt/bedrock~)/bedrock/clients/~(arch~) base
  base-devel`

Once you have the files, you may still have to setup pacman's keys.  Chroot
into the ~{client~}:

- {class="rcmd"}
- export CLIENT=~(arch~)
- cp /etc/resolv.conf ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/etc
- mount -t proc proc ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/proc
- mount -t sysfs sysfs ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/sys
- mount --bind /dev ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev
- mount --bind /dev/pts ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev/pts
- mount --bind /run ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/run
- chroot ~(/mnt/bedrock~)/bedrock/clients/$CLIENT /bin/sh

Run the following commands to setup pacman.  It may speed things up to use your
mouse and keyboard to help generate entropy.

- {class="rcmd"}
- pacman-key --init
- pacman-key --populate archlinux

When you have finished, run the following to clean up:

- {class="rcmd"}
- exit   #(to leave the chroot)
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/proc
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/sys
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev/pts
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/run

Edit the following two files to configure pacman to your liking:

- ~(/mnt/bedrock~)/bedrock/clients/~(arch~)/etc/pacman.d/mirrorlist
- ~(/mnt/bedrock~)/bedrock/clients/~(arch~)/etc/pacman.conf

Finally, create a /bedrock/etc/clients.d/~(arch~).conf file as explained
in [the configuration page](configure.html).

## {id="fedora"} Fedora

The Fedora project provides disk images containing the files of a Fedora
system.  Select your [prefered
mirror](https://mirrors.fedoraproject.org/publiclist/Fedora/) which has your
desired release.  In the mirror's directory, navigate to and download
`releases/~(release~)/Images/~(arch~)/Fedora-~(version~)-sda.raw.xz`.

Decompress the image with

`unxz Fedora-~(version~).raw.xz`

To mount the file we must find the offset to provide to `mount`.  `fdisk -l
fedora-~(version~).raw` will provide the relevant information: look for (1)
where the image "Start"s and (2) the "Unit" size.  The unit size is typically
512 - if you see that number in the "Units" line, that's probably what you
need.  Multiplying these two items together will provide you with the proper
offset.  Once you've found this, mount the Fedora image and copy the
information off to the desired mount point.

- {class="rcmd"}
- mkdir -p ~(/bedrock/clients~)/tmp/fedora-image-mount
- mkdir -p ~(/bedrock/clients~)/bedrock/clients/~(heisenbug~)
- mount -o ro,loop,offset=~($(expr 1953 \\\* 512)~) Fedora-~(version~)-sda.raw ~(/bedrock/clients~)/tmp/fedora-image-mount
- cp -drp ~(/bedrock/clients~)/tmp/fedora-image-mount/\* ~(/mnt/bedrock~)/bedrock/clients/~(heisenbug~)/

Finally, create a /bedrock/etc/clients.d/~(client-name~).conf file as explained
in [the configuration page](configure.html).

## {id="gentoo"} Gentoo Linux

Gentoo Linux provides a tarball of the userland, which makes installing it as a
Bedrock ~{client~} fairly simple. Note that this is a quick overview of the
steps required in getting Gentoo working as a Bedrock ~{client~}. For more
information on configuring and using Gentoo, consult the 
[Gentoo Handbook](http://www.gentoo.org/doc/en/handbook/).

To download the tarball, navigate to the
[Gentoo mirrorlist](http://www.gentoo.org/main/en/mirrors2.xml) and choose
the mirror that is closest to you. Once you've followed the link to the mirror,
navigate to `releases/amd64/autobuilds/current-stage3-~(arch~)` for 64-bit, or 
`releases/x86/autobuilds/current-stage3-~(arch~)` for 32-bit, and download the
appropriate stage3 tarball to the directory that Gentoo is being installed into.

Unpack the tarball.

- {class="cmd"}
- tar -xvjpf stage3-\*.tar.bz2 # Note the "-p" option

The next step is to configure `~(/bedrock/clients/gentoo~)/etc/portage/make.conf` file
so that you can compile the appropriate utilities using portage. For information
on how to optimize portage for comiplation on your machine, consult Gentoo's
[Compilation Optimization Guide](http://www.gentoo.org/doc/en/gcc-optimization.xml).

After configuring your compilation optimization variables, it is time to set up
the system so that you can chroot into it to finish the installation process.

- {class="rcmd"}
- export CLIENT=~(gentoo~)
- cp /etc/resolv.conf ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/etc
- mount -t proc proc ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/proc
- mount -t sysfs sysfs ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/sys
- mount --bind /dev ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev
- mount --bind /dev/pts ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev/pts
- mount --bind /run ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/run
- chroot ~(/mnt/bedrock~)/bedrock/clients/$CLIENT /bin/sh

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
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/proc
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/sys
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev/pts
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/dev
- umount ~(/mnt/bedrock~)/bedrock/clients/$CLIENT/run


Create a /bedrock/etc/clients.d/~(clientname~).conf file as explained
in [the configuration page](configure.html).
