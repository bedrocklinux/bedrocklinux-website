Title: Bedrock Linux 1.0beta2 Nyla Quick Start
Nav: nyla.nav

Bedrock Linux 1.0beta2 Nyla Quick Start
=======================================

- [Notes](#notes)
- [Hijack installation](#hijack-install-method)
- [Compile userland](#compile-userland)
- [Acquire other strata](#acquire-strata)
- [Configure](#configure)
- [Manage users and groups](#manage-users-groups)
- [Configure fstab](#configure-fstab)
- [Configure bootloader](#configure-bootloader)
- [Reboot](#reboot)

## {id="notes"} Notes

The full Bedrock Linux installation procedure provides quite a lot of
flexibility.  This comes at the cost of substantial decision making during the
installation process.  For those who simply want to get started quickly, the
instructions below are a "quick start" which attempts to use sane default
options for most decisions.  Note that some options cannot be easily changed
post install; if you would prefer to do a "full" install read the full
[installation instructions](install.html).

Bedrock Linux is quite a bit different from other distributions, and just
following these instructions may be insufficient to fully understand and manage
the resulting system.   If you plan to use the resulting system as a daily
driver, it may be worthwhile to eventually skim [the other pages](index.html)
for this release of Bedrock Linux (1.0beta2 Nyla).  It is useful to know, for
example, the Bedrock Linux specific [lexicon defined here](concepts.html), be
aware of the [known issues](knownissues.html) and [troubleshooting
advice](troubleshooting.html) before you begin following the instructions
below.  Additionally, it may be best to skim all these installation
instructions before actually executing them.

## {id="hijack-install-method"} Hijack installation

The idea behind Bedrock Linux is to let the user utilize desirable parts of
other distributions.  This includes installation.  Thus, the first step in
installing Bedrock Linux is to actually install another distribution so that we
can utilize that distribution's techniques for things such as adding users,
partitioning, and even full disk encryption.  Once this is done, we can
"hijack" it and turn it into Bedrock Linux.  While not covered here, you can
even remove the original install's software, just retaining things like the
bootloader and partitioning scheme.

Go ahead and install some other "traditional" distro.  If you use a very simple
partitioning scheme, such as just one root partition and swap, you can skip
some later steps.  This is useful to expedite things and is in the spirit of
these "quick start" instructions.  More complicated partitioning schemes will
require additional configuration later.

*NOTE**:  At least one user reported Slackware's initrd does not respect "rw"
on the bootloader line.  This may make things a bit harder; for the time being
it may be advisable to pick another distro.  The "rw" requirement will be
dropped later to ensure Slackware becomes a viable option here.

Once you've installed it, boot into it and set up things such as your desired
users and network access.

## {id="compile-userland"} Compile userland

Next we need to compile the Bedrock Linux userland.  Now that you're running
the distro we're going to hijack into Bedrock Linux.  Install the following
build dependencies:

- gcc.  Note there is a bug in gcc 4.8.2 and 4.9.0 (and 4.9.1?) which will keep it from being able to properly compile one of Bedrock Linux's dependences, the musl libc.  Thus, it would be useful to pick a distro that can provide either an older or newer version of gcc, such as 4.7.X or below, or 4.9.2 or higher.
- make
- git version 1.8 or above.  This will be used to acquire source code, both
  Bedrock Linux's and source code for required third party software.
- standard UNIX tools such as sh, grep, sed, awk, and tar.
- autoconf (needed for FUSE)
- automake (needed for FUSE)
- libtool (needed for FUSE)
- gettext (needed for FUSE)
	- and possibly gettext-dev or gettext-devel depending on your distro
- fakeroot (for building tarball with proper permissions)

**There have been reports of difficulties building the tarball on musl-based
systems such as Alpine; until this is remedied the tarball easiest to build on
glibc based systems (which includes most major distros).**

As a normal user, acquire this release's source code:

- {class="cmd"}
- git clone --branch 1.0beta2 https://github.com/bedrocklinux/bedrocklinux-userland.git

Then build a Bedrock Linux userland tarball:

- {class="cmd"}
- cd bedrocklinux-userland
- make

If everything goes well, you'll have a tarball in your present working
directory.  Next we'll want to expand the tarball into the desired location.

As root, change directory to the root of the Bedrock Linux system then expand
the tarball.

- {class="rcmd"}
- cd /
- tar xvf ~(/path/to/bedrock-linux-tarball~)

`tar` does not track extended filesystem attributes, and `brc` requires a
special attribute to allow non-root users to utilize it.  To set this
attribute, run:

    {class="rcmd"} /bedrock/libexec/setcap cap_sys_chroot=ep /bedrock/bin/brc

Some initrds assume directories existing on the root filesystem.  Ensure these
directories exist to appease the initrds:

- {class="rcmd"}
- for dir in dev proc sys mnt root tmp var run bin; do mkdir -p /$dir; done

Additionally, many people are accustomed to debugging a system by setting
"init=/bin/sh".  Ensure this option exists:

- {class="rcmd"}
- [ -e /bin/sh ] || ln -s /bedrock/libexec/busybox /bin/sh

## {id="acquire-strata"} Acquire other strata

The hijacked distro is being converted into a ~{stratum~} which can provide a
base set of system files.  However, it may be desirable to have other
~{strata~} before continuing so that once you boot into Bedrock Linux you
already have a software from other distros ready to go.

The tarball you expanded in the previous step provided a minimal stratum called
"fallback" to use in case of emergencies.  It does not provide a kernel image,
but does provide things such as a minimal init system and shell.

Go [here](strata.html) to acquire other ~{strata~} then return to the
instructions here.  Consider opening that link in another tab/window.

## {id="configure"} Configure

Next we're going to do the bare minimum configuration necessary to use the
resulting system.

First you'll need a name to use to describe the files you acquired from the
hijacked distro.  The convention here is to use the name of the hijacked
distro's release (or just the distro's name of it is a rolling release).  For
example, if you installed and are hijacking Debian 8 "Jessie", the convention
is to use "jessie" as ~{rootfs~}' name.  If you've hijacked an Arch Linux
install, "arch" would be used.

Edit `/bedrock/etc/strata.conf`.  At the very bottom, append
the following:

    [~(stratum-name~)]
    framework = global

to the bottom of the file.  It should look something like:

    [jessie]
    framework = global

If the distro you're hijacking is using systemd, also append

    init = /lib/systemd/systemd

Otherwise, append

    init = /sbin/init

Thus, the resulting stanza you've appended could look like

    [jessie]
    framework = global
    init = /lib/systemd/systemd

or perhaps

    [crux]
    framework = global
    init = /sbin/init

Next, edit `/bedrock/etc/aliases.conf` and change:

    global = <DO AT INSTALL TIME>
    rootfs = <DO AT INSTALL TIME>

to

    global = ~(stratum-name~)
    rootfs = ~(stratum-name~)

This should be the same name you used in `strata.conf.`  For example:

    global = jessie
    rootfs = jessie

In a "full" install we'd have the option of making those two items different,
but for the quick start here we'll want them the same to keep things simple.

Make a directory in `/bedrock/strata` corresponding to this same name:

- {class="rcmd"}
- mkdir -p /bedrock/strata/~(stratum-name~)
- chmod a+rx /bedrock/strata/~(stratum-name~)

As well as some symlinks:

- {class="rcmd"}
- ln -s ~(stratum-name~) /bedrock/strata/rootfs
- ln -s ~(stratum-name~) /bedrock/strata/global

The tarball did not "install" quite all of the files it contained.  Copy the
rest of the files into place:

- {class="rcmd"}
- cp -rp /bedrock/global-files/* / && rm -r /bedrock/global-files

Confirm you've got a file at `/etc/adjtime`.  If it looks like you don't,
create one:

- {class="rcmd"}
- [ -e "/etc/adjtime" ] || printf '0.000000 0.000000 0.000000\n0\nUTC\n' > /etc/adjtime

If you already have a `/etc/sudoers` file, append a Bedrock Linux `$PATH`
setting to it:

- {class="rcmd"}
- [ -e "/etc/sudoers" ] && echo 'Defaults secure_path="/bedrock/bin:/bedrock/sbin:/bedrock/brpath/pin/bin:/bedrock/brpath/pin/sbin:/usr/local/bin:/opt/bin:/usr/bin:/bin:/usr/local/sbin:/opt/sbin:/usr/sbin:/sbin:/bedrock/brpath/bin:/bedrock/brpath/sbin"' >> /etc/sudoers

Otherwise, create a sudoers file to ensure, if you do get `sudo` later, the
`$PATH` is setup properly:

- {class="rcmd"}
- [ -e "/etc/sudoers" ] || printf 'Defaults secure_path="/bedrock/bin:/bedrock/sbin:/bedrock/brpath/pin/bin:/bedrock/brpath/pin/sbin:/usr/local/bin:/opt/bin:/usr/bin:/bin:/usr/local/sbin:/opt/sbin:/usr/sbin:/sbin:/bedrock/brpath/bin:/bedrock/brpath/sbin"\n\nroot ALL=(ALL) ALL\n' > /etc/sudoers
- chown root:root /etc/sudoers
- chmod 440 /etc/sudoers

Find the file corresponding to your timezone in `/usr/share/zoneinfo` and copy
it to `/bedrock/etc/localtime`:

- {class="rcmd"}
- cp -p /usr/share/zoneinfo/~(timezone-file~) /bedrock/etc/localtime

For example:

- {class="rcmd"}
- cp -p /usr/share/zoneinfo/America/New\_York /bedrock/etc/localtime

Ensure you have a global fstab

- {class="rcmd"}
- touch /etc/fstab

## {id="manage-users-groups"} Manage users and groups

Different `adduser` implementations have different flags.  For consistency,
users and groups will be added with the same Bedrock Linux-provided busybox
utility.  The provided busybox's shell is configured to prioritize its own
commands over those found in the `$PATH`.  Launch the shell:

- {class="rcmd"}
- /bedrock/libexec/busybox sh

To handle nuances of how shells are handled in a typical Linux system, Bedrock
Linux provides its own meta-shell, `brsh`, which can be configured to
immediately switch to some other, desired shell (e.g. bash or zsh).  Ensure
root is using brsh:

- {class="rcmd"}
- awk 'BEGIN{FS=OFS=":"} /^root:/{$NF = "/bedrock/bin/brsh"} 1' /etc/passwd > /etc/new-passwd
- mv /etc/new-passwd /etc/passwd

While `brsh` is very convenient for most instances, it may be wise to provide a
way to bypass it in case something goes wrong.  Add a new username "brroot" as
an alias to the root user which uses `/bin/sh`:

- {class="rcmd"}
- sed -n 's/^root:/br&/p' /etc/passwd | sed 's,:[^:]\*$,:/bin/sh,' >> /etc/passwd
- sed -n 's/^root:/br&/p' /etc/shadow >> /etc/shadow

Non-root users should use brsh as well:

- {class="rcmd"}
- awk 'BEGIN{FS=OFS=":"} /^~(username~):/{$NF = "/bedrock/bin/brsh"} 1' /etc/passwd > /etc/new-passwd
- mv /etc/new-passwd /etc/passwd

Optionally, provide a fall back for these non-root users:

- {class="rcmd"}
- sed -n 's/^~(username~):/br&/p' /etc/passwd | sed 's,:[^:]\*$,:/bin/sh,' >> /etc/passwd
- sed -n 's/^~(username~):/br&/p' /etc/shadow >> /etc/shadow

Next we'll need to add expected users and groups.  If you get a "in use" error,
this simply indicates you already have the user or group; no harm done.

- {class="rcmd"}
- addgroup -g 0 root
- addgroup -g 5 tty
- addgroup -g 6 disk
- addgroup -g 7 lp
- addgroup -g 15 kmem
- addgroup -g 20 dialout
- addgroup -g 24 cdrom
- addgroup -g 25 floppy
- addgroup -g 26 tape
- addgroup -g 29 audio
- addgroup -g 44 video
- addgroup -g 50 staff
- addgroup -g 65534 nogroup || addgroup -g 60000 nogroup
- adduser -h / -s /bin/false -D -H man || adduser -h / -s /bin/false -D -H -G man man
- addgroup input
- addgroup utmp
- addgroup plugdev
- addgroup uucp
- addgroup kvm
- addgroup syslog

It may be desirable to add your normal user to the "audio" and "video" groups:

- {class="rcmd"}
- addgroup ~(username~) audio
- addgroup ~(username~) video

If you plan to use systemd as your init at some point, even just temporarily,
it is a good idea to ensure some of the users and groups it expects exist, as
otherwise it may fail to boot.

- {class="rcmd"}
- adduser -h / -s /bin/false -D -H daemon || adduser -h / -s /bin/false -D -H -G daemon daemon
- adduser -h / -s /bin/false -D -H systemd-network || adduser -h / -s /bin/false -D -H -G network network
- adduser -h / -s /bin/false -D -H systemd-timesync || adduser -h / -s /bin/false -D -H -G timesync timesync
- adduser -h / -s /bin/false -D -H systemd-resolve || adduser -h / -s /bin/false -D -H -G resolve resolve
- adduser -h / -s /bin/false -D -H systemd-bus-proxy || adduser -h / -s /bin/false -D -H -G proxy proxy
- adduser -h / -s /bin/false -D -H messagebus || adduser -h / -s /bin/false -D -H -G messagebus messagebus
- adduser -h / -s /bin/false -D -H dbus || adduser -h / -s /bin/false -D -H -G dbus dbus
- addgroup daemon
- addgroup adm
- addgroup systemd-journal
- addgroup systemd-journal-remote
- addgroup systemd-timesync
- addgroup systemd-network
- addgroup systemd-resolve
- addgroup systemd-bus-proxy
- addgroup messagebus
- addgroup dbus
- addgroup netdev
- addgroup bluetooth
- addgroup optical
- addgroup storage
- addgroup lock
- addgroup uuidd

If you want to add any other users or groups, now is a good time.  Once you're
done, exit the busybox shell.

- {class="rcmd"}
- exit

## {id="configure-fstab"} Configure fstab

Bedrock Linux has two files that need to be updated for any partitions outside
of the typical root and swap partitions, `fstab` and the default `strata.conf`
framework.  If your partitioning scheme is more complicated than simply a root
filesystem and a bootloader, configure `/bedrock/etc/fstab` and the default
framework as described [here](configure.html#fstab) then return to these
instructions.  Consider opening that link in another tab or window.

## {id="configure-bootloader"} Configure bootloader

Finally, you will need to configure your bootloader.  This is the last major
step for the installation.

You'll want to change four things:

- Set/change the menu item's name to something you'll recognize for this
  install of Bedrock Linux, e.g.  "Bedrock Linux 1.0beta2 Nyla".

- Set it to use `/bedrock/sbin/brn` as the init.

- Set it to mount the root filesystem as read-write, not read-only.
  Boot-to-read-only is not supported in 1.0beta2 Nyla.

- Ensure no graphical splash screen is utilized (as this may mask Bedrock
  Linux's pick-an-init menu).

For example, if you are using GRUB2, edit:

    /etc/default/grub

and change

    GRUB_CMDLINE_LINUX=~(...~)

to

    GRUB_CMDLINE_LINUX="rw init=/bedrock/sbin/brn"

and

    GRUB_DISTRIBUTOR=~(...~)

to

    GRUB_DISTRIBUTOR="Bedrock Linux 1.0beta2"

If you see "splash" in any of the GRUB configuration lines, such as

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

remove it, leaving something like:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet"

Finally, run

- {class="rcmd"}
- update-grub

to have GRUB2 read and utilize the updated configuration.

With syslinux or LILO, just edit the relevant lines to change the menu item to
"Bedrock Linux 1.0beta2 Nyla" and add "rw init=/bedrock/sbin/brn" to the kernel
line, as well as ensure "splash" is unset.  For example, with syslinux, an
adjusted stanza may look like:

    LABEL nyla
        MENU LABEL Bedrock Linux 1.0beta2 nyla
        LINUX ../vmlinuz-3.16.0-4-amd64
        APPEND root=/dev/sda1 quiet rw init=/bedrock/sbin/brn
        INITRD ../initrd.img-3.16.0-4-amd64

## {id="reboot"} Reboot

At this point, everything should be good to go.  Just reboot into Bedrock Linux
and enjoy!

If you run into any difficulties, try reviewing the relevant documentation
pages for this release, and if that doesn't help sufficiently, don't hesitate
to drop into the [IRC channel](https://webchat.freenode.net/?channels=bedrock),
the [forums](http://www.linuxquestions.org/questions/bedrock-linux-118/), or
[subreddit](https://www.reddit.com/r/bedrocklinux).
