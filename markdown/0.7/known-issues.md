Title: Bedrock Linux 0.7 Poki Known Issues
Nav: poki.nav

Bedrock Linux 0.7 Poki Known Issues
===================================

Issues listed here are supplemental to [issues listed in the compatibility section](compatibility-and-workarounds.html).

## {id="init-menu"} Hidden init-selection menu

Some distros, most notably Ubuntu, use a `vt_handoff` feature which hides Bedrock's init-selection menu.

If you run into this, waiting for the init selection menu timeout (which is, by default, 30 seconds) grants access to the system.  To disable `vt_handoff`, remove `splash` from `/etc/default/grub` and regenerate `/boot/grub/grub.cfg` (e.g. with `grub-mkconfig -o /boot/grub/grub.cfg`).

*Some* subsystem presumably disables `vt_handoff` at some point in the boot process making virtual terminals visible.  The ideal solution would be for Bedrock to trigger this itself.  However, where `vt_handoff` gets turned off is unknown.

A future Bedrock update may either replicate the `vt_handoff` disabling code or, if we are unable to determine how to do that, enforce the absence of `splash` from `/etc/default/grub`.

## {id="lvm"} lvm mount failures

Some users have reported issues with lvm partitions, most notably `/home`, not mounting.

Typical init systems do not mount `/etc/fstab` values corresponding to ~{global~} directories such as `/home`, and thus Bedrock is required to do so itself.  However, Bedrock does not currently know how to populate `/dev/mapper` files required for lvm.

A future Bedrock update may embed `dmsetup` into Bedrock to allow it to populate `/dev/mapper` and mount ~{global~} lvm partitions such as `/home`.

## {id="tray-icons"} Missing tray icons

Some users have reported issues with tray icons not working across strata boundaries.

## {id="brl-update-out-of-range"} brl update prints "sh: out of range"

Running `brl update` prints `sh: out of range`.  This is a harmless aesthetic issue.

## {id="brl-which-bedrock-strata"} brl which on /bedrock/strata

`brl which` currently misreports some paths within `/bedrock/strata` as ~{global~} when they should be ~{cross~}.

## {id="x11-repeated"} /bedrock/cross/bin/X11/

The `/bedrock/cross/bin/X11` directory recursively contains many `X11` directories.

This is because many distros contain a symlink at `/usr/bin/X11` which points to `.` which `/bedrock/cross/bin` tries to expand.

A possible fix for this would be for `cross-bin` to ignore directories.

## {id="fuse-sigterm"} etcfs and crossfs sigterm handling

Bedrock Linux has two FUSE filesystems, etcfs and crossfs.  Ideally, both should unmount themselves on SIGTERM, such as when the system is shutting down.  Currently they do not do so.  This may cause problems with sysv inits which have shutdown scripts within `/etc`.

## {id="unmount-warnings"} Unmount warnings on shutdown

Bedrock uses a Linux kernel feature which propogates some mount and unmount operations.  When an init system performs an umount operation on shutdown, this may actually unmount multiple mount points.  Some init systems are confused by this, as it is not a commonly used feature, and print warnings about being unable to unmount directories because they already unmounted them.  These warnings are harmless aesthetic issues.  Note that this does not mean *all* warnings about mount difficulties on shutdown are harmless and only refers to a specific subset.

## {id="fsck-root"} Root filesystem fsck may be skipped

Due to a quirk in how Bedrock works, init systems may not mount the root directory read-only in preparation for providing it to `fsck`.  Bedrock attempts to disable this by changing the corresponding field in `/etc/fstab`.

Some initrds will `fsck` the root filesystem, but not all.  Bedrock should offer the option of calling `fsck` on the root filesystem itself.  However, it currently does not.

## {id="localegen-single"} Bedrock localegen only understands single value

Bedrock has a `localegen` field in `bedrock.conf` which, if populated, will be used to configure the locale of fetched strata.  However, it only understands a single value.  This should be expanded to support multiple localegen values.

Moreover, research should be performed into the viability of making `/etc/locale.gen` global.  This would remove the need for Bedrock to understand this field.

## {id="missing-application-icons"} Some application launchers do not show cross-stratum icons

Bedrock Linux ensures application launchers see applications from other strata.  However, some application launches do not show the application's icon.

This appears to be due to the application launcher interpreting the freedesktop.org standard differently than the Bedrock Linux developers.  The standard indicates [here](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables) that `$XDG_DATA_DIRS` is a colon-separated list of possible entires.  For example, by default Bedrock Linux sets it to:

	XDG_DATA_DIRS=/usr/local/share:/usr/share:/bedrock/cross/

Which would indicate that `/usr/local/share/`, `/usr/share`, and `/bedrock/cross/` should be searched for data.

The also standard indicates [here](https://standards.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html#directory_layout) that icons can be found in `$XDG_DATA_DIRS/icons`.

Bedrock Linux interprets this to mean that, if

	XDG_DATA_DIRS=/usr/local/share:/usr/share:/bedrock/cross/

applications search search for icons in `/usr/local/share/icons`, `/usr/share/icons`, and `/bedrock/cross/icons`.  However, it seems many application launchers do not search all of `XDG_DATA_DIRS`; they either only search the first element, or they interpret the entire contents as a single file path.

Bedrock Linux cannot cleanly resolve this on its end.  Patches should be submitted upstream to the various application launchers to get them to support the full list of `$XDG_DATA_DIRS` paths.
