Title: Bedrock Linux 1.0alpha3 Bosco Tips, Tricks and Troubleshooting
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Bosco Tips, Tricks and Troubleshooting
==============================================================

This page contains tips, tricks and troubleshooting advice for various software
and clients for Bedrock Linux 1.0alpha3 Bosco.

- [General issues](#general)
	- [Proprietary Nvidia Drivers](#proprietary-nvidia-drivers)
	- [DNS from the core does not work](#dns)
	- [/dev/fd errors](#dev-fd-errors)
	- [No keyboard or mouse in xorg](#no-kbd-mouse)
	- [Mount Table Unreadable](#no-mount-table)
	- [root/sudo path issues](#root-path)
	- [time issues](#time)
- [Client specific issues](#client-specific)
	- [Debian-based Linux distributions](#debian-based)
		- [Ubuntu/Upstart fix](#upstart-fix)
		- [Locale packages](#upstart-fix)
		- [Statoverride](#statoverride)
		- [Ubuntu resolv.conf](#ubuntu-resolvconf)
	- [Arch Linux](#arch)
		- [Pacman Filesystem Errors](#pacman-filesystem-errors)
	- [Gentoo Linux](#gentoo)
		- [/var/tmp out of space](#portage-out-of-space)
	- [Fedora](#fedora)
		- [Problems with using yum.](#yum-problems)



## {id="general"} General issues

### {id="proprietary-nvidia-drivers"} Proprietary Nvidia Drivers

The official Nvidia proprietary drivers works well in Bedrock Linux if set up
properly.  Various things to keep in mind:

- Try to use the same version (e.g.: 310.19) of the driver everywhere.  *If*
  the official straight-from-nvidia proprietary driver works, that would be
  best, as you can then use the same file to install in all of the clients that
  require it.  However, this is not always an option, as the official
  proprietary nvidia driver doesn't play well with every client distribution,
  in which case you'll need the specially modified version of the driver for
  the specific distribution (ie, the one from its repos).  No testing has been
  done for how well mixing and matching different driver release versions will
  go.

- You must make sure the kernel module is available in client which provides
  the xorg you use (as starting xorg will attempt to load the module).  Ensure
  `/lib/modules` is shared both there and the client which provides the kernel
  (if they are different).

- xorg needs to be installed the client which provides xorg and may or may not
  need to be installed in clients which will provide applications which require
  graphics card acceleration (such as compositing window manager, CAD tool or
  videogame).  Yes, this is a lot of extra disk space used, but it is necessary
  (as explained below).  If you'd rather save disk space, make all of these the
  same client; ie, use the same client to provide the kernel, xorg, and all
  graphics-card-acceleration-requiring applications.

- The proprietary nvidia driver has two components: a kernel module and a
  userland component.  The module is needed in the client which provides the
  kernel (ie, it needs to go into the relevant /lib/modules/ location);
  however, it does not need to be installed in every client.  You can use the
  `--no-kernel-module` flag with the official proprietary driver to only
  install the userland component, or `--kernel-module-only` to avoid installing
  the userland component.

- While it is possible to install the kernel module into one client while
  installing the driver from another (see `--kernel-source-path` flag), that's
  more work and not documented here.  You're welcome to take a crack at it,
  though - it works if you do it right.

- You should ensure nouveau is not enabled. Bedrock currently does not have any
system in place to manage kernel module loading. If you compiled your kernel
with nouveau, you can simple (re)move the module. To find it, run

		{class="cmd"} find /lib/modules -name nouveau

and move or delete the file (as root).

- Nvidia's current solution for multiarch doesn't seem to play well with the
  current solution implemented by some distros.  If you're on a 64-bit system
  and wish to run 32-bit software which requires graphics card acceleration, It
  may simply be easiest to create a 32-bit client for 32-bit applications and
  install the 32-bit nvidia driver in it like so:

		{class="rcmd"} linux32 sh ./NVIDIA-Linux-~(ARCH~)-~(VERSION~).run --no-kernel-module

The "linux32" command ensures the driver doesn't complain about being in a
64-bit environment when installing.  Do not try this without
`--no-kernel-module` if you have a 64-bit kernel.


### {id="dns"} DNS from the core does not work

It seems that even if `ldd` reports busybox was statically compiled, when
compiled against glibc, the DNS libraries do not seem to be pulled it and
functionality such as `ping` or `wget` do not seem to work.  This is considered
a minor issue as a client should be able to provide this functionality such
that the core Bedrock Linux does not need it.  If you insist on remedying it,
you have two choices:

- you can statically compile busybox against a library such as uclibc or musl,
  but be warned [some consider this difficult](knownissues.html#static)

- you can compare the strace output of a "static" busybox in a client where it
works the strace output of it in the core to see what libraries it is using and
copy them into the core.

TODO: do the above and provide the libraries in the instructions here

#### {id="dev-fd-errors"} /dev/fd errors

If you receive errors along these lines:

	/dev/fd/~(N~): No such file or directory

where ~(N~) is a number, this is most likely due to the fact that the device
manager you are using is not setting up `/dev/fd` as some programs expect.
This can be solved (for the current session) by running:

- {class="rcmd"}
- rm -r /dev/fd
- ln -s /proc/self/fd /dev

To solve this permanently, one could simply add those two lines to
`/etc/rc.local` in the core Bedrock such that it is run every time Bedrock Linux
is booted.

### {id="no-kbd-mouse"} No keyboard or mouse in xorg

If you run `startx` and do not have a keyboard or mouse:

- First, don't panic about your system being hard locked.  You can regain
  keyboard control and go to a tty by hitting alt-sysrq-r followed by the keys
  to go to the tty (such as ctrl-alt-F1).  Read up about
  [magic sysrq on linux](http://en.wikipedia.org/wiki/Magic_SysRq_key) if
  you're not familiar with it.

- Ensure you have the relevant keyboard and mouse packages installed.  On
  Debian-based systems, these would be `xserver-xorg-input-kbd` and
  `xserver-xorg-input-mouse`.

- You may need `AutoAddDevices` and `AllowEmptyInput` set to `False` in your `xorg.conf` file.  If this file already exists, it is probably at `/etc/X11/xorg.conf` in the client that provides `startx`; otherwise, you'll have to create it.  Try adding the following to the relevant `xorg.conf` file and starting the xserver:

		Section "ServerFlags"
			Option "AutoAddDevices" "False"
			Option "AllowEmptyInput" "False"
		EndSection

- Try using `udev` if you aren't already.


### {id="no-mount-table"} Mount Table Unreadable

If you are receiving errors such as

	df: Warning: cannot read table of mounted file systems

This could be because the application (such as `df`) is attempting to read
information from `/etc/mtab`, which is not being maintained.  What you can do instead, however, is symlink `/proc/mounts` (which is being maintained) to `/etc/mtab`, like so:

	{class="rcmd"} ln -f -s /proc/mounts /etc/mtab

This should remedy the issue.  If you like, you could run this in all of your clients:

	{class="rcmd"} brl ln -f -s /proc/mounts /etc/mtab

### {id="root-path"} Root sometimes loses PATH items

There are two common ways to switch from a normal user to root, both of which
can potentially change your `$PATH` away from what is desired.  To see the proper
path for the root user, login directly to a tty and run `echo $PATH`.

If you use sudo, consider adding a "secure_path" line to `/etc/sudoers` which includes the entire root PATH, such as:

	Defaults secure_path="/bedrock/bin:/bedrock/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/bedrock/brpath/bin:/bedrock/brpath/sbin"

If you use su *without the -l flag*, consider changing the relevant lines in `/etc/login.defs` to the following:

	ENV_SUPATH PATH=/bedrock/bin:/bedrock/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/bedrock/brpath/bin:/bedrock/brpath/sbin
	ENV_PATH PATH=/bedrock/bin:/usr/local/bin:/usr/bin:/bin:/bedrock/brpath/bin

Note that

- busybox does not provide `sudo` and
- busybox's `su` does not seem to respect `/etc/login.defs`

Thus, neither of these items will resolve anything in the core Bedrock, only in
clients.  In the core, you could:

- log in directoy to a tty
- use `su -l`
- use another client's tool to become root and then run the core's shell, such
  as `sudo brc bedrock brsh`

### {id="time"} time issues

Bedrock manages the timezone through the [TZ variable which is set in
rc.conf](configure.html#tz).  This should be picked up by /etc/profile and, by
extension, your shell and every other program on your system irrelevant of
client, so long as they all follow the POSIX TZ standard.  If you set this as
described, it should not require any tweaking per client.  If you are having
trouble with your timezone, see if maybe you are setting `$TZ` elsewhere such
as your shell's rc file (e.g.: `.bashrc`) or are using a shell that is not
parsing `/etc/profile` (`brsh` should parse `/etc/profile`)

To set the time, use an application such as `{class="rcmd"} ntpdate` from a client, then run
`{class="rcmd"} hwclock -s` to save the result to your hardware clock so it sticks across
reboots.

## {id="client-specific"} Client specific issues

### {id="debian-based"} Debian-based Linux distributions

#### {id="upstart-fix"} Ubuntu/Upstart fix

Ubuntu uses Upstart for its init system. Many services in Ubuntu have been
modified to depend on `init` to be specific to Upstart and refuse to operate
otherwise. This means they do not work in chroots out of the box. See the
[here](https://bugs.launchpad.net/ubuntu/+source/upstart/+bug/430224)
for more information. One way to alleviate this is to run the following two
commands as root (within the Ubuntu client, via using `brc` for each command or
`brc` to open a shell in the client and run it from the shell):

- {class="rcmd"}
- dpkg-divert --local --rename --add /sbin/initctl
- ln -s /bin/true /sbin/initctl

#### {id="upstart-fix"} Locale packages

In Debian, if you get errors about locale, try installing the `locales-all`
package.

In Ubuntu, if you get errors about locale, try installing the appropriate
`language-pack-~(LANGUAGE~)` (such as `language-pack-en`) package.

#### {id="statoverride"} Statoverride

If you get an error about statoverride when using apt/dpkg, it can most likely
be resolved by deleting the contents of `/var/lib/dpkg/statoverride` (from
within the client - ie, `~(/var/chroot/client~)/var/lib/dpkg/statoverride` from
outside). Leave an empty file there. This seems to occur due to the fact an
expected daemon is not running.

#### {id="ubuntu-resolvconf"} Ubuntu resolv.conf

If you have difficulty sharing `/etc/resolv.conf` in Ubuntu, note that it creates
a symlink for that file directing elsewhere. It should be safe to remove the
symlink and just create an empty file in its place

### {id="arch"} Arch Linux

#### {id="pacman-filesystem-errors"} Pacman Filesystem Errors

If you get errors about `could not get filesystem information for ~(PATH~)`
when using `pacman`, this is normal and mostly harmless so long as you have
sufficient free disk space for the operation you are attempting. This seems to
be caused by `pacman` assuming that the mount points it sees are the same as the
ones init sees (which would be a fair assumption in almost every case except
Bedrock Linux). You can configure `pacman` to not check for free disk space by
commenting out `CheckSpace` from `~(/var/chroot/arch~)/etc/pacman.conf`

### {id="gentoo"} Gentoo Linux

#### {id="portage-out-of-space"} /var/tmp Out of Space

If you get errors when updating Gentoo that `/var/tmp` is out of space, this is
most likely because portage uses `/var/tmp` to compile everything. If `/var/tmp`
is configured in `brclients.conf` to be shared, and you have your core Bedrock
system on a separate, smaller partition, then this error is because `/var/tmp`
is stored on the smaller core Bedrock partition. To fix it, just unshare
`/var/tmp` from Gentoo in your `brclients.conf`.

### {id="fedora"} Fedora

#### {id="yum-problems"} Problems with using yum.

Febootstrap does not seem to always include the `fedora-release` package. This is
troublesome, as the package is utilized to access the Fedora repositories. If you
find difficulties using `yum`, you might be able to respolve this by downloading
the `fedora-release` package for the given release (e.g.:
`fedora-release-17.noarch.rpm`), and install it thusly (from within the Fedora
client, via `brc`):

	{class="rcmd"} rpm -i fedora-~(VERSION~).noarch.rpm

You should then be able to use `yum` to access Fedora's repositories as one
normally would.
