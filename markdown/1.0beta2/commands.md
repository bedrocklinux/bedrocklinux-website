Title: Bedrock Linux 1.0beta2 Nyla Command Overview
Nav: nyla.nav

Bedrock Linux 1.0beta2 Nyla Command Overview
============================================


- [brc ("BedRock Change local Context")](#brc)
- [bri ("BedRock Information")](#bri)
- [brl ("BedRock aLl")](#brl)
- [brsh ("BedRock SHell")](#brsh)
- [brw ("Bedrock Where")](#brw)
- [brp ("BedRock Path")](#brp)
- [brs ("BedRock Setup")](#brs)
- [bru ("BedRock Union")](#bru)
- [brn ("Bedrock Union pre-iNit")](#brn)

## {id="brc"} brc ("BedRock Change local context")

The way Bedrock Linux resolves potential conflicts between packages from
different distributions is by having multiple instances of such files.  This
can mean multiple versions of any given executable will be present.  When a
user runs a command, a specific rule set will decide which instance of an
executable is run if multiple are available.  To bypass this rule set and
~{explicitly~} specify which is to be run one can use the `brc` command.

If `firefox` is installed in multiple ~{strata~} (such as Arch and Fedora),
and the user would like to specify which is to run (rather than allowing
Bedrock Linux to chose the default), one can ~{explicitly~} call `brc`, like so:
`brc fedora firefox`.

If no command is given, `brc` will attempt to use the user's current `$SHELL`.
If the value of `$SHELL` is not available in the ~{stratum~} it will fall back to
`/bin/sh`.

## {id="bri"} bri ("BedRock Information")

The `bri` command will provide information about the ~{strata~} based on which
flag is used.
- `bri -c` will print Config values for the specified ~{stratum~}.
- `bri -e` will populate the `/etc/bedrock_stratum` file.  This provides small
  performance improvement for `bri -n`.
- `bri -h` will print the Help
- `bri -i` will print a list of enabled ~{strata~} and aliases.
- `bri -I` will print a list of all ~{strata~} and aliases, enabled and disabled.
- `bri -l` will print List of enabled ~{strata~}
- `bri -L` will print List of all ~{strata~}, enabled and disabled
- `bri -m` will prints Mount points in current ~{stratum~} OR following ~{stratum~} name(s)
- `bri -M` will prints Missing mount points in current ~{stratum~} OR following ~{stratum~} name(s)
- `bri -n` will print Name of ~{stratum~} corresponding to current process
- `bri -p` will print the ~{stratum~} that provides the following Process id or (non-numeric) Process name
- `bri -P` will print a list of Processes provided by the current ~{stratum~} OR following ~{stratum~} name(s)
- `bri -s` will print the setup Status of the current OR following ~{stratum~} name(s)
- `bri -w` will print the ~{stratum~} Which provides the command(s) in the argument(s)

## {id="brl"} brl ("BedRock aLl")

The `brl` command will run its argument in the ~{local~} context of all enabled
~{strata~}.

Examples:

Attempt to ping bedrocklinux.org to check if networking/DNS is working

`brl ping -c 1 google.com`

Run 'apt-get update && apt-get dist-upgrade' with the `apt-get` from all
~{strata~} that have apt-get available in the ~{local~} context.

`brl -c 'brw apt-get|grep "(~{direct~})$"' sh -c 'apt-get update && apt-get dist-upgrade'`

List all of the pids and their corresponding ~{strata~}.  Can append `| sort -n` to sort by pid.

`brl bri -P | grep -v "brl\|bri"`

## {id="brsh"} brsh ("BedRock SHell")

`/etc/passwd` requires the full path to the user's desired shell.  While this
is available through via ~{implicit~} access through
`/bedrock/brpath/bin/~(shell~)`, due to how the ~{implicit~} subsystem is
currently implemented any indication that the shell is a login shell is lost.

To resolve this, Bedrock Linux provides a meta-shell, `brsh`, which simply
calls the shell configured in [~/.brsh.conf](configure.html#.brsh.conf).

## {id="brw"} brw ("Bedrock Where")

The `brw` command is simply an alias to parts of `bri`.  Without any arguments,
`brw` will print the name of the current ~{stratum~} (`bri -n`).  If arguments are
provided, it will indicate which ~{stratum~} provides the listed command(s) (`bri
-w`).

## {id="brp"} brp ("BedRock Path")

The `brp` executable is responsible for maintaining the `/bedrock/brpath`
directory and thus allowing ~{implicit~} file access.  This is typically
launched during boot; end-users will rarely ever have to run it ~{directly~}.  It
is configured via [/bedrock/etc/brp.conf](configure.html#brp.conf).

## {id="brs"} brs ("BedRock Setup")

`brs` can be used to enable and disable ~{strata~}.  After enabling or
disabling a ~{stratum~}, it will inform `brp` to update its internal list of
~{strata~}.

To enable ~{strata~}, run:

    `brs enable ~(strata~)`

To disable:

    brs disable ~(strata~)

To disable then reenable:

    brs reenable ~(strata~)

If config/frameworks have changed since a ~{stratum~} was enabled, and one
would like to add new mount items to a running ~{stratum~} without disabling
it, it is done like so:

    brs update ~(strata~)

Note that `brs update` may miss things such as subshare items and new
components of a union item.  Generally, a full `brs reenable` is recommended
over `brs update` if it is not a problem.

## {id="bru"} bru ("Bedrock Union filesystem")

The `bru` command will mount a filesystem, unioning the contents of two
directories.  Specifically, it implements the required functionality for the
[union stratum.conf setting](configure.html#stratum.conf-union). Like `brp` this
is mostly managed by the system and it is unlikely the end-user will need to
run this directly.

## {id="brn"} brn ("Bedrock Union pre-iNit")

The `brn` command bootstraps other init systems.  It reads
[brn.conf](configure.html#brn.conf) and, through querying `bri`, the
[init](configure.html#stratum.conf-init) and
[enable](configure.html#stratum.conf-enable) values in the union stratum.conf
setting, optionally prompting the user to select a init to use, then hands off
control to that init.

Like `brp` and `bru` this is mostly managed by the system and it is unlikely
the end-user will need to run this directly.
