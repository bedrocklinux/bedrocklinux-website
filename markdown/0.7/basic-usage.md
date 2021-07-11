Title: Bedrock Linux 0.7 Poki Basic Usage
Nav: poki.nav

# Bedrock Linux 0.7 Poki Basic Usage

This page will introduce you to the minimum ~+Bedrock Linux~x-specific
background required to utilize and manage a ~+Bedrock~x system.

An interactive version of this content is available on ~+Bedrock~x systems via
the `brl tutorial basics` command.

TableOfContents

## {id="strata"} Strata

A ~+Bedrock~x system is composed of ~{strata~}, which are collections of
interrelated files and processes.  These typically correspond to Linux distro
installs: one may have a ~+Debian~x ~{stratum~}, an ~+Arch~x ~{stratum~}, etc.
~+Bedrock~x integrates these into a single, largely cohesive system.

To list the currently installed (and enabled) ~{strata~}, run:

	{class="cmd"} brl list

A fresh install will have two ~{strata~}:

- `bedrock`, which is the stratum providing ~+Bedrock~x-specific functionality.
- The ~{hijacked~} stratum, which provides the files corresponding to the
  ~{hijacked~} install.


This, alone, is of little more immediate value than just the initial install.
To benefit from ~+Bedrock~x more ~{strata~} are needed.  To list distros
~+Bedrock~x knows how to acquire as ~{strata~}, run:

	{class="cmd"} brl fetch --list

Then to acquire new ~{strata~}, run (as root):

	{class="rcmd"} brl fetch ~(distros~)

This may fail if it auto-detects a bad mirror.  If so, manually find a good
mirror for the distro and provide it to `brl fetch` with the `--mirror` flag.

## {id="cross-stratum-commands"} Cross Stratum Commands

Many features from ~{strata~} should work just as they would in their normal
environments.  For example, if you `brl fetch`'d ~+Alpine~x and ~+Void~x
strata, you can run both ~+Alpine~x's package manager:

	{class="cmd"} apk --help

and ~+Void~x's package manager:

	{class="cmd"} xbps-install --help

These can be used to install packages from each stratum such as ~+Alpine~x's `jq` and
~+Void~x's `jo`:

- {class="rcmd"}
- apk add jq
- xbps-install -y jo

The commands can interact just as they would were they from the same distro.
This command works just as it would if `jo` and `jq` came from the same distro:

- {class="cmd"}
- jo "distro=bedrock" | jq ".distro"

## {id="other-cross-stratum-features"} Other Cross Stratum Features

~+Bedrock~x integrates more than just terminal commands.  It strives to make as
much as it can work transparently and cohesively across ~{strata~}, including:

- Graphical application menu contents
- Shell tab completion
- Kernel firmware detection
- Xorg fonts
- Some themes

Lets try another example: `man` pages.  We can get ~+Alpine~x's `jq` `man`
page and ~+Void~x's `man` executable:

- {class="rcmd"}
- apk add jq-doc
- xbps-install -y man

Then have ~+Void~x's `man` read ~+Alpine~x's `jq` documentation:

- {class="cmd"}
- man jq

which, again, works as it would had the `man` executable and `jq` man page come
from the same distribution.

## {id="brl-which"} brl which

On a ~+Bedrock~x system, every file and every process is associated with some
~{stratum~}.  The `brl which` command can be used to query ~+Bedrock~x for this
association.

Running

- {class="cmd"}
- brl which apk
- brl which xbps-install

would indicate the ~+Alpine~x and ~+Void~x ~{strata~}, respectively.

What about commands that multiple ~{strata~}, such as both ~+Alpine~x _and_
~+Void~x, provide?  For example, `ls`:

	{class="cmd"} brl which ls

This will indicate one ~{stratum~}'s instance.  This is the one which will be
run if `ls` is run in the given context.  How it picks this ~{stratum~} will be
described further on.

`brl which` can also be used for Process IDs.  To see which ~{stratum~}
provides the running init system, one could run:

	{class="cmd"} brl which 1

File paths work as well:

	{class="cmd"} brl which /

indicates which ~{stratum~}'s root directory listing will be provided by a `ls
/` in the given context.  How this is chosen, like the `ls` example above,
described below.

One last hint towards upcoming content: querying for the ~+Bedrock~x
configuration file ~{stratum~}:

	{class="cmd"} brl which /bedrock/etc/bedrock.conf

prints `global`, which is not a ~{stratum~} name.

## {id="local-file-paths"} Local File Paths

To avoid conflicts, processes from one ~{stratum~} may see their own
~{stratum~}'s instance of a given file (or lack of file) at a given file path.

You can query ~+Bedrock~x for the ~{stratum~} associated with your shell:

	{class="cmd"} brl which

This ~{stratum~} will match queries the root directory example in the previous
section:

	{class="cmd"} brl which /

If your shell ~{stratum~} has a `/etc/os-release` file, it
will probably correspond to your shell ~{stratum~} distro:

	{class="cmd"} cat /etc/os-release

This is needed to avoid conflicts.  For example, ~+Debian~x's `apt` needs to
see ~+Debian~x mirrors at `/etc/apt/sources.list` and ~{Ubuntu~}'s `apt` needs
to see ~+Ubuntu~x's mirrors at the same path.  If they saw the same contents in
`sources.list` these two programs would conflict with each other.

In ~+Bedrock~x terminology, these file paths are described as ~{local~}.

## {id="global-file-paths"} Global File Paths

If all paths were ~{local~}, ~{strata~} would be unable to interact with each
other.  For ~{strata~} to interact, there are also ~{global~} paths: file paths
where every ~{stratum~} sees the same content.  Under-the-hood, these are
`bedrock` ~{stratum~} files which are being shared with other ~{strata~}.

For example, all ~{strata~} see the same contents in `/run` to communicate over
common sockets:

	{class="cmd"} brl which /run

Directories like `/home` and `/tmp` are also ~{global~}.  You can have software
from one ~{stratum~}, like ~+Alpine~x's `jq`, read files created by another
~{stratum~}, like ~+Void~x's `jo`, provided the file is in a ~{global~} location:

- {class="cmd"}
- brl which /tmp
- jo "path=global" > /tmp/tut
- jq ".path" < /tmp/tut

## {id="cross-file-paths"} Cross File Paths

Sometimes processes from one ~{stratum~} need to access ~{local~} files from
another.  This is achieved via ~{cross~} file paths.

If you want to read or write to a ~{local~} file specific to a given ~{stratum~},
prefix `/bedrock/strata/~(stratum~)` to the file path to ~{cross~} to that
~{stratum~}.

A previous example read the ~{local~} `/etc/os-release`, whose output was
dependent on which process read it.  To read specifically `bedrock`'s
`/etc/os-release`, run:

	{class="cmd"} cat /bedrock/strata/bedrock/etc/os-release

Similarly, a `gentoo` ~{stratum~}'s `/etc/os-release` can be read via:

	{class="cmd"} cat /bedrock/strata/gentoo/etc/os-release

## {id="strat-command"} The strat Command

`/bedrock/strata/` is only suitable for reading and writing ~{cross~} files.  To
execute a program from a specific ~{stratum~}, prefix `strat ~(stratum~)`.

For example, if you have both a `debian` ~{stratum~} with an `apt` command and
an `ubuntu` ~{stratum~} with an `apt` command, you could run:

	{class="cmd} strat debian apt

to run `debian`'s and

	{class="cmd} strat ubuntu apt

to run `ubuntu`'s.

If you do not specify the desired ~{stratum~} with `strat`, ~+Bedrock~x will
try to figure one out from context:

- If ~+Bedrock~x is configured to ensure one ~{stratum~} always provides the
given command, it will do so.  For example, init related commands should always
correspond to the ~{stratum~} providing PID 1.  This is called ~{pinning~}.
- If the command is not ~{pinned~} to a given ~{stratum~} but is available
~{locally~}, ~+Bedrock~x will utilize the ~{local~} one.  This is to ensure
distro-specific dependency quirks are met.
- If the command is not ~{pinned~} and not available ~{locally~}, ~+Bedrock~x
assumes the specific build of the command does not matter.  In these cases
~+Bedrock~x will search other ~{strata~} and supply the first instance of the
command it finds.

The first bullet point above is how ~+Bedrock~x ensures the `reboot` comes from
the `init` ~{stratum~} and why these two commands usually provide the same
output:

- {class="cmd"}
- brl which reboot
- brl which 1

The second bullet point above is why the `ls` you get if you do not specify
one with `strat` is probably from the same ~{stratum~} providing your shell and
consequently why these two commands provide the same output:

- {class="cmd"}
- brl which ls
- brl which

Finally, the third rule above is why commands like `apk` and `xbps-install`
work despite being from different ~{strata~}:

- {class="cmd"}
- brl which apk
- brl which xbps-install

## {id="restriction"} Restriction

Occasionally, software may become confused by ~+Bedrock~x's environment.  Most
notably this occurs when build tools scan the environment for dependencies and
find them from different distributions.  To handle this situation, `strat`'s
`-r` flag may be used to ~{restrict~} the command from seeing
~{cross~}-~{stratum~} hooks.

For example, normally ~+Void~x shell can see an ~+Alpine~x ~{stratum~}'s `apk`.
Provided the ~{strata~} are available, this command can be expected to work:

	{class="cmd"} strat void sh -c 'apk --help'

But if you ~{restrict~} it this command will usually fail:

	{class="cmd"} strat -r void sh -c 'apk --help'

~+Bedrock~x will automatically ~{restrict~} some commands that it knows are
related to compiling, such as ~+Arch~x's `makepkg`.  If this is a problem for
any reason, you can un-~{restrict~} with `strat -u`.

In general, if something acts oddly under ~+Bedrock~x, the first thing you
should try is to ~{restrict~} it.  This is especially true when it comes to
compiling software.

## {id="stratum-states"} Stratum states

It is sometimes useful to have a ~{stratum~}'s files on disk without them being
integrated into the rest of the system.  To do this, disable the ~{stratum~}
with the `brl disable` command.  For example:

	{class="rcmd"} brl disable void

This will stop all of the ~{stratum~}'s running processes and block the ability
to launch new ones.  This command will now fail:

	{class="cmd"} strat void xbps-install --help

The ~{stratum~} may be re-enabled:

	{class="rcmd"} brl enable void

after which this command will again work:

	{class="cmd"} strat tut-void xbps-install --help

## {id="updating"} Updating

~{Strata~} are each responsible for updating themselves.  To update an ~+Alpine~x
~{stratum~} we can tell its package manager to update:

	{class="rcmd"} apk update && apk upgrade

and to update a ~+Void~x ~{stratum~} we can similarly instruct its package
manager:

	{class="rcmd"} xbps-install -Syu

~+Bedrock~x's ~{stratum~} can be updated via `brl update`:

	{class="rcmd"} brl update

## {id="removing-strata"} Removing Strata

As a protective measure, ~{strata~} may not be removed while ~{enabled~}.  If you
wish to remove a ~{stratum~}, first ~{disable~} it.

- {class="rcmd"}
- brl disable alpine
- brl remove alpine

If you know the target ~{stratum~} is ~{enabled~}, `brl remove` takes a `-d`
flag to ~{disable~} prior to removing:

- {class="rcmd"}
- brl remove -d void

## {id="special-strata"} Special strata

The ~{stratum~} currently providing PID 1 (the init) may not be ~{disabled~}, as the
Linux kernel does not respond well to PID 1 dying.  If

	{class="cmd"} brl which 1

outputs `void`, this command will fail:

	{class="rcmd"} brl disable void

If you wish to remove the init-providing ~{stratum~}, first reboot and select
another ~{stratum~} to provide your init for the given session.

The `bedrock` ~{stratum~} glues the entire system together.  It is the only
stratum which may not be removed.

There is nothing particularly special about the ~{stratum~} created by
hijacking another Linux install.  You are free to remove it, should you wish to
do so.  Just make sure to install anything essential the ~{stratum~} is
providing, such as a bootloader, kernel, or `sudo`, in another ~{stratum~}.

## {id="manually-adding-strata"} Importing strata

If you would like to make a ~{stratum~} from some distro that `brl fetch` does
not support, you may use the `brl import` command to do so.

Get the desired files in some format such as:

- Directory containing desired files
- Tarball containing desired files
- Virtual Machine image (with one partition) (e.g. .qcow, .vdi, .vmdk)

then run

	{class="rcmd"} brl import ~(name~) ~(/path/to/source~)

## {id="bedrock.conf"} bedrock.conf

All ~+Bedrock~x configuration is placed in a single file,
`/bedrock/etc/bedrock`.conf.  If it seems like something ~+Bedrock~x does should
be configurable, look in there.  After making changes to `bedrock.conf` run
`brl apply` to ensure they take effect.

## {id="brl"} brl

Most operations used to manage ~+Bedrock~x can be found in the `brl` command.
This includes both those discussed earlier on this page as well as some
which were skipped for brevity.

Consider exploring `brl`:

	{class="cmd"} brl --help

going through provided tutorials:

	{class="cmd"} brl tutorial --help

or reading through `/bedrock/etc/bedrock.conf`.
