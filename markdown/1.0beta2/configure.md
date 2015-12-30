Title: Bedrock Linux 1.0beta2 Nyla Configuration Instructions
Nav: nyla.nav

TODO: adjtime

Bedrock Linux 1.0beta2 Nyla Configuration Instructions
======================================================

- [rc.conf](#rc.conf)
	- [TZ](#tz)
	- [LANG](#lang)
	- [NPATH](#npath)
	- [SPATH](#spath)
	- [MANPATH](#manpath)
	- [INFOPATH](#infopath)
	- [XDG\_DATA\_DIRS](#xdg\_data\_dirs)
- [strata.conf and strata.d/\*](#strata.conf)
	- [share](#share)
	- [bind](#bind)
	- [union](#union)
	- [preenable/postenable/predisable/postdisable](#hooks)
	- [enable](#enable)
	- [init](#init)
	- [unmanaged](#unmanaged)
	- [framework](#framework)
- [aliases.conf and aliases.d/\*](#aliases.conf)
- [brp.conf](#brp.conf)
- [brn.conf](#brn.conf)
- [fstab](#fstab)

## {id="rc.conf"} rc.conf

The `rc.conf` configuration file, located at `/bedrock/etc/rc.conf`, is used to
populate a number of important environment variables.

### {id="tz"} TZ

`TZ` variable indicates timezone information.  It can be in one of three forms:

- POSIX, e.g. "EST5EDT,M3.2.0,M11.1.0".  For documentation, see:
	- [http://pubs.opengroup.org/onlinepubs/7908799/xbd/envvar.html](http://pubs.opengroup.org/onlinepubs/7908799/xbd/envvar.html) (UNIX)
	- [http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html](http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html) (GNU)
	- [http://www-01.ibm.com/support/docview.wss?uid=isg3T1000252](http://www-01.ibm.com/support/docview.wss?uid=isg3T1000252) (AIX)
- Olson, e.g. "America/New_York".  This requires a timezone database in every
  strata, and is thus not recommended.
- A file path to an Olson timezone database file.  By ensuring the database
  is global, all strata will see the same timezone information.  However, since
  various distros will try to independently control the timezone database,
  they may conflict.  Instead, it is recommended to copy the desired Olson
  database file to `/bedrock/etc/localtime` and direct `TZ` to that.  For
  example, copy `/usr/share/zoneinfo/America/New_York` if you are in EST/EDT.

Some software may ignore the `TZ` environment variable and instead attempt to
read `/etc/localtime` to determine the current timezone.  Bedrock Linux will
copy `/bedrock/etc/localtime` to `/etc/localtime` when enabling a ~{stratum~}
to cover this possibility.

### {id="lang"} LANG

Sets the language/locale information.

e.g.: `LANG=en_US.UTF-8`

Note locale information must be installed/generated in every ~{statum~}, as it
is currently set to ~{local~} to avoid conflicts.

### {id="npath"} NPATH

Sets the normal user POSIX PATH variable.  These are the directories in which
programs look for executables.  If you aren't sure what to put here, you almost
certainly want the value in the example below.  Note that `/etc/profile` (which
should be sourced by your shell when it starts) will add items to the beginning
and end of this variable to make it play with Bedrock specific functionality.

e.g.: `NPATH=/opt/bin:/usr/local/bin:/usr/bin:/bin`

### {id="spath"} SPATH

Sets additional directories for the super user's (aka root's) POSIX PATH
variable.  Same general idea as above, but for the root user who probably needs
access to the s\* directories that the non-root user does not.

e.g.: `SPATH=/opt/sbin:/usr/local/sbin:/usr/sbin:/sbin`

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


## {id="strata.conf"} strata.conf and strata.d/\*

Per-~{stratum~} configuration is read from `/bedrock/etc/strata.conf` and
whatever files are found in `/bedrock/etc/strata.d/`.  Typically most
~{strata~} will use the same, default configuration.  However, occasionally it
is necessary or useful to adjust it, either for all ~{stratum~} or just a
handful of individual ~{stratum~}.

### {id="share"} share

`share` indicates a given path should be considered ~{global~}, i.e. that
everything should see the same set of files at any of these paths rather than
their own version.  New mount points in any of these directories will also be
treated as ~{global~} (`mount --share`'d). e.g.:

    share = /proc, /sys, /dev, /home, /root, /lib/modules, /tmp, /var/tmp, /mnt
    share = /media, /run

### {id="bind"} bind

`bind` is similar to `share` except new mount points made under these
directories are not treated as ~{global~}.  This is primarily used to avoid
recursion where one ~{global~} item is mounted within another.  In general,
anything set to be ~{global~} in `/bedrock` should be `bind`'d rather than
`share`'d. e.g.

    bind = /bedrock, /bedrock/brpath, /bedrock/strata/bedrock

Careful with the order - directories should come before what they contain.

### {id="union"} union

One cannot `rename()` the `share` or `bind` items.  This is problematic for some
files in `/etc` which (1) have neighboring items which are ~{local~} (and so we
cannot share all of `/etc`) and (2) which are updated via `rename()`. Any files
which hit the above two situations should be `union`'d.  One can break up `share`
and `bind` items if the lines get to long, but `union` items have a picky syntax;
keep all of the items that are contained in the same directory on the same
line. e.g.:

`union = /etc: profile, hostname, hosts, passwd, group, shadow, sudoers, resolv.conf, machine-id, shells, systemd/system/multi-user.target.wants/bedrock.service, locale.conf, motd, issue, os-release, lsb-release, rc.local`

### {id="hooks"} preenable/postenable/predisable/postdisable

Bedrock Linux has hooks to run executables before/after enabling/disabling a
stratum.  If you would like to do something such as ensure a
~{stratum~}-specific mount point is mounted before enabling a ~{stratum~},
these hooks could be utilized to achieve this.  For example, you could check if
an NFS mount point is mounted on `/bedrock/strata/~{networked-stratum~}` and,
if it is not, mount it just before enabling the ~{stratum~}.  You could then
unmount it when disabling the ~{stratum~}.
e.g.:

    preenable = /bedrock/share/brs/force-symlinks
    preenable = /bedrock/share/brs/setup-etc
    preenable = /bedrock/share/brs/run-lock

### {id="enable"} enable
`enable` indicates if the given ~{stratum~} should be enabled at boot time.  This
can either be `boot` (indicating it should be enabled at boot time) or
`manual` (indicating it will be enabled/disabled manually). e.g.

    enable = boot

If multiple `enable` items are set, the latest one takes precidence.  Thus, one
can include `enable = boot` in a ~{framework~} (~{frameworks~} described below)
and then override it with a ~{stratum~}-specific `enable = manual`.

Generally one would want `enable = boot`; however, if some ~{stratum~} is
rarely used it may be best left to `manual`.

### {id="init"} init

`init` indicates the given ~{stratum~} can provide an init system.  The value
should be the command to run at boot if this ~{stratum~} is chosen to provide ~{init~}.
The value is the entire line after the `=`; do not place multiple init commands
in the same line separated by `,`'s as one can do with `share`.  Historically,
`/sbin/init` is utilized as the command to run the init; however, systemd
systems seem to prefer `/lib/systemd/system` without a corresponding symlink at
`/sbin/init`. e.g.:

    init = /sbin/init

Note multiple `init` values can be provided if a given ~{stratum~} provides
multiple init systems; all of the resulting values will be listed in the
init-selection menu.

### {id="unmanaged"} unmanaged

When enabling a ~{stratum~}, Bedrock Linux will mount some filesystems (e.g.
from other `stratum.conf` settings such as `share`), and then proceed to unmount
filesystems when disabling the ~{stratum~}.  To manage this sanely, Bedrock Linux
expects the ~{stratum~} to have no mount points when disabled.

If there is some exception where Bedrock Linux should accept a pre-existing
mount point when enabling a ~{stratum~}, or leave some mount point mounted when
disabling a ~{stratum~}, this can be indicated via the `unmanaged` setting. For
example, of a ~{stratum~}'s root directory is mounted over NFS, one could indicate
Bedrock Linux should not touch a mount point at root via:

    unmanaged = /

Nonetheless it is useful to manage such mount points, e.g. ensure the NFS mount
is mounted at ~{stratum~} enable.  To do this use the `preenable` and
`postdisable` hooks.

### {id="framework"} framework

"framework" is used to inherit settings placed in
`/bedrock/etc/frameworks.d/~(framework-name~)`.  This is useful to avoid
excessive repetition when multiple strata share the same settings. e.g.

    framework = default

Most ~{strata~} should use `framework = default`, with the notable exception of
the ~{global stratum~} which should use `framework = global`.

## {id="aliases.conf"} aliases.conf and aliases.d/\*

Aliases can be created for ~{strata~}.  In most contexts the alias can be used
in place of the ~{stratum~}, e.g. with `brc` and `bri`.  Bedrock Linux requires
some aliases for tracking ~{singleton strata~}, but you are free to create
others to your liking.

Alias information is read from `/bedrock/etc/aliases.conf` and from the files
found in `/bedrock/etc/aliases.d/`.  Simply indicate the desired alias name
followed by an `=` and then the ~{stratum~} it is aliased to.  For example,
Debian releases are often referred to by their current state in the development
process in addition to their name.  Thus:

    oldstable = wheezy
    stable    = jessie
    testing   = stretch
    unstable  = sid

When stretch becomes stable, the aliases can be adjusted accordingly so
"stable" points to the new stable release.

## {id="brp.conf"} brp.conf

The file at `/bedrock/etc/brp.conf` is responsible for managing the filesystem
at `/bedrock/brpath` filesystem which is the underlying mechanism for the
~{implicit~} access rules.  The `brpath` filesystem is used to make files from
other ~{strata~} accessible, altering them as necessary so things "just work".
If any ~{strata~} provides a file, this file could be made accessilbe through
the `/bedrock/brpath` filesystem for the other ~{strata~}.

The `[pass]`, `[brc-wrap]` and `[exec-filter]` headings should contain
key-value pairs separated by an equals sign.  The keys will indicate
files/directories that should show up at `/bedrock/brpath`, and the values will
indicate files/directories that will be unioned to populate the mount point's
files.

For the keys, a trailing "/" indicates the item should be a directory (and
thus the values will be used to populate files in the directory).  Otherwise,
the item is treated as a file and the values indicate possible files it could
represent.

For the values, a prefixed ~{stratum~} (e.g. "~(stratum~):/path/to/file")
indicates the value corresponds to that specific ~{stratum~}'s file/directory.
Otherwise, all of the enabled ~{strata~} will be searched as possible sources
for the file.

The `[stratum-order]` heading should be followed by a list of ~{strata~}, one
per line.  These indicate the priority order for values that do not have a
`~(stratum~):` prefix.  Note this does not have to be an exhaustive list - any
enabled ~{strata~} not listed will still be used; they will simply be treated as
lower priority than the those listed.

An example `brp.conf`:

    # Nothing special with this "pass" category, it just passes files through
    # untouched.
    [pass]
    /man/      = /usr/local/share/man,   /usr/share/man
    /info/     = /usr/local/share/info,  /usr/share/info
    /icons/    = /usr/local/share/icons, /usr/share/icons
    /firmware/ = /lib/firmware
    /zoneinfo/ = /usr/share/zoneinfo
    
    # This will wrap all items it finds in a script that calls brc to set the local
    # context.  This is important for executables to "just work".
    [brc-wrap]
    /bin/  = /usr/local/bin,  /usr/bin,  /bin
    /sbin/ = /usr/local/sbin, /usr/sbin, /sbin
    
    # By convention, items in "/pin/" are given a higher priority than even local
    # files.  This is used, for example, to ensure a given executable which is
    # strongly related to the init system is always tied to the init system.
    /pin/bin/systemctl  = init:/usr/bin/systemctl,  init:/bin/systemctl
    /pin/bin/rc-service = init:/usr/bin/rc-service, init:/bin/rc-service
    /pin/bin/rc-status  = init:/usr/bin/rc-status,  init:/bin/rc-status
    /pin/bin/rc-update  = init:/usr/bin/rc-update,  init:/bin/rc-update
    
    /pin/sbin/poweroff   = init:/usr/sbin/poweroff,   init:/sbin/poweroff, init:/usr/bin/poweroff, init:/bin/poweroff
    /pin/sbin/reboot     = init:/usr/sbin/reboot,     init:/sbin/reboot,   init:/usr/bin/reboot,   init:/bin/reboot
    /pin/sbin/shutdown   = init:/usr/sbin/shutdown,   init:/sbin/shutdown, init:/usr/bin/shutdown, init:/bin/shutdown
    /pin/sbin/halt       = init:/usr/sbin/halt,       init:/sbin/halt,     init:/usr/bin/halt,     init:/bin/halt
    /pin/sbin/systemctl  = init:/usr/sbin/systemctl,  init:/sbin/systemctl
    /pin/sbin/rc-service = init:/usr/sbin/rc-service, init:/sbin/rc-service
    /pin/sbin/rc-status  = init:/usr/sbin/rc-status,  init:/sbin/rc-status
    /pin/sbin/rc-update  = init:/usr/sbin/rc-update,  init:/sbin/rc-update
    
    # This will modify some of the fields in the freedesktop standard .desktop
    # items to fix local context issues.
    [exec-filter]
    /applications = /usr/local/share/applications, /usr/share/applications
    
    [stratum-order]
    # Add strata here in the order you want them to take priority when multiple
    # ones provide a file.  One stratum per line.
    centos
    debian
    arch

## {id="brn.conf"} brn.conf

`strata.conf`/`strata.d/` indicates which init system(s) a given ~{stratum~}
can provide, if any.  The user is then (optionally) prompted during boot to
chose which of them to use for the given session.  `/bedrock/etc/brn.conf` can
be used to configure a default ~{stratum~}/command pair for init as well as a
timeout for the init selection menu.

`timeout` indicates the amount of time, in seconds, the user is provided to
make a selection before the default is automatically chosen.  Set to 0 to
indicate no time should be provided - always boot directly into the configured
default.  Set to -1 to indicate no time limit - nothing will be chosen
automatically, the user has as much time as desired.

To chose a default ~{stratum~}, set the `default_stratum =` and `default_cmd`
items accordingly.  With those set, a user can simply hit enter at the menu and
the default item will be chosen.  Moreover, if a timeout is set, the default
item will be chosen when the timeout expires.

## {id="fstab"} fstab

The content below revolves around three configuration files:

- `/etc/fstab`
- `/bedrock/etc/fstab`
- `/bedrock/etc/frameworks.d/default`

The first - `/etc/fstab` - is ~{global~} by default.  If you are editing it at
install time - when you're not yet actually running Bedrock Linux - the file
may be at `$GLOBAL/etc/fstab` (e.g. `/bedrock/strata/global/etc/fstab`), and
**not** directly at `/etc/fstab` quite yet.  The latter two should be at
`/bedrock/etc/fstab` irrelevant of the circumstances: either you're hijacking
such that it is on the root, or you're doing a manual install and have made a
symlink for `/bedrock`.

Bedrock Linux provides a menu on boot to let the user choose which init system
to use for the given session.  Naturally this menu must be provided before the
init system is run, which means it must be provided before `/etc/fstab` is
parsed by the init system.  If the init system is on a partition other than the
boot-time root partition, this partition must be mounted by something other
than `/etc/fstab`.  For these mounts Bedrock Linux provides its own pre-init
time fstab file at `/bedrock/etc/fstab`.

Some users prefer to make a partition specifically for `/bedrock/strata` or one
for each ~{strata~} within `/bedrock/strata` (e.g. a partition for
`/bedrock/strata/gentoo`, a partition for `/bedrock/strata/slackware`, etc).
Since these partitions can potentially contain init systems,
`/bedrock/etc/fstab` was created specifically to support these workflows.  If
you do not have special partitions for/within `/bedrock/strata`, but rather
kept that directory on the root partition, you probably do not need to worry
about `/bedrock/etc/fstab`.  However, you may still need to worry about the
default framework - keep reading below.

Other common mount points - such as `/home` and `/tmp` - can use `/etc/fstab`
just as they are utilized in other distros.  Nonetheless, if you would like to
have `/bedrock/etc/fstab` mount partitions such as `/home` it can do so.

Be sure not to include the same mount item in *both* `/etc/fstab` *and*
`/bedrock/etc/fstab` - any given mount should only appear in one or the other.
When you place anything in `/bedrock/etc/fstab` make sure you do not also have
it within `/etc/fstab`.

For the most part, `/bedrock/etc/fstab` utilizes the same syntax as the typical
`/etc/fstab`.  However, there are a few special things to keep in mind for
`/bedrock/etc/fstab`:

- `/bedrock/etc/fstab` is mounted by the Bedrock Linux provided busybox
  executable in a limited environment.  It may not understand some less common
  fstab features which would have been understood in `/etc/fstab`.  For those
  features, `/etc/fstab` will be required.  It is possible to run into a
  catch-22 in which some special fstab command that busybox does not
  understand is required to provide a given init - avoid these situations.

- Since `/bedrock/etc/fstab` is mounted so early - before init - various
  Bedrock Linux subsystems are not yet enabled.  For example, the systems in
  place to ensure ~{global~} files are available in the same place from
  everyone's point-of-view or that ~{rootfs~} stratum's files are available at
  the explicit path `/bedrock/strata/~(rootfs-stratum-name~)/` are not yet
  enabled.  Thus, special consideration must be utilized when mounting into
  either the ~{global~} or ~{rootfs~} ~{strata~}.

- The ~{rootfs stratum~} is on the root of the filesystem tree, i.e. `/`, from
  `/bedrock/etc/fstab`'s point of view.  Thus, if you would like to place
  ~{rootfs~}' `/boot` on its own partition, it should be mounted at `/boot` and
  not, for example, `/bedrock/strata/jessie/boot`.

- `/bedrock` is considered part of the rootfs stratum, and thus anything in
  `/bedrock` should be mounted directly onto the root of the filesystem tree.
  For example, if you have `/bedrock/strata` on its own partition, it should
  mount the partition onto `/bedrock/strata`.

- Any ~{global~} mount points, such as `/home` or `/tmp`, should be mounted in the
  ~{global stratum~}.  If ~{global~} is also ~{rootfs~}, then `/home` should be
  mounted to `/home`.  However, if ~{global~} is not ~{rootfs~}, `/home` should
  be mounted to `/bedrock/strata/~(global-stratum-name~)/home`.  The default
  framework settings will then ensure it is accessible in the other strata.

- Order matters.  Any mount point which contains a directory in which another
  device will be mounted should be mounted first.

Additionally, the default framework should be made aware of some of these
additional mount points; place such changes into
`/bedrock/etc/frameworks.d/default`.  Any mount points in `/bedrock/` should be
configured as `bind` items.  For example, if you made `/bedrock/strata` its own
partition, add

    bind = /bedrock/strata

and the `/bedrock/strata` mounted in in `/bedrock/etc/fstab` will be made
accessible in the other ~{strata~}.  Careful not to double up - ensure there is
only one `bind` item for any given `bind` directory.  For example, by default
Bedrock Linux is configured with a `bind` item for `/bedrock/run` - no need to
make another one for that directory.

Any mount global mount points should be configured as `share` items.  For
example, if you made `/var/log` its own partition and wish for it to be
considered global, add

    share = /var/log

to the default framework.  Again, careful not to double up - ensure there is
only one instance of any given `share` item.  For example, `/home` should be
configured as a `share` item by default and should not be added again.
