Title: Bedrock Linux 1.0alpha3 Bosco Command Overview
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Bosco Command Overview
==============================================


- [brc ("BedRock Chroot")](#brc)
- [brp ("BedRock Path")](#brp)
- [brl ("BedRock aLl")](#brl)
- [bru ("Bedrock Update")](#bru)
- [brs ("BedRock Setup")](#brs)
- [brsh ("BedRock SHell")](#brsh)
- [bri ("BedRock Information")](#bri)
- [brw ("Bedrock Where")](#brw)

## {id="brc"} brc ("BedRock Chroot")

`brc` provides the ability to run commands in clients, properly chrooting to
avoid conflicts.  Once Bedrock Linux is properly set up, it will allow the user
to transparently run commands otherwise not available in a given client.  For
example, if `firefox` is installed in a Arch client but not in a Debian client,
and a program from the Debian client tries to execute `firefox`, the Arch
`firefox` will be executed as though it were installed locally in Debian.

If `firefox` is installed in multiple clients (such as Arch and Fedora), and
the user would like to specify which is to run (rather than allowing Bedrock
Linux to chose the default), one can explicitly call `brc`, like so: `brc
fedora firefox`.

If no command is given, `brc` will attempt to use the user's current `$SHELL`.
If the value of `$SHELL` is not available in the client it will fail.


## {id="brp"} brp ("BedRock Path")

Very early (before any public release) versions of Bedrock Linux would try to
detect if you tried to run a command which isn't available and, on the fly,
attempt to find the command in a client. This proved to slow. Instead,
Bedrock's `brp` command will search for all of the commands available and store
them in directories which can be included in one's `$PATH` so that those
commands work transparently.  `/etc/profile` should include the relevant
directories in the `$PATH` automatically.


## {id="brl"} brl ("BedRock aLl")

The `brl` command will run its argument in all available clients. If, for
example, you want to test to ensure that all of your clients have internet
access, you could run the following: `brl ping -c 1 google.com`

## {id="bru"} bru ("Bedrock Update")

Updating all of the clients is a very common task, and so `bru` was created to
make it a simple one. `bru` can be used to update all of the clients in a
single command.  Note that eventually this will likely be replaced by a more
comprehensive package manager manager (not a typo) command.

## {id="brs"} brs ("BedRock Setup")

`brs` will set up the `share` items from `brclients.conf` in the client(s)
provided as (an) argument(s).  In Bedrock Linux 1.0alpha3, this is automatically
used at boot and rarely needs to be run by the user.  The exception is if a new
client is added or a share mount point accidentally removed, in which case the
user can simply call `brs ~(clientname~)`.  Unlike prior versions, this will
not check if a client has already been set up - do not run in a client which
has already been set up.

## {id="brsh"} brsh ("BedRock SHell")

Due to its purposeful minimalism, the core Bedrock Linux install only includes
busybox's very limited shells; users will most likely want to use a client's
shells by default. However, this raises three problems:

- What if the user needs to log into the core Bedrock's busybox's `/bin/sh`? For
  example, maybe the chroot system broke, or he/she is debugging a busybox
  update.
- What if the chroot system is fine but the client breaks? What if the user
  forgets that he/she uses the client's shell and removes the client?
- The typical Unix system used to determine which shell to run requires the
  full page to shells to be set within `/etc/passwd`. However, this path will
  likely change depending on which client is attempting to run the shell. For
  example, the core Bedrock Linux see `zsh` located at `/var/local/brpath/zsh`, but
  a Debian client will see the same `zsh` located at `/bin/zsh`. Having two
  differing paths for zsh like this will not work with a single login and the
  traditional Unix `/etc/passwd` system.

Bedrock Linux provides two options to resolve these issues:

1. Bedrock Linux has its own meta-shell, `brsh`, which will log in to a
configured client's shell, if available. If it is not available, it will
automatically drop to `/bin/sh` if it is available in the client, and if not,
then it drops down to the core Bedrock's `/bin/sh`. The path to `brsh` should
remain in the same location irrelevant of which client is running it, meaning
it will work in /etc/passwd while still allowing access to shells which have
changing paths.
2. The traditional Unix /etc/passwd allows creating multiple entries with
different login names and different shells but same password, home, etc, for
the same user. For example:

		root:x:0:0:root:/root:/opt/bedrock/bin/brsh
		brroot:x:0:0:root:/root:/bin/sh

This can be advantageous over `brsh` as (1) it should work if `brsh` fails to
detect a client has broken, and (2) it does not require logging in, changing
the `brsh` configuration file, then logging back out, and logging back in
again, if the user wants to directly log into the core Bedrock shell.


## {id="bri"} bri ("BedRock Information")

The `bri` command will provide information about the clients based on which
flag is used.

- `bri -l` will print a List of clients.
- `bri -n` will print the name of the client in which the command is run.
- `bri -p` will print the path of the client in which the command is run *if*
  no arguments are given.  Otherwise, it will print the paths of the clients
  provided in the argument.
- `bri -s` will print the shared mount points for a client.  It does not check
  if these are actually set up yet (from [brs](#brs)); it only prints the items
  listed in the brclients.conf for the respective client(s).  If no argument is
  provided, it will print for the client in which the command is run;
  otherwise, it will print for all clients.
- `bri -w` will print the client which will provide the command if it is not
  available locally.
- `bri -W` will print the client which will provides the command - either the
  client it is run in (ie, `bri -n`) if it is available locally or the output
  of `bri -w` if it is available in the brpath.
- `{class="rcmd"} bri -c` will cache the values of `-n` and `-p` to speed up
  future requests.  Note that this requires root.  It is recommended that this
  is run in newly made clients immediately after they are made.

## {id="brw"} brw ("Bedrock Where")

The `brw` command is simply an alias to `bri -n` for convenience.
