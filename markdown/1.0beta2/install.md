Title: Bedrock Linux 1.0beta2 Nyla Installation Instructions
Nav: nyla.nav

Bedrock Linux 1.0beta2 Nyla Installation Instructions
=====================================================

- [Notes](#notes)
- [Hijack installation](#hijack-install-method)
- [Manual installation](#manual-install-method)
- [Compile userland](#compile-userland)
- [Install Bedrock Linux userland](#install-userland)
- [Acquire other strata](#acquire-strata)
- [Configure](#configure)
	- [Configure rootfs stratum](#configure-roofs)
	- [Configure global stratum](#configure-global)
	- [Configure time](#configure-time)
	- [Configure init](#configure-init)
- [Linux kernel and associated files](#kernel)
	- [/boot files](#boot-files)
	- [modules](#modules)
	- [firmware](#firmware)
- [Manage users and groups](#manage-users-groups)
- [Configure bootloader](#configure-bootloader)
- [Reboot](#reboot)

## {id="notes"} Notes

While installation (particularly via hijacking described below) is in some ways
improved from prior releases, it is still a relatively rough and hands-on
process.  If you are not an experienced Linux user it may be advisable to wait
for a future release where installation has been further polished.  If you wish
to press on despite concerns about insufficient experience, consider testing
first in a VM before committing a box to the process.

There are no explicit instructions for upgrading from a prior Bedrock Linux
release; the expectation at this point in the development cycle is a fresh
install.  However, most of your files can be backed up and moved over to the
new install unaltered, such as: `/home`, `/root`, `/boot`, and your ~{strata~}
in `/bedrock/clients`.  Be sure to also bring along `/etc/passwd`, `/etc/group`
and `/etc/shadow` so the UID/GIDs on disk in the ~{strata~} match up.

Before beginning installation, be sure to at least skim [the other
pages](index.html) for this release of Bedrock Linux (1.0beta2 Nyla).  Make
sure you know, for example, the Bedrock Linux specific [lexicon defined
here](concepts.html), are aware of the [known issues](knownissues.html) and
[troubleshooting advice](troubleshooting.html) before you begin following the
instructions below.  Additionally, it may be best to skim all these
installation instructions before actually executing them.

Throughout the instructions ~(this syntax~) is used to indicate something which
you should *not* copy exactly but instead substitute with something else.  What
you should substitute should be obvious from context.

Provided shell commands are prefixed with a `{class="cmd"} $` or
`{class="rcmd"} #` indicating they should be run as a normal user or a root
user, respectively.  These prefixes won't be selected by a mouse so that you
can easily copy multiple lines and paste them into a terminal.  If you do
copy/paste, be sure to change the aforementioned ~(substitution syntax~).  Also
note that copying from a web page and pasting directly into a terminal [can be
a bad idea](https://thejh.net/misc/website-terminal-copy-paste).

There are two general methods for installation:

- Hijack method: hijacking another distribution's installation.  Bedrock
  Linux's goal of allowing users to utilize software from various other distros
  includes installation.  The hijack method will allow typical installation
  steps such as partitioning, setting up a bootloader, setting up full disk
  encryption, etc to all be done via another distribution's installation
  software/documentation/techniques.  This is generally recommended for less
  experienced Linux users.  If you wish to utilize this method, [continue
  reading here](#hijack-install-method).

- Manual method: manually partition, set up a bootloader, etc.  This option was
  required in Bedrock Linux release before hijack installation was supported,
  and it has been retained for those who wish to continue using it.
  Documentation here is relatively sparse, as the focus for this release has
  gone towards supporting the new hijack installation method.  To use this
  installation method you should already know how to do things such as
  partition, set up a bootloader of your choice, and, if you wish to use full
  disk encryption, set that up as well, all with minimal assistance from
  Bedrock Linux documentation.  If you wish to utilize this method, [continue
  reading here](#manual-install-method).

## {id="hijack-install-method"} Hijack installation

While it may be possible to hijack some existing, long-used install, this has
not been well tested.  Instead, it may be advisable to install a fresh distro
and then hijack that.

If you are installing a new distro to hijack, you'll have to pick which
one.  Some background to help you make your choice:

- This process should work for most major, "traditional" distros (e.g. should
  work for Slackware, not for Android).  Some less traditional distros, such as
  Gobo and NixOS, have not yet been tested.  They may or may not work in this
  release.  There are plans to test and support them in future releases.

- This distro's installation will be responsible for partitioning, setting up a
  bootloader, and (optionally) things such as full disk encryption.  If you
  prefer a certain bootloader or want to use full disk encryption, that may
  influence your decision here.

- You may not necessarily have to keep around any of the distro's files (sans
  things like a bootloader).  Depending on how you set things up, you're
  welcome to remove the hijacked distro when you're done with the Bedrock Linux
  installation (or, certainly, you're welcome to keep the distro's files and
  use them as part of your Bedrock Linux system).  Thus, if there is a distro
  which provides an installation process you like, but you do not like the
  resulting system, that would be a viable choice here.  The main caveat is if
  you have some special partitioning scheme (e.g. full disk encryption), you
  may have special requirements for your kernel/initrd or init to utilize it
  that other distros may not be able to fulfill.  This will then require you
  retain the installation distro.

- You will need to compile a Bedrock Linux userland tarball.  While this can be
  done from another distro/machine and copied over to the installation distro
  install, it may be easier to have the installation distro compile it.  This
  will then require the installation distro can provide the following:

	- gcc.  Note there is a bug in gcc 4.8.2 and 4.9.0 (and 4.9.1?) which will keep it from being able to properly compile one of Bedrock Linux's dependences, the musl libc.  It would be useful to pick a distro that can provide either an older or newer version of gcc, such as 4.7.X or below, or 4.9.2 or higher.
	- make
	- git.  This will be used to acquire source code, both Bedrock Linux's
	  and source code for required third party software.
	- standard UNIX tools such as sh, grep, sed, awk, and tar.
	- autoconf (needed for FUSE)
	- automake (needed for FUSE)
	- libtool (needed for FUSE)
	- gettext (needed for FUSE)
	- fakeroot (for building tarball with proper permissions)

Once you've chosen the distro, install it and boot into it.  For the most part,
whatever you normally do during installation should be fine here.  If you like
to make multiple partitions for different directories, keep in mind that the
majority of your userland will end up in a new, Bedrock Linux-specific
directory at `/bedrock/strata/`.  You could make `/bedrock/strata` its own
partition, or perhaps make one for each ~{stratum~} that ends up in that
directory.  If you aren't sure what to do here, just follow the recommendations
provided by the distro you are installing.

Skip the manual installation instructions and continue reading the instructions
to [compile the userland](#compile-userland).  Note the instructions below
merge with the hijack installation method; they will mention things such as
"if you are doing a hijack install" or "if you are doing a manual install".

## {id="manual-install-method"} Manual installation

Boot into some distro that you can utilize to partition, set up a bootloader,
etc.  This can be a live distro (e.g. knoppix) or an existing install on a
partition other than the one you will install Bedrock Linux onto.  Be sure that
distro can provide the following requirements for compiling Bedrock Linux:

- gcc.  Note there is a bug in gcc 4.8.2 and 4.9.0 (and 4.9.1?) which will keep it from being able to properly compile one of Bedrock Linux's dependences, the musl libc.  Thus, it would be useful to pick a distro that can provide either an older or newer version of gcc, such as 4.7.X or below, or 4.9.2 or higher.
- make
- git.  This will be used to acquire source code, both Bedrock Linux's
  and source code for required third party software.
- standard UNIX tools such as sh, grep, sed, awk, and tar.
- autoconf (needed for FUSE)
- automake (needed for FUSE)
- libtool (needed for FUSE)
- gettext (needed for FUSE)
- fakeroot (for building tarball with proper permissions)

Partition via preferred tools, e.g. fdisk or gparted.

For the most part, whatever partitioning scheme you prefer for other distros
should be fine.  If you like to make multiple partitions for different
directories, keep in mind that the majority of your userland will end up in a
new, Bedrock Linux-specific directory at `/bedrock/strata/`.  You could make
`/bedrock/strata` its own partition, or perhaps make one for each ~{stratum~}
that ends up in that directory.  If you aren't sure what to do here, one big
partition for the root directory and a swap partition about 2.5 times your RAM
size should be fine.

Set up a bootloader.  Instructions for setting up syslinux are provided
[here](syslinux.html).  If you prefer something else, e.g. GRUB2, you'll have
to find instructions elsewhere.

While it should be possible to manually set up full disk encryption, RAID, etc;
no instructions are provided here to do so.  Either find instructions elsewhere
or use the hijack installation method with a distro that provides full disk
encryption, RAID, etc.

Mount the partitions wherever you like.  Note the instructions below merge with
the hijack installation method; they will mention things such as "if you
are doing a hijack install" or "if you are doing a manual install".

## {id="compile-userland"} Compile userland

Next you will need to compile the Bedrock Linux userland tarball.  If you are
doing a hijack install, you can do it from that install, or you could do it
from another machine/distro and copy it over.  If you plan to compile elsewhere
and copy over, be careful to ensure the CPU architecture is the same (e.g. both
are x86\_64, or both are x86, or both are ARMv7, etc).

You'll need the following dependencies:

- gcc.  Note there is a bug in gcc 4.8.2 and 4.9.0 (and 4.9.1?) which will keep it from being able to properly compile one of Bedrock Linux's dependences, the musl libc.  Thus, it would be useful to pick a distro that can provide either an older or newer version of gcc, such as 4.7.X or below, or 4.9.2 or higher.
- make
- git.  This will be used to acquire source code, both Bedrock Linux's
  and source code for required third party software.
- standard UNIX tools such as sh, grep, sed, awk, and tar.
- autoconf (needed for FUSE)
- automake (needed for FUSE)
- libtool (needed for FUSE)
- gettext (needed for FUSE)
- fakeroot (for building tarball with proper permissions)


As a normal user, acquire this release's source code:

- {class="cmd"}
- git clone --branch 1.0beta2 https://github.com/bedrocklinux/bedrocklinux-userland.git

Then build a Bedrock Linux userland tarball:

- {class="cmd"}
- cd bedrocklinux-userland
- make

If everything goes well, you'll have a tarball in your present working
directory.  If you compiled this on something other than the installation
distro, copy it over to the installation distro.

## {id="install-userland"} Install Bedrock Linux userland

As root, change directory to the root of the Bedrock Linux system.  If you are
doing a hijack install, this is your root directory (i.e. `/`).  If you are
doing a manual install, this is wherever you mounted it.

    {class="rcmd"} cd ~(/path/to/bedrock-linux/root~)

Then expand the tarball:

    {class="rcmd"} tar xvf ~(/path/to/bedrock-linux-tarball~)

This will create a `bedrock` directory.  If you are using the manual install,
make a symlink to this directory at `/bedrock`.  This is useful to ensure
uniformity throughout the instructions, as the same files can then be
referenced at the same path irrelevant of if you are doing a manual install, a
hijack install, or are currently running a Bedrock Linux system.  After you
have finished installing Bedrock Linux you are free to remove the symlink.
Thus, if you are doing a manual install, as root:

    {class="rcmd"} ln -s ~(/path/to/bedrock-linux/mount~)/bedrock /bedrock

`tar` does not track extended filesystem attributes, and `brc` requires a
special attribute to allow non-root users to utilize it.  To set this
attribute, run:

    {class="rcmd"} /bedrock/libexec/setcap cap_sys_chroot=ep /bedrock/bin/brc

## {id="acquire-strata"} Acquire other strata

Further down the instructions will include things like configuring which init
system to use.  Before doing that, it may be advisable to acquire the userlands
of other distros so that they are available to be used in the configuration as
you get farther into the instructions.  This is especially true if you are
doing the manual install so that you have at least one kernel image.

The tarball you expanded in the previous step provided a minimal stratum called
"fallback" to use in case of emergencies.  It does not provide a kernel image,
but does provide things such as a minimal init system and shell.

Go [here](strata.html) to acquire other ~{strata~} then return to the
instructions here.  Consider opening that link in another tab/window.

## {id="configure"} Configure

The instructions below do not go into full detail configuration; they just
cover the minimum you need to configure before booting into Bedrock Linux,
skipping some of the details on what is going on under-the-hood.  If you would
like further details on configuration, see [here](configure.html).

### {id="configure-roofs"} Configure rootfs stratum

All of Bedrock Linux's files have some corresponding ~{stratum~}.  `/boot`,
`/bedrock`, and if you are doing a hijack install, the hijacked
distro's files, are all in the ~{rootfs~} ~{stratum~}.

You'll need to come up with some other name for this ~{stratum~}.  Then, later,
~{rootfs~} will be aliased to this name so that either option will refer to the
same ~{stratum~}.  If you did a hijack install and are keeping the
hijacked distro's files, the convention here is to use the name of the
hijacked distro's release (or just the distro's name of it is a rolling
release).  For example, if you installed and are hijacking Debian 8
"Jessie", the convention is to use "jessie" as ~{rootfs~}' name.  If you are
doing a manual install, the convention is to use the Bedrock Linux release
name.  For this release, Bedrock Linux 1.0beta2 "Nyla", that is "nyla".

Edit `/bedrock/etc/strata.conf` and append:

    [~(rootfs-stratum-name~)]
    framework = default

to the bottom of the file.  It should look something like:

    [nyla]
    framework = default

This tells Bedrock Linux that you have a ~{stratum~} with the configured name,
as well as tells it what per-~{stratum~} configuration to use for this new
~{stratum~}.  It is recommended to use the default configuration for most
~{strata~}, with one exception: the ~{global~} ~{stratum~}.  It's possible (and
in fact, common) to have *both* ~{rootfs~} and ~{global~} aliases to the same
~{stratum~}.  If you do this, you'll have to return to this file and change
"default" to "~{global~}".

Next you need to tell Bedrock Linux that this new ~{stratum~} you added is
~{rootfs~} so Bedrock Linux will know where to look for ~{rootfs~} files such
as `/bedrock`.  Edit `/bedrock/etc/aliases.conf` and change:

    rootfs = <DO AT INSTALL TIME>

to

    rootfs = ~(rootfs-stratum-name~)

Make a directory in `/bedrock/strata` so the ~{stratum~}'s files can be
accessed via the ~{explicit~} path:

- {class="rcmd"}
- mkdir -p /bedrock/strata/~(rootfs-stratum-name~)
- chmod a+rx /bedrock/strata/~(rootfs-stratum-name~)

Finally, make a symlink in `/bedrock/strata` so the ~{rootfs~} alias can be
utilized when using the ~{explicit~} path.  As root:

- {class="rcmd"}
- ln -s ~(rootfs-stratum-name~) /bedrock/strata/rootfs

To make future commands easier, make a variable now that refers to ~{rootfs~}'s
current location.  If you are doing a hijack install (and, thus, are
currently running the install you are hijacking), your current root
directory is the ~{rootfs~}.  Thus:

- {class="rcmd"}
- export ROOTFS=/

Otherwise, if you are doing a manual install such that ~{rootfs~} is some mount
point other than your root directory, run:

- {class="rcmd"}
- export ROOTFS=~(/path/to/bedrock-linux/mount-point/~)

If you change shells, reboot, etc. at any point be sure to update the variable
as future installation commands reference it.

### {id="configure-global"} Configure global stratum

Bedrock Linux refers to a special set of files as ~{global~} files.  These
files are used for interaction between different ~{strata~} and include things
such as `/etc/passwd` and `/home`.  Just as `/bedrock` is associated with
~{rootfs~}, these ~{global~} files need to be associated with a ~{stratum~}.
This can be the same ~{stratum~} as your ~{rootfs~}, another distro/release's
~{stratum~}, or a fresh ~{stratum~} that contains nothing but the ~{global~}
files.  Consider:

- If you hijacked an install that you've already been using for a while
  (i.e.  not a fresh install) which has things such as users and dotfiles set
  up, you'll want to use the ~{rootfs~} as your ~{global~}
  ~{stratum~} to continue using things like your already setup `$HOME`
  directory.  Additionally, using a hijacked distro as *both* ~{rootfs~}
  *and* ~{global~} will make a latter installation step (placing various
  kernel-related files in the correct place) slightly easier.

- ~{global~} will hold key files you do not want to remove.  Placing them in
  their own ~{stratum~} frees up the option of removing other ~{strata~}'s
  files without risk of removing ~{global~} files.  Consider: if some distro
  release stops being supported, you may wish to remove a corresponding
  ~{stratum~}; if the ~{global~} files are there this could be problematic.

- If you already have ~{global~} files intermixed with another distro (e.g. prior
  Bedrock Linux release, or even prior other distro install), you can use that
  distro as its own ~{stratum~} and continue to use the ~{global~} files from
  within it.

Once you've made your choice, you'll also need a name for the ~{stratum~}
(provided you're not reusing an existing, configured ~{stratum~} such as
~{rootfs~}).  If this is a fresh ~{stratum~} that just contains the ~{global~}
files, the convention is to call it "~{global~}" and avoid creating an alias
for it.  Otherwise, the convention is to use the distro's release (or distro's
name if it is a rolling-release), e.g. "jessie" or "vivid", then create the
~{global~} alias for it.

If you are not reusing an existing, configured ~{stratum~} (e.g. ~{rootfs~}),
you'll need to make a directory for the ~{global~} ~{stratum~}'s ~{explicit~} path:

- {class="rcmd"}
- mkdir -p /bedrock/strata/~(global-stratum-name~)
- chmod a+rx /bedrock/strata/~(global-stratum-name~)

If you're using another distro for this ~{stratum~}, or a ~{stratum~} from a
past Bedrock Linux install, move or copy the files into the newly created
directory.

If you are not reusing an existing ~{stratum~}, you'll need to add the
~{stratum.conf~} configuration to tell Bedrock Linux about it.  Edit
`/bedrock/etc/strata.conf` and append:

    [~(global-stratum-name~)]
    framework = global

If you are re-using an existing ~{stratum~} such as ~{rootfs~} which you
configured to use `framework = default` be sure to change `default` to
`~{global~}`.  Failing to do so and retaining `framework = default` can cause
difficult to remedy issues.

If you are not naming the ~{stratum~} "~{global~}", you'll need to make an alias
to it.  Edit `/bedrock/etc/aliases.conf` and change:

    global = <DO AT INSTALL TIME>

to

    global = ~(global-stratum-name~)

Then (still assuming you are not naming the ~{global~} ~{stratum~}
"~{global~}"), create a symlink so that the alias can be used as an
~{explicit~} path:

- {class="rcmd"}
- ln -s ~(global-stratum-name~) /bedrock/strata/global

If you *are* naming the ~{stratum~} "~{global~}", edit
`/bedrock/etc/aliases.conf` and remove this line:

    global = <DO AT INSTALL TIME>

Like ~{rootfs~}, later steps will be eased if we create a variable to reference
for the current, install-time location of the ~{global~} ~{stratum~}.

If your ~{rootfs~} and ~{global~} are the same ~{stratum~}:

- {class="rcmd"}
- export GLOBAL=$ROOTFS

Otherwise:

- {class="rcmd"}
- export GLOBAL=/bedrock/strata/~(global-stratum-name~)

Next we need to get some required ~{global~} files into this ~{global
stratum~}.  The Bedrock Linux userland tarball included a standard set of some
of these files.  Copy them into place:

- {class="rcmd"}
- cp -rpT /bedrock/global-files $GLOBAL

The tarball did not include all of the required ~{global~} files; it does not
include things such as `/etc/passwd.`  You'll need to get those next.

If you are doing a hijack install and ~{rootfs~} is the same as ~{global~}, you
already have key files such as `/etc/passwd` in place.

If you are doing a hijack install and you're using a fresh ~{global~}
~{stratum~} that only contains ~{global~} files, copy over the ~{rootfs~}'
`/etc/passwd`, `/etc/group`, and `/etc/shadow` files into the ~{global~}
~{stratum~} to use them as a base set of passwd/group/shadow files:

- {class="rcmd"}
- cp -rp $ROOTFS/etc/passwd $ROOTFS/etc/group $ROOTFS/etc/shadow $GLOBAL

If you are doing a manual install and you're using a fresh ~{global~}
~{stratum~} that only contains ~{global~} files, you can copy over your current
system's `/etc/passwd`, `/etc/group`, and `/etc/shadow` files into the
~{global~} ~{stratum~} to use them as a base set of passwd/group/shadow files:

- {class="rcmd"}
- cp -rp /etc/passwd /etc/group /etc/shadow $GLOBAL

Or, alternatively, you can create a new set of these files (root password is
"bedrock", be sure to change this later):

- {class="rcmd"}
- mkdir -p $GLOBAL/etc
- chmod a+rx $GLOBAL/etc
- echo 'root:x:0:0:,,,:/root:/bedrock/bin/sh' > $GLOBAL/etc/passwd
- echo 'root:$1$t03vz3.6$tDptA3cYB6E3gnrY07D/S/:15695:0:99999:7:::' > $GLOBAL/etc/shadow
- printf 'root:x:0:\ntty:x:5:\ndisk:x:6:\nlp:x:7:\nkmem:x:15:\ndialout:x:20:\ncdrom:x:24:\nfloppy:x:25:\ntape:x:26:\naudio:x:29:\nvideo:x:44:\nstaff:x:50:\n' > $GLOBAL/etc/group

The `/bedrock/global-files` directory is no longer needed.  Remove it to avoid
later confusion:

- {class="rcmd"}
- rm -r /bedrock/global-files

### {it="configure-time"} Configure time

Bedrock Linux 1.0beta2 Nyla's system for managing time is particularly weak at
the moment.  While everything one would need should be possible to do, there is
a bit of additional manual work required in comparison to traditional distros.
This is a known issue which should hopefully be resolved in future Bedrock
Linux releases.

If you do not have a file at `$GLOBAL/etc/adjtime`, create one:

- {class="rcmd"}
- printf '0.000000 0.000000 0.000000\n0\nUTC\n' > $GLOBAL/etc/adjtime

If your hardware clock is using UTC, ensure the third line (which should also
be the last) of the file at `$GLOBAL/etc/adjtime` is "UTC".  This is common on
machines which only run Linux-based operating systems.  Otherwise, if your
hardware clock is in local time, set it to "LOCAL".  This is common on machines
which dual-boot with Microsoft Windows.

Next you'll need to configure your timezone information.  Ideally your Olson
timezone file would be ~{global~} or ~{implicit~}.  Sadly, however, this does
not work as of Bedrock Linux 1.0beta2 Nyla.  Instead, Bedrock Linux will
attempt to direct everything to utilize the timezone file at
`/bedrock/etc/localtime`.  This file needs to be updated manually.  Thus, copy
your desired timezone file to `/bedrock/etc/localtime`:

- {class="rcmd"}
- cp -p /usr/share/zoneinfo/~(timezone-file~) /bedrock/etc/localtime

for example:

- {class="rcmd"}
- cp -p /usr/share/zoneinfo/America/New\_York /bedrock/etc/localtime

If timezone information changes, either because you move timezones or some
local law changed the timezone details where you reside, remember to repeat
this with an updated Olson timezone file.  Most distros - and hence, your
~{strata~} - will update their `/usr/share/zoneinfo` files automatically as
laws change the timezone details.

### {id="configure-init"} Configure init

Bedrock Linux needs to have the available init systems configured to utilize
them.  For any ~{strata~} which provides an init system, edit
`/bedrock/etc/strata.conf` and add:

    init = /path/to/init

to configure Bedrock Linux to utilize the given executable as provided by the
given ~{stratum~} as a potential init system.

For example, if you did a hijack install on a distro that uses systemd, you
probably want:

    init = /lib/systemd/systemd

under

    [~(rootfs-stratum-name~)]

so it will look something like:

    [jessie]
    framework = default
    init = /lib/systemd/systemd

If you are configuring a ~{stratum~} which does not utilize systemd, you
probably want

    init = /sbin/init

for example:

    [void]
    framework = default
    init = /sbin/init

Additionally, you can set a default ~{stratum~}/command pair, as well as a
timeout which will trigger the default if left to expire, by editing
`/bedrock/etc/brn.conf`.  Set the desired default ~{stratum~} and the command
that should be run for it as well as the desired timeout in seconds.  If the
timeout is set to "0" it will immediately pick the default.  If the timeout is
set to "-1" it wait indefinitely.  For example:

    default_stratum = alpine
    default_cmd = /sbin/init
    timeout = 10

### {it="configure-hostname"} Configure hostname

The default hostname is "bedrock-box".  To change this, edit
`/bedrock/etc/hostname` as desired.

Change "bedrock-box" in `/bedrock/etc/hosts` to your desired hostname
as well.

## {id="kernel"} Linux kernel and associated files

Next you'll need a set of related files usually tied to the Linux kernel to be
placed in specific locations.  At a minimum you need one set, but more could
be desired.  If you are doing a hijack install where ~{global~} and
~{rootfs~} are the same ~{stratum~}, you should already have one set of these files
in place.  If that is the case, you can skip down to the [configure
bootloader](#configure-bootloader) step.

### {id="boot-files"} /boot files

Typically one or more Linux kernel images and some associated files, such as
initrds, are placed into `/boot`.  These files are:

- The kernel image itself, which usually looks like ~(vmlinuz-VERSION-ARCH~).
- An initrd.  Some distros do not use these, but most do.  They usually look
  something like ~(initrd.img-VERSION-ARCH~).
- Optionally, a system map.  Looks like ~(System.map-VERSION~).
- Optionally, the `.config` for the kernel.  Usually looks like
  ~(config-VERSION-ARCH~).

If you are doing a hijack install, you've already got one set in place.  If
that is the case and if you do not want to get others you can skip to the [next
section](#modules).

Look through `/bedrock/strata/~(*~)/boot/` to see if you have such a set of
files.  If not, you'll have to `chroot` into at least one of the stratum and
install them, like so:

- {class="rcmd"}
- export STRATUM=~(stratum-name~)
- cp /etc/resolv.conf /bedrock/strata/$STRATUM/etc
- mount -t proc proc /bedrock/strata/$STRATUM/proc
- mount -t sysfs sysfs /bedrock/strata/$STRATUM/sys
- mount --bind /dev /bedrock/strata/$STRATUM/dev
- mount --bind /dev/pts /bedrock/strata/$STRATUM/dev/pts
- mount --bind /run /bedrock/strata/$STRATUM/run
- chroot /bedrock/strata/$STRATUM /bin/sh

From here, run whatever commands are necessary to install the kernel.  For
example, in a x86\_64 Debian-based ~{stratum~}, run:

	{class="rcmd"} apt-get install linux-image-amd64

or for an Arch Linux ~{stratum~} run

	{class="rcmd"} pacman -S linux

When you have finished, run the following to clean up:

- {class="rcmd"}
- exit   #(to leave the chroot)
- umount /bedrock/strata/$STRATUM/proc
- umount /bedrock/strata/$STRATUM/sys
- umount /bedrock/strata/$STRATUM/dev/pts
- umount /bedrock/strata/$STRATUM/dev
- umount /bedrock/strata/$STRATUM/run

Once you have located at least one set of these files, copy them into `$ROOTFS/boot/`.

For example, if copying Arch Linux's initrd and kernel image:

- {class="rcmd"}
- cp -p /bedrock/strata/arch/boot/initramfs-linux.img /bedrock/strata/arch/boot/vmlinuz-linux $ROOTFS/boot/

### {id="modules"} modules

Kernel images are typically paired with kernel modules which are located in
`/lib/modules`.  Find the modules associated with the kernel files you copied
into `$ROOTFS/boot` and place it into `$GLOBAL/lib/modules`.

If you are doing a hijack install and your ~{rootfs~} and ~{global~} are
the same ~{stratum~}, you've already got one set of modules in place.
If you do not want to get others you can skip to the [next section](#firmware).

Look through `/bedrock/strata/~(*~)/lib/modules` to see if you have such a set
of files.  You most likely have one set associated with the kernel image you
copied in the previous step.  Copy these modules into `$GLOBAL/lib/modules`.

For example if an Arch Linux ~{strata~} provides the desired files:

- {class="rcmd"}
- cp -rp /bedrock/strata/arch/lib/modules/\* $GLOBAL/lib/modules/

### {id="firmware"} firmware

Bedrock Linux 1.0beta2 Nyla's system for managing firmware is particularly weak
at the moment.  While everything one would need should be possible to do, there
is a bit of additional manual work required in compassion traditional distros.
This is a known issue which should hopefully be resolved in future Bedrock
Linux releases.

Various firmware files needed by kernel modules are typically made available in
`/lib/firmware`.  Sadly, these files do not cleanly fit into either the ~{local~}
or ~{global~} category: software from various ~{strata~} need to see them such that
they *should* be ~{global~}, but various package managers will conflict if they
see firmware from other strata such that they *should* be ~{local~}.  Moreover,
the Linux kernel may try to read them from the ~{rootfs~} before the ~{global~}
system is set up, making ~{global~} non-viable.

Until a better solution is implemented, the solution is to simply copy them
from the various ~{strata~} that provide them to the various ~{strata~} that need them,
then remove them if/when a package manager complains.

Since the kernel may try to read them from ~{rootfs~}, that's a good place to
start.  Copy the various firmware files from the various ~{strata~} into
`$ROOTFS/lib/modules/`:

- {class="rcmd"}
- cp -rp /bedrock/strata/\*/lib/modules/\* $ROOTFS/lib/modules

## {id="manage-users-groups"} Manage users and groups

You already have some basic users and groups set up from the "Configure global
stratum" step, but it is best to ensure some minimum expectations are met
before continuing.

To manage users, you'll need to `chroot` into ~{global~}.  However, unless you
set up ~{rootfs~} and ~{global~} to be the same ~{stratum~}, it is not
guaranteed that ~{global~} has any commands to run at this point.  Bedrock
Linux's subsystems will resolve this at run time, but not during installation.
If ~{rootfs~} and ~{global~} are different, run:

- {class="rcmd"}
- [ "$GLOBAL" != "$ROOTFS" ] && mkdir -p $GLOBAL/bedrock/libexec/
- [ "$GLOBAL" != "$ROOTFS" ] && cp $ROOTFS/bedrock/libexec/busybox $GLOBAL/bedrock/libexec/

Now that we know that a special build of `busybox` exists at
`$GLOBAL/bedrock/libexec/busybox`, we can chroot to it:

- {class="rcmd"}
- chroot $GLOBAL /bedrock/libexec/busybox sh

First, ensure you have a root user:

- {class="rcmd"}
- grep -c "^root:" /etc/passwd

That should output "1".  If it does not we'll need to make a new pair of
`passwd` and `shadow` files:

- {class="rcmd"}
- echo 'root:x:0:0:,,,:/root:/bedrock/bin/brsh' > /etc/passwd
- echo 'root:$1$t03vz3.6$tDptA3cYB6E3gnrY07D/S/:15695:0:99999:7:::' > /etc/shadow

Set the root user's password:

- {class="rcmd"}
- passwd -a sha512

To handle nuances of how shells are handled in a typical Linux system, Bedrock
Linux provides its own meta-shell, `brsh`, which can be configured to
immediately switch to some other, desired shell (e.g. bash or zsh).  Ensure
root is using brsh:

- {class="rcmd"}
- awk 'BEGIN{FS=OFS=":"} /^root:/{$NF = "/bedrock/bin/brsh"} 1' /etc/passwd > /etc/new-passwd
- mv /etc/new-passwd /etc/passwd

While `brsh` is very convenient for most instances, it may be wise to provide a
way to bypass it in case something goes wrong.  Add a new username as an alias
to the root user which uses `/bin/sh`:

- {class="rcmd"}
- sed -n 's/^root:/br&/p' /etc/passwd | sed 's,:[^:]\*$,:/bin/sh,' >> /etc/passwd
- sed -n 's/^root:/br&/p' /etc/shadow >> /etc/shadow

Next, check if your desired normal user exists.  It may have been inherited
from the hijacked install:

- {class="rcmd"}
- grep -c "^~(desired-username~):" /etc/passwd

If that does not print "1", add the user:

- {class="rcmd"}
- adduser -s /bedrock/bin/brsh -D ~(username~)

Set the user's password:

- {class="rcmd"}
- passwd -a sha512 ~(username~)

And ensure the user is using `brsh`:

- {class="rcmd"}
- awk 'BEGIN{IFS=":";OFS=":"} /^~(username~):/{$NF = "/bedrock/bin/brsh"} 1' /etc/passwd > /etc/new-passwd
- mv /etc/new-passwd /etc/passwd

If you'd like a emergency-drop-to-`/bin/sh` alias for this user as well, you
can optionally create one:

- {class="rcmd"}
- sed -n 's/^~(username~):/br&/p' /etc/passwd | sed 's,:[^:]\*$,:/bin/sh,' >> /etc/passwd
- sed -n 's/^~(username~):/br&/p' /etc/shadow >> /etc/shadow

Next we'll need to add groups.  If you get a "group ~(group-name~) in use",
this simply indicates you already have the group; no harm done.

Adding typical expected groups:

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
- addgroup man
- addgroup input
- addgroup utmp
- addgroup plugdev

It may be desirable to add your normal user to the "audio" and "video" groups:

- {class="rcmd"}
- addgroup ~(username~) audio
- addgroup ~(username~) video

If you plan to use systemd as your init at some point, even just temporarily,
it is a good idea to ensure some of the users and groups it expects exist, as
otherwise it may fail to boot.

- {class="rcmd"}
- adduser -h / -s /bin/false -D -H daemon
- adduser -h / -s /bin/false -D -H systemd-network
- adduser -h / -s /bin/false -D -H systemd-timesync
- adduser -h / -s /bin/false -D -H systemd-resolve
- adduser -h / -s /bin/false -D -H systemd-bus-proxy
- adduser -h / -s /bin/false -D -H messagebus
- adduser -h / -s /bin/false -D -H dbus
- addgroup daemon
- addgroup adm
- addgroup systemd-journal
- addgroup systemd-timesync
- addgroup systemd-network
- addgroup systemd-resolve
- addgroup systemd-bus-proxy
- addgroup messagebus
- addgroup dbus
- addgroup netdev
- addgroup bluetooth

If you want to add any other users or groups, now is a good time.  Once you're
done, exit the chroot.

- {class="rcmd"}
- exit

## {id="configure-bootloader"} Configure bootloader

Finally, you will need to configure your bootloader.  This is the last major
step for the installation.

You'll want to change three things:

- Set/change the menu item's name to something you'll recognize for this
  install of Bedrock Linux, e.g.  "Bedrock Linux 1.0beta2 Nyla".

- Set it to use `/bedrock/sbin/brn` as the init.

- Set it to mount the root filesystem as read-write, not read-only.
  Boot-to-read-only is not supported in 1.0beta2 Nyla.

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

then run

- {class="rcmd"}
- update-grub

With syslinux or LILO, just edit the relevant lines to change the menu item to
"Bedrock Linux 1.0beta2 Nyla" and add "rw init=/bedrock/sbin/brn" to the kernel
line.  For example, with syslinux, an adjusted stanza may look like:

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
to drop into the [IRC channel](https://webchat.freenode.net/?channels=bedrock).
