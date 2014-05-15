Title: Bedrock Linux 1.0alpha4 Flopsie Tips, Tricks and Troubleshooting
Nav: flopsie.nav

Bedrock Linux 1.0alpha4 Flopsie Tips, Tricks and Troubleshooting
================================================================

This page contains tips, tricks and troubleshooting advice for various software
and clients for Bedrock Linux 1.0alpha4 Flopsie.

- [Tips](#tips)
	- [Client Aliases](#client-aliases)
- [General issues](#general)
	- [Proprietary Nvidia Drivers](#proprietary-nvidia-drivers)
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

## {id="tips"} Tips

### {id="client-aliases"} Client Aliases

Rather than typing `brc ~(client~)`, one can shave some keystroke by generating
aliases for all of the clients, like so:

	for CLIENT in $(bri -l)
	do
		alias $CLIENT="brc $CLIENT"
		alias s$CLIENT="sudo brc $CLIENT"
	done

## {id="general"} General issues

### {id="proprietary-nvidia-drivers"} Proprietary Nvidia Drivers

The official Nvidia proprietary drivers works well in Bedrock Linux if set up
properly.

Note, the proprietary nvidia drivers are functionally two components: the
userland component and the kernel module.  The goal is to get the kernel module
in /lib/modules so it can be utilized by the rest of the system, and to get the
userland component into (1) the client that provides xorg and (2) clients which
you would like to have graphics acceleration.  Finally, note that mixing nvidia
driver version probably isn't a good idea; it may be best to stick with a
single version everywhere.  However, that doesn't mean it has to come from the
same place.  If a client has a nvidia proprietary driver version 310.19, and
you can download the official driver installer from nvidia's website of the
same 310.19 version, the two will almost certainly play along nicely.

First, note that nvidia's proprietary drivers do not play nicely with the
nouveau drivers, and so the nouveau drivers must be disabled.  In the client
that provides the /dev manager (either the core for mdev, or the client that
provides udev if you are using udev), create or append to the file at
`/etc/modprobe.d/blacklist` the following

	blacklist nouveau

If nouveau is currently loaded, it will have to be removed.  If you have
difficulty `{class="rcmd"} rmmod`'ing it because it is in use, reboot.

Next, the proprietary driver module.  In the client that provides the kernel
(so the versions match), make sure `/lib/modules` is shared and install the
proprietary nvidia driver module by doing one of the following:

- Installing a package from the client's repository.  For example, Arch's
  "nvidia" package.
- Using the official proprietary nvidia driver with the `-K` option to install
  only the kernel.
- Using the official proprietary nvidia driver with*out* the
  `--no-kernel-module` option so that it installs both the userland and,
  importantly, the kernel module.

Make sure `/lib/modules` is also shared in the client that provides xorg so
that the module will be loaded when xorg is started.

Finally, install the userland component in all of the clients which you would
like to have acceleration in xorg.  There are two strategies here:

- The "proper" way is to install the (same version of) the drivers in the
  client, either through their package manager, or through the official nvidia
  driver with the `--no-kernel-module` option.  If you have a 32-bit client on
  a 64 bit system, you can use the x86 nvidia driver prefixed with "linux32" so
  it doesn't complain about being on a 64 bit system.
- Alternatively, you can install the userland component of the drivers into the
  client that provides xorg and simply distribute the important files around to
  the other clients, if everything is of the same architecture (no mixing x86
  and x86_64).  Sharing with `bind` may be tedious since there are many
  individual files in directories with files that should not be shared.
  Sharing with `union` could work but has not been tried.  As an alternative,
  simply copy the files around.  The files that need to be distributed appear
  to be (this list may be incomplete):
  - /usr/lib/libGL.so.\* (all of the files)
  - /usr/lib/nvidia/ (can just copy/share the directory)
  - /usr/lib/libnvidia-\* (all of the files)


### {id="dev-fd-errors"} /dev/fd errors

If you receive errors along these lines:

	/dev/fd/~(N~): No such file or directory

where ~(N~) is a number, this is most likely due to the fact that the device
manager you are using is not setting up `/dev/fd` as some programs expect.
This can be solved (for the current session) by running:

- {class="rcmd"}
- rm -r /dev/fd
- ln -s /proc/self/fd /dev

To solve this permanently, one could simply add those two lines to
`/etc/rc.local` in the core Bedrock such that it is run every time Bedrock
Linux is booted.

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

- Try using `udev` if you aren't already.  See the [configuration page item about udev](configure.html#udev).


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

If you use sudo, make sure you have a "secure_path" line in `/etc/sudoers` which includes the entire root PATH, such as:

	Defaults secure_path="/bedrock/bin:/bedrock/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/bedrock/brpath/bin:/bedrock/brpath/sbin"

If you use su *without the -l flag*, consider changing the relevant lines in `/etc/login.defs` to the following:

	ENV_SUPATH PATH=/bedrock/bin:/bedrock/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/bedrock/brpath/bin:/bedrock/brpath/sbin
	ENV_PATH PATH=/bedrock/bin:/usr/local/bin:/usr/bin:/bin:/bedrock/brpath/bin

Note that

- busybox does not provide `sudo` and
- busybox's `su` does not seem to respect `/etc/login.defs`

Thus, neither of these items will resolve anything in the core Bedrock, only in
clients.  In the core, you could:

- log in directly to a tty
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
is configured in `gentoo.conf` to be shared, and you have your core Bedrock
system on a separate, smaller partition, then this error is because `/var/tmp`
is stored on the smaller core Bedrock partition. To fix it, just unshare
`/var/tmp` from Gentoo in your `brclients.conf`.

### {id="fedora"} Fedora

#### {id="yum-problems"} Problems with using yum.

Febootstrap does not seem to always include the `fedora-release` package. This is
troublesome, as the package is utilized to access the Fedora repositories. If you
find difficulties using `yum`, you might be able to resolve this by downloading
the `fedora-release` package for the given release (e.g.:
`fedora-release-17.noarch.rpm`), and install it thusly (from within the Fedora
client, via `brc`):

	{class="rcmd"} rpm -i fedora-~(VERSION~).noarch.rpm

You should then be able to use `yum` to access Fedora's repositories as one
normally would.
