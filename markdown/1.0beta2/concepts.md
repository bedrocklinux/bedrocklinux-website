Title: Bedrock Linux 1.0beta2 Nyla Concepts
Nav: nyla.nav

Bedrock Linux 1.0beta2 Nyla Concepts
====================================

The text below is an introduction too the key concepts, theory, and terminology
behind Bedrock Linux 1.0beta2 Nyla.

- [Problem to solve](#problem)
- [Local vs global files](#local-vs-global)
- [Strata](#strata)
- [Singletons](#singletons)
- [Singleton Strata Attributes](#singleton-strata-attributes)
	- [Init Stratum](#init-stratum)
	- [Global Stratum](#global-stratum)
	- [Rootfs Stratum](#rootfs-stratum)
	- [Local Stratum](#local-stratum)
- [Filesystem access rules](#rules)
	- [Explicit access](#explicit)
	- [Direct Access](#direct-access)
	- [Implicit Access](#implicit-access)
		- [High Implicit Access](#high-implicit-access)
		- [Direct Implicit Access](#direct-implicit-access)
		- [Low Implicit Access](#low-implicit-access)
	- [Rule Summary](#rule-summary)
- [Under the hood](#under-the-hood)

## {id="problem"} Problem to solve

Linux software is often written or built with specific assumptions about the
environment in which it will be utilized.  These assumptions should hold true
for a given release of a given distribution but may not hold true in other
contexts.  One cannot simply install a non-distro-native package and expect it
to "just work".  One technique which will allow software to function in a
non-native distro is to segregate it from the rest of the system; for example,
consider container technologies such as LXC.  Utilizing these technologies,
however, means the given piece of software's ability to interact with the rest
of the system is severely limited, and the users' workflow must change to
accommodate this.  The fundamental problem Bedrock Linux is attempting to solve
is how to overcome these environment conflicts *without* segregating the
software from the rest of the system *or* adjusting the software to remove the
assumptions.  Ideally, a user should be able to take any package from any
distro and install it, unmodified, in Bedrock Linux and have it "just work".

Various assumptions software often makes about its environment include but are
not limited to:

- That a given build of a library exists at a specific location.  Not only does
  this require it to be the specific version of the library for the specific
  architecture, but occasionally also require things like specific build flags
  to have been used when the library was compiled.  If software from different
  distributions have differing requirements for a file at the same exact file
  path they will conflict with each other.

- The requirement for a specific file at a specific path extends beyond just
  libraries, but can also include things such as executables.  Consider, for
  example, that some distros - notably Red Hat-related ones - often use `bash`
  to provide `/bin/sh`.  Other distros, such as Debian-based ones, use other
  shells such as `dash`.  If a given `#!/bin/sh` program uses `bash`-isms it
  will work on Red Hat-related distros but not on Debian-based ones.  A proper
  fix would be for the given script to simply use `#!/bin/bash`, but sadly this
  is not always an exercised practice.

- Software may have requirements about which program has a given PID.  This is
  particularly common with init-related commands which may have requirements
  about what is providing PID 1.  For example, a sysv `reboot` command will not
  work on a system where PID 1 is provided by systemd.

- Software may require a daemon such as `dbus` to be listening to a given
  socket.  If an executable is placed in, for example, a minimal distro which
  does not include `dbus`, this requirement will fail to be met and the
  software may not work.

- Software may require a given kernel feature to work.  If running another
  kernel build from another distro this feature may be missing.

While Bedrock Linux, as of 1.0beta2 Nyla, does not solve all of these kinds of
problems, it does solve many of the more pressing ones. It thus allows quite a
lot of software from various, typically mutually-exclusive, Linux distributions
to "just work" when utilized in Bedrock Linux.

## {id="local-vs-global"} Local vs global files

If two pieces of software both require different file contents at a given path,
for both to work two instances of the given file must exist such that each
piece of software will see the file it expects at the given path.  Bedrock
Linux refers to files with this requirement as ~{local~} files.

In contrast to ~{local~} files are ~{global~} files: files which must be the
*same* when different pieces of software from different expected environments
attempt to utilize it.

For example, `/etc/apt/sources.list` is a ~{local~} file.  Debian's `apt-get`
and Ubuntu's `apt-get` should see different file contents when reading
`/etc/apt/sources.list`, as both will have different mirrors and configuration
for their package managers.  Thus, if a given Bedrock Linux install has both
Debian's and Ubuntu's `apt-get`, it will also have two copies of
`/etc/apt/sources.list`.

`/etc/passwd` is a ~{global~} file.  When software from different distributions
attempt to match a UID to a username, the pairing should be consistent.

## {id="strata"} Strata

Since a given path is not a unique identifier for a ~{local~} file, something
else must be used to identify which instance of the file is which.  Bedrock
Linux refers to this extra piece of information as the given file's
~{stratum~}.

~{Strata~} are collections of files which (usually) are intended to work
together; they share the same expected environment.  If a given piece of
software has some dependency on a ~{local~} file, that dependency can (usually)
be met by the software in the same ~{stratum~}.

Every file in a Bedrock Linux system has an associated ~{stratum~}, including
~{global~} files and ~{local~} files which don't actually have conflicts on
disk.  A given file path and ~{stratum~} pair uniquely identify every file.

One can also think of ~{strata~} as slices of the filesystem.  Each slice is
uniform in environment expectations, but they exist side-by-side and, together,
make the entire system.

~{Strata~} were previously referred to as "~{clients~}", but sadly that term
was found to be misleading and led to regular misunderstandings.  For example,
it implies a client-server relationship, when no such thing exists in Bedrock
Linux. [Strata](https://en.wikipedia.org/wiki/Stratum) is a much more fitting
mental image for what is actually happening.

## {id="singletons"} Singletons

Most software from different ~{strata~} can be in use simultaneously.  One can
have, for example, two instances of `vlc` running at the same time from
different distros.  Sadly, not all software works this way.  Things such as the
Linux kernel and init/PID1 are ~{singletons~}: you can only have one instance
of it at a time.

Bedrock Linux does not restrict its users to only using one singleton, but
rather only one at a time.  Consider a situation where two distros each provide
a Linux kernel with a feature the other one lacks (e.g. one has TOMOYO Linux
while the other has systemtrace).  Bedrock Linux does not do anything to allow
its users to have both kernels at the same time; however, one can choose which
to use on reboot.  If a user would like to use TOMOYO Linux most of the time,
but occasionally use systemtap to debug an issue, this is a viable option.

Another example of a ~{singleton~} is the init/PID1.  If a user typically
prefers to use `runit` as their PID1, but occasionally needs `systemd` as a
dependency for a piece of software, with Bedrock Linux the user can usually
just have Void Linux provide `runit`, but occasionally reboot to `systemd` as
provided by Arch Linux.

## {id="singleton-strata-attributes"} Singleton Strata Attributes

Bedrock Linux needs to track which ~{strata~} are currently providing specific
functionality.  Such ~{strata~} have special aliases used to access them.  When
a ~{singleton~} switches to another ~{stratum~}, the alias is adjusted so that
it always points to the ~{stratum~} providing the specific functionality.

### {id="init-stratum"} Init Stratum

Whichever ~{stratum~} is currently providing PID1 is aliased to ~{init~}.  If
the user reboots and selects another init system, the stratum providing the
chosen init system this becomes the ~{init stratum~}.  This information is
needed to properly determine from which stratum a given init-related command
(e.g. `reboot`) should be provided.

### {id="global-stratum"} Global Stratum

The aforementioned ~{global~} files all belong one ~{stratum~}, which is
aliased to ~{global~} so the relevant Bedrock Linux subsystems will know where
the ~{global~} files.  It is technically possible to copy/move the ~{global~}
files to another ~{stratum~} and thus change the ~{global~} stratum, but is
generally not recommended as it is easy to botch; ~{global~} is typically
chosen at install time and left throughout the life of the system.

### {id="rootfs-stratum"} Rootfs Stratum

One ~{stratum~} provides the root filesystem at very early boot time.  This
includes things such as `/boot` for the bootloader and `/bedrock` for the
Bedrock Linux subsystems.  This ~{stratum~} aliased to ~{rootfs~}.  It is
technically possible to move key files such as `/bedrock` to another
~{stratum~} and thus change the ~{rootfs~} stratum, but is generally not
recommended as it is easy to botch; ~{rootfs~} is typically chosen at install
time and left throughout the life of the system.

### {id="local-stratum"} Local Stratum

Software can refer to its own ~{stratum~} as the ~{local~} stratum; the
~{local~} alias works for everything to refer to itself.

## {id="rules"} Filesystem access rules

When a program attempts to access a ~{global~} file, it gets the ~{global~} file
- very simple.  However, when it attempts to access a ~{local~} file Bedrock
Linux must determine which if any ~{local~} file to provide so that both
environment expectations are met *and* things interact smoothly as they would
if they were all from the same distribution.

From a high-level, conceptual point of view, when a filesystem access attempt
is made, Bedrock Linux goes through the following rules to determine which if
any ~{stratum~} should provide the given file.  The end result of these rules
is that various pieces of software will see the correct instance of a file if
there is some associated environment expectation without constraining them such
that they would lose the ability to fully interact with software from other
distros.

Note that while it is useful to understand these rules to tweak or debug them,
it is not expected that one keeps them in mind during typical, day-to-day
Bedrock Linux usage; everything should "just work" transparently, as though all
of the software in use was intended to work together.

### {id="explicit"} Explicit access

The highest-priority rule is referred to as ~{explicit~} access.  This occurs
when the ~{stratum~} is specified in a Bedrock Linux specific manner.
Naturally, software from other distributions are not designed to use any
Bedrock Linux specific mechanisms and so they will not automatically utilize
~{explicit~} access; only Bedrock Linux-aware users and software should utilize
this.

For everything but execution, the desired file's path and ~{stratum~} can be
specified via:

    /bedrock/strata/~(stratum-name~)/~(file-path~)

For example, to access *specifically* Crux's `/etc/rc.conf` file, one could
use the following file path:

    /bedrock/strata/crux/etc/rc.conf

Specifying a file to execute require a different access method.  Instead, the
given executable should be prefixed with `brc ~(stratum-name~)`, as one would
do with the `sudo -u` or `chroot` commands.

For example, to explicitly run Arch Linux's `vim`, one could run:

    brc arch vim

These two systems can be combine.  To use Arch's `vim` to edit Crux's
`/etc/rc.conf` one could run:

    brc arch vim /bedrock/strata/crux/etc/rc.conf

Please note that this ~{explicit~} access - and the tedium which results from
the extra text to associate the given ~{stratum~} - is relatively rare compared
to the other rules.  It is primarily used as an override.  For most things the
system will automatically determine which ~{stratum~} is appropriate from the
following rules.

### {id="direct-access"} Direct Access

If the path to the file is specified - either the full path or a relative path
- Bedrock Linux considers it ~{direct~} access.  A *specific* file was chosen -
the request was not open to *any* file with the given name - but no
~{stratum~} was specified.  This generally occurs with dependencies.  If, for
example, specifically `/usr/lib/libc-2.22.so` is needed, software will access
it via that path.

In these situations there is a strong possibility that the requested file is a
dependency, possibly a picky one such that failing to provide the exact file
will cause a failure.  Here Bedrock Linux will provide the given file from the
same ~{stratum~} as the program which requested it, i.e. the ~{local~}
~{stratum~}.  If `apt-get` from a Linux Mint ~{stratum~} requests
`/etc/apt/sources.list`, the Linux Mint copy of `/etc/apt/sources.list` is
provided.  Thus, dependencies - and hence environmental expectations - are met.

### {id="implicit-access"} Implicit Access

~{Implicit~} access occurs when neither a specific path nor a specific
~{stratum~} is provided.  In these situations Bedrock Linux is afforded some
freedom to chose which file from which ~{stratum~} to chose.  However, the
possibility of a specific environment expectation remains in these situations,
and thus care must be taken.

For example, if a user runs `man vim`, Bedrock Linux may have some choice both
for which `man` to provide as well as which `vim` man page.  Both the
executable `man` and the `vim` man page are accessed ~{implicitly~}.

Note that ~{implicit~} access is always read-only.

#### {id="high-implicit-access"} High Implicit Access

If the given file has some expectation which Bedrock Linux cannot automatically
detect via ~{local-implicit~} (described below), [one can
configure](configure.html#brp.conf) Bedrock Linux to always ~{implicitly~}
provide a given file from a given ~{stratum~}.

For example, the `reboot` command needs to be tied to the ~{stratum~} providing
init/PID1.  An openrc-using Alpine Linux `reboot` will not reboot a system which
has systemd as its init/PID1.  Thus, Bedrock Linux can be configured to always
have the `reboot` command provided by the ~{init~} ~{stratum~}.

Such configured access is refered to as ~{high implicit~} access, as it has the
highest priority of any of the ~{implicit~} access rules.

Do note that running `/usr/sbin/reboot` is considered ~{direct~} access;
programs which attempt to run `/usr/sbin/reboot` (e.g. the shutdown button from
a desktop environment) will get the ~{local~} ~{stratum~} copy and may fail to
work.  Sadly, Bedrock Linux's transparency breaks down here: users will be
required to configure/adjust things to use ~{implicit~} access in these
situations.  Luckily, these situations are fairly rare.

If a path is needed to for ~{high implicit~} access, such as specifying a
NOPASSWD item in `/etc/sudoers`, one can use
`/bedrock/brpath/pin/~(path-to-file~)`.  For example, to allow the user
"paradigm" NOPASSWD `sudo` access to the `reboot` command, one could add the
following to `/etc/sudoers`:

    paradigm ALL=NOPASSWD: /bedrock/brpath/pin/sbin/reboot

That file will always refer to the proper `reboot` command associated with the
current ~{init stratum~}.

#### {id="direct-implicit-access"} Direct Implicit Access

~{direct implicit~} access is utilized to cover the possibility of a dependency
to something that did not use a path to specify the file.  If:

- No ~{stratum~} is specified (thus, not ~{explicit~} access)
- No path is specified (thus, not ~{direct~} access)
- No ~{high implicit~} configuration rule is matched (thus, not ~{high implicit~})

Bedrock Linux checks to see if the given file exists in the ~{local~} stratum.
If it exists, the ~{local~} copy is utilized.

For example, if a script uses `#!/usr/bin/env python`, the `env` executable
will try to execute `python`.  The script, however, may require a *specific*
`python` executable, such as python 2.X vs python 3.X.  If `python` is
available ~{locally~}, that version will be used to ensure the environment
expectation is met.

The term ~{direct implicit~} is admittedly awkward; the terminology here may
change in the future.

#### {id="low-implicit-access"} Low Implicit Access

When a file access is attempted, and:

- No ~{stratum~} is specified (thus, not ~{explicit~})
- No path is specified (thus, not ~{direct~})
- No ~{high implicit~} rule is matched (thus, not ~{high implicit~})
- and the file is not available in the ~{local stratum~} (thus, not ~{direct implicit~})

Then ~{low implicit~} is used.  With this rule, Bedrock Linux will check if
*any* of the other ~{strata~} can provide the given file.  If so, that
instance of the file is utilized.  The order these other ~{strata~} are
searched is configurable; some users prefer having cutting-edge versions given
a higher priority while others prefer older/stable software to take priority if
available.

This rule is what allows most of the ~{local~} file interaction between
~{strata~}.

If a `bash` shell runs `man vim`, but only one instance of each `bash`, `man` and
the `vim` man page exist and they're all from different ~{strata~}, this rule
is what allows them to all work together.  A user is free to type `man vim` in
the `bash` shell and the expected man page shows up - everything "just works"
here despite everything being from potentially different distributions.  `bash`
and `man` will both see their own dependencies due to ~{direct~} access that
will occur in their runtime (through runtime linking, `open()`/`read()`, etc).

If a path is needed to for ~{low implicit~} access, again such as specifying a
NOPASSWD item in `/etc/sudoers`, one can use `/bedrock/brpath/~(path-to-file~)`
(note lack of "pin/").  For example, to allow the user "paradigm" NOPASSWD
`sudo` access to a custom `wifion` script which connects the system to a
wireless network, one could add the following to `/etc/sudoers`:

    paradigm ALL=NOPASSWD: /bedrock/brpath/sbin/wifion

### {id="rule-summary"} Rule Summary

- ~{Global access~}:
	- A file configured as ~{global~} file is accessed.
	- Uses file from ~{global stratum~}.
	- Intended to ensure ~{strata~} interact properly.
- ~{Explicit access~}:
	- Desired ~{stratum~} is specified (e.g. `brc` **`slack141`** `vim` or `/bedrock/strata/`**`arch`**`/etc/pacman.conf`)
	- Uses specified ~{stratum~}.
	- Intended to override other rules.
- ~{Direct access~}:
	- A path is provided to the file (e.g. **`/usr/lib/`**`libc.so.6`)
	- Uses ~{local stratum~}.
	- Intended to catch dependencies (e.g. which instance of a library to use).
- ~{High implicit~}:
	- No ~{stratum~} or path specified, but rule is configured.
	- Uses ~{stratum~} specified by rule.
	- Intended to catch dependencies (e.g. which `reboot` to use, should be tied to init).
- ~{Direct implicit~}:
	- No ~{stratum~} or path specified, no ~{high implicit~} configuration, but file does exist in ~{local stratum~}.
	- Uses ~{local stratum~}.
	- Intended to catch dependencies (e.g. which `python` to use with `#!/usr/bin/env python`)
- ~{Low implicit~}:
	- No ~{stratum~} or path specified, no ~{high implicit~} configuration, and file not does exist in ~{local stratum~}, but file does exist in another ~{stratum~}
	- Uses first ~{stratum~} that provides file from configured order.
	- Intended to ensure ~{strata~} interact properly.

Otherwise, a file access is treated as no such file (e.g. `open(2)` with `O_RDONLY` returns `ENOENT`).

## {id="under-the-hood"} Under the hood

Various notes on what is going on under-the-hood for those who are curious
follow.  These are not intended to give a full, detailed picture, but just a
general idea.  This information is not required to utilize Bedrock Linux.

- `chroot()` is used to segregate out the different ~{stratum~}, effectively
  implementing ~{local~} files.
- bind mounts are used to selectively "undo" some `chroot()` segregation,
  implementing some ~{global~} files.
- A custom FUSE filesystem, `bru`, is mounted onto specific directories where
  bind mounts are not applicable.  This selectively redirects access to files
  within the mount point accordingly, implementing the rest of the ~{global~}
  files.
- `chroot()` is used as a way to "tag" a given process with the associated
  ~{stratum~}.  `bri -p` compares roots to determine which ~{stratum~} a given
  process is in.  This is why `brc` is needed for execution ~{explicit~}
  access: it calls `chroot()`.
- bind mounts are used to ensure files are at the ~{explicit~} non-execution
  access location of `/bedrock/strata/~(stratum-name~)`.
- ~{direct~} access works due to `chroot()` usage in `brc`.
- Which of the three ~{implicit~} access rules is chosen via `$PATH`-like
  variables for different applications.  For example, `man` looks through the
  `$MANPATH` when looking for a man page.  If a rule is invalid, no file will
  exist for the respective location in the `$PATH`-like variable, and thus
  access will fall through to the next ~{implicit~} rule.
- ~{high implicit~} and ~{low implicit~} rules are implemented via another FUSE
  filesystem, `brp`.  This populates the directories in the `$PATH`-like
  variables on-the-fly depending on configuration and what files are available
  in what ~{stratum~} at the time of `brp` access.
- While all of the above systems ensure the appropriate *file contents* are
  available at the appropriate times/locations, they do leave a gap: only some
  processes can see all of the *mount points*.  This distinction is primarily
  important for unmounting the mount points at shutdown time.  `pivot_root` is
  called when selecting the ~{init stratum~} at boot time to ensure the init
  system can see all of the mount points and thus cleanly unmount everything at
  poweroff.

The specific details described above vary from release to release as better
ways of solving the fundamental problem are found, and thus information such as
what is described here can quickly become outdated.  A full, detailed white
paper is planned to be written and released when Bedrock Linux stabilizes at a
1.0 stable release.  At such a time the white paper contents will be valid for
a long enough time to justify the effort placed into writing it.
