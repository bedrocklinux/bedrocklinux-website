Title: Bedrock Linux 1.0beta2 Nyla Known Issues
Nav: nyla.nav

Bedrock Linux 1.0beta2 Nyla Known Issues
========================================

This page lists major known issues with the release at the time it was
released; more up-to-date information may be found at [the issue
tracker](https://github.com/bedrocklinux/bedrocklinux-userland/issues?state=open)

- [Only init stratum's init hooks work](#init)
- [No such file on umount](#no-such-file-on-umount)
- [brpath can't self-reference](#recursive-brp)
- [bru may not respect ACLs, supplementary groups](#bru-acls-groups)
- [Limited support for encrypted /home](#encrypted-home)
- [One cannot use a stratum as a stand-alone system](#stand-alone)
- [Manual work is required to manage time, firmware](#manual-handling-time-firmware)
- [Cannot boot with a read-only filesystem](#cannot-read-only-boot)
- [Some users cannot use keyboard in init-choosing menu](#no-keyboard)

## {id="init"} Only init stratum's init hooks work

On typical Linux distributions, upon installing a package which may start a
daemon at boot, the package will leave instructions for the init system
regarding how the daemon should be started.  Currently these hooks only
automatically trigger for the ~{stratum~} which is currently providing init.
If you would like, for example, CUPS to start at boot, the easiest solution is
to install it from the ~{init~} ~{statum~}.

It is very possible to manually add new init hooks which work across
~{stratum~}.  Be sure to use `brc` as appropriate.  See the documentation for
both the given init system in use (and/or the corresponding distro) as well as
the documentation for the software you would like to run at boot.

All major init systems run `/etc/rc.local` at boot time, and `/etc/rc.local` is
configured to be ~{global~}.  Thus relatively simple boot-time operations can
be written to that file which should then work irrelevant of which init from
which distro is being used.

## {id="no-such-file-on-umount"} No such file on umount

When shutting down a system, many init systems may report that they are unable
to mount a given item because it does not exist.  This error message is
harmless but annoying.  Bedrock Linux utilizes a Linux feature called "shared
subtrees" which propagates mount and unmount actions.  When the init system
unmounts a given mount point, other mount points are automatically unmounted as
well.  When the init system goes to unmount those mount points, it is surprised
to find they're already unmounted.

## {id="recursive-brp"} brpath can't self-reference

Bedrock Linux's implicit filepath access, via `/bedrock/brpath`, provides an
alternative view of the filesystem.  However, due to a technical implementation
limitation it locks up when attempting to show an alternative view of itself.
Do not configure `brp` to use any path which leads back to `/bedrock/brpath`.

## {id="bru-acls-groups"} bru may not respect ACLs, supplementary groups

The `bru` mount point only checks access via a processes' UID and GID; it
currently does not fully support more sophisticated access mechanisms such as
ACLs and supplementary groups.

## {id="encrypted-home"} Limited support for encrypted /home

Some distros provide an option to encrypt `/home` on installation, which is
then automatically decrypted on login.  This is not yet supported by Bedrock
Linux.

## {id="stand-alone"} Cannot use a stratum as a stand-alone system

If one reboots into a ~{stratum~} as its own stand-alone system, global files -
especially `/etc/passwd`, `/etc/group` and `/etc/shadow` - may not be properly
in place.  Things such as UIDs and GIDs may be out-of-sync from what may be on
the rest of the filesystem.  There are plans to have Bedrock Linux merge
certain `/etc` files when enabling/disabling a ~{stratum~} to remedy this, but
these plans have not yet been implemented.

## {id="manual-handling-time-firmware"} Manual work is required to manage time, firmware

While most regular maintenance for distros, such as adding and removing
packages, should "just work" for Bedrock Linux, there are still some exceptions
which require additional manual efforts, such as time and firmware handling.
It's quite possible to make full use of these features, but doing so requires
manual work.

## {id="cannot-read-only-boot"} Cannot boot with a read-only filesystem

Some distros set up the bootloader/initrd to initially mount the filesystem as
read-only.  Then, later, the init system remounts it to read-write.

Bedrock Linux 1.0beta2 Nyla does not currently support such a setup.  Instead,
the bootloader's kernel line should use "rw" to indicate that the filesystem
should be mounted as read-write.  Most init systems should be flexible enough
to handle such a setup situation; so far testing as not found any major issues
with it.  Nonetheless this constraint should be removed.

## {id="no-keyboard"} Some users cannot use keyboard in init-choosing menu

Some users have reported that they are unable to utilize the keyboard in the
init selection menu.  No one on the development team has been able to reproduce
this, making it difficult to debug.  If you run into this and have the
time/capability/interest in helping debug, please bring it up in the IRC
channel.
