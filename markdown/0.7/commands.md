Title: Bedrock Linux 0.7 Poki Commands
Nav: poki.nav

Bedrock Linux 0.7 Poki Commands
===============================

All Bedrock Linux command functionality is provided by a single front-end
executable: `brl`.  Run `brl --help` to see an overview of its functionality
and `brl ~(command~) --help` for details on its sub-commands.

## {id="common"} Common commands

### {id="brl-strat"} brl strat

If multiple ~{strata~} provide the same command, absent any additional
indication of which to use Bedrock will choose one by default in a given
context.  For example, if you have both Debian and Ubuntu ~{strata~}, you will
have two `apt` commands:

- {class="rcmd"}
- brl fetch debian ubuntu
- apt install vim

Bedrock will chose either Debian's or Ubuntu's `apt`.

Bedrock's choice [can be guided by configuration](configuration.html#cross).  With proper configuration, Bedrock gets it right quite often.  However, it cannot read your mind.  If a specific ~{stratum~}'s command is desired in a specific instance, `brl strat
~(stratum~)` may be prefixed to the command.  For example:

- {class="rcmd"}
- brl strat debian apt install vim # use Debian's apt
- brl strat ubuntu apt install vim # use Ubuntu's apt

This workflow is sufficiently common that `strat` is included directly in the default `$PATH` and `brl` may be dropped.  Thus, it is more common to run:

- {class="rcmd"}
- strat debian apt install vim # use Debian's apt
- strat ubuntu apt install vim # use Ubuntu's apt

Compilation and build tools may become confused when scanning the environment
for dependencies and finding them from different distributions, and so Bedrock
will automatically [restrict](concepts-and-terminology.md#restriction) them.
To override Bedrock's ~{restriction~} configuration, `strat` may be called with
the `-r` flag to indicate the given command should be restricted:

- {class="cmd"}
- # restrict build system to Debian
- strat -r debian ./configure && strat -r make

or with the `-u` flag indicating it should not:

- {class="cmd"}
- # unrestrict build system to Arch
- strat -u arch makepkg

When restricted, build tools may then complain about missing dependencies, even if they're provided by other strata.  If so, install the dependencies, just as one would do on the native distro.

### {id="brl-list"} brl list

One may use `brl list` to list all of the ~{strata~} on the system.  For example:

- {class="cmd"}
- sudo brl fetch arch debian gentoo
- brl list # prints bedrock, opensuse (hijacked), arch, debian, and gentoo

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

### {id="brl-which"} brl which

Bedrock's intermixing of files from different ~{strata~} can be confusing for new users.  To help such users understand and explore the system, Bedrock provides the `brl which` command which can be used to query which ~{stratum~} provides a given object.  It supports queries about:

- A process ID
- A binary in the `$PATH`
- A filepath
- An X11 window

If no flag is provided, `brl which` will guess what type of object the query is about from context.  For example:

- {class="cmd"}
- brl which # no object specified, default to calling process (e.g. a shell)
- brl which 1 # object is a number, probably a PID
- brl which ~/.vimrc # object contains a `/`, probably a file path
- brl which vim # no number or /, probably a $PATH entry

If there are concerns `brl which` will guess the wrong type of object, a flag
may be provided to specify the desired type:

	<none>          guess type from identifier
	-c, --current   which stratum provides current process
	-b, --bin       which stratum provides a given binary in $PATH
	-f, --file      which stratum provides a given file path
	-p, --pid       which stratum provides a given process ID
	-x, --xwindow   which stratum provides a given X11 window (requires xprop)

## {id="strata-management"} Strata management commands

### {id="brl-fetch"} brl fetch

Bedrock provides a `brl fetch` command to automatically acquire files from other distros for use as ~{strata~}.

The specific distros Bedrock knows how to fetch vary depending on CPU architecture and time.  To list the actively maintained list of fetch-able distros for your CPU architecture, run:

	brl fetch --list

Bedrock may also know how to fetch other distros but does not have anyone actively maintaining the their fetch code.  To list these distros, run:

	brl fetch --experimental

To fetch distros, run (as root):

- {class="rcmd"}
- brl fetch ~(distros~)

The desired name, release, and mirror for newly fetched ~{strata~} can be specified via flags or left unspecified for `brl fetch` to attempt to determine the details itself:

	<none>                  automatically determine name, release, and mirror
	-n, --name [name]       specify desired stratum name
	-r, --release [release] specify desired distro release
	-m, --mirror [mirror]   specify desired mirror

`brl fetch`'s logic for detecting a mirror or release may fail if the upstream distro changes details or lists bad mirrors.  If `brl fetch` does not work or takes too long, try manually looking up the mirror or release and specifying it.

~{Strata~} are ~{hidden~} and ~{disabled~} mid-fetch to avoid accidentally using them before they are ready.  By default, they are ~{shown~} and ~{enabled~} immediately after a successful fetch for use.  However, you may disable the post-fetch ~{showing~}/~{enable~} via flags:

	-e, --dont-enable       do not enable newly fetched strata
	-s, --dont-show         do not show newly fetched strata

Provided `qemu-user-static` is installed in some stratum, Bedrock supports strata from non-native CPU architectures.  `brl fetch` can fetch such strata with the `-a` and `-A` flags:

	-A, --archs             list architectures for [distros]
	-a, --arch [arch]       specify desired CPU architecture

### {id="brl-remove"} brl remove

When a ~{stratum~} is ~{enabled~} (or ~{broken~}), it has various hooks integrating it with the rest of the system.  When ~{disabled~} the hooks *should* be removed, but if something goes wrong some may still be in place.  **`rm -r` may follow these hooks to other ~{strata~} and should not be used to remove any ~{stratum~}.**  Instead, Bedrock provides `brl remove` which takes care to avoid tripping on any hooks.

An ~{enabled~} ~{stratum~} cannot be removed, and by default `brl remove` will error out if told to remove such a ~{stratum~}.  However, `brl remove` may be provided a `-d` flag indicating that it should attempt to ~{disable~} any ~{enabled~} ~{strata~} queued for removal.

`brl remove` also removes ~{aliases~}.

The `bedrock` ~{stratum~} cannot be removed, as it is essential for the system to function.

The ~{stratum~} *currently* providing PID1 cannot be disabled, which is a prerequisite for removal.  However, one may reboot and select another ~{stratum~} to provide the init system, after which the previously un-disable-able ~{stratum~} becomes available to be disabled and removed.

### {id="brl-rename"} brl rename

Similar to removing ~{strata~}, one should not attempt to rename a ~{stratum~} with `mv` for fear of tripping on various Bedrock hooks.  Instead, the `brl rename` command is provided.  This only works on ~{disabled~} ~{strata~}.  If you would like to rename an ~{enabled~} ~{stratum~}, `brl disable` it first.

`brl remove` also renames ~{aliases~}.

The `bedrock` ~{stratum~} cannot be renamed, as it internally has hard-coded references to itself which are essential for the system to function.

The ~{stratum~} *currently* providing PID1 cannot be disabled, which is a prerequisite for renaming.   However, one may reboot and select another ~{stratum~} to provide the init system, after which the previously un-disable-able ~{stratum~} becomes available to be disabled and renamed.

### {id="brl-copy"} brl copy

Similar to removing and renaming ~{strata~}, one should not attempt to copy a ~{stratum~} with `cp` for fear of tripping on various Bedrock hooks.  Instead, the `brl copy` command is provided.  This only works on ~{disabled~} ~{strata~}.  If you would like to copy an ~{enabled~} ~{stratum~}, `brl disable` it first.

`brl copy` dereferences aliases when copying; it cannot copy ~{aliases~} themselves.  To effectively make a copy of an ~{alias~}, simply create a new alias targeting the same ~{stratum~}.

The `bedrock` ~{stratum~} cannot be disabled in preparation for copying.

The ~{stratum~} *currently* providing PID1 cannot be disabled, which is a prerequisite for copying.   However, one may reboot and select another ~{stratum~} to provide the init system, after which the previously un-disable-able ~{stratum~} becomes available to be disabled and copied.

## {id="strata-status-management"} Strata status management commands

A ~{stratum~} may be in one of the following states:

- ~{enabled~}, indicating it is integrated with the rest of the system.
- ~{disabled~}, indicating it is not integrated with the rest of the system.
- ~{hidden~}, indicating that various Bedrock subsystems are ignoring it.
- ~{broken~}, indicating that the desired state is ~{enabled~} but something went wrong.

### {id="brl-status"} brl status

To query a ~{stratum~}'s ~{state~}, one may use `brl status`.  If the ~{stratum~} is ~{broken~}, `brl status` prints an indication of specifically what is wrong to aid debugging and fixing.

### {id="brl-enable"} brl enable

To ~{enable~} a ~{disabled~} ~{stratum~}, one may use `brl enable` (as root).

### {id="brl-disable"} brl disable

To ~{disable~} an ~{enabled~} or ~{broken~} ~{stratum~}, one may use `brl disable` (as root).

The `bedrock` ~{stratum~} cannot be disabled.

The ~{stratum~} *currently* providing PID1 cannot be disabled.   However, one may reboot and select another ~{stratum~} to provide the init system, after which the previously un-disablable ~{stratum~} becomes available to be disabled.

### {id="brl-repair"} brl repair

Bedrock can attempt to repair a ~{broken~} ~{stratum~} with `brl repair`.  `brl repair` has three strategies available:

	<none>         defaults to --retain
	-n, --new      only add new mounts, do not remove anything
	                 only fixes trivially broken strata
	-r, --retain   try to retain as much as possible except problematic mount points
	                 fixes most strata but risks losing some state
	-c, --clear    clears strata processes and mount points
	                 should fix almost all strata but loses all state

## {id="strata-visibility-management"} Strata visibility management commands

A ~{stratum~} may be ~{hidden~} from various Bedrock subsystems.  This is useful to both avoid accidental use during sensitive operations such as fetching or removing a ~{stratum~}, or to keep a ~{stratum~}'s files on-disk but out of the way.

### {id="brl-hide"} brl hide

If you would like to keep a ~{stratum~}'s files on your system but out of the way, you may ~{hide~} it with the `brl hide` command.  While most users either hide it from or show it to all subsystems, the functionality is more fine grained and specific subsystems may be specified:

	<none>       defaults to --all
	-a, --all    hide stratum in all available subsystems
	-b, --boot   do not automatically enable stratum during boot
	-c, --cross  do not include stratum's files in /bedrock/cross
	-i, --init   do not list stratum's init options during boot
	-l, --list   do not list with `brl list` without `-i` flag.

Bedrock ~{hides~} ~{strata~} at sensitive moments such as when fetching a ~{stratum~} or just before its removal.

### {id="brl-show"} brl show

One may use `brl show` undo a `brl hide` operation.  While most users either hide it from or show it to all subsystems, the functionality is more fine grained and may only specific subsystems may be specified:

	<none>       defaults to --all
	-a, --all    show stratum in all available subsystems
	-b, --boot   automatically enable stratum during boot
	-c, --cross  include stratum's files in /bedrock/cross
	-i, --init   list stratum's init options during boot
	-l, --list   list with `brl list` even without `-i` flag.

## {id="alias-management"} Alias management commands

~{Aliases~} may be created as alternative names for ~{strata~}.  ~{aliases~} may be created, removed, or renamed irrelevant of their corresponding ~{stratum~}'s state, making them more flexible than the ~{strata~} names.

### {id="brl-alias"} brl alias

The `brl alias` command can be used to create a new ~{alias~}.  The first argument should be a pre-existing ~{stratum~}'s name, and the second argument should be the new ~{alias~} name.  Creating ~{aliases~} to ~{aliases~} is disallowed.

### {id="brl-deref"} brl deref

To dereference an ~{alias~}, one may use `brl deref`.

## {id="miscellaneous-commands"} Miscellaneous commands

### {id="brl-apply"} brl apply

All Bedrock configuration is centralized in the `/bedrock/etc/bedrock.conf` file.  After a change is made, run `brl apply` (as root) to apply the changes to the system.

### {id="brl-update"} brl update

~{Strata~} are responsible for maintaining their own updates.  An Arch ~{stratum~} may be updated with `pacman`, a Debian ~{stratum~} may be updated with `apt`, etc.  Similarly, the `bedrock` ~{stratum~} is responsible for updating itself.  This is achieved with the `brl update` command.

If `brl update` is run without any parameters, it will attempt to fetch an update online.  If you wish to update an offline system, you may download an installer/updater for the corresponding version and provide it as a parameter to `brl update`.

By default `brl update` reads the `mirror` value in `/bedrock/etc/bedrock.conf` to determine which Bedrock mirror to use.  However, this can be overridden with `-m`.

`brl update` utilizes `gpg` to verify the signature on updates.  However, Bedrock does not provide its own `gpg`, but rather depends on other ~{strata~} to provide it.  If no `gpg` is available, `brl update` will error out accordingly.  If you cannot install `gpg` from some other ~{stratum~}, you may tell `brl update` to `--skip-check` to skip the signature verification.  Skipping the signature check is not recommended.

Some Bedrock subsystems cannot have their update applied live and require a reboot.  This is undesirable, but no alternative is currently known.

Some updates recommend changes to `/bedrock/etc/bedrock.conf`.  These will create new reference configuration files at `/bedrock/etc/bedrock.conf-~(version~)`.  Compare these files against your `bedrock.conf` and apply changes as appropriate, then remove the reference `bedrock.conf-~(version~)`.

### {id="brl-version"} brl version

`brl version` prints the current Bedrock version.

### {id="brl-report"} brl report

`brl report` generates a report on the system which may be useful for debugging issues.  If you run into an issue with Bedrock and seek assistance, try to generate a report with `brl report` and provide it along with your problem description.

This covers all the background required [before continuing to the Bedrock configuration](configuration.html).
