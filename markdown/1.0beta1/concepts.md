Title: Bedrock Linux 1.0beta1 Hawky Concepts
Nav: hawky.nav

Bedrock Linux 1.0beta1 Hawky Concepts
=====================================

Below is an explanation of the key concepts, theory, and terminology behind
Bedrock Linux 1.0beta1 Hawky.

- [Bedrock Linux Concepts, Theory, and Terminology](#concepts)
	- [Clients](#clients)
	- [Local and Global files](#local-and-global)
	- [Direct, Implicit and Explicit file eaccess](#direct-implicit-explicit)

## {id="concepts"} Bedrock Linux Concepts, Theory, and Terminology

### {id="clients"} Clients

Most Linux distributions have *packages* which contain the software the distros
provide.  There are also *meta-packages* which do not contain anything
themselves but rather refer to other packages to group or redirect packages
conceptually.  Packages are typically collected and made available through
*repositories*.  Moreover, distributions typically provide *package managers*:
tools to automate installation, removal, acquisition and other details of
managing packages

A Bedrock Linux ~{client~} is a collection of the above concepts.  The defining
feature of a ~{client~} is that all of the software in the ~{client~} is
intended to work together.  A ~{client~}'s package manager can manage the
particular type of package format used by the packages in the ~{client~}.  Any
dependencies in any given ~{client~} should be met by other packages in the
same ~{client~}.  The repositories should provide packages which make the same
assumptions about the filesystem as other packages; most of the packages which
depend on a standard C library will likely depend on the same exact one.

A typical Bedrock Linux system will have multiple ~{clients~}, usually from
different distributions.  However, one is certainly welcome to have multiple
~{clients~} from different releases of the same distribution, or even multiple
clients corresponding to the exact same release of the exact same distribution.

Bedrock Linux, itself, is very small.  It is intended to only provide enough
software to bootstrap and manage the software provided by the ~{clients~}.

### {id="local-and-global"} Local and Global files

The fundamental problem with running software intended for different
distributions is that the software may make mutually exclusive assumptions
about the filesystem.  For example, two programs may both expect different,
incompatible versions of a library at the same exact file path.  Or two
programs may expect `/bin/sh` to be implemented by different *other* programs.
One could have, for example, a `#!/bin/sh` script that uses bash-isms.  If
`/bin/sh` is provided by `/bin/bash`, this will work fine, but if it is
provided by another program it may not.

Bedrock Linux's solution is to have multiple instances of any of the files
which could cause such conflicts.  Such files are referred to as ~{local~} files.
Which version of any given ~{local~} file is being accessed is differentiated by
~{client~}.  In contrast, files which do not result in such conflicts are ~{global~}
files.  A Bedrock Linux system will only have one instance of any given ~{global~}
file.

By default, all files are ~{local~}.  This way if some ~{client~} distribution is doing
something unusual with its file system it will not confuse other ~{clients~}.  What
files should be ~{global~} - which tends to be the same across most Linux
distributions - are listed in configuration files.  This way Bedrock Linux can
provide a sane set of default configuration files which *typically* just work,
even against ~{client~} distributions against which they were not explicitly
designed.

### {id="direct-implicit-explicit"} Direct, Implicit and Explicit file access

One potential problem with having multiple copies of any given ~{local~} file is
determining which should be accessed when, and how to specify and configure
this.  Bedrock Linux provides three separate methods of accessing ~{local~} files.

The first method is ~{direct~}.  When any given process tries to read a ~{local~}
file at its typical location it will get the same version of the file it would
have gotten had it done so on its own distribution.  For example, if a process
provided by a Fedora ~{client~} tries to access a library, it will see that Fedora
release's version of the libary.  If another process from OpenSUSE runs a
`#!/bin/sh` script, it will be run by the same `/bin/sh` that comes with its
release of OpenSUSE.  The primary reason for ~{direct~} file access is to ensure
dependencies are resolved correctly at runtime.

If a file is not available ~{directly~}, it will be accessed ~{implicitly~}.
In an ~{implicit~} file access, if any one ~{client~} provides a given file,
that version of the file will be returned.  If multiple ~{clients~} can provide
a file, they are ordered by a certain configured priority and the highest
priority ~{client~} which can provide a given file will.  For example, if a
process from Arch Linux tries to run `firefox`, but the Arch ~{client~} does
not have firefox installed, but a Gentoo ~{client~} *does* have firefox
installed, the Gentoo ~{client~}'s firefox will run.  If the `man` executable
from Mint looks for the man page for `yum`, it probably won't see it
~{directly~} because Mint typically does not use the `yum` package manager.
However, if a Fedora ~{client~} is installed, Mint's `man` can ~{implicitly~}
read Fedora's `yum` man page.  This ~{implicit~} file access is largely
automatic.  The primary reason for ~{implicit~} file access is to have things
"just work" across ~{clients~}.

Finally, if a user would like to ~{explicitly~} specify which version of a ~{local~}
file to access, this can be done through the ~{explicit~} file access.  For
example, if multiple ~{clients~} can provide the vlc media player, an end user can
specify exactly which one to use.

Between these three file access types, most things just work as one would
expect despite the fact that they are not intended to work together.

~{Directly~} accessing a file is done as one would typically do so.  It is
necessary for this to be the typical method for dependencies to be
automatically met by software intended for other distributions.

~{Implicitly~} accessing files is done through the filesystem mounted at
`/bedrock/brpath`.  This provides a (read-only) view of the files available in
*all* ~{clients~}.  If any ~{client~} provides a file, it can be made
accessible here.  By adding `/bedrock/brpath` *at the end* of various
`$PATH`-style variables, programs will automatically search for their own
~{local~} files first and, if it does not find anything, attempt to use files
provided by other ~{clients~}.  Bedrock Linux sets up these `$PATH` variables
automatically so that no manual work or thought is necessary to access anything
~{implicitly~} - it "just works" as one would have expected if the software was
packaged for the distribution.

~{Explicitly~} accessing a file is done by accessing the file through a path
at:

`/bedrock/clients/~(client-name~)/~(path/to/file~)`

Where ~(client-name~) is the name of the ~{client~} and ~{path/to/file~} is the
path to the desired file.  To ~{explicitly~} specify which ~{client~}'s
executable one would want, use `brc`:

`brc ~(client-name~) ~(command~) ~(arguments~)`.

For example, to use the `vim` text editor from the Arch ~{client~} to modify
the gentoo ~(client~)'s (~{local~}) `/etc/issue` file, one could use:

`brc arch vim /bedrock/clients/gentoo/etc/issue`
