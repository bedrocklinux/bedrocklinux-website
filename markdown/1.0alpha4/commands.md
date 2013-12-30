Title: Bedrock Linux 1.0alpha4 Flopsie Command Overview
Nav: flopsie.nav

Bedrock Linux 1.0alpha4 Flopsie Command Overview
==============================================


- [brc ("BedRock Chroot")](#brc)
- [brp ("BedRock Path")](#brp)
- [brl ("BedRock aLl")](#brl)
- [bru ("BedRock Union")](#bru)
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
If the value of `$SHELL` is not available in the client it will fall back to
`/bin/sh`.


## {id="brp"} brp ("BedRock Path")

Very early (before any public release) versions of Bedrock Linux would try to
detect if you tried to run a command which isn't available and, on the fly,
attempt to find the command in a client. This proved to slow. Instead,
Bedrock's `brp` command will search for all of the commands available and store
them in directories which can be included in one's `$PATH` so that those
commands work transparently.  `/etc/profile` should include the relevant
directories in the `$PATH` automatically.  The priority order defining which
client should provide a given command is defined by [the brp.conf
file](configure.html#brpconf).


## {id="brl"} brl ("BedRock aLl")

The `brl` command will run its argument in all available clients. If, for
example, you want to test to ensure that all of your clients have internet
access, you could run the following: `brl ping -c 1 google.com`

If the first argument is `-c`, the following argument will be used as a
conditional to determine if the following arguments should be run.  For example:

run 'apt-get update' in all clients that have apt-get locally

- {class="rcmd"} 
- brl -c 'brw apt-get|grep local' apt-get update

clear the statoverride file in all clients which have it

- {class="rcmd"} 
- brl -c '[ -e /var/lib/dpkg/statoverride ]' echo '' > /var/lib/dpkg/statoverride


## {id="bru"} bru ("Bedrock Union filesystem")

The `bru` command will mount a filesystem, unioning the contents of two
directories.  All filesystem calls to the mount point will be redirected to one
of the directories, except a specified list which will be redirected to the
other directory.  This is setup for you automatically by the `brs` command
depending on the [union in the client.conf file](#configure.html#union) for any
given client.

If you would like to use it directly for whatever reason:

- The first argument is the mount point
- The second argument is the directory to which filesystem calls will be redirected by default
- The third argument is the directory specifically listed items will be redirected into
- The remaining arguments are the files which should be redirected into the
  directory specified in the third argument rather than the second.  These
  should be relative to the mount point and not start with a slash.

For example, if bru is called with

    bru /tmp /mnt/realtmp /dev/shm /.X11-unix /.X0-lock

all calls to `/tmp` or its contents will be redirected to `/mnt/realtmp` except
for `.X11-unix` and `.X0-lock`, which will be redirected to
`/dev/shm/.X11-unix` and `/dev/shm/.X0-lock`.


## {id="brs"} brs ("BedRock Setup")

`brs` can be used to bring up or down clients.  The first argument should be
`up` or `down` to specify which operation to perform, and the following
arguments should be the names of clients to be brought up or down.

Bringing down a client which provides running processes will kill the processes
- careful!

Bringing up a client will enable it for use by the rest of the system.  This is
particularly useful immediately after acquiring a client so it can be used.
Bringing down a client will remove any system dependencies on it so it can be
safely removed (`{class="rcmd"} rm /bedrock/clients/~(client~)`).


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
  example, the core Bedrock Linux sees `zsh` located at `/bedrock/brpath/bin/zsh`, but
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

- `bri -b` will print configured Bind mounts
- `bri -c` will Cache -n value of current OR following client name(s) (requires
  root).  Provides a small performance improvement to following -n requests
- `bri -h` will print help.
- `bri -l` will print List enabled clients.
- `bri -L` will print List all clients, both enabled and disabled.
- `bri -m` will prints Mount points in current client OR following client name(s)
- `bri -n` will print Name of client currently in
- `bri -p` will print the client that provides the following Process id or
  (non-numeric) Process name.
- `bri -P` will print a list of processes provided by the current client OR
  following client name(s)
- `bri -s` will print the setup Status of the current OR following client name(s)
- `bri -u` will print configured union mounts
- `bri -w` will print the client which provides the command(s) in the argument(s)

## {id="brw"} brw ("Bedrock Where")

The `brw` command is simply an alias to parts of `bri`.  Without any arguments,
`brw` will print the name of the current client (`bri -n`).  If arguments are
provided, it will indicate which client provides the listed command(s) (`bri
-w`).
