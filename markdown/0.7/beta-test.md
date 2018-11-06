Title: Bedrock Linux 0.7 Poki Beta Test
Nav: poki.nav

Bedrock Linux 0.7 Poki Beta Test
================================

In depth documentation is unlikely to be available during Poki's pre-release
testing.  However, one of the release's goals is a much improved user
experience such that documentation should be much less necessary than it was in
past releases.  If it met this goal, the currently limited documentation should
not be a major hindrance.

- [Installation instructions](#install)
- [Things to test](#test-targets)
- [Basic usage](#basic-usage)
- [Known issues](#issues)

## {id="install"} Installation instructions

**This is intended for pre-release testing and is not suitable for production systems.  There is a substantial amount of new code with limited testing.  There are likely many still undiscovered bugs.  Only install on test machines for the time being.**

**See known issue list before installing.  Hijacking some distros may be known to be broken at this point in time.**

Poki is currently targeting `x86_64`.  Additional architectures may be added later.

Install a traditional `x86_64` Linux distribution such as Arch, Debian, Fedora,
or Gentoo.  Select a filesystem which supports extended filesystem attributes
(most common ones do).  Set it up as you would normally, including setting up
various users and networking.

Download a pre-built binary of the latest Poki installation script from
[here](https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases) or build your own from [here](https://github.com/bedrocklinux/bedrocklinux-userland/tree/0.7).

Run the script as root with the `--hijack` flag:

    {class="rcmd"} sh bedrock-linux-~(release~)-x86_64.sh --hijack

Reboot.

You should see a new init selection menu during the boot process.  Initially
this will only have one option.  Select it or wait for the timeout.  `brl
fetch`'ing new strata will add more items later.

Once you have logged in, explore the `brl` command and the
`/bedrock/etc/bedrock.conf` configuration file.

## {id="basic-usage"} Basic usage

A Bedrock Linux system is composed of "strata".  These are collections of
interrelated files.  These are often, but not always, one-to-one with other,
traditional Linux distributions.  Bedrock integrates these strata together,
creating a single, largely cohesive system with desirable features from other
distributions.

To list the currently installed (and enabled) strata, run:

	$ brl list

To list distros which can be easily acquired as strata, run:

	$ brl fetch --list

To acquire new strata, run (as root):

	# brl fetch <distros>

Once that has completed, you may run commands from the new strata.  For
example, the following series of commands make sense on a Bedrock system:

	$ sudo brl fetch arch debian
	$ sudo pacman -S mupdf && sudo apt install texlive
	$ man pdflatex
	$ pdflatex preexisting-file.tex && mupdf preexisting-file.pdf

Bedrock's integration is not limited to the command line.  For example,
graphical application menus or launchers will automatically pick up
applications across strata, and Xorg fonts installed from one stratum will be
picked up in an X11 graphical application from another stratum.

If there are multiple instances of an executable, Bedrock will select one by
default in a given context.  If there are hints it can pick up on for which one
to use, it is normally correct.  `brl which` can be used to query which Bedrock
will select in a given context.  For example:

	$ # arch, debian, and centos are installed.
	$ # running debian's init, and thus must use debian's reboot
	$ sudo brl which -b reboot
	debian
	$ # only arch provides pacman, so arch's pacman will be used
	$ brl which -b pacman
	arch
	$ # yum is a python script.  Since yum comes from centos, the python
	$ # interpreter used to run yum will also come from centos.
	$ sudo yum update
	^Z
	$ brl which $(pidof python | cut -d' ' -f1)
	centos

If you would like a specific instance, you may select it with `strat`:

	$ # arch, debian, and ubuntu are installed
	$ # install vlc from arch
	$ sudo pacman -S vlc
	$ # install vlc from debian
	$ sudo strat debian apt install vlc
	$ # install vlc from ubuntu
	$ sudo strat ubuntu apt install vlc
	$ # run default vlc
	$ vlc /path/to/video
	$ # run arch's vlc
	$ strat arch vlc /path/to/movie
	$ # run debian's vlc
	$ strat debian vlc /path/to/video
	$ # run ubuntu's vlc
	$ strat ubuntu vlc /path/to/video

To avoid conflicts, processes from one stratum may see its own stratum's
instance of a given file.  For example, Debian's `apt` and Ubuntu's `apt` must
both see their own instance of `/etc/apt/sources.list`.  Other files must be
shared across strata to ensure they work together, and thus all strata see the
same file.  For example, `/home`.  Such shared files are referee to as
"global".  Which stratum provides a file in a given context can be queried by
`brl which`:

	$ # which stratum is my shell from?
	$ brl which --pid $$
	gentoo
	$ # that query is common enough the PID may be dropped
	$ brl which
	gentoo
	$ # which stratum provides ~/.vimrc
	$ brl which --filepath ~/.vimrc
	global
	$ # global indicates all stratum seem the same file; not specific to any
	$ # stratum.
	$ brl which --filepath /bin/bash
	gentoo
	$ brl which --bin pacman
	arch

If you would like to specify which non-global file to read or write, prefix
`/bedrock/strata/<stratum>/` to its path.

	$ brl which --filepath /bedrock/strata/debian/etc/apt/sources.list
	debian
	$ brl which --filepath /bedrock/strata/ubuntu/etc/apt/sources.list
	ubuntu
	$ # edit debian's sources.list with ubuntu's vi
	$ strat ubuntu vi /bedrock/strata/debian/etc/apt/sources.list

`brl` provides much, much more functionality.  See `brl --help`.


## {id="test-targets"} Things to test

- Explore the `brl` command.  Does its user interface make sense?
- Check for UI inconsistency.  For example, are error messages punctuated in
  some contexts but not others?
- Explore the `/bedrock/etc/bedrock.conf` configuration file.
- Try hijacking various distros.
- Try `brl fetch`'ing various (non-experimental) distros.
- Try using various init systems at the init-selection menu.
- Try running commands from various strata.
- Try bash, fish, and zsh tab completion.  Both completing `brl` *and* completing items from other strata.  For example, see if Debian's `zsh` will tab-complete Void's `xbps-install` flags.
- Try man pages across strata.
- Try info pages across strata.
- Try fonts across strata.
- Try themes across strata.
- Try using an application menu to launch applications from other strata.
- Keep an eye out for an update and `brl update` to it.
- Experiment with the init selection menu.  Do its actions make sense if you enter a blank line?  Or if it times out with a number entered?

## {id="issues"} Known issues

Here is a list of known issues and other to-do items.  Given the current beta testing phase, there are likely more issues to be discovered.

- There are reports that hijacking a Void install did not work.
	- Early guess is that it failed due to `/sbin/` being a symlink and so it may fail on other distros with similar `/sbin/` symlinks.
- Auto-detecting distro via `os-release` fails in non-trivial cases.
	- This should be easy to fix, as `os-release` was explicitly intended to be parsed by shell scripts such as the installer.
- If the hijacked system is using GRUB, the hijack process should update the GRUB menu item to indicate it is now Bedrock.
- Login shells set to a local path will not work with login prompts from strata which do not provide the shell locally.  Have some automation update login shells to use `/bedrock/cross/` paths to avoid potential problems here.
- Arch's `zsh` does not pick up Bedrock completion.
- Execute-only cross-bin items do not work.  For example, void's `sudo`.
	- Naively, there would be no problem having the bouncer ignore the non-readable status of its underlying file and be readable.  However, some thought should be applied here before executing such a change.
- cross-fonts can break.  For example, `xbps-install font-hack-ttf` results in problems with `/bedrock/cross/fonts/TTF/fonts.dir`.
- Add a feature to set the desired init on the kernel command line.  This would bypass the init-selection menu.
- Consider taking control of the motd to print a Bedrock specific message.
- Determine and document build requirements.
