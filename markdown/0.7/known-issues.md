Title: Bedrock Linux 0.7 Poki Known Issues
Nav: poki.nav

# Bedrock Linux 0.7 Poki Known Issues

## {id="proxy"} brl-update and brl-fetch fail with proxy

Some users have reported issues with `brl update` and `brl fetch` failing when behind a proxy.

This issue appears to be specific https URLs.  For `brl update`, possible work-arounds include:

- Downloading the update with some other software and providing it as the parameter to `brl update`
- Configuring `brl update` to use another ~+Bedrock~x mirror.

There are no obvious work-arounds for `brl fetch`.

## {id="unmount-warnings"} Unmount warnings on shutdown

Bedrock uses a Linux kernel feature which propagates some mount and unmount operations.  When an init system performs an umount operation on shutdown, this may actually unmount multiple mount points.  Some init systems are confused by this, as it is not a commonly used feature, and print warnings about being unable to unmount directories because they already unmounted them.  These warnings are harmless aesthetic issues.  Note that this does not mean *all* warnings about mount difficulties on shutdown are harmless and only refers to a specific subset.

## {id="fsck-root"} Root filesystem fsck may be skipped

Due to a quirk in how Bedrock works, init systems may not mount the root directory read-only in preparation for providing it to `fsck`.  Bedrock attempts to disable this by changing the corresponding field in `/etc/fstab`.

Some initrds will `fsck` the root filesystem, but not all.  Bedrock should offer the option of calling `fsck` on the root filesystem itself.  However, it currently does not.
