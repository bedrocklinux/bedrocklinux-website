Title: Bedrock Linux 1.0beta3 Poki Plans
Nav: poki.nav

Bedrock Linux 1.0beta3 Poki Plans
=================================

This page serves to describe plans for the upcoming release of Bedrock Linux
1.0beta3 Poki.

## {id="brg"} brg: a utility to automate bootstrapping base files for various distros

Typical Bedrock Linux installations acquire most of their software through the
package managers provided by other distributions.  If one would like some
package (e.g. vim) from some distribution (e.g. Debian), this is acquired
through the distribution's package manager (e.g. `apt-get install vim`).
However, this results in a bootstrapping problem: how does one get the package
manager on the system?  As of Nyla, this is done by manually following
distribution-specific instructions.  With Poki, the hope is to automate this
process with a new utility called `brg`.

`brg` aims to automate various tasks related to acquiring a new stratum:

- listing available releases of the distro (if applicable)
- listing available mirrors for a given release of a given distro
- listing available architectures for a given release of a given distro
- automate acquiring the distro's base files
- automate applying Bedrock Linux-specific tweaks which may be necessary
- automate setting up Bedrock Linux-specific configuration for the stratum

When attempting to utilize `brg` to acquire a new stratum details such as the
desired mirror or architecture may be left out, in which case `brg` will either
default to something (e.g. for a mirror) or determine what should be done based
on context (e.g. for the architecture).  Ideally, a single command could be
used to automate the entire process of acquiring and setting up new stratum.
For example, something like:

- {class="rcmd"}
- brg get --distro debian --release jessie

will automatically download Debian Jessie from a default mirror with the
Bedrock Linux system's native architecture, configure it as a stratum including
coming up with a name, and apply any tweaks necessary to ensure it interacts
properly with the rest of the Bedrock Linux system.

### {id="brg-strategies"} Acquisition strategies

Some distros provide a tarball or image of a filesystem which can be downloaded
and used directly.  For example, Gentoo provides "stage 3" tarballs which are
ideal for this scenario.  Where applicable this system is preferred due to its
relative simplicity.

Many Linux distributions provide some means to bootstrap themselves.  Often
this can be done with the distro's native package manager, such as via `yum` ,
or with specialized tools such as `pacstrap`.  Sometimes these tools are nicely
portable; for example as `xbps` is provided in a very portable
statically-linked version.  Where available, a portable version of the tool
will be automatically acquired and used to bootstrap the rest of the system.

Sadly these tools sometimes require non-trivial dependencies which, while
available on the target distribution, may not be available elsewhere.  This
results in a catch-22: to bootstrap Debian one would use `debootstrap`, but to
acquire `debootstrap` one would require Debian.  The plan to resolve this is a
sort of double-bootstrapping, where the bootstrapping tool is itself
bootstrapped via more portable code.

Some distros provide disk images intended to be burned to a disk and booted
from as part of the distro's installation process.  These disks often contain a
local repository of packages which can be used to bootstrap the system.

### {id="brg-naming-scheme"} Automatic naming scheme

While users are free to name stratum themselves, an automated system can be
used to determine a default name:

- If the distro being acquired is a rolling-release distro, a short version of
  that distro's name will be used.  For example, an Arch Linux stratum will
  default to "arch".
- If the distro being acquired has release code names, those shall be used.
  For example, Debian 8.x is code named "Jessie", and thus "jessie" will be
  used.
- If the distro being acquired is not a rolling release and lacks per-release
  code names, a short version of the name followed by the major release version
  will be used.  For example, CentOS's 7th release would result in "centos7".
- If there appears to be a name conflict with an existing stratum the process
  to automate naming will be aborted; the user will have to determine a name in
  this situation.

## {id="brh"} brh: a utility to automate hijack automation

As of Nyla, Bedrock Linux has two broad installation methods:

- Hijacking the install of another distro, thereby leveraging other distros'
  tools and techniques for partitioning, setting up full disk encryption, a
  bootloader, users, etc
- Manually partitioning, adding users, etc

If users want a "hands on" install process they are welcome to either utilize
the manual installation method or hijack another distro which uses a "hands on"
installation process.  As of Nyla, while there is room for improvement, the
general process is largely acceptable here.

If users want an easy/automated install, the expectation is to hijack another
distro which has an easy/automated installation process.  However, this then
requires the hijack process also be easy/automated.  As of Nyla, it is not.
Poki hopes to remedy this with a new utility: `brh`.

`brh` will be a portable shell script which has the other Bedrock Linux files
embedded within it.  It will contain all of the files necessary to hijack a
given major distro install into a Bedrock Linux one (sans standard utilities
such as a bourne shell, `tar`, `grep`, `sed`, etc).  Neither a compiler nor
internet access will be strictly required (although may be beneficial).

`brh` will be able to run in one of three modes:

- One in which it will interactively prompt the user for the information needed
  during the hijack process.  For example, the installer will prompt for
  whether or not ~{global~} should be its own stratum or shared with another
  one.
- One in which the it attempts to auto-detect or default to some value for
  all of the information it requires.  This will allow for a fully automated
  process with minimal expectations on the user, ideal for people who want to
  jump into Bedrock Linux quickly.
- One in which a configuration file is provided to the script which should
  cover the information needed during the hijack process.  This will allow for
  a fully automated process without giving up any control.

There may be some areas where the initial version of `brh` released with Poki
may be limited.  For example, it may only initially support fully automating
the hijack of GRUB2 systems.  It will attempt to automatically detect such
situations that it does not support early on to ensure the user does not end up
with a broken or partially-hijacked system.  If possible, it may allow the user
to manually do the steps it cannot while automating the rest.

### {id="brh-native-packages"} Native packages

In addition the portable `brh` script, the Bedrock Linux build system may also
create packages for various popular package managers.  For example, it may
create `.deb` or `.rpm` packages.  These packages, when installed, will
automate hijacking the distribution.  It will effectively be the same as
`brh`'s auto-detect/default mode.  Thus, a user may be able to install Debian
then do:

- {class="rcmd"}
- dpkg -i bedrock_linux_1.0beta3_hijack.deb && reboot

and find him/herself with a Bedrock Linux system.

Efforts may be made to distribute such packages through third party repository
services such as Ubuntu's PPA or Arch's AUR.
