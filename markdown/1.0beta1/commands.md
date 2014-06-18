Title: Bedrock Linux 1.0beta1 Hawky Command Overview
Nav: hawky.nav

Bedrock Linux 1.0beta1 Hawky Command Overview
==============================================


- [brc ("BedRock Change local Context")](#brc)
- [bri ("BedRock Information")](#bri)
- [brl ("BedRock aLl")](#brl)
- [brsh ("BedRock SHell")](#brsh)
- [brw ("Bedrock Where")](#brw)
- [brp ("BedRock Path")](#brp)
- [brs ("BedRock Setup")](#brs)
- [bru ("BedRock Union")](#bru)

## {id="brc"} brc ("BedRock Change local Context")

The way Bedrock Linux resolves potential conflicts between packages from
different distributions is by having multiple instances of such files.  This
can mean multiple versions of any given executable will be present.  When a
user runs a command, a specific rule set will decide which instance of an
executable is run if multiple are available.  To bypass this rule set and
~{explicitly~} specify which is to be run one can use the `brc` command.

If `firefox` is installed in multiple ~{clients~} (such as Arch and Fedora),
and the user would like to specify which is to run (rather than allowing
Bedrock Linux to chose the default), one can ~{explicitly~} call `brc`, like so:
`brc fedora firefox`.

If no command is given, `brc` will attempt to use the user's current `$SHELL`.
If the value of `$SHELL` is not available in the ~{client~} it will fall back to
`/bin/sh`.

## {id="bri"} bri ("BedRock Information")

The `bri` command will provide information about the ~{clients~} based on which
flag is used.  
- `bri -c` will print Config values for the specified ~{client~}.
- `bri -C` will Cache -n value of current OR following ~{client~} name(s) (requires
  root), providing a small performance improvement to following `bri -n` and
  `brw` requests
- `bri -h` will print the Help
- `bri -l` will print List of enabled ~{clients~}
- `bri -L` will print List of all ~{clients~}, enabled and disabled
- `bri -m` will prints Mount points in current ~{client~} OR following ~{client~} name(s)
- `bri -n` will print Name of ~{client~} corresponding to current process
- `bri -p` will print the ~{client~} that provides the following Process id or (non-numeric) Process name
- `bri -P` will print a list of Processes provided by the current ~{client~} OR following ~{client~} name(s)
- `bri -s` will print the setup Status of the current OR following ~{client~} name(s)
- `bri -w` will print the ~{client~} Which provides the command(s) in the argument(s)

## {id="brl"} brl ("BedRock aLl")

The `brl` command will run its argument in the ~{local~} context of all enabled
~{clients~}.

Examples:

Attempt to ping google ito check if networking is working

`brl ping -c 1 google.com`

Run 'apt-get update && apt-get dist-upgrade' with the `apt-get` from all
~{clients~} that have apt-get available in the ~{local~} context.

`brl -c 'brw apt-get|grep "(~{direct~})$"' sh -c 'apt-get update && apt-get dist-upgrade'`

List all of the pids and their corresponding ~{clients~}.  Can append `| sort -n` to sort by pid.

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
`brw` will print the name of the current ~{client~} (`bri -n`).  If arguments are
provided, it will indicate which ~{client~} provides the listed command(s) (`bri
-w`).

## {id="brp"} brp ("BedRock Path")

The `brp` executable is responsible for maintaining the `/bedrock/brpath`
directory and thus allowing ~{implicit~} file access.  This is typically
launched during boot; end-users will rarely ever have to run it ~{directly~}.  It
is configured via [/bedrock/etc/brp.conf](configure.html#brp.conf).

## {id="brs"} brs ("BedRock Setup")

`brs` can be used to enable and disable ~{clients~}.  After enabling or
disabling a ~{client~}, it will inform `brp` to update its internal list of
~{clients~}.

To enable ~{clients~}, run:

    `brs enable ~(clients~)`

To disable:

    brs disable ~(clients~)

To disable then reenable:

    brs reenable ~(clients~)

If config/frameworks have changed since a ~{client~} was enabled, if one would like
to add new mount items to a running ~{client~} without disabling it, one can do
this like so:

    brs update ~(clients~)

Note that \`brs update\` may miss things such as subshare items and new
components of a union item.

## {id="bru"} bru ("Bedrock Union filesystem")

The `bru` command will mount a filesystem, unioning the contents of two
directories.  Specifically, it implements the required functionality for the
[union client.conf setting](configure.html#client.conf-union) Like `brp` this
is mostly managed by the system and it is unlikely the end-user will need to
run this directly.
