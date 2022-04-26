Title: Bedrock Linux 0.7 Poki Commands
Nav: poki.nav

# Bedrock Linux 0.7 Poki Commands

TableOfContents

## {id="brl"} brl

Most ~+Bedrock Linux~x functionality is provided by a single front-end
executable: `brl`.  Run `brl --help` to see an overview of its functionality
and `brl ~(command~) --help` for details on its sub-commands.

### {id="common-commands"} Common Commands

#### {id="brl-strat"} brl strat

If multiple ~{strata~} provide the same command, absent any additional
indication of which to use Bedrock will choose one by default in a given
context.  For example, if you have both Debian and Ubuntu ~{strata~}, you will
have two `apt` commands:

- {class="rcmd"}
- brl fetch debian ubuntu
- apt install vim

Bedrock will chose either Debian's or Ubuntu's `apt`.

Bedrock's choice [can be guided by configuration](configuration.html#cross).
With proper configuration, Bedrock gets it right quite often.  However, it
cannot read your mind.  If a specific ~{stratum~}'s command is desired in a
specific instance, `brl strat
~(stratum~)` may be prefixed to the command.  For example:

- {class="rcmd"}
- brl strat debian apt install vim ~## use Debian's apt~x
- brl strat ubuntu apt install vim ~## use Ubuntu's apt~x

This workflow is sufficiently common that `strat` is included directly in the
default `$PATH` and `brl` may be dropped.  Thus, it is more common to run:

- {class="rcmd"}
- strat debian apt install vim ~## use Debian's apt~x
- strat ubuntu apt install vim ~## use Ubuntu's apt~x

Compilation and build tools may become confused when scanning the environment
for dependencies and finding them from different distributions.  These tools
should be ~{restricted~}.  ~+Bedrock~x knows to do this for some commands, such
as ~+Arch~x's `makepkg`, but not others, such as `./configure` scripts.

To override ~{Bedrock~}'s ~{restriction~} configuration, `strat` may be called with
the `-r` flag to indicate the given command should be ~{restricted~}:

- {class="cmd"}
- ~## restrict build system to Debian~x
- strat -r debian ./configure && strat -r make

or with the `-u` flag indicating it should not:

- {class="cmd"}
- ~## unrestrict build system from Arch~x
- strat -u arch makepkg

When ~{restricted~}, build tools may then complain about missing dependencies,
even if they're provided by other ~{strata~}.  If so, install the dependencies,
just as one would do on the native distro.

#### {id="brl-list"} brl list

One may use `brl list` to list all of the ~{strata~} on the system.  For example:

- {class="cmd"}
- sudo brl fetch arch debian gentoo
- brl list ~## prints bedrock, opensuse (hijacked), arch, debian, and gentoo~x

By default `brl list` only lists enabled, non-hidden ~{strata~}.  However it
has various flags to control what is listed:

	<none>                 defaults to --enabled
	-e, --enabled-strata   enabled stratum
	-E, --enabled-aliases  aliases to enabled stratum
	-d, --disabled-strata  disabled stratum
	-D, --disabled-aliases aliases to disabled stratum
	-a, --all-strata       all strata
	-A, --all-aliases      all aliases
	-r, --deref            dereference aliases
	-i, --include-hidden   include hidden strata in list
	-v, --everything       equivalent to -aAir

#### {id="brl-which"} brl which

~+Bedrock~x's intermixing of files from different ~{strata~} can be confusing for new users.  To help such users understand and explore the system, Bedrock provides the `brl which` command which can be used to query which ~{stratum~} provides a given object.  It supports queries about:

- A process ID
- A binary in the `$PATH`
- A filepath
- An X11 window

If no flag is provided, `brl which` will guess what type of object the query is about from context.  For example:

- {class="cmd"}
- brl which ~## no object specified, default to calling process (e.g. a shell)~x
- brl which 1 ~## object is a number, probably a PID~x
- brl which ~/.vimrc ~## object contains a slash, probably a file path~x
- brl which vim ~## no number or slash, probably a $PATH entry~x

If there are concerns `brl which` will guess the wrong type of object, a flag
may be provided to specify the desired type:

	<none>          guess type from identifier
	-c, --current   which stratum provides current process
	-b, --bin       which stratum provides a given binary in $PATH
	-f, --file      which stratum provides a given file path
	-p, --pid       which stratum provides a given process ID
	-x, --xwindow   which stratum provides a given X11 window (requires xprop)

### {id="strata-management"} Strata management commands

#### {id="brl-fetch"} brl fetch

~+Bedrock~x provides a `brl fetch` command to acquire files from other distros
for use as ~{strata~}.

The specific distros ~+Bedrock~x knows how to ~{fetch~} vary depending on CPU
architecture and may change over time.  To list the actively maintained list of
~{fetch~}-able distros for your CPU architecture, run:

	brl fetch --list

~+Bedrock~x may also know how to fetch other distros but does not have anyone
actively maintaining the their fetch code.  To list these distros, run:

	brl fetch --experimental

To ~{fetch~} distros, run (as root):

- {class="rcmd"}
- brl fetch ~(distros~)

The desired name, release, and mirror for newly ~{fetched~} ~{strata~} can be
specified via flags or left unspecified for `brl fetch` to attempt to determine
the details itself:

	<none>                  automatically determine name, release, and mirror
	-n, --name [name]       specify desired stratum name
	-r, --release [release] specify desired distro release
	-m, --mirror [mirror]   specify desired mirror

`brl fetch`'s logic for detecting a mirror or release may fail if the upstream
distro changes details or lists bad mirrors.  If `brl fetch` does not work or
takes too long, try manually looking up the mirror or release and specifying
it.

~{Strata~} are ~{hidden~} and ~{disabled~} mid-~{fetch~} to avoid accidentally
using them before they are ready.  By default, they are ~{shown~} and
~{enabled~} immediately after a successful ~{fetch~} for use.  However, you may
disable the post-~{fetch~} ~{showing~}/~{enable~} via flags:

	-e, --dont-enable       do not enable newly fetched strata
	-s, --dont-show         do not show newly fetched strata

Provided `qemu-user-static` is installed in some ~{stratum~}, ~+Bedrock~x has
limited support for ~{strata~} from non-native CPU architectures.  `brl fetch`
can ~{fetch~} such ~{strata~} with the `-a` and `-A` flags:

	-A, --archs             list architectures for [distros]
	-a, --arch [arch]       specify desired CPU architecture

Functionality for non-native ISA ~{strata~} is entirely provided by and
constrained by `qemu-user-static`.  Should some newer executable attempt to
perform some action `qemu-user-static` does not yet support, it will not work.

#### {id="brl-import"} brl import

~+Bedrock~x provides a `brl import` command to create strata from on-disk
sources.   This may be useful for distros that `brl fetch` does not support or
for use with offline systems.

To import a stratum, run

	{class="rcmd"} brl import ~(name~) ~(/path/to/source~)

where the ~(source~) is any of:

- Directory
- Tarball (`.tar`)
- Qemu qcow/qcow2/qcow3 image (`.qcow`, `.qcow2`, `.qcow3`)
- VirtualBox image (`.vdi`)
- VMware image (`.vmdk`)

If importing a VM, be sure the VM has one partition and that that partition is
unencrypted.  Do not use separate `/boot` or `/home` partitions for the VM.  Do
not use full disk encryption.

#### {id="brl-remove"} brl remove

~{Strata~} may contain references to the rest of the system, such as bind
mounts, and should **~!not~x** be removed via `rm -r`.  ~+Bedrock~x provides a `brl
remove` command which takes care to avoid removing any file outside of the
specified ~{stratum~}.

As a protective measure, ~{strata~} may not be removed while ~{enabled~}.  If you
wish to remove a ~{stratum~}, first ~{disable~} it.  For example:

- {class="rcmd"} brl disable alpine
- {class="rcmd"} brl remove alpine

If you know the target ~{stratum~} is ~{enabled~}, `brl remove` takes a `-d`
flag to ~{disable~} prior to removing:

- {class="rcmd"}
- brl remove -d void

`brl remove` also removes ~{aliases~}.

The `bedrock` ~{stratum~} cannot be removed, as it is essential for the system
to function.

The ~{stratum~} currently providing PID 1 (the init) may not be ~{disabled~},
as the Linux kernel does not respond well to PID 1 dying.  If you wish to
remove the init-providing ~{stratum~}, first reboot and select another
~{stratum~} to provide your init for the given session.

#### {id="brl-rename"} brl rename

Similar to removing ~{strata~}, one should not attempt to rename a ~{stratum~}
with `mv` for fear of tripping on various Bedrock hooks.  Instead, the `brl
rename` command is provided.  This only works on ~{disabled~} ~{strata~}.  If
you would like to rename an ~{enabled~} ~{stratum~}, `brl disable` it first.
For example:

- {class="rcmd"}
- brl rename ubuntu bionic

`brl rename` also renames ~{aliases~}.

The `bedrock` ~{stratum~} cannot be renamed, as it internally has hard-coded
references to itself which are essential for the system to function.

The ~{stratum~} *currently* providing PID1 cannot be disabled, which is a
prerequisite for renaming.  If you wish to rename the init-providing
~{stratum~}, first reboot and select another ~{stratum~} to provide your init
for the given session.

#### {id="brl-copy"} brl copy

Similar to removing and renaming ~{strata~}, one should not attempt to copy a
~{stratum~} with `cp` for fear of tripping on various Bedrock hooks.  Instead,
the `brl copy` command is provided.  This only works on ~{disabled~}
~{strata~}.  If you would like to copy an ~{enabled~} ~{stratum~}, `brl
disable` it first.  For example:

- {class="rcmd"}
- brl copy debian debian-pre-dist-upgrade

`brl copy` dereferences aliases when copying; it cannot copy ~{aliases~}
themselves.  To effectively make a copy of an ~{alias~}, simply create a new
alias targeting the same ~{stratum~}.

The `bedrock` ~{stratum~} cannot be disabled in preparation for copying.

The ~{stratum~} currently providing PID 1 (the init) may not be ~{disabled~},
as the Linux kernel does not respond well to PID 1 dying.  If you wish to
copy the init-providing ~{stratum~}, first reboot and select another
~{stratum~} to provide your init for the given session.

### {id="strata-status-management"} Strata status management commands

A ~{stratum~} may be in one of the following states:

- ~{enabled~}, indicating it is integrated with the rest of the system.
- ~{disabled~}, indicating it is not integrated with the rest of the system.
- ~{hidden~}, indicating that various ~+Bedrock~x subsystems are ignoring it.
- ~{broken~}, indicating that the desired state is ~{enabled~} but something went wrong.

#### {id="brl-status"} brl status

To query a ~{stratum~}'s ~{state~}, use `brl status`.  If the ~{stratum~} is
~{broken~}, `brl status` prints an indication of specifically what is wrong to
aid debugging and fixing.

#### {id="brl-enable"} brl enable

To ~{enable~} a ~{disabled~} ~{stratum~}, use `brl enable` (as root).

#### {id="brl-disable"} brl disable

To ~{disable~} an ~{enabled~} or ~{broken~} ~{stratum~}, use `brl disable` (as
root).

The `bedrock` ~{stratum~} cannot be disabled.

The ~{stratum~} currently providing PID 1 (the init) may not be ~{disabled~},
as the Linux kernel does not respond well to PID 1 dying.  If you wish to
disable the init-providing ~{stratum~}, first reboot and select another
~{stratum~} to provide your init for the given session.

#### {id="brl-repair"} brl repair

~+Bedrock~x can attempt to repair a ~{broken~} ~{stratum~} with `brl repair`.
`brl repair` has three strategies available:

	<none>       defaults to --retain
	-n, --new    only add new mounts, do not remove anything
	               only fixes trivially broken strata
	-r, --retain try to retain as much as possible except problematic mount points
	               fixes most strata but risks losing some state
	-c, --clear  clears strata processes and mount points
	               should fix almost all strata but loses all state

### {id="strata-visibility-management"} Strata visibility management commands

A ~{stratum~} may be ~{hidden~} from various ~+Bedrock~x subsystems.  This is
useful to avoid accidental use during sensitive operations such as ~{fetching~}
or removing a ~{stratum~}, as well as to keep a ~{stratum~}'s files on-disk but
out of the way.

#### {id="brl-hide"} brl hide

If you would like to keep a ~{stratum~}'s files on your system but out of the
way, you may ~{hide~} it with the `brl hide` command.  While most users either
hide it from or show it to all subsystems, the functionality is more fine
grained and specific subsystems may be specified:

	<none>       defaults to --all
	-a, --all    hide stratum in all available subsystems
	-b, --boot   do not automatically enable stratum during boot
	-c, --cross  do not include stratum's files in /bedrock/cross
	-i, --init   do not list stratum's init options during boot
	-l, --list   do not list with `brl list` without `-i` flag.
	-p, --pmm    do not consider for `pmm` operations

#### {id="brl-show"} brl show

One may use `brl show` undo a `brl hide` operation.  While most users either
hide it from or show it to all subsystems, the functionality is more fine
grained and may only specific subsystems may be specified:

	<none>       defaults to --all
	-a, --all    show stratum in all available subsystems
	-b, --boot   automatically enable stratum during boot
	-c, --cross  include stratum's files in /bedrock/cross
	-i, --init   list stratum's init options during boot
	-l, --list   list with `brl list` even without `-i` flag.
	-p, --pmm    consider for `pmm` operations

### {id="alias-management"} Alias management commands

~{Aliases~} may be created as alternative names for ~{strata~}.  ~{Aliases~}
may be created, removed, or renamed irrelevant of their corresponding
~{stratum~}'s state, making them more flexible than the ~{strata~} names.

#### {id="brl-alias"} brl alias

The `brl alias` command can be used to create a new ~{alias~}.  The first
argument should be a pre-existing ~{stratum~}'s name, and the second argument
should be the new ~{alias~} name.  Creating ~{aliases~} to ~{aliases~} is
disallowed.  For example:

- {class="rcmd"}
- brl alias ubuntu bionic
- diff /bedrock/strata/{ubuntu,bionic}/etc/os-release ~## no difference, same file~x

#### {id="brl-deref"} brl deref

To dereference an ~{alias~}, one may use `brl deref`.  For example:

- {class="rcmd"}
- brl deref bionic ~## prints ubuntu~x

### {id="miscellaneous-commands"} Miscellaneous commands

#### {id="brl-apply"} brl apply

All ~+Bedrock~x configuration is centralized in the `/bedrock/etc/bedrock.conf`
file.  After a change is made, run `brl apply` (as root) to apply the changes
to the system.

#### {id="brl-update"} brl update

~{Strata~} are responsible for maintaining their own updates.  An ~+Arch~x
~{stratum~} may be updated with `pacman`, a ~+Debian~x ~{stratum~} may be updated
with `apt`, etc.  Similarly, the `bedrock` ~{stratum~} is responsible for
updating itself.  This is achieved with the `brl update` command.

If `brl update` is run without any parameters, it will attempt to download an
from a mirror configured in `bedrock.conf`:

- {class="rcmd"}
- brl update # downloads and applies an update

Offline updates are supported by providing the update file as a parameter:

- {class="rcmd"}
- wget ~(http://path-to-update~) -O ./bedrock-update.sh
- brl update ./bedrock-update.sh

By default `brl update` reads the `mirror` value in `/bedrock/etc/bedrock.conf`
to determine which Bedrock mirror to use.  However, this can be overridden with
`-m`.

`brl update` utilizes `gpg` to verify the signature on updates.  However,
~+Bedrock~x does not provide its own `gpg`, but rather depends on other
~{strata~} to provide it.  If no `gpg` is available, `brl update` will error
out accordingly.  If you cannot install `gpg` from some other ~{stratum~}, you
may tell `brl update` to `--skip-check` to skip the signature verification.
Skipping the signature check is not recommended.

Some ~+Bedrock~x subsystems cannot have their update applied live and require a
reboot.  If it is needed, a message will be printed by `brl update` after
applying the update.

Some updates propose changes to `/bedrock/etc/bedrock.conf`, such as when
default configuration recommendations have changed or when new configuration
options are available.  

`brl update` may create new reference configuration files at
`/bedrock/etc/bedrock.conf-~(version~)`.  These are proposed changes to
`/bedrock/etc/bedrock.conf` and may contain recommendations for new default
configurations or indicate new configuration options.  Compare these files
against your `bedrock.conf` and apply changes as appropriate, then remove the
reference `bedrock.conf-~(version~)`.

#### {id="brl-version"} brl version

`brl version` prints the current Bedrock version.

#### {id="brl-report"} brl report

`brl report` generates a report on the system which may be useful for debugging
issues.  If you run into an issue with ~+Bedrock~x and seek assistance, try to
generate a report with `brl report` and provide it along with your problem
description.

#### {id="brl-tutorial"} brl tutorial

~+Bedrock~x provides interactive tutorials via the `brl tutorial` command.
This command takes a parameter indicating the desired lesson.  For example, the
`basics` tutorial is recommended for new users:

	{class="cmd"} brl tutorial basics

## {id="strat"} strat

The `brl`'s `strat` subcommand is used frequently.  To minimize friction, it is
made available in the `$PATH` stand-alone without the `brl` prefix.  Calling
`strat` alone is functionally identical to `brl strat`.  See the [brl strat
documentation](#brl-strat).

## {id="pmm"} pmm

### {id="pmm-basics"} pmm basics

~+Bedrock~x systems typically have multiple package managers.  This naturally
leads to multi- and cross-package-manage work flows which may become tedious to
do manually.  For example, one may wish to upgrade all ~{strata~} on the system
with something like:

- {class="rcmd"}
- apk update && apk upgrade
- strat debian apt update && strat debian apt upgrade
- strat ubuntu apt update && strat ubuntu apt upgrade
- brl update
- dnf update
- pacman -Syu
- xbps-install -Su

Or one may wish to install a rare package and consequently manually search
multiple package managers:

- {class="rcmd"}
- apk search scron ~## no results~x
- strat debian apt search scron ~## no results~x
- strat ubuntu apt search scron ~## no results~x
- dnf search scron ~## no results~x
- pacman -Ss scron ~## no results~x
- xbps-query scron ~## found it!~x
- xbps-install scron ~## install it~x

~+Bedrock~x provides an abstraction layer over package managers to ease such
work flows.  It is ~+Bedrock~x's `P`ackage `M`anager `M`anager, or `pmm`.

Rather than introduce a new interface for users to learn, `pmm` mimics user
interfaces provided by other package managers.  See [pmm's
configuration](configuration.html#pmm) for how to set `pmm`'s user interface.
The examples below may need to be adjusted accordingly.

Rather than the series of commands provided above to upgrade all packages on a system, one may run:

- {class="rcmd"}
- pmm -Syu ~## mimicking pacman~x

Regarding the second example of installing `scron`, one may run:

- {class="rcmd"}
- pmm add scron ~## mimicking apk~x

and `pmm` will find and install the highest priority instance the command.

`pmm` covers a large number of operations and some flags common to multiple
package managers, including much more functionality than described here.  Once
its `user-interface` is configured, run `pmm --help` to see a list of available
flags and operations.

### {id="pmm-specific-flags"} pmm specific flags

In addition to flags one may expect from other package managers, `pmm` has several specific to it.

#### {id="pmm-every"} pmm --every flag

By default, operations which change package states (e.g. installing a package)
operate on the first instance `pmm` finds.  `pmm`'s `--every` flag may be used
to indicate all available instances should be operated on.  For example,
cross-stratum `bash` completion requires all strata to have `bash-completion`
installed, and so one may run:

- {class="rcmd"}
- pmm-install --every bash-completion ~## mimicking xbps~x

#### {id="pmm-version-flags"} pmm version flags

Some workflows may have desire version constraints on packages, which `pmm` provides:

	--newest                   select newest corresponding versions of items
	--oldest                   select oldest corresponding versions of items
	--approx-version ~(version~) only consider items with a version prefixed by ~(version~)
	--exact-version ~(version~)  only consider items that are exactly ~(version~)
	--newer-or-equal ~(version~) only consider items that are newer than or equal to ~(version~)
	--newer-than ~(version~)     only consider items that are newer than ~(version~)
	--older-or-equal ~(version~) only consider items that are older than or equal to ~(version~)
	--older-than ~(version~)     only consider items that are older than ~(version~)

For example, to install the newest `abiword` available:

- {class="rcmd"}
- pmm --newest abiword ~## mimicking portage~x


### {id="pmm-world-file"} pmm world file

`pmm` supports synchronizing the explicitly installed package state against a
configuration file at `/bedrock/etc/world`.

`world` supports comments and is helpful when keeping a ~+Bedrock~x system with
a large number of packages strewn across multiple package managers organized.

For example, the ~{world~} file may contain a block such as:

	# bedrock linux `make check` dependencies
	arch:pacman	clang
	arch:pacman	cppcheck
	arch:pacman	fuse3
	arch:pacman	shellcheck
	arch:pacman	uthash
	debian:apt	indent
	void:xbps	shfmt

which could later be used to explain why your `arch` ~{stratum~} has `cppcheck`
installed.

`world` can also be useful for things like moving responsibility across ~{strata~}.  One may substitute all instances of one ~{stratum~} with another in `world` then apply it to the system.

`world` is also useful for re-creating ~+Bedrock~x systems.  A `world` file may be copied from a working system and used to clone its installed package state after the appropriate ~{strata~} have been fetched and had their mirrors/repos setup.

~{world~} file operations are specified via the following `pmm` flags:

	--diff-world             print differences between /bedrock/etc/world and system's explicitly installed packages
	--update-world-installed populate /bedrock/etc/world with missing explicitly installed packages
	--update-world-removed   remove /bedrock/etc/world items that do not correspond to explicitly installed packages
	--update-world           sync /bedrock/etc/world to system's explicitly installed package list
	--apply-world-installed  explicitly install /bedrock/etc/world items
	--apply-world-removed    remove packages not in /bedrock/etc/world and resulting orphan packages
	--apply-world            sync system's explicitly installed package list to /bedrock/etc/world and remove orphans
