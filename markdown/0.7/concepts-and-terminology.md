Title: Bedrock Linux 0.7 Poki Concepts And Terminology
Nav: poki.nav

Bedrock Linux 0.7 Poki Concepts And Terminology
===============================================

## {id="strata"} Strata

Many Linux distributions are composed of packages, which are collections of
related files.  In such distros most distro-specific files and processes are
associated with some package.  For example, `/usr/bin/vim` may be provided by
the `vim` package.  Packages are typically written with the expectation of
interacting with other packages from the same Linux distribution release.
For example, an executable from one package may utilize a library provided by
another package.  This interaction expectation typically breaks down across
packages from different Linux distributions, or even packages across different
releases of the same distribution.  For example, two packages from different
distributions may each expect a different build of a library at the same file
path.

A Bedrock Linux system is composed ~{strata~}.  Like packages, these are
collections of related files.  Unlike packages, however, ~{strata~} have a
relatively high degree of tolerance for interacting with other files from other
Linux distributions.  A Bedrock system may be composed of ~{strata~} that each
expect a different build of a library at the same file path but still work, and
work together.

~{Strata~} are often one-to-one with traditional Linux distribution installs.
One may have an Arch ~{stratum~}, a Debian ~{stratum~}, a Gentoo ~{stratum~},
etc.  However, they do not have to be related to Linux distributions.  For
example, one may have a stratum that is composed of a single man page.

*Every* process and every file on a Bedrock Linux system is associated with
some ~{stratum~}.  ~{Global~} files (described below) are associated with the
`bedrock` ~{stratum~}.

[Bedrock provides commands to manage strata](commands.html#strata-management).

## {id="dependency-types"} Dependency types

A ~{hard dependency~} is a dependency on either:

- A ~{specific~} build of a given file or process.  For example, a dependency on a specific glibc build would be a ~{hard dependency~}.
- A ~{specific~} file path.  For example, dependency on not just `awk` but specifically `/usr/bin/awk` is a ~{hard dependency~}.

In contrast, a ~{soft dependency~} is a dependency that a given file or process exists, but allows for freedom around the dependency's specific build or location.  For example, a process may require an Xorg server to display a window, but it may not care about which specific Xorg build is used.

Bedrock operates under the assumption that all of a given ~{stratum~}'s ~{hard dependencies~} are provided by that same ~{stratum~}.  For example, if a ~{stratum~}'s `/usr/bin/vim` requires a specific libc at `/lib/x86_64-linux-gnu/libc.so.6`, that same ~{stratum~} should provide such a file at that location.  Typical distro package managers usually ensure this is the case.  However, ~{soft dependencies~} may be missing from a given ~{stratum~} so long as another ~{stratum~} provides them.  For example, a ~{stratum~} may have a script which requires *some* build of `jq`, but does not care which specific `jq` or which specific file path provides the `jq`, in which case another ~{stratum~} may fulfill the `jq` ~{soft dependency~}.

## {id="filepath-types"} Filepath types

Two ~{strata~} may have mutually exclusive assumptions around the same file path.  For example, a Debian ~{stratum~}'s `apt` and an Ubuntu ~{stratum~}'s `apt` may each require different file contents at `/etc/apt/sources.list`.  For both of these `apt` binaries to work, each must see its own ~{stratum~}'s instance of `/etc/apt/sources.list`.  However, if *all* file are treated this way, ~{strata~} are unable to interact with each other.  Thus this system is only applied to *some* file, which are referred to as ~{local~} files.

In contrast to ~{local~} files are ~{global~} files.  All processes see the same files at ~{global~} paths.  For example, a `firefox` process from one ~{stratum~} may download a PDF file at `~/Downloads/file.pdf`, a ~{global~} path, and an `evince` process from another ~{stratum~} may read it.

~{Global~} paths allow ~{strata~} to share access to some files, but not all.  To fully interact, ~{strata~} also need to be able to see other ~{strata~}'s ~{local~} files.  For example, the aforementioned `firefox` process may benefit from the ability to directly launch another ~{stratum~}'s `evince`.  Thus, a third category of file path: ~{cross~} file paths.  Bedrock adds ~{cross~} paths to various application look up locations such as the `$PATH` environment variable to make ~{cross~}-~{stratum~} functionality work transparently.

By default, most file paths are ~{local~}.  The [bedrock.conf global section](configuration.html#global) is used to configure which are ~{global~}, and the [bedrock.conf cross sections](configuration.html#cross) are used to configure ~{cross~} paths.  The [brl which command](commands.html#brl-which) can be used to query which ~{stratum~} provides a given path.

To execute a specific ~{stratum~}'s ~{local~} executable, prefix the command with `strat ~(stratum~)`.  For example, to run Debian's `vim` (rather than, say, Ubuntu's), run `strat debian vim`.  To read or write a specific ~{stratum~}'s ~{local~} file, prefix the file path with `/bedrock/strata/~(stratum~)`.  For example, to edit Ubuntu's `/etc/apt/sources.list` (in contrast to, say, Debian's), run `vim /bedrock/strata/ubuntu/etc/apt/sources.list`.  These can be combine.  For example, to use Debian's `vim` to edit Ubuntu's `/etc/apt/sources.list`, run `strat debian vim /bedrock/strata/ubuntu/etc/apt/sources.list`.

## {id="restriction"} Restriction

Build tools often become confused by Bedrock's environment when attempting to find build dependencies.  As a solution, Bedrock provides the ability to ~{restrict~} processes from *automatically* seeing ~{cross~} paths by removing ~{cross~} entries from environment variables.  To be clear, this is not a security mechanism; such ~{restricted~} processes can still access ~{cross~} paths if they know to search them via some other means, such as a user instruction.

[Bedrock provides configuration to manage restriction](commands.html#restriction).  This may be overridden by providing `strat` either the `-r` flag to indicate the given command should be restricted or `-u` flag indicating it should not.

## {id="strata-state"} Strata state

A ~{stratum~} may be either ~{enabled~} or ~{disabled~}.  An ~{enabled~} ~{stratum~} is integrated with the rest of the system.  Its binaries are available for execution, its man pages detectable by `man`, etc.  One may wish to ~{disable~} a ~{stratum~}, de-integrating it from the rest of the system, at times such as:

- Mid-acquisition, before a new ~{stratum~}'s files are fully acquired and setup.
- Just before certain operations on the ~{stratum~} which require it to be ~{disabled~}, such as removal or renaming.
- To get the ~{stratum~} out of the way while keeping its files around in case it will become useful in the future.

A ~{stratum~} may also be ~{broken~}.  This indicates that the ~{stratum~}'s target state is ~{enabled~}, but that something went wrong.

[Bedrock provides commands to manage strata state](commands.html#strata-state-management).

## {id="strata-visibility"} Strata visibility

A ~{stratum~} may be either ~{shown~} or ~{hidden~} in/from various subsystems, controlling:

- Whether or not it is ~{enabled~} at boot.
- Whether or not it is listed in the init-selection menu.
- Whether or not its files are included in `/bedrock/cross`
- Whether or not it is listed by `brl list` without requiring the `-i` flag

Bedrock automatically ~{hides~} ~{strata~} to keep them from being accidentally ~{enabled~} at sensitive times such as mid-acquisition or just before removal.  Users may wish to ~{hide~} ~{strata~} if they are not expected to be useful for an extended period of time to keep them out of the way while still retaining them on disk for future use.

[Bedrock provides commands to manage strata visibility](commands.html#strata-visibility-management).

## {id="aliases"} Aliases

~{Aliases~} may be created as alternative names for ~{strata~}.  ~{aliases~} may be created, removed, or renamed irrelevant of their corresponding ~{stratum~}'s state, making them more flexible than the ~{strata~} names.

Some example situations where this may be useful:

- A user may desire some features be provided by the latest Ubuntu release and other features the latest Ubuntu LTS release.  Sometimes these are the same, and sometimes they are not.  This user may name ~{strata~} by their release code name, e.g. `bionic` and `cosmic`, then create `ubu-latest` and `ubu-lts` aliases and update them as new Ubuntu releases come out.
- A user may desire some features be provided by a specific Debian version and other features by a specific Debian branch.  This user may name ~{strata~} by their Debian release code names, e.g. `stretch` and `buster`, then create `deb-testing` and `deb-stable` aliases and update them as Debian releases shift branches.
- A user wish to create many hard-coded references the ~{stratum~} providing their preferred `firefox` build such as in shell scripts which call `strat ~(stratum~) firefox`.  Should the preferred `firefox` providing ~{stratum~} change, the user would have to find and change each shell script.  Instead, the user may create a `firefox-provider` ~{alias~} and have the scripts reference that instead.  This will allow an update to a single location to effectively change all hard-coded references.

Bedrock automatically creates a `hijacked` ~{alias~} during the hijack install to track which stratum corresponds to the initial install.  This is solely for the benefit of the user, and you are free to remove this.

Bedrock automatically creates and updates an `init` ~{alias~} corresponding to the ~{stratum~} that is providing the init system for the current session.  Bedrock's default `bedrock.conf` functionality leverages this to ensure init-related commands such as `reboot` are provided by the correct ~{stratum~}.  If you are not intimately familiar with how Bedrock works it is best to leave the `init` ~{alias~} untouched.

Bedrock automatically creates and updates an `local` ~{alias~} corresponding to the ~{stratum~} reading the ~{alias~}.  Bedrock's default `bedrock.conf` functionality leverages this to ensure ~{restricted~} commands are provided by the ~{local~} ~{stratum~} if available there before ~{crossing~} to other ~{strata~}.

[Bedrock provides commands to manage aliases](commands.html#alias-management).

This covers all the background required [before continuing to the Bedrock commands](commands.html).
