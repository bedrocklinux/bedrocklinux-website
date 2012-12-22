Title: Bedrock Linux 1.0alpha3 Changelog
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Bosco Changelog
=======================================

The following changes were made from Bedrock Linux 1.0alpha2 Momo:

- significant performance improvements
  - `brc` (~1/2000th Momo's overhead delay, see [here](../1.0alpha2/backports.html) for benchmarks)
  - `brp` (~1/4000th-1/100th Momo's execution time)
- significantly reduced number of mount points (~1/100th Momo's count)
- reworked configuration files
  - `brclients.conf` now follows ini format
  - `brclients.conf` now supports "frameworks" to reduce editing work
  - `capchroot.allow` dropped
  - `/etc/fstab` no longer necessary for adding client share items
- experimental support for using precompiled components from clients in core
  - `busybox` (if static and minimum applets are met)
  - linux kernel (with modules and initrd if required)
- moved `bedrock` directory from `/opt` to root
- removed `(/opt)/bedrock/lib`

