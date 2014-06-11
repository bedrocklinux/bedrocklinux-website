Title: Bedrock Linux 1.0beta1 Hawkey Plans
Nav: hawkey.nav

# Bedrock Linux 1.0beta1 Hawkey Plans

This page serves to describe plans for the then-upcoming release of Bedrock Linux,
1.0beta4 "Hawkey". Hawkey is scheduled to be released July 1st, 2014.

## New fuse-based brp

Bedrock Linux's brp command populates the `/bedrock/brpath` directory.  The
contents in this directory are used to make a certain class of files "just
work" in a transparent manner.  Specifically, these are files which:

- Cannot be global, or package managers would fight over them.
- Cannot be local, as they need to be available globally for everything to
  "just work".
- May need some modification to work across local contexts.  For example,
  executables should be wrapped in `brc` so they run with the proper local
  context.

These files include:

- executables (such as are found in directories like `/usr/bin`)
- man pages
- info pages
- .desktop files (such as are found in directories like `/usr/share/applications/`)

In 1.0alpha4 Flopsie, of the above listed files, only executables are supported
by brp.  Moreover, that version of brp must be re-run to update
`/bedrock/brpath` every time something changes.  The planned improvements to
brp are:

- The contents of `/bedrock/brpath` will be updated on-the-fly /
  in-the-background so that when they are accessed they are always up-to-date.
- The new brp is designed in a partially file-type-agnostic manner, so that it
  works for not only executables, but also man pages, info pages, .desktop
  files, and possibly other types of files for which the user could easily add
  support.

## Global post-client set up mount points

In 1.0alpha4 Flopsie, if something is mounted *after* a client is set up, that
mount point is automatically "local".  Only processes from the same client that
provided the mount command can access it.  In 1.0beta1 Hawkey, we are adding a
new client.conf configuration item - "share" - which will function exactly the
same way "bind" does in 1.0alpha4 Flopsie, except mount points contained within
the configured item's directory are also global.

For example, the 1.0beta1 Hawkey will likely contain this configuration item in
the default framework:

    share = /mnt

With this, if a user mounts something within `/mnt`, such as a usb stick or
compact disk, the contents of that mount point will be visible to all clients
(which use the default framework).

## Client enable/disable hooks

1.0beta1 Hawkey will include hooks to run something at the following times:

- Just before a client is enabled
- Just after a client is enabled
- Just before a client is disabled
- Just after a client is disabled

These hooks may be used by the end-user however he or she wishes.  However,
Bedrock Linux has specific uses for them in mind.

Symlinks are used by Linux distributions to move where files and directories
are placed while retaining support for software which still uses the old
location.  For example, many Linux distributions have moved `/var/run` to
`/run` by making `/var/run` a symlink to `/run`.  If any old software accesses
the old location they are redirected to the new location.  Any new software
which simply uses the new location will just work.

This causes a problem for Bedrock Linux.  Bind-mounting both the source and
destination of a symlink can cause issues.  To make the content in `/var/run`
and/or `/run` global, only one of the two directories should be made global
depending on which the given client uses.  While the user could configure this,
it would be preferable for these things to "just work".  These hooks will be
used in 1.0beta1 Hawkey to force a symlink standard across clients:

- `/var/run` will be a symlink to `/run`
- `/var/lib/dbus/machine-id` will be a symlink to `/etc/machine-id`

By doing this, Bedrock Linux will be able to make `/run` and `/etc/machine-id`
global, ensuring things such as dbus and udev work across clients.  This change
will be enforced utilizing the just-before-a-client-is-enabled hook.

Another potential use for this is to synchronize certain global files with the
client local version upon enabling or disabling a client.  Interest has been
shown in dual-booting Bedrock Linux with another distro *and* using that distro
as a Bedrock Linux client.  For this to work, certain files - such as
`/etc/passwd` and `/etc/group` - must be synchronized upon client enable and
disable.  The code to merge such files is not yet in place and so this dual
booting with a client functionality will not be available in Hawkey, but the
hooks created in Hawkey will be useful later in providing this functionality.
