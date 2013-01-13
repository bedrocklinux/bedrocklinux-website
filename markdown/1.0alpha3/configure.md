Title: Bedrock Linux 1.0alpha3 Bosco Configuration Instructions
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Bosco Configuration Instructions
========================================================


- [rc.conf](#rcconf)
	- [TZ](#tz)
	- [HWCLOCK](#hwclock)
	- [LANG](#lang)
	- [DEVICE\_MANAGER](#device-manager)
	- [UDEV\_CLIENT](#udev-client)
	- [FSCK](#fsck)
	- [NPATH](#npath)
	- [SPATH](#spath)
- [brclients.conf](#brclientsconf)
	- [General Format](#brclients-general-format)
	- [Settings](#brclients-settings)
		- [path](#brclients-path)
		- [updatecmd](#brclients-updatecmd)
		- [share](#brclients-share)
		- [framework](#brclients-framework-setting)
		- [Example](#brclienits-genera-example)
	- [Frameworks](#brclients-frameworks)
	- [Recommend Share Settings](#recommended-share)
		- [Required for basic functionality](#share-basic)
		- [Required for Bedrock Linux functionality](#share-required-bedrock)
		- [Temporary directories](#share-temporary)
		- [User files](#share-user-friles)
		- [Host files](#share-host-files)
		- [modules](#share-modules)
		- [boot](#share-boot)
		- [firmware](#share-firmware)
		- [Other clients](#share-other-clients)
		- [Problematic /etc files](#share-etc)
	- [Other Notes:](#brclients-other-notes)
		- [Client Placement](#client-placement)
		- [Bedrock Linux as a client](#bedrock-as-a-client)
	- [Full Example](#brclients-full-example)
- [fstab](#fstab)
- [.brsh.conf](#brshconf)
- [rcS.clients and rcK.clients](#rcSrcK)


## {id="rcconf"} rc.conf

The `rc.conf` configuration file covers the general system-wide configuration
options, especially boot configuration options.  It is located at
`/bedrock/etc/rc.conf`.  It is sourced as a bourne shell script, so be careful
with your syntax - there should be no spaces around the equals signs used for
establishing a setting. Change the text to the right of the equals sign to set
the value.

### {id="tz"} TZ

Sets timezone using the POSIX TZ environmental variable standard.  For details
on the nuances of the POSIX TZ environmental variable, see:

- [http://pubs.opengroup.org/onlinepubs/7908799/xbd/envvar.html](http://pubs.opengroup.org/onlinepubs/7908799/xbd/envvar.html) (UNIX)
- [http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html](http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html) (GNU)
- [http://www-01.ibm.com/support/docview.wss?uid=isg3T1000252](http://www-01.ibm.com/support/docview.wss?uid=isg3T1000252) (AIX)

e.g.: `TZ=EST+5EDT,M3.2.0/2:00:00,M11.1.0/2:00:00`

### {id="hwclock"} HWCLOCK

Sets whether the hardware clock is set to local time or UTC. Traditionally UNIX
systems use UTC, but Windows uses local. If you are dual-booting with Windows,
local may be preferable. Set to LOCAL or UTC accordingly.

e.g.: `HWCLOCK=UTC`

### {id="lang"} LANG

Sets the language/locale information.

e.g.: `LANG=en_US.UTF-8`

### {id="device-manager"} DEVICE_MANAGER

Determines which device manager Bedrock will use.  Four options are available:

1. "mdev": Bedrock Linux will use busybox's `mdev` at boot.  If you have no
clients which provide `udev`, or you do not like `udev`, this provides a
similar service.

2. "udev": Bedrock Linux will use `udev` from a client at boot.  This has more
features than `mdev` (for example, X11 can use it to automatically detect your
hardware).  It is what is used in most major Linux distributions.  However,
it requires `udev` be installed in a client.  Should this fail - for example,
if the client is deleted by a user who forgets to update this config -
Bedrock Linux will attempt to fall back to `mdev`.

3. "static": Bedrock will assume a static `/dev` has been created, and will not
attempt to manage `/dev` at all.  This is useful for systems where the devices
are unlikely to change between boots or during usage, such as embedded
systems.

4. "initrd": This informs Bedrock's init that the initrd in use has set up
both `/dev` and a `device manager`, and that it should be left alone.  This may
not work well if the initrd's device manager expects things to be in place in
the filesystem after the init has finished which Bedrock does not provide.
If the initrd sets up `/dev` and a device manager but another value is used for
this setting, Bedrock's init will attempt to remove the initrd's work before
using what you set.

e.g.: `DEVICE_MANAGER=mdev`

### {id="udev-client"} UDEV_CLIENT


If using `DEVICE_MANAGER=udev`, `UDEV_CLIENT` specifies which client's `udev` to
utilize.  If this is left blank, Bedrock Linux will attempt to use the `udev`
components specified in `/bedrock/sbrpath` (which are populated by `brp`).  If
this, too, fails, Bedrock Linux will attempt to fall back to `mdev`.

e.g.: `UDEV_CLIENT=squeeze`

### {id="fsck"} FSCK

if `FSCK=1`, Bedrock will attempt to run `fsck` at boot.  Otherwise, Bedrock
will skip running `fsck` at boot.  If you are using an initrd which runs
`fsck`, it could be beneficial to set `FSCK=0` to avoid running `fsck` twice at
boot.

e.g.: `FSCK=1`

### {id="npath"} NPATH

Sets the normal user POSIX PATH variable.  These are the directories in which
programs look for executables.  If you aren't sure what to put here, you almost
certainly want the value in the example below.  Note that `/etc/profile` (which
should be sourced by your shell when it starts) will add items to the beginning
and end of this variable to make it play with Bedrock specific functionality.

e.g.: `NPATH=/usr/local/bin:/usr/bin:/bin`

### {id="spath"} SPATH

Sets additional directories for the super user's (aka root's) POSIX PATH
variable.  Same general idea as above, but for the root user who probably needs
access to the s* directories that the non-root user does not.

e.g.: `SPATH=/usr/local/sbin:/usr/sbin:/sbin`

## {id="brclientsconf"} brclients.conf

The `brclients.conf` configuration file covers most client-specific settings in
Bedrock Linux.  It is located at `/bedrock/etc/brclients.conf`.

### {id="brclients-general-format"} General Format

Each client will get its own configuration section.  These sections each
start with a section header, which looks like:

	[client "~(CLIENTNAME~)"]

where ~(CLIENTNAME~) is changed to the name you would like to give the client.
For example, if you would like to make a client named "squeeze" (for Debian 6
Squeeze), the relevant configuration would go under a line starting with

	[client "squeeze"]

The lines under the section headers are settings which are all in the form of
key-value pairs.  They look like:

	KEY = VALUE

In addition to client sections, there are framework sections, which look like

	[framework "~(FRAMEWORKNAME~)"]

These, too, take key-value pairs.  Blank lines and lines starting with a "#" or
";" are ignored.  In-line comments are not supported.

### {id="brclients-settings"} Settings

#### {id="brclients-path"} path

Every client should have exactly one `path` setting which specifies where the
client's files are located in the filesystem relative to the absolute root
(ie, without chroots or other filesystem manipulations.)  For example, if a
Debian Squeeze client is located at `/var/chroot/squeeze`, the relevant line
will look like:

	path = /var/chroot/squeeze

#### {id="brclients-updatecmd"} updatecmd

Since updating clients is a common task, the `bru` command was created to
update all of the clients.  The `updatecmd` setting specifies the command `bru`
should run for the given client to update it.  This is a bourne shell command;
feel free to include bourne shellisms such as `&&` within it.  You may have
multiple `updatecmd`'s per a client, in which case they will be run one at a time.  The
`updatecmd` setting is optional - if left out, `brp` will simply skip the
client.  This is necessary for clients which do not have commands to update
them, such as Bedrock Linux itself.  For example, for a Debian Squeeze
client:

	updatecmd = apt-get update && apt-get upgrade

#### {id="brclients-share"} share

Most of the client's files are separated from the rest of the system via
chroot.  However, many things should be shared between clients to ensure they
operate, such as `/proc`, and others should be shared to ensure the system
feels cohesive, such as `/home`.  Which files and directories should be shared
for a client are specified with the `share` setting, which takes a
comma-separated list of directories.  Several examples:

	share = /proc, /dev, /dev/pts, /sys, /bedrock, /etc/profile, /tmp
	share = /var/tmp, /dev/shm, /home, /root, /etc/hostname, /etc/hosts
	share = /lib/modules, /var/chroot, /var/chroot/bedrock
	share = /etc/passwd, /etc/group, /etc/shadow, /etc/sudoers
	share = /etc/resolv.conf

Note multiple share's are allowed per client to avoid overly long lines.  See
[Recommended Share Settings](#recommended-share) below for recommendations on
what directories to share.  This is technically optional, but you almost
certainly want it for all of your clients except for the Bedrock Linux client.
Note the order of the comman-separated items matters.  Items which contain
other items, such as `/dev` which contains `/dev/pts`, should be earlier in the
order.

#### {id="brclients-framework-setting"} framework

Finally, there is a `framework` setting which can be used to utilize the
settings set in a framework section.  For example, if there is a framework
section called `debclient`, and you would like a Debian Squeeze client to
utilize the settings specified there:

	frmaework = debclient

#### {id="brclienits-genera-example"} Example

An example utilizing `path`, `updatecmd` and `share` (but not `framework`):

	[client "squeeze"]
		path = /var/chroot/squeeze
		updatecmd = apt-get update && apt-get upgrade
		share = /proc, /dev, /dev/pts, /sys, /bedrock, /etc/profile, /tmp
		share = /var/tmp, /dev/shm, /home, /root, /etc/hostname, /etc/hosts
		share = /lib/modules, /var/chroot, /var/chroot/bedrock
		share = /etc/passwd, /etc/group, /etc/shadow, /etc/sudoers
		share = /etc/resolv.conf


### {id="brclients-frameworks"} Frameworks

It is commonplace for multiple clients to have identical `updatecmd` or `share`
settings (but *not* `path` - this has to be unique per client).  Rather than
having each client have their own copy of such settings - and having to make
a change in all of them when a need for a change is found - clients refer to
"frameworks" for some of their settings.  Note that the `framework` setting
is not legal within a framework.  Frameworks themselves do not do anything;
their settings are simply references for use by clients.  For example, if
there are three clients, two of which utilize the same framework:

	# framework for debian-based clients
	[framework "debclient"]
		updatecmd = apt-get update && apt-get upgrade
		share = /proc, /dev, /dev/pts, /sys, /bedrock, /etc/profile, /tmp
		share = /var/tmp, /dev/shm, /home, /root, /etc/hostname, /etc/hosts
		share = /lib/modules, /var/chroot, /var/chroot/bedrock
		share = /etc/passwd, /etc/group, /etc/shadow, /etc/sudoers,
		share = /etc/resolv.conf
	
	# debian 6 squeeze
	[client "squeeze"]
		path = /var/chroot/squeeze
		framework = debclient
	
	# ubuntu 12.04 precise pangolin
	[client "precise"]
		path = /var/chroot/squeeze
		framework = debclient
	
	# arch linux
	[client "arch"]
		path = /var/chroot/arch
		updatecmd = pacman -Syu
		share = /proc, /dev, /dev/pts, /sys, /bedrock, /etc/profile, /tmp
		share = /var/tmp, /dev/shm, /home, /root, /etc/hostname, /etc/hosts
		share = /lib/modules, /var/chroot, /var/chroot/bedrock
		share = /etc/passwd, /etc/group, /etc/shadow, /etc/sudoers,
		share = /etc/resolv.conf

### {id="recommended-share"} Recommend Share Settings

Following is a list of the files and directories which you should consider
for the `share` settings in your clients and frameworks.  This is not
exhaustive - if you can think of something else you would like to share, feel
free to do so.  Moreover, if you disagree with the recommendation and feel
you understand the repercussions of not sharing something, you may skip
sharing these directories.  Do not blindly take values from this, as many of
this are potentially problematic - these are recommended for *consideration
for use* rather than necessarily for use.

#### {id="share-basic"} Required for basic functionality

The following directories are expected to be set up by many programs which
require them for basic functionality.  You almost certainly want these for
all of your clients.

	/proc,/dev,/dev/pts,/sys

#### {id="share-required-bedrock"} Required for Bedrock Linux functionality

The following should be shared in any client that should be able to run
commands in other clients.  If you are attempting to set up a limited client
without such functionality, this can be skipped.

	/bedrock,/etc/profile

#### {id="share-temporary"} Temporary directories

Many programs create temporary files in these directories.  These files are
often used to communicate with other programs.  To ensure these inter-program
communication function across clients, you should share these directories.

	/tmp,/var/tmp,/dev/shm

Note that `/dev/shm` should be *after* `/dev` if you are sharing `/dev`.

#### {id="share-user-friles"} User files

Most of the user-specific files will be in /home and, for the root user,
/root.  You probably want these shared across clients.

	/home,/root

#### {id="share-host-files"} Host files

Some programs will expect these files to be populated.  Note that you do not
necessarily have to make these the same in all clients, but if you cannot
think of a reason to differentiate them, it is probably best to ensure they
are the same.
	/etc/hostname,/etc/hosts

#### {id="share-modules"} modules

The modules for the Linux kernel are traditionally kept in `/lib/modules`.  If
multiple clients would like to load these modules (or install non-upstreamed
modules), the directory should be shared with all clients.  Note that some
Linux distributions are moving these to `/usr/lib/modules`, now, and leaving a
symlink at `/lib/modules` pointing accordingly.  This should not be a problem
so long as the symlink is there.  However, if you have multiple clients which
use the same name for their kernels which attempt to install modules there
could be a conflict.  This is unlikely if you do not use multiple clients of
the same distro/release which all have the kernel/modules packages installed,
but is something to be careful about nonetheless.  If you are using a kernel
from a client, you almost certainly want to share this directory with at
least that client.

	/lib/modules

#### {id="share-boot"} boot

Like `/lib/modules`, sharing this directory could be useful if you are using a
kernel from a client so the client can keep the kernel you are using up to
date.  However, this also means if that client or another client which also
shares `/boot` has a problem or there is a conflict, it could potentially make
your system unbootable.  There also are not very many benefits to sharing
this with clients which will not have their kernels used for booting.  It
might be safest to simply manually copy the kernel files from the `/boot` of
the respective clients into the core where they are out of reach of the
client's package managers.

	/boot

#### {id="share-firmware"} firmware

Like `/lib/modules` and `/boot`, it can be useful to use a client's
`/lib/firmware` if you are also using its kernel.  However, this can easily
conflict with other clients.  In general, it is probably best to simply copy
files from clients into the core Bedrock's `/lib/firmware`.

	/lib/firmware

#### {id="share-other-clients"} Other clients

You may want to share the directories which contain the other clients to make
their files accessible elsewhere.  For example, the core Bedrock client only
has a very limited form of `vi` as an editor; if you would like to use
another editor to edit its files, these files will have to be accessible from
the client with the editor.  The recommended location for clients is
`/var/chroot/`.  That directory could be shared to share all of the clients.
Do note however that Bedrock Linux itself isn't available there.  To resolve
this, `/etc/fstab` could be used to bind mount it in `/var/chroot`.  However,
since it is mounted there, it will have to be shared separately.  Note the
order; it matters here.

	/var/chroot,/var/chroot/bedrock

#### {id="share-etc"} Problematic /etc files

You probably want these files shared between clients.  However, if they are
set to be shared here, the normal means of updating them will break.  See
[here](http://bedrocklinux.org/issues/issue-ed10277445e2bc796171ca53603f0894f300a5ef.html)
for the issue page:

You have several options:

- You could share these files and manually "update" them.  If the `groupadd`
command is run, it will fail and leave a temporary file such as `/etc/group+`
behind.  You can cat this file over the normal `/etc/group` file to finalize
the command yourself, like so:

	cat /etc/group+ /etc/group && rm /etc/group+

- You could avoid sharing these files files through the brclients.conf system
and manually sync them when one changes.  For example, if `groupadd` is run,
you could run the following:

	cp /etc/group /tmp/ && brl cp /tmp/group /etc/group && rm /tmp/group

This assumes `/tmp` is shared between clients.

Work is underway to create a daemon to automate this second option.  See
[here](http://bedrocklinux.org/issues/issue-a158e55ccf9aa3f6eb8036fb086f83c8cdab0cd9.html)
for its current state:

The discussed files are:

	/etc/passwd,/etc/group,/etc/shadow,/etc/sudoers,/etc/resolv.conf

### {id="brclients-other-notes"} Other Notes:

#### {id="client-placement"} Client Placement

The standard location to place clients is each in their own directory in
`/var/chroot`.  However, if you would like to place some or all clients
elsewhere, this is supported.

#### {id="bedrock-as-a-client"} Bedrock Linux as a client

It is useful to set up Bedrock Linux itself as a client so that commands such
as `brl` recognize it.  Moreover, bedrock *has* to be a client to get
commands such as `poweroff` and `reboot` to work.

Note that:

- The path setting will just be `/`
- There is no(t yet any) updatecmd for it.
- There is no need to `share` anything, as `share` shares with the core Bedrock
  Linux; it would simply bind mount an item over itself.

- If you would like its files to be directly accessible in other clients, a
  line to bind mount `/` to somewhere such as `/var/chroot` should be placed in
  `/etc/fstab`.  See [the /etc/fstab section](#fstab)

### {id="brclients-full-example"} Full Example

Following is an example `brclients.conf` which makes use of all of the
discussed functionality and is representative of what most `brclients.conf`
will look like.

	# framework used by most clients
	[framework "normal"]
		share = /proc, /dev, /dev/pts, /sys, /bedrock, /etc/profile, /tmp
		share = /var/tmp, /dev/shm, /home, /root, /etc/hostname, /etc/hosts
		share = /lib/modules, /var/chroot, /var/chroot/bedrock
		share = /etc/passwd, /etc/group, /etc/shadow, /etc/sudoers
		share = /etc/resolv.conf

	# the core bedrock linux as a client
	[client "bedrock"]
		path = /

	# debian 6 squeeze
	[client "squeeze"]
		path = /var/chroot/squeeze
		updatecmd = apt-get update && apt-get upgrade
		framework = normal

	# ubuntu 12.04 precise pangolin
	[client "precise"]
		path = /var/chroot/squeeze
		updatecmd = apt-get update && apt-get upgrade
		framework = normal

	# fedora 17 beefy miracle
	[client "beefy"]
		path = /var/chroot/beefy
		updatecmd = yum update
		framework = normal

	# arch linux
	[client "arch"]
		path = /var/chroot/arch
		updatecmd = pacman -Syu
		framework = normal

	# debian unstable/sid
	[client "sid"]
		path = /var/chroot/sid
		updatecmd = apt-get update && apt-get upgrade
		framework = normal

	# 32-bit debian 6 squeeze
	[client "squeeze32"]
		path = /var/chroot/squeeze32
		updatecmd = apt-get update && apt-get upgrade
		framework = normal

	# sandboxed debian for apache
	[client "apachesandbox"]
		path = /var/chroot/apachesandbox
		updatecmd = apt-get update && apt-get upgrade
		share = /proc,/dev,/dev/pts,/sys,/etc/hostname,/etc/hosts
		share = /etc/resolv.conf


## {id="fstab"} fstab

For the most part, this is a `/etc/fstab` file such as you would find in any
other Linux distribution, and documentation for those distributions should
apply here as well.  This file is primarily used for mounting partitions at
boot or setting up the functionality for devices to be easily mounted by an
end-user, such as optical drives.

However, there are a few additional things to note:

- Bedrock Linux ensures `/proc`, `/sys`, `/dev`, `/dev/pts`, `/dev/shm`, and
the root directory are all set up during the init process and do not
necessarily need to be placed here.

- If you place all of the clients in the same directory (such as
`/var/chroot`), it may be useful to bind mount the root directory to that
location to have the core Bedrock Linux act like every other client.  Include
the following line in your `/etc/fstab` to do this:

		/ /var/chroot/bedrock  bind  defaults,bind  0  0

- After the mounts from this are created, `/bedrock/etc/brclients.conf` is
parsed and mount points are created from the `share` items there.  If you
would like to mount anything *after* that takes place, you will have to use
something other than `/etc/fstab`, such as `/etc/rc.local`

- There are limitations of the system put in place to share files and
directories as set in `/bedrock/etc/brclients.conf`; for example, every item
shared has to be in the same place in all of the clients which share it.
While symlinks can partially alleviate this particular issue, if you'd prefer
to have more fined-tuned control of how sharing works, feel free to disregard
the share settings in `/bedrock/etc/brclients.conf` and simply create bind
mounts in `/etc/fstab` that are to your liking.

## {id="brshconf"} .brsh.conf

To use the Bedrock Linux meta-shell `brsh`, create a file in your home directory
called `.brsh.conf` which contains the contents that should be in your `$SHELL`
environment. For example, if you would like to use `bash`, have `~/.brsh.conf`
contain just:

	/bin/bash.

## {id="rcSrcK"} rcS.clients and rcK.clients

To have a client daemon start or stop at boot/shutdown, place the relevant
command to do this in `/etc/init.d/rcS.clients` and `/etc/init.d/rcK.clients`,
respectively. For example, to start Debian squeeze's `cups` daemon at boot, place
the following in your `/etc/init.d/rcS.clients`:

	brc squeeze /etc/init.d/cups start

And, to ensure it properly closes at shutdown, place the following in your
`/etc/init.d/rcK.clients`:

	brc squeeze /etc/init.d/cups stop

