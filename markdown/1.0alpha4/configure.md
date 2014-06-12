Title: Bedrock Linux 1.0alpha4 Flopsie Configuration Instructions
Nav: flopsie.nav

Bedrock Linux 1.0alpha4 Flopsie Configuration Instructions
==========================================================

- [rc.conf](#rcconf)
	- [TZ](#tz)
	- [HWCLOCK](#hwclock)
	- [LANG](#lang)
	- [FSCK](#fsck)
	- [NPATH](#npath)
	- [SPATH](#spath)
- [clientsconf](#clientsconf)
	- [General Format](#clientsconf-general-format)
	- [Bind](#clientsconf-bind)
	- [Union](#clientsconf-union)
	- [Framework](#clientsconf-framework)
	- [Recommended Bind/Union Settings](#clientsconf-recommended)
		- [Required for basic functionality](#clientsconf-recommended-basic)
		- [Required for Bedrock Linux functionality](#clientsconf-recommended-required)
		- [Temporary directories](#clientsconf-recommended-temp)
		- [User files](#clientsconf-recommended-user)
		- [Host files](#clientsconf-recommended-host)
		- [modules](#clientsconf-recommended-modules)
		- [boot](#clientsconf-recommended-boot)
		- [firmware](#clientsconf-recommended-firmware)
	- [Bedrock Linux as a client](#bedrock-as-a-client)
	- [Full Example](#clientsconf-full-example)
- [udev](#udev)
- [fstab](#fstab)
- [.brsh.conf](#brshconf)
- [rcS.clients and rcK.clients](#rcSrcK)
- [brp.conf](#brpconf)


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
access to the s\* directories that the non-root user does not.

e.g.: `SPATH=/usr/local/sbin:/usr/sbin:/sbin`

## {id="clientsconf"} clients.conf

The existence of a (root owned, non-root-unwritable) file at

    /bedrock/etc/clients.d/~(clientname~).conf

indicates configuration for an (enabled) client.  If the filename is, instead,

    /bedrock/etc/clients.d/~(clientname~).conf.disabled

then the client is considered disabled (so one cannot use it with `brc`).
However, it will contain configuration necessary to re-enable it (with `brs`).

### {id="clientsconf-general-format"} General Format

The contents of the configuration files are simply a series of "key = value"
lines.  Blank lines and lines starting with "#" are ignored.  Baring
newlines, it is flexible about whitespace.

There are three recognized keys in Bedrock Linux 1.0alpha4 Flopsie:
"bind", "union", and "framework".

### {id="clientsconf-bind"} Bind

Most of any given client's files are separated from the rest of the system
via chroot.  This way they will not conflict with each other.  However, many
things should be shared between clients to ensure they can interoperate with
other clients, such as /home and /tmp.  "bind" items are lists of files and
directories which the given client should share with the rest of the system
via bind-mounts.

The values on the right side of the equals sign can be comma separated to
list multiple items per line.

There are two things to keep in mind when using bind items:

- bind mounts are not (by default) recursive.  If you want to share a
directory that contains a mount point (and the contained mount point), you'll
need two bind items.  For example, if you want to share /dev and /dev/shm,
that will have to be two separate items, since /dev/shm is usually mounted
within /dev.  Moreover, the two items must be listed in the order they should
be mounted.
- The rename() system command cannot be used directly on a mount point,
including the bind mounts utilized here.  For the most part this is a
non-issue, as most things which are shared are directories which are not
usually rename()'d.  However, there is a notable exception: there are files
within /etc which should be shared (such as /etc/passwd) and other files
within /etc which should not be shared (such as /etc/issue).  Hence, one
cannot simply share (all of) /etc.  However, /etc/passwd is typically updated
with rename(), and so bind-mounts are not a good way to share it.  Instead,
use "union" (see below).

Example:

    bind = /proc, /sys, /dev, /dev/pts, /dev/shm, /bedrock
    bind = /bedrock/clients/bedrock, /home, /root, /lib/modules, /tmp, /var/tmp

### {id="clientsconf-union"} Union

Union is similar in purpose to bind.  However, it is different in two ways:

- it does not have the same restriction on rename()
- it has a non-negligible performance overhead.

Thus, the majority of shared items should use bind (to maximize performance),
except those which need to be updated via rename().

The first item on the right side of the equals sign should be the directory
containing the item(s) to be shared, followed by a colon, followed by a
comma-separated list of items to be shared relative to the first item without
a starting slash.  This may be better explained with examples, see below.

Note that the first item listed is a mount point.  One cannot use two union
items on the same directory or the latter one will be mounted over the former
and the former will be inaccessible.  Instead, combine them into one line.

Example:

    union = /etc: profile, hostname, hosts, passwd, group, shadow, sudoers, resolv.conf

### {id="clientsconf-framework"} Framework
Multiple clients will likely share similar if not identical bind/union
settings.  Instead of duplicating many settings, a framework can be used to
indicate that a collection of settings stored in

    /bedrock/etc/frameworks.d/~(frameworkname~)

are to be utilized.  Frameworks have the exact same syntax as normal
client.conf files (and can refer to each other).  Typical Bedrock Linux systems
may have one or two frameworks which most client configurations
utilize.

A reference framework with recommended defaults for most clients should be
available by default at

    /bedrock/etc/frameworks.d/default

Example:

	framework = default

### {id="clientsconf-recommended"} Recommended Bind/Union Settings

Following is a list of the files and directories which you should consider
for the "bind" and "union" settings in your clients and frameworks.  This is
not exhaustive - if you can think of something else you would like to share,
feel free to do so.  Moreover, if you disagree with the recommendation and
feel you understand the repercussions of not sharing something, you may skip
sharing these directories.  Do not blindly take values from this, as many of
this are potentially problematic - these are recommended for *consideration
for use* rather than necessarily for use.

#### {id="clientsconf-recommended-basic"} Required for basic functionality
The following directories are expected to be set up by many programs which
require them for basic functionality.  You almost certainly want these for
all of your clients.

    bind = /proc, /dev, /dev/pts, /sys

#### {id="clientsconf-recommended-required"} Required for Bedrock Linux functionality
The following should be shared in any client that should be able to run
commands in other clients.  If you are attempting to set up a limited client
without such functionality, this can be skipped.

    bind = /bedrock, /bedrock/clients/bedrock
    union = /etc: /etc/profile

#### {id="clientsconf-recommended-temp"} Temporary directories
Many programs create temporary files in these directories.  These files are
often used to communicate with other programs.  To ensure these inter-program
communication function across clients, you should share these directories.

    bind = /tmp, /var/tmp, /dev/shm

Note that "/dev/shm" should be *after* "/dev" if you are sharing "/dev".

#### {id="clientsconf-recommended-user"} User files
Most of the user-specific files will be in /home and, for the root user,
/root.  You probably want these shared across clients.

    bind = /home, /root

#### {id="clientsconf-recommended-host"} Host files
Some programs will expect these files to be populated.  Note that you do not
necessarily have to make these the same in all clients, but if you cannot
think of a reason to differentiate them, it is probably best to ensure they
are the same.

    union = /etc: hostname, hosts

#### {id="clientsconf-recommended-modules"} modules
The modules for the Linux kernel are traditionally kept in /lib/modules.  If
multiple clients would like to load these modules (or install non-upstreamed
modules), the directory should be shared with all clients.  Note that some
Linux distributions are moving these to /usr/lib/modules, now, and leaving a
symlink at /lib/modules pointing accordingly.  This should not be a problem
so long as the symlink is there.  However, if you have multiple clients which
use the same name for their kernels which attempt to install modules there
could be a conflict.  This is unlikely if you do not use multiple clients of
the same distro/release which all have the kernel/modules packages installed,
but is something to be careful about nonetheless.  If you are using a kernel
from a client, you almost certainly want to share this directory with at
least that client.

    bind = /lib/modules

#### {id="clientsconf-recommended-boot"} boot
Like /lib/modules, sharing this directory could be useful if you are using a
kernel from a client so the client can keep the kernel you are using up to
date.  However, this also means if that client or another client which also
shares /boot has a problem or there is a conflict, it could potentially make
your system unbootable.  There also are not very many benefits to sharing
this with clients which will not have their kernels used for booting.  It
might be safest to simply manually copy the kernel files from the /boot of
the respective clients into the core where they are out of reach of the
client's package managers.

    bind = /boot

#### {id="clientsconf-recommended-firmware"} firmware
Like /lib/modules and /boot, it can be useful to use a client's /lib/firmware
if you are also using its kernel.  However, this can easily conflict with
other clients.  In general, it is probably best to simply copy files from
clients into the core Bedrock's /lib/firmware.

    bind = /lib/firmware

### {id="bedrock-as-a-client"} Bedrock Linux as a client

There should be a file at /bedrock/clients/bedrock.conf to ensure bedrock is
recognized as a client for commands such as `bri` and `poweroff` to work.  This
file can be empty.

Additionally, the root directory should be bind-mounted into /bedrock/clients
(as is done in the default /etc/fstab).  See the [fstab configuration
section](#fstab).


### {id="clientsconf-full-example"} Full Example

	framework = default

or

	bind = /proc, /sys, /dev, /dev/pts, /dev/shm, /bedrock
	bind = /bedrock/clients/bedrock, /home, /root, /lib/modules, /tmp, /var/tmp
	union = /etc: profile, hostname, hosts, passwd, group, shadow, sudoers, resolv.conf

## {id="udev"} udev

By default, Bedrock Linux uses mdev rather than udev.  If you would like to use
udev instead, ensure you have udev in a client, then do the following:

- edit `/etc/init.d/rcS.udev` (in the core) so that the `UDEV_CLIENT` variable
  indicates which client provides udev.

- add `sh /etc/init.d/rcS.udev` to `/etc/init.d/rcS.clients`

The next time you reboot, udev should replace mdev.

To replace mdev with udev in the current session without rebooting, simply run
`{class="rcmd"} sh /etc/init.d/rcS.udev`.

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

- In order for the core Bedrock Linux to be treated as a client, it needs to be
  bind-mounted into /bedrock/clients.  This is done by default in fstab with
  this line:

	/ /bedrock/clients/bedrock  bind  defaults,bind  0  0

- After the mounts from this are created, the
  `/bedrock/etc/~(clientname~).conf` files are parsed and mount points are
  created from the `bind` and `union` items there.  If you would like to mount
  anything *after* that takes place, you will have to use something other than
  `/etc/fstab`, such as `/etc/rc.local`

## {id="brshconf"} .brsh.conf

To use the Bedrock Linux meta-shell `brsh`, create a file in your home directory
called `.brsh.conf` which contains the contents that should be in your `$SHELL`
environment. For example, if you would like to use `bash`, have `~/.brsh.conf`
contain just:

	/bin/bash

## {id="rcSrcK"} rcS.clients and rcK.clients

To have a client daemon start or stop at boot/shutdown, place the relevant
command to do this in `/etc/init.d/rcS.clients` and `/etc/init.d/rcK.clients`,
respectively. For example, to start Debian squeeze's `cups` daemon at boot, place
the following in your `/etc/init.d/rcS.clients`:

	brc squeeze /etc/init.d/cups start

And, to ensure it properly closes at shutdown, place the following in your
`/etc/init.d/rcK.clients`:

	brc squeeze /etc/init.d/cups stop

## {id="brpconf"} brp.conf

To specify client priority order for the brp utility, add the clients in the
desired order, one per line, in `/bedrock/etc/brp.conf`.

If a given command is not available in the local client, but is available in
another client, and brp has been run, the highest-listed client in brp.conf
will indicate which client will provide the command.  If no client which
provides the command is listed in brp.conf, but there are clients which provide
the command, the first one listed by `bri -l` will provide the command.

For example:
- client "debian" does not have command `gparted`
- both clients "arch" and "fedora" have `gparted`
- if arch or fedora runs `gparted`, each will see their own version of gparted.
- if debian runs gparted, it will either run arch's or fedora's, depending on
  which is listed higher within brp.conf.  If neither is listed, the first one
  listed by `bri -l` will be chosen.
