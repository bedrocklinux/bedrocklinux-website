Title: Bedrock Linux 1.0alpha4 Flopsie
Nav: flopsie.nav

Bedrock Linux 1.0alpha4 Flopsie Plans
=====================================

Research into various options is still required before the exact desired plans
for Flopsie are solidified.  Several options being considered are:

- [Generate the brpath on the fly via a FUSE virtual filesystem](http://bedrocklinux.org/issues/issue-d364e2c09c68fa3d060a315d5353f52d6b827b69.html), removing the need for brp.

- Fix the [/etc issue](http://bedrocklinux.org//issues/issue-ed10277445e2bc796171ca53603f0894f300a5ef.html).  Researching [using a daemon to detect a change and distribute it](http://bedrocklinux.org/issues/issue-a158e55ccf9aa3f6eb8036fb086f83c8cdab0cd9.html) or using FUSE.

- Mandate specific location for all clients.  Downside is less flexibility,
upsides are simpler config and brc.

- Use shared subtrees (ie, `mount --make-shared`) to propagate mounts between
  clients.  For example, make `/mnt/` shared so that if a USB drive is mounted
  at `/mnt/usbflash` in one client, its files are accessible in all clients.

- Several required libraries - most notably libcap - are not available
  *statically* in all major distros (e.g.: Arch, Fedora).  Installation
  instructions should include compiling the libraries to provide static.

- Improve Makefile to automate compiling more software, such as fsck, to ease
  installation.

- Create a system to allow users to prioritize non-native commands over native
  commands.  Currently, if multiple clients provide the same command, each will
  run their own version when.  The user should be able to prioritize one of
  them so that it is always run, irrelevant of whether or not the command is
  available in the client which attempts to run it.

  For example, for the Nvidia proprietary driver to work properly, every client
  which provides commands which require graphics card acceleration requires the
  xorg userland (note: this is not the case for nouveau or other non-proprietary
  drivers).  This means they all provide the `startx` command.  If the user would
  prefer to always use one client's `startx` transparently - without explicitly
  calling `brc` each time -  no clean way to do this is currently provided.

