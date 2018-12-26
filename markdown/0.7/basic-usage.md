Title: Bedrock Linux 0.7 Poki Basic Usage
Nav: poki.nav

Bedrock Linux 0.7 Poki Basic Usage
==================================

A Bedrock Linux system is composed of ~{strata~}, which are collections of
interrelated files.  These are often one-to-one with traditional Linux
distribution installs: one may have an Arch ~{stratum~}, a Debian ~{stratum~}, a Gentoo
stratum, etc.  Bedrock integrates these ~{strata~} together creating a single,
largely cohesive system.

To list the currently installed (and enabled) ~{strata,~} run:

	{class="cmd"} brl list

A fresh install will have two ~{strata:~} Bedrock itself and the initial install.
This, alone, is of little more immediate value than just the initial install.
To benefit from Bedrock more ~{strata~} are needed.  To list distros Bedrock knows
how to acquire as ~{strata~}, run:

	{class="cmd"} brl fetch --list

Then to acquire new ~{strata~}, run (as root):

	{class="rcmd"} brl fetch ~(distros~)

Once that has completed you may run commands from the new ~{strata.~}  For
example, the following series of commands make sense on a Bedrock system:

- {class="cmd"}
- sudo brl fetch arch debian
- sudo pacman -S mupdf && sudo apt install texlive
- pdflatex file.tex && mupdf file.pdf

Bedrock's integration is not limited to the command line commands.  Other
features which work across ~{strata~} include:

- Graphical application menus or launchers will automatically pick up
  applications across ~{strata.~}  For example, Ubuntu's Unity will offer launching
  Gentoo's `vlc`.
- Shell tab completion.  For example, Gentoo's `zsh` will tab complete Arch's
  `pacman`.
- The Linux kernel will detect firmware across ~{strata~}.
- Xorg fonts work across ~{strata~}.  For example, Arch's `firefox` will detect
  Gentoo's terminus font.
- Various graphical theming information work across ~{strata~}.
- Man and info pages work across ~{strata~}.  For example, Arch's `man` will
  display Void's `xbps-install` man page.

If there are multiple instances of an executable Bedrock will select one by
default in a given context.  If there are hints it can pick up on for which one
to use, it is *typically* correct.  `brl which` can be used to query which
Bedrock will select in a given context.

Some examples:

- {class="cmd"}
- brl which reboot # void
- brl which pacman # arch
- sudo yum update & brl which $(pidof python | cut -d' ' -f1) # fedora

If you would like a specific instance, you may specify it with `strat`:

- {class="cmd"}
- sudo brl fetch arch debian ubuntu
- # only one pacman, and so this is unambiguous
- sudo pacman -S vlc
- # multiple apt's - bedrock will pick one by default
- sudo apt vlc
- # specify debian's apt is desired
- sudo strat debian apt install vlc
- # specify debian's apt is desired
- sudo strat ubuntu apt install vlc
- # multiple vlc's - bedrock will pick one by default
- vlc /path/to/video
- # specify arch's vlc
- strat arch vlc /path/to/movie
- # specify debian's vlc
- strat debian vlc /path/to/video
- # specify ubuntu's vlc
- strat ubuntu vlc /path/to/video

To avoid conflicts, processes from one ~{stratum~} may see its own ~{stratum~}'s
instance of a given file.  For example, Debian's `apt` and Ubuntu's `apt` must
both see their own instance of `/etc/apt/sources.list`.  Other files must be
shared across ~{strata~} to ensure they work together, and thus all ~{strata~} see the
same file.  For example, `/home` must be shared.  Such shared files are referred
to as ~{global~}, in contrast to ~{stratum~}-~{local~} files.  Which ~{stratum~} provides a
file in a given context can be queried by `brl which`:

- {class="cmd"}
- # which stratum is my shell from?
- brl which $$ # gentoo
- # that query is common enough the PID may be dropped
- brl which # gentoo
- # which stratum provides ~/.vimrc?
- brl which ~/.vimrc # global
- # which stratum provides /etc/lsb-release?
- brl which /etc/lsb-release # gentoo

If you would like to specify which non-~{global~} file to read or write, prefix
`/bedrock/strata/~(stratum~)/` to its path.

- {class="cmd"}
- brl which /etc/lsb-release # gentoo
- brl which /bedrock/strata/debian/etc/apt/sources.list # debian
- brl which /bedrock/strata/ubuntu/etc/apt/sources.list # ubuntu
- # edit debian's sources.list with ubuntu's vi
- sudo strat ubuntu vi /bedrock/strata/debian/etc/apt/sources.list

This is enough information for most users to begin exploring and experimenting with Bedrock Linux.  However, if you would like to learn Bedrock more deeply, consider continuing to [concept and terminology overview](concepts-and-terminology.html) which expands on the details described here.
