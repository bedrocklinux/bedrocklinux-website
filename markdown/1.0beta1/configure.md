Title: Bedrock Linux 1.0beta1 Hawky Configuration Instructions
Nav: hawky.nav

Bedrock Linux 1.0beta1 Hawky Configuration Instructions
==========================================================

- [rc.conf](#rc.conf)
	- [TZ](#tz)
	- [HWCLOCK](#hwclock)
	- [LANG](#lang)
	- [FSCK](#fsck)
	- [NPATH](#npath)
	- [SPATH](#spath)
	- [MANPATH](#manpath)
	- [INFOPATH](#infopath)
	- [XDG\_DATA\_DIRS](#xdg_data_dirs)
- [client.conf](#client.conf)
	- [General Format](#client.conf-general-format)
	- [Share](#client.conf-share)
	- [Bind](#client.conf-bind)
	- [Union](#client.conf-union)
	- [Preenable, Postenable, Predisable, Postdisable](#client.conf-hooks)
	- [Framework](#client.conf-framework)
	- [Bedrock Linux as a client](#bedrock-as-a-client)
	- [Full Example](#client.conf-full-example)
- [udev](#udev)
- [fstab](#fstab)
- [.brsh.conf](#brshconf)
- [rcS.clients and rcK.clients](#rcSrcK)
- [brp.conf](#brpconf)


## {id="rc.conf"} rc.conf

The `rc.conf` configuration file covers the general system-wide configuration
options, especially boot configuration options.  It is located at
`~(/mnt/bedrock~)/bedrock/etc/rc.conf`.  It is sourced as a bourne shell script, so be careful
with your syntax - there should be no spaces around the equals signs used for
establishing a setting. Change the text to the right of the equals sign to set
the value.

### {id="tz"} TZ

Sets timezone using the POSIX TZ environmental variable standard.  For details
on the nuances of the POSIX TZ environmental variable, see:

- [http://pubs.opengroup.org/onlinepubs/7908799/xbd/envvar.html](http://pubs.opengroup.org/onlinepubs/7908799/xbd/envvar.html) (UNIX)
- [http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html](http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html) (GNU)
- [http://www-01.ibm.com/support/docview.wss?uid=isg3T1000252](http://www-01.ibm.com/support/docview.wss?uid=isg3T1000252) (AIX)


e.g.: `TZ=EST5EDT,M3.2.0,M11.1.0`

The content to put here can likely be found in /usr/share/zoneinfo/ in most
major distros.  Find the file that corresponds to your timezone and look at
the very last line, for example with `tail -1 /usr/share/zoneinfo/path/to/timezone/file`.

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

### {id="manpath"} MANPATH

This is a list of directories used by the man executable to find man pages.
If you alter this from the default, be sure to also change
`/bedrock/etc/brp.conf` as well.

e.g. `MANPATH="/usr/local/share/man:/usr/share/man"`

### {id="infopath"} INFOPATH

This is a list of directories used by the info executable to find info
documentation.  If you alter this from the default, be sure to also change
`/bedrock/etc/brp.conf` as well.

e.g. `INFOPATH="/usr/local/share/info:/usr/share/info"`

### {id="xdg\_data\_dirs"} XDG\_DATA\_DIRS

This is a list of directories that contain directories used by the
freedesktop.org standard.  For example, the items here could contain "icon"
directories which contain icons to be used by GUI programs.  For another
example, it could contain an "applications" directory which contains .desktop
files that are used to populate application menus and mime/default programs.
If you alter this from the default, be sure to also change
`/bedroock/etc/brp.conf` as well.

e.g. `XDG_DATA_DIRS="/usr/local/share:/usr/share"`


## {id="client.conf"} client.conf

The existence of a (root owned, non-root-unwritable) file at

    /bedrock/etc/clients.d/~(clientname~).conf

indicates configuration for an (enabled) ~{client~}.  If the filename is, instead,

    /bedrock/etc/clients.d/~(clientname~).conf.disabled

then the ~{client~} is considered disabled (so one cannot use it with `brc`).
However, it will contain configuration necessary to re-enable it (with `brs`).

The defaults are in general fairly good.  To set the ~{client~} to use the default
configuration, simply include "framework = default" as the only content, like so:

`echo "framework = default" > /bedrock/etc/clients.d/~(clientname~).conf`

If you would like to understand what these defaults *are* so you can change or
improve upon them for your specific situation, continue reading the rest of
this "client.conf" section.

### {id="client.conf-general-format"} General Format

The contents of the configuration files are simply a series of "key = value"
lines.  Blank lines and lines starting with "#" are ignored.  Baring
newlines, it is flexible about whitespace.

There are eight recognized keys in Bedrock Linux 1.0beta1 Hawky:

- share
- bind
- union
- preenable
- postenable
- predisable
- postdisable
- framework

### {id="client.conf-share"} Share

Bedrock Linux's files are broken up into two categories: ~{local~} and ~{global.~}
The difference between the two is there is only one instance of any given
~{global~} file, while there may be multiple instances (up to one per ~{client~}) of a
~{local~} file.

Without any configuration, everything is ~{local.~}  There are three ways to make
something ~{global~}, one of which is "share".  This is the most common method
and is the recommended default for most items.  If neither the description of
"bind" or "union" seems fitting, this is the setting one should use to make
something ~{global~}.

Example:

`share = /proc, /sys, /dev, /home, /root, /lib/modules, /tmp, /var/tmp, /mnt, /media, /run`

### {id="client.conf-bind"} Bind

Bind is exactly like share except if any items are mounted in a "bind" item,
they are set to ~{local~}.  For example, if one mounts a CD at /mnt/cdrom, and
/mnt or /mnt/cdrom is set to "bind", then only the ~{client~} which ran the mount
command will be able to see it.  However, if the item is set to "share", then
any new mount points under it will be ~{global~} and processes from other ~{clients~}
will be able to see the contents of /mnt/cdrom as well.

For the most part, you probably want share rather than bind.  The main
exception is anything in /bedrock; as if anything there is set to "share"
then the ~{explicit~} path will not function properly.  Anything in `/bedrock`
should be set to "bind".  If you put `/bedrock/clients`, or any specific
~{client,~} on its own filesystem, be sure to both (1) add it to `/etc/fstab` to be
mounted at boot and (2) add a bind item for it to your ~{clients~} (or just to
the default framework).

Example:

`bind = /bedrock, /bedrock/brpath, /bedrock/clients/bedrock`

### {id="client.conf-union"} Union

Both bind and share have one notable fault: one cannot call `rename()` on them.
Typically, one shares or binds a directory which never gets `rename()`'d and so
this is a non-issue.  However, there is a notable exception with some files
in `/etc`.  Files such as `/etc/passwd` should be ~{global~}, but neighboring files
such as `/etc/issue` should be ~{local~}.  Thus, one cannot simply bind or share
all of `/etc`.  Attempting to bind or share `/etc/passwd` will cause problems when
the file is updated, as that file is updated via `rename()`.

The solution for this is the union setting.  Union can be set on a directory
and told to only treat some files as ~{global~} and leave others as ~{local~}.  This
is particularly important for `/etc`.  The downside to union is that it does
have some overhead; one would not want a performance-sensitive database, for
example, running on union.  Thus, union should only be used where `rename()` is
an issue such that bind and share cannot be used.

Note that while one can typically break up one share or bind line into multiple
ones without any trouble, union's syntax requires any collection of items
within a union directory all be spelled out on the same potentially long line.

Example:

`union = /etc: profile, hostname, hosts, passwd, passwd-, group, group-, shadow, shadow-, gshadow, gshadow-, sudoers, resolv.conf, machine-id`

### {id="client.conf-hooks"} Preenable, Postenable, Predisable, Postdisable

Bedrock Linux supports hooks to run programs just before or after a ~{client~} is
enabled or disabled.  Note that the programs are run in the core; if you
would like to run them in the ~{client~} that is being enabled or disabled, the
script itself must call `brc`.  Also note that the first argument to the
program will be the name of the ~{client~}.

Bedrock Linux 1.0beta1 Hawky uses the "preenable" script to force certain
symlink setups on ~{clients~}.

Other possible uses for this being explored for future releases are:

- Mount a sshfs or other remote filesystem on preenable and umount it on
postdisable so that a remote machine can be treated like a ~{client~}.  This can
be advantageous over something such as `ssh -X` in that all of the latency
will be on disk access, not user interface.

- Merge some ~{global~} files such as `/etc/passwd` on ~{client~} enable and disable so
that the UID and GIDs of the files on the ~{client~} and the rest of the Bedrock
Linux system are set proper if the ~{client~} is also being used as a stand-alone
system.  This could be useful to dual-boot with a ~{client~} or have a
liveusb/livecd Bedrock Linux system which automatically detects and adds
~{local~} systems as ~{clients~} on boot.

Example:

`preenable = /bedrock/share/brs/force-symlinks`

### {id="client.conf-framework"} Framework

Multiple ~{clients~} will likely share similar if not identical settings. Instead
of duplicating many settings, a framework can be used to indicate that a
collection of settings stored in

    /bedrock/etc/frameworks.d/~(frameworkname~)

is to be utilized.  Frameworks have the exact same syntax as normal
client.conf files (and can refer to each other).  Typical Bedrock Linux
systems may have one or two frameworks which which most ~{client~} configurations
utilize.

A reference framework with recommended defaults for most ~{clients~} should be
available by default at

    /bedrock/etc/frameworks.d/default

Example:

    framework = default

### Full example

    framework = default

or

	share = /proc, /sys, /dev, /home, /root, /lib/modules, /tmp, /var/tmp, /mnt
	share = /media, /run
	bind =  /bedrock, /bedrock/brpath, /bedrock/clients/bedrock
	union = /etc: profile, hostname, hosts, passwd, group, shadow, sudoers, resolv.conf, machine-id
	preenable = /bedrock/share/brs/force-symlinks


## {id="udev"} udev

By default, Bedrock Linux uses mdev rather than udev.  A number of
applications, such as xorg and SDL2 programs, assume udev is available and mdev
alone may not be sufficient for your purposes.  If you would like to use udev
instead, ensure you have udev in a ~{client~}, and then follow the instructions
below.

You must modify two files.  The location of these files can differ a bit
depending on if you are booted into another system installing Bedrock Linux or
if you are in a running Bedrock Linux system.

If you are in another system with the Bedrock Linux filesystem at
~(/mnt/bedrock~), the files are located at

- `~(/mnt/bedrock~)/etc/init.d/rcS.udev`
- `~(/mnt/bedrock~)/etc/init.d/rcS.clients`

If you are in a Bedrock Linux system, modify these files:

- `/bedrock/clients/bedrock/etc/init.d/rcS.udev`
- `/bedrock/clients/bedrock/etc/init.d/rcS.clients`

Once you have found the files, modify them accordingly:

- edit `rcS.udev` so that the `UDEV_CLIENT` variable indicates which ~{client~}
  provides udev.
- add `sh /etc/init.d/rcS.udev` (verbatim, do not change to compensate for
  where the system is currently mounted) to `rcS.clients`.

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

- In order for the core Bedrock Linux to be treated as a ~{client~}, it needs to be
  bind-mounted into /bedrock/~{clients~}.  This is done by default in fstab with
  this line:

		/ /bedrock/clients/bedrock  bind  defaults,bind  0  0

## {id="brshconf"} .brsh.conf

To use the Bedrock Linux meta-shell `brsh`, create a file in your home directory
called `.brsh.conf` which contains the contents that should be in your `$SHELL`
environment. For example, if you would like to use `bash`, have `~/.brsh.conf`
contain just:

	/bin/bash

## {id="rcSrcK"} rcS.clients and rcK.clients

To have a ~{client~} daemon start or stop at boot/shutdown, place the relevant
command to do this in `/etc/init.d/rcS.clients` and `/etc/init.d/rcK.clients`,
respectively.  If you are configuring this from installation where Bedrock
Linux's filesystem is mounted somewhere, prepend the mount point (such as
~(/mnt/bedrock~) to the path).  If you are configuring this from a running
Bedrock Linux system, be sure to access the files in the core, in
`/bedrock/clients/bedrock/etc/init.d/`.

Be sure that the items fork off into the background if they are long-running,
such as daemons.  Consider appending `&`.

For example, to start Debian squeeze's `cups` daemon at boot, place
the following in your `/etc/init.d/rcS.clients`:

	brc squeeze /etc/init.d/cups start

And, to ensure it properly closes at shutdown, place the following in your
`/etc/init.d/rcK.clients`:

	brc squeeze /etc/init.d/cups stop

If you would like start/stop daemons during it which were written for systemd,
you may have to manually parse the unit files looking for `Exec=` lines to
figure out what to place here, as managing systemd daemons are not yet directly
supported in Bedrock Linux.  However, so long as the daemon is not functionally
dependent on systemd to run, it should be possible to figure out what systemd
is doing to manage the daemon and do so yourself.

## {id="brpconf"} brp.conf

The file at `/bedrock/etc/brp.conf` is responsible for managing the filesystem
at `/bedrock/brpath` filesystem.  This filesystem is used to make files from
other ~{clients~} accessible, altering them as necessary so things "just work".  If
any ~{client~} provides a file, this file could be made accessilbe through the
`/bedrock/brpath` filesystem for the other ~{clients~}.

For all of the headings in the config except ~{client~}-order, any keys will show
up on the root of the brp filesystem and will union all of the values for all
of the ~{clients~}.  For example, the line

    /rootfs = /

means that if one looks at /bedrock/brpath/rootfs one will see a union of all
of the root directories of all of the ~{clients~}.

Items in the "pass" heading are passed through unmodified.  Items in the
"brc-wrap" heading are wrapped in a script to call brc to change the ~{local~}
context; brc-wrap items should typically be directories containing executables.
Finally, "exec-filter" items are passed through unmodified except for "Exec="
and "TryExec=" lines which are modified to handle ~{local~} context issues.

If multiple ~{clients~} can provide the same file, the one which provides the file
is the highest priority one of the group.  To set the priority, add ~{clients~} in
the order you would like, one per line, under the "client-order" heading.

For example:

    [pass]
    /rootfs = /
    /man  = /usr/local/share/man, /usr/share/man
    /info = /usr/local/share/info, /usr/share/info
    /icons = /usr/local/share/icons, /usr/share/icons
    [brc-wrap]
    /bin  = /usr/local/bin, /usr/bin, /bin
    /sbin = /usr/local/sbin, /usr/sbin, /sbin
    [exec-filter]
    /applications = /usr/local/share/applications, /usr/share/applications
    [client-order]
    centos
    debian
    arch

The brp filesystem's current understanding of the configuration can be read
back by reading the file at

    /bedrock/brpath/reparse_config

as root.  If you change the configuration file at runtime and would like brp to
reparse its config, write anything to that file as root

    {class="rcmd"} echo 1 > /bedrock/brpath/reparse_config

brs will automatically tell brp to reparse its config whenever a ~{client~} is
enabled or disabled.

As a side note, this will not work as you may expect:

    {class="cmd"} sudo echo 1 > /bedrock/brpath/reparse_config

That tells *the shell*, running as a normal user, to write the output of what
`sudo echo` says.  If you would like to use `sudo` for something like this, you
will need to use another program, such as `tee`, to do the actual writing, like
so:

    {class="cmd"} echo 1 | sudo tee /bedrock/brpath/reparse_config
