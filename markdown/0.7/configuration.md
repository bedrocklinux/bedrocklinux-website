Title: Bedrock Linux 0.7 Poki Configuration
Nav: poki.nav

# Bedrock Linux 0.7 Poki Configuration

All ~+Bedrock~x Linux configuration is centralized in a single ini-format file at
`/bedrock/etc/bedrock.conf`.  After making any changes to it, run (as root)
`brl apply` to apply them.

Sections are in square brackets `[like-so]`.

Comments are specified with `#`.

Keys are to the left of `=` characters, and their values are to the right.
Values may be comma separated to indicate multiple values for a given key.

For example:

	[example-section]

	# example comment
	example-key = single-example-value

	# another example comment
	another-example-key = example-value-1, example-value-2, example-value-3

TableOfContents

## {id="locale"} Locale

### {id="locale-timezone"} timezone

Different programs in different distros handle timezone details slightly
differently.  ~+Bedrock~x attempts to enforce a single standard across the system.
The `[locale]/timezone` field indicates the desired Olson timezone.

For example:

	timezone = America/New_York

~+Bedrock~x will attempt to detect this in a ~{hijack~} install and populate the field
accordingly.

### {id="locale-localegen"} localegen

Many distros use `/etc/local.gen` to manage their locale information.  If
`[locale]/localegen` is populated, `brl fetch` will configure corresponding
~{strata~} during the fetch.

For example:

	localegen = en_US.UTF-8 UTF-8

Multiple comma-separated values may be provided.

~+Bedrock~x will attempt to detect this in a ~{hijack~} install and populate the field
accordingly.

### {id="locale-LANG"} LANG

Many programs use a `$LANG` variable to manage their locale.  If
`[locale]/LANG` is populated, ~+Bedrock~x will enforce this value across the
system.

For example:

	LANG = en_US.UTF-8

## {id="init"} init

~+Bedrock~x provides an init selection menu during the boot process.  This is
used to select which ~{stratum~}:`init` pair to use as the init for the given
session.

### {id="init-timeout"} timeout

The `[init]/timeout` field is used to indicate how long the init selection menu
will be displayed before automatically choosing the default ~{stratum~}:`init`,
if a default is specified.

A positive value indicates how long, in seconds, the menu should wait for input
before selecting the default init.

A value of `0` indicates the menu is to be skipped and the default init chosen
immediately.

A value of `-1` indicates the menu should wait for input indefinitely.

For example:

	timeout = 30

### {id="init-default"} default

The `[init]/default` field is used to indicate the desired default
~{stratum~}:`init` pair.  This will be selected automatically once
`[init]/timeout` expires, or upon hitting `enter` at a blank init-selection
prompt.

~+Bedrock~x will attempt to detect this in a ~{hijack~} install and populate
the field accordingly.

Most distros provide one init which either exists at or is symlinked to
`/sbin/init`, and so this is usually a safe default path for any given
~{stratum~}.  However, some distros may offer multiple init systems and
consequently require different file paths to differentiate between them.  `brl
fetch` attempts to grab a minimal version of the specified distro which might
lack an init; this is normal.

For example:

	default = void:/sbin/init

### {id="init-paths"} paths

The init selection menu offers every `[init]/paths` executable found in every
non-hidden ~{stratum~}.  If it is missing an init system you would like, feel
free to append it to the list.

## {id="global"} global

The `[global]` section is used to configure ~{global~} paths.  Everything not
specified in this section is ~{local~} by default, baring the hard-coded list
of ~{cross~} paths.


### {id="global-share"} share

`[global]/share` lists directories which should be considered ~{global~}.
Moreover, any new mount points created within these directories will also be
~{global~}.

### {id="global-bind"} bind

`[global]/bind` lists directories which should be considered ~{global~}.
However, any new mount points created within these directories will be
~{local~}.  This is primarily intended to avoid recursion when sharing nested
mount points.

### {id="global-etc"} etc

The technique used for `share` and `bind` above do not work with `/etc` files.
Thus, a separate configuration item, `[global]/etc`, is used for files and
directories within `/etc` that should be ~{global~}.  Unlike the other
`[global]` categories which use absolute paths, values here are relative to
`/etc`.

## {id="symlinks"} symlinks

Any `file-path = link-path` pairs under `[symlinks]` are enforced when
~{enabling~} ~{strata~}.

These are useful to standardize file paths which different distros handle
differently.  For example, some distros use `/var/run/` while others use
`/run`.  To ensure ~{cross~}-~{stratum~} compatibility, ~+Bedrock~x is configured
by default to ensure one is a symlink to the other.

## {id="etc-symlinks"} etc-symlinks

Any `file-path = link-path` pairs under `[etc-symlinks]`, where `file-path`
starts with `/etc`, are enforced whenever the filepaths in `/etc` are read.

This is useful to keep files essential for ~+Bedrock~x to work from being
overwritten at runtime.

## {id="etc-inject"} etc-inject

~+Bedrock~x ensures that, if the key path relative to `/etc` exists, it contains
content specified at the value's path.

For example:

	zsh/zshenv = /bedrock/share/zsh/include-bedrock

ensures that, if a user installs `zsh` from a ~{stratum~} which creates
`/etc/zsh/zshenv` that file will contain zsh-specific ~+Bedrock~x configuration.

## {id="env-vars"} env-vars

Many programs search environment variables consisting of a colon-separated list
of directories.  For ~{cross~}-~{stratum~} functionality to work, ~+Bedrock~x's
`cross` paths must be included in these variables.  ~+Bedrock~x alters various
configuration files to ensure those variables contain contents specified here.

Generally, the environment variable fields fall into three categories, which
should be configured in the following order:

- The file must come from a specific ~{stratum~}.
	- For example, `reboot` should be provided by the ~{stratum~} providing the
	  current init.
	- Typically, these are provided by `/bedrock/cross/pin/~(...~)`.
- The file must come from the ~{local~} ~{stratum~}.
	- ~+Bedrock~x Linux assumes ~{strata~} are self-sufficient in terms of hard
	  dependencies.  Thus, if something has a hard dependency on a given
	  file that file *must* be available ~{locally~}.
	- For example, if a given distro's `/bin/sh` is provided by bash, that
	  distro's scripts may use bash-isms, and thus another distro's
	  `/bin/sh` may be unsuitable.
	- Typically these values are the traditional values of the given
	  environment variable.
- The file may come from any ~{stratum~}.
	- If the above two categories don't apply, we know the program isn't
	  picky about the specific version of the given file, and thus any
	  distro may provide it.
	- Typically, these are provided by `/bedrock/cross/~(...~)`.

### {id="env-vars-path"} PATH

`PATH` is a list of directories searched by various programs to find
executables.  The traditional `PATH` value should be prefixed with:

	/bedrock/cross/pin/bin

and have the following appended:

	/bedrock/cross/bin

### {id="env-vars-manpath"} MANPATH

`MANPATH` is a list of directories searched by the man executable to find
documentation.  The traditional `MANPATH` value should have the following
appended:

	/bedrock/cross/man

### {id="env-vars-infopath"} INFOPATH

`INFOPATH` is a list of directories searched by the man executable to find
documentation.  The traditional `INFOPATH` value should have the following
appended:

	/bedrock/cross/info

### {id="env-vars-xdg-data-dirs"} XDG\_DATA\_DIRS

`XDG_DATA_DIRS` a list of directories used by the freedesktop.org standard
containing things such as icons and application descriptions.  The traditional
`XDG_DATA_DIRS` value should have the following appended:

	/bedrock/cross


### {id="env-vars-terminfo-dirs"} TERMINFO\_DIRS

`TERMINFO_DIRS` is a list of terminfo file locations.  The traditional
`TERMINFO_DIRS` value should have the following appended:

	/bedrock/cross/terminfo

## {id="restriction"} restriction

Some programs become confused upon discovering software from other distros.  To
avoid this, ~+Bedrock~x can ~{restrict~} processes from seeing
~{cross~}-~{stratum~} hooks.

This is primarily needed for software which discovers dependencies in
preparation for compiling, such as ~+Arch Linux~x's `makepkg`.  However, it may
be useful for other programs as well.

This only affects processes which are run through `strat` or `/bedrock/cross`.
To ensure unwrapped calls are run through `/bedrock/cross`, configure them as
`pin` entries under `[cross-bin]` as well.

## {id="cross"} cross

~+Bedrock~x Linux mounts a virtual filesystem at

	/bedrock/cross

which provides an alternative view of various files from the enabled ~{strata~}.
This view is used for ~{cross~}-~{stratum~} coordination.

For the `[cross-~(*~)]` sections below, the keys represent file paths appended
to `/bedrock/cross`, and the values are a list of files or directories to be
searched for contents for the given file path.  For example,

	man = /usr/local/share/man, /usr/share/man

indicates that `/bedrock/cross/man` should be populated with the contents of
the `/usr/local/share/man` and `/usr/share/man` directories of all of the
enabled strata.

The paths used for values may be prefixed by `~(stratum~):` indicating the
given file/directory should only be considered from a specific stratum.  For
example,

	pin/bin/firefox = arch:/usr/bin/firefox, void:/usr/bin/firefox

Indicates a file at `/bedrock/cross/pin/bin/firefox` should be provided by
`arch` if available, or if not then `void`; otherwise, the file should not
exist.

### {id="cross-priority"} priority

If a value does not have a ~{stratum~} prefixed, it may be provided by any
~{stratum~} that has the file.  If multiple do, the values in `priority`
indicate which should be given `priority`.  Any enabled ~{strata~} left
unspecified are implicitly appended at the end in an unspecified order.  For
example,

	priority = gentoo, debian

indicates that for the `man` example above, if `gentoo` provides the given man
page, `gentoo`'s version should be provided.  Otherwise, if `debian` does, then
`debian`'s should be provided.  Otherwise, any ~{stratum~} that provides the
man page may provide it.

## {id="cross-pass"} cross-pass

Files within `[cross-pass]` are populated in the corresponding `/bedrock/cross`
file path unaltered.  For example,

	man = /bedrock/share/man, /usr/local/share/man, /usr/share/man

ensures that `/bedrock/cross/man/` contains files from `/bedrock/share/man`,
`/usr/local/share/man`, and `/usr/share/man` from all enabled ~{strata~} as-is.

## {id="cross-bin"} cross-bin

`[cross-bin]` file paths are populated with binaries that internally redirect
to the corresponding ~{stratum~}'s binary.

Given the above `PATH` configuration is of the form:

	/bedrock/cross/pin/bin:~(...~):/bedrock/cross/bin/

We know `/bedrock/cross/bin/` is checked last, after everything else (namely
~{pinned~} and ~{local~}) items are exhausted.  At that point, we have no
reason to prefer any ~{stratum~} and should check all available ~{strata~} for
an instance the given command.  Thus, `bin =` usually contains all common
system-wide executable locations.

Since `/bedrock/cross/pin/bin` is at the front of the `$PATH`, any keys to
`pin/bin/~(file~) will take priority over everything else.  This is used to
~{pin~} a program to a given ~{stratum~}.  For example,

	pin/bin/reboot = init:/usr/sbin/reboot, init:/sbin/reboot

ensures `reboot` comes from the `init` ~{stratum~} if it provides `reboot`.

The above `[restriction]` section only works on executables called through
`strat` or `/bedrock/cross`.  If there is no ~{pinned~} instance at the front
of the `$PATH`, we could get an un-`strat`'d ~{local~} copy, which would then
be ~{unrestricted~}.  Thus, all `[restriction]` items should be ~{pinned~} to
ensure they go through `/bedrock/cross`.

~+Bedrock~x provides a `local` ~{alias~} which always refers to the calling
~{stratum~}.  ~{pinning~} to this ~{alias~} ensures that, if there is a
~{local~} copy of a command, it is run through `/bedrock/cross` before a
`/bedrock/cross/bin/` copy from another ~{stratum~} is used.

For example,

	pin/bin/makepkg = local:/usr/local/bin/makepkg, local:/usr/bin/makepkg

ensures that if the ~{local~} ~{stratum~} has `makepkg`, a copy of it through
`/bedrock/cross` shows up at the front of the `$PATH`.  If it is not available
~{locally~}, the `$PATH` search will fall through to a possbile
`/bedrock/cross/bin/makepkg`  if `makepkg` is provided by another ~{stratum~}.
Thus, wherever `makepkg` is, it's guarenteed to run through `/bedrock/cross`
and be ~{restricted~}.

## {id="cross-ini"} cross-ini

`[cross-ini]` file paths are populated with the backing files, but altered to
work ~{cross~}-~{stratum~}.  For example, `Exec` keys may have their values
prefixed with `strat ~(stratum~)` to ensure they work across ~{stratum~}
boundaries.

## {id="cross-font"} cross-font

`[cross-font`] file paths are treated as Xorg font directories.  Most files are
passed unaltered, but some special files such as `fonts.dir` are dynamically
populated with the merged contents.

## {id="pmm"} pmm

A typical ~+Bedrock Linux~x system has multiple package managers.
~+Bedrock~x's Package Manager Manager, or `pmm`, acts as a front-end for these
and provides multi-package-manager and cross-package-manager operations.

### {id="pmm-user-interface"} user-interface

The command line user interface `pmm` should utilize.

See file names in `/bedrock/share/pmm/package_managers/` for available options.

For example, to mimic ~+Debian~x/~+Ubuntu~x/etc's `apt` user interface, set:

	user-interface = apt

Or to mimic ~+Arch~x's `pacman` user interface, set:

	user-interface = pacman

### {id="pmm-priority"} priority

List indicating the order package managers should be considered by `pmm`.  Any
available package manager not included will be considered after this list in
an undefined order.

List entries may have any of the following patterns:

- `~(stratum~):~(package-manager~)`, indicating a specific ~{stratum~}'s
  specific package manager.
- `~(stratum~):`, indicating any/all package managers in the given ~{stratum~}.
- `:~(package-manager~)`, indicating a specific package manager from any
  ~{stratum~}.

For example:

	priority = alpine:, debian:apt, arch:pacman, centos:, :pip

### {id="pmm-ignore-non-system-package-managers"} ignore-non-system-package-managers

If true, only system package managers such as `apt` or `pacman` will be
considered by `pmm`.

If false, non-system-package managers such as `pip` or `yay` will be
considered as well.

`priority` overrides this setting and may be used to white list specific
non-system package managers while others remain ignored.

### {id="pmm-unprivileged-user"} unprivileged-user

Some package managers such as `yay` recommend against running as root.  If
`pmm` is called as root, `pmm` will call such package managers with this user
via `sudo`.

`sudo` sets `$SUDO_USER` accordingly and is thus a good general default if
`pmm` is called via `sudo`.  If you call `pmm` as root via some other means,
consider setting it either your primary user or a dedicated unprivileged user.

### {id="pmm-warn-about-skipping-package-managers"} warn-about-skipping-package-managers

Most package managers support only a subset of available operations.  If a
given package manager is unable to fulfill an operation, it is skipped.

If true, print a warning when skipping package manager because it does not
support the requested operation.

If false, skip package managers silently.

### {id="pmm-cache-package-manager-list"} cache-package-manager-list

If true, `pmm` will cache the list of package managers to consider.

If false, `pmm` will build list of available package managers every operation.

This cache is updated on changes to `bedrock.conf` or the list of
non-`pmm`-hidden, enabled ~{strata~}.  It will miss the addition of new package
managers within a preexisting ~{stratum~}, such as would occur if one ran `apt
install python-pip`.

This cache size varies depending on the number of package managers available
on the system.  It may use tens of kilobytes of disk space in total.

### {id="pmm-cache-package-database"} cache-package-database

If true, `pmm` will cache the list of available packages and some of their
metadata.  This speeds up internal look-ups about available packages.

If false, `pmm` will query underlying package managers every time it needs to
learn about possible available packages.

This cache is updated after `pmm` is instructed to update package manager
databases (e.g. `pmm update`, `pmm -Syu`, etc).  It may become outdated if
package managers update their databases outside of `pmm`.

This cache size and caching time varies heavily depending on the number of
packages a given package manager has available.  It may use tens of megabytes
of disk space per package manager.

## {id="brl-fetch-mirrors"} brl-fetch-mirrors

If a mirror is provided to the `brl fetch` command, it is used to ~{fetch~} the
given distro.  Otherwise, this configuration is checked to see if it
specifies a given mirror should be tried.  If no working mirror is found
here, `brl fetch` will attempt to select a mirror from those it finds for the
given distribution.

You may set mirrors per distro by setting the distro name as spelled by

	brl fetch --list

as the key and the mirror as the value.  For example, to indicate that ~+Ubuntu~x
should be ~{fetched~} with the mirror

	http://us.archive.ubuntu.com/ubuntu

One may set

	ubuntu = http://us.archive.ubuntu.com/ubuntu

Some mirrors support multiple Linux distributions and use the same prefix path
for all of them.  For example, at the time of writing,  there is an ~+Arch~x
mirror at

    http://mirrors.edge.kernel.org/archlinux

and a ~+CentOS~x mirror at

    http://mirrors.edge.kernel.org/centos

and a ~+Debian~x mirror at:

    http://mirrors.edge.kernel.org/debian

and a ~+Fedora~x mirror at

    http://mirrors.edge.kernel.org/fedora

Rather than configuring each of these separately, the base URL can be added
to mirror-prefix to tell `brl fetch` to check it as a possible mirror.  For
the above kernel.org example, one may set:

    mirror-prefix = http://mirrors.edge.kernel.org

This is a comma separated list which is checked in order.

## {id="brl-update"} brl-update

Set mirrors to one or more ~+Bedrock Linux~x releases file URLs.

Most users are recommend to stick with the stable release channel here:

`mirrors = https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases`

However, if you would like to help test upcoming ~+Bedrock~x updates and are
willing to take the associated risks, a beta channel is available as well.
It should be added in addition to the stable channel so that you're always on
whichever is newer between the two:

`mirrors = https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases, https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7beta/releases`

## {id="miscellaneous"} miscellaneous

### {id="miscellaneous-cache-life"} cache-life

Time to retain Bedrock cached data (such as from brl-fetch) in days.

### {id="miscellaneous-color"} color

Set to `false` to disable `brl`'s use of ANSI colors.

### {id="miscellaneous-debug"} debug

Enable debugging for specified subsystems.

Possible values are:

- `etcfs`
	- If this is set, new `etcfs` mounts will log into
	  `/bedrock/var/cache/etcfs-~(stratum~)`.  Enabling this inflicts a
	  non-trivial performance hit.
- `brl-fetch`
	- By default, `brl fetch` removes files associated with a failed `brl
	  fetch` attempt.  This is to ensure users do not `rm -rf` the files,
	  as that may remove more data than a user expected.  Setting `debug =
	  brl-fetch` disables this functionality, which can help `brl fetch`
	  developers debug per-distro configuration.
