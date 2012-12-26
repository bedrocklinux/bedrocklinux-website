Title: Bedrock Linux 1.0alpha4 Flopsie
Nav: flopsie.nav

Bedrock Linux 1.0alpha4 Flopsie Plans
=====================================

There are two goals for Flopsie:

1. Fix the [/etc issue](http://bedrocklinux.org//issues/issue-ed10277445e2bc796171ca53603f0894f300a5ef.html).

2. Create a system to allow users to prioritize non-native commands over native
commands.  Currently, if multiple clients provide the same command, each will
run their own version when.  The user should be able to prioritize one of them
so that it is always run, irrelevant of whether or not the command is available
in the client which attempts to run it.

For example, for the Nvidia proprietary driver to work properly, every client
which provides commands which require graphics card acceleration requires the
xorg userland (note: this is not the case for nouveau or other non-proprietary
drivers).  This means they all provide the `startx` command.  If the user would
prefer to always use one client's `startx` transparently - without explicitly
calling `brc` each time -  no clean way to do this is currently provided.
