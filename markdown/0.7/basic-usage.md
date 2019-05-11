Title: Bedrock Linux 0.7 Poki Basic Usage
Nav: poki.nav

Bedrock Linux 0.7 Poki Basic Usage
==================================

This is the minimum Bedrock Linux-specific background required to manage a
Bedrock Linux system.

## {id="strata"} Strata

A Bedrock Linux system is composed of ~{strata~}, which are collections of
interrelated files.  These are often one-to-one with traditional Linux
distribution installs: one may have an Arch ~{stratum~}, a Debian ~{stratum~}, a Gentoo
~{stratum~}, etc.  Bedrock integrates these ~{strata~} together creating a single,
largely cohesive system.

To list the currently installed (and enabled) ~{strata~}, run:

	{class="cmd"} brl list

A fresh install will have two ~{strata~}: Bedrock itself and the initial install.
This, alone, is of little more immediate value than just the initial install.
To benefit from Bedrock more ~{strata~} are needed.  To list distros Bedrock knows
how to acquire as ~{strata~}, run:

	{class="cmd"} brl fetch --list

Then to acquire new ~{strata~}, run (as root):

	{class="rcmd"} brl fetch ~(distros~)

This may fail if it auto-detects a bad mirror.  If so, manually find a good
mirror for the distro and provide it to `brl fetch` with the `--mirror` flag.

You may remove strata with

	{class="rcmd"} brl remove ~(strata~)

## {id="cross-stratum-features"} Cross-stratum features

Once `brl fetch` has completed you may run commands from the new ~{strata~}.  For
example, the following series of commands make sense on a Bedrock system:

- {class="cmd"}
- sudo brl fetch arch debian
- sudo pacman -S mupdf && sudo apt install texlive
- pdflatex file.tex && mupdf file.pdf

Bedrock's integration is not limited to the command line commands.  Other
features which work across ~{strata~} include:

- Graphical application menus or launchers will automatically pick up
  applications across ~{strata.~}  For example, OpenSUSE's KDE will offer
  launching Gentoo's `vlc`.
- Shell tab completion.  For example, Gentoo's `zsh` will tab complete Arch's
  `pacman`.
- The Linux kernel will detect firmware across ~{strata~}.
- Xorg fonts work across ~{strata~}.  For example, Arch's `firefox` will detect
  Gentoo's terminus font.
- Various graphical theming information work across ~{strata~}.
- Man and info pages work across ~{strata~}.  For example, Arch's `man` will
  display Void's `xbps-install` man page.

## {id="strat-command"} The strat command

If multiple ~{strata~} provide an executable Bedrock will select one by default in
a given context.  If there are hints it can pick up on for which one to use, it
is *typically* correct.  `brl which` can be used to query which ~{stratum~}'s
executable Bedrock will select in a given context.

Some examples:

- {class="cmd"}
- brl which reboot # void
- brl which pacman # arch
- brl which ls # debian

If you would like a specific instance, you may specify it with the `strat` command:

- {class="cmd"}
- sudo brl fetch arch debian ubuntu
- # only one pacman, and so this is unambiguous
- sudo pacman -S vlc
- # multiple apt's - bedrock will pick one by default
- sudo apt install vlc
- # specify debian's apt is desired
- sudo strat debian apt install vlc
- # specify ubuntu's apt is desired
- sudo strat ubuntu apt install vlc
- # multiple vlc's - bedrock will pick one by default
- vlc /path/to/video
- # specify arch's vlc
- strat arch vlc /path/to/movie
- # specify debian's vlc
- strat debian vlc /path/to/video
- # specify ubuntu's vlc
- strat ubuntu vlc /path/to/video

## {id="file-path-types"} Local, global, and cross file paths

To avoid conflicts, processes from one ~{stratum~} may see its own
~{stratum~}'s instance of a given file.  For example, Debian's `apt` and
Ubuntu's `apt` must both see their own instance of `/etc/apt/sources.list`.
Such file paths are referred to as ~{local~} paths.

Other files must be shared across ~{strata~} to ensure they work together, and
thus all ~{strata~} see the same file.  For example, `/home` must be shared.
Such shared files are referred to as ~{global~}.

Which ~{stratum~} provides a file in a given context can be queried by `brl which`:

- {class="cmd"}
- # which stratum provides ~/.vimrc?
- brl which ~/.vimrc # global
- # which stratum provides /etc/lsb-release?
- brl which /etc/lsb-release # local to gentoo

Finally, ~{cross~} paths are used to allow processes from one ~{stratum~} to
see ~{local~} files from another.  These are available through the
`/bedrock/strata` and `/bedrock/cross` directories.

If you would like to specify which ~{stratum~}'s ~{local~} file to read or write, prefix
`/bedrock/strata/~(stratum~)/` to its path.

- {class="cmd"}
- brl which /etc/lsb-release # local to gentoo
- brl which /bedrock/strata/debian/etc/apt/sources.list # cross to debian
- brl which /bedrock/strata/ubuntu/etc/apt/sources.list # cross to ubuntu
- # edit debian's sources.list with ubuntu's vi
- sudo strat ubuntu vi /bedrock/strata/debian/etc/apt/sources.list

## {id="restriction"} Restriction

Occasionally, software may become confused by Bedrock's environment.   Most
notably this occurs with compilation and build tools when scanning the
environment for dependencies and finding them from different distributions.
For these situations, `strat`'s `-r` flag should be used to ~{restrict~} the
command to the given ~{stratum~}.  For example:

- {class="cmd"}
- # restrict build system to Debian
- strat -r debian ./configure && strat -r debian make

In general, if software is not acting as expected, try ~{restricting~} it with
`strat -r`.

This occurs sufficiently often with Arch's `makepkg` that Bedrock is configured
to run `makepkg` through `strat -r` automatically under-the-hood.  To bypass
this, call it with `strat` with the `-u` flag.

- {class="cmd"}
- # unrestrict makepkg
- strat -u arch makepkg

When ~{restricted~}, build tools may then complain about missing dependencies, even if they're provided by other strata.  If so, install the dependencies in the build tool's stratum, just as one would do on the native distro.

This is enough information for most users to begin exploring and experimenting with Bedrock Linux.  Consider running `brl --help` to being your exploration.  If you would like to configure anything, such as the init selection menu timeout, read through `/bedrock/etc/bedrock.conf`.

If you would like to learn Bedrock more deeply, consider continuing to [concept and terminology overview](concepts-and-terminology.html) which expands on the details described here.  If you run into issues, read through [debugging](debugging.html), [known issues](known-issues.html), and [compatibilty and work arounds](compatibility-and-workarounds.html).
