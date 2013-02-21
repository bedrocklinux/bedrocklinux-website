Title: Bedrock Linux 1.0alpha4 Flopsie Plans
Nav: flopsie.nav

# Bedrock Linux 1.0alpha4 Flopsie Plans

This page serves to describe plans for the upcoming release of Bedrock Linux,
1.0alpha4 "Flopsie". Flopsie is tentatively set for release by End-of-Summer
2013.

The primary changes planned are the addition of two FUSE virtual filesystems,
brpath and brinfo.

## brpath virtual filesystem

The current release of Bedrock Linux, 1.0alpha3 "Bosco", requires users run the
`brp` utility every time an executable is added or remove from the system.
Additionally, Bosco does not have a clean way to ensure a given executable is
*always* provided by the same client, irrelevant of what the client may have
natively.  These two issues will be addressed with a FUSE virtual filesystem
called "brpath".  It will be mounted at `/bedrock/brpath/` and have something
along the following root-level directory structure:

- `/bedrock/brpath/prebin/`
- `/bedrock/brpath/presbin/`
- `/bedrock/brpath/postbin/`
- `/bedrock/brpath/postsbin/`
- `/bedrock/brpath/reparse_configs`

### prebin and presbin

The `prebin` and `presbin` directories will contain `brc`-wrappers for
executables which should always be provided by a given client.  For example, if
you would like `startx` to always be provided by a client called "squeeze", a
`brc`-wrapper for `startx` will be located in `prebin`.

The contents of `prebin` and `presbin` will be populated based on a
configuration file located at `/bedrock/etc/brbins.conf`.  Each line in the
configuration file will include an executable name followed by white space and
then a client name.  For example, to have the core Bedrock always provide
`halt`, `reboot`, `poweroff` and `shutdown`:

	# command	# client
	halt		bedrock
	reboot		bedrock
	poweroff	bedrock
	shutdown	bedrock

Note that if you include an executable in `brbins.conf` that is not available
from the given client, it will not show up in `prebin`/`presbin`; the
availability of every command in the brpath is checked on-the-fly (hence no
need for `brp`).  If the command is made available in another client, the
search through the `$PATH` will continue past the `prebin`/`presbin` and may be
provided by another client later in the `$PATH`.

### postbin and postsbin

The contents of `postbin` and `postsbin` will provide `brc`-wrappers for every
executable normally in the `$PATH` (i.e.: `/bin`, `/usr/bin`, `/usr/local/bin`,
and their sbin-counterparts).  Like `prebin` and `presbin`, the contents here
will be generated on-the-fly as needed so that `brp` is not needed.

### reparse_configs

While the existence of executables is checked on-the-fly, the contents of the
relevant configuration files (`brclients.conf`, `brbins.conf`, and `rc.conf`)
will be cached in order to improve performance.  To inform the brpath virtual
filesystem to reparse the configuration files, write `1` to `reparse_configs`
as root, like so:

	{class="rcmd"} echo 1 > /bedrock/brpath/reparse_configs

## brinfo virtual filesystem

Another FUSE virtual filesystem, brinfo, is also planned to be included in
Flopsie.  It is intended to function in a similar manner to the typical Linux
`/sys` directory: it will both provide information about the Bedrock subsystems
as well as provide a means to make changes to it.  It will be mounted at
`/bedrock/brinfo` and have something along the following root-level directory
structure:

- `/bedrock/brinfo/clients/`
- `/bedrock/brinfo/bins/`
- `/bedrock/brinfo/sbins/`

### clients

The `/bedrock/brinfo/clients/` directory will contain one directory for each
client on the system (roughly akin to `/proc/` containing one directory for
each PID).  Additionally, there will be a symlink called "current" which will
point to the client the reading process is currently in.

One can thus run `ls /bedrock/brinfo/clients | grep -v "^current$"` to get a
list of clients on the system.  Moreover, one can run `readlink
/bedrock/brinfo/clients/current` to determine in which client the calling
executable is currently being provided by.

Each directory will contain the following:

- `name`
	- This simply provides the name of the client which is the same as the name
	  of the directory which contains it.  Some people may prefer reading files
	  over getting a name of a directory.
- `setup`
	- This provides the mount point setup status of a given client if read.  If
	  written to as root, it can be used to (re)set up a client.  If you change the
	  "share" values for a given client and would like to re-set up the client,
	  this is where to do it.
- `running_processes`
	- If read, this will provide a list of PIDs of processes that are provided
	  by the given client.

### bins and sbins

The `/bedrock/brinfo/bins/` and `/bedrock/brinfo/sbins/` directories will each
contain one file for every executable in their parts of the filesystem.
Reading the file will provide the name of the client which provides it.
