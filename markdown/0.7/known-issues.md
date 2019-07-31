Title: Bedrock Linux 0.7 Poki Known Issues
Nav: poki.nav

Bedrock Linux 0.7 Poki Known Issues
===================================

Issues listed here are supplemental to [issues listed in the compatibility section](compatibility-and-workarounds.html).

## {id="init-menu-no-keyboard"} With some hardware or initrds, keyboard input is not recognized in init selection menu

Some users have reported their keyboard inputs are not recognized during Bedrock's init selection menu.

By default, Bedrock will wait 30 seconds for input at the init selection menu.  Once that expires, it will automatically continue with the default choice.  If you run into this issue, simply wait out the default.  Going forward, consider shortening the timeout in `/bedrock/etc/bedrock.conf`.  You can use another init in another session either by changing the default in `bedrock.conf` or by placing `bedrock_init=<stratum>:<init-path>` on the kernel line in your boot loader.

If you run into this, please contact paradigm indicating which distro provided your kernel, initrd, and any pertinent hardware details.

## {id="proxy"} brl-update and brl-fetch fail with proxy

Some users have reported issues with `brl update` and `brl fetch` failing when behind a proxy.

This issue appears to be specific https URLs.  It may be possible to work around `brl update` failing by manually downloading the update and running it with the `--update` flag, and it may be possible to work around `brl fetch` failing by specifying an http (non-https) mirror.

## {id="lvm"} lvm mount failures

Some users have reported issues with lvm partitions, most notably `/home`, not mounting.

Typical init systems do not mount `/etc/fstab` values corresponding to ~{global~} directories such as `/home`, and thus Bedrock is required to do so itself.  However, Bedrock does not currently know how to populate `/dev/mapper` files required for lvm.

The next release will include full LVM support.

## {id="x11-repeated"} /bedrock/cross/bin/X11/

The `/bedrock/cross/bin/X11` directory recursively contains many `X11` directories.

This is because many distros contain a symlink at `/usr/bin/X11` which points to `.` which `/bedrock/cross/bin` tries to expand.

A possible fix for this would be for `cross-bin` to ignore directories.

## {id="fuse-sigterm"} etcfs and crossfs sigterm handling

Bedrock Linux has two FUSE filesystems, etcfs and crossfs.  Ideally, both should unmount themselves on SIGTERM, such as when the system is shutting down.  Currently they do not do so.  This may cause problems with sysv inits which have shutdown scripts within `/etc`.

## {id="unmount-warnings"} Unmount warnings on shutdown

Bedrock uses a Linux kernel feature which propagates some mount and unmount operations.  When an init system performs an umount operation on shutdown, this may actually unmount multiple mount points.  Some init systems are confused by this, as it is not a commonly used feature, and print warnings about being unable to unmount directories because they already unmounted them.  These warnings are harmless aesthetic issues.  Note that this does not mean *all* warnings about mount difficulties on shutdown are harmless and only refers to a specific subset.

## {id="fsck-root"} Root filesystem fsck may be skipped

Due to a quirk in how Bedrock works, init systems may not mount the root directory read-only in preparation for providing it to `fsck`.  Bedrock attempts to disable this by changing the corresponding field in `/etc/fstab`.

Some initrds will `fsck` the root filesystem, but not all.  Bedrock should offer the option of calling `fsck` on the root filesystem itself.  However, it currently does not.
