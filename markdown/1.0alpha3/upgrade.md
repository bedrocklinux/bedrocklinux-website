Title: Bedrock Linux 1.0alpha3 Bosco Upgrade Instructions
Nav: bosco.nav

Bedrock Linux 1.0alpha3 Bosco Upgrading Instructions
====================================================

Upgrading an installation from a prior version is not officially tested or
supported.  It is recommended to simply back everything up and install from
scratch.  Attempt to upgrade an existing installation at your own risk.

If you would like to attempt to upgrade despite the above warning, *first* read all of the instructions below, then begin following them.

1. Back everything up, especially the configuration files in the core
2. Boot from some other medium (such as a LiveCD or LiveUSB) and mount your
Bedrock Linux partitions within it.  You may skip mounting partitions which
contain only:
 - `/home`
 - `/root`
 - `/boot`
 - `/bin`
 - `/sbin`
 - `/usr/bin`
 - `/usr/sbin`
 - your clients (such as `/var/chroot/`)
3. Remove the *entire* userland except for the items listed directly above
(`/home`, `/root`, etc).  You did back up, right?
4. Download [the userland tarball](bedrock-userland-1.0alpha3.tar.gz) and move it into the root of the directory which contained the Bedrock Linux filesystem.
5. Untar the userland with `tar xvf bedrock-userland-1.0alpha3.tar.gz`.
6. Run `make; make install` to get Bosco's new binary `brc` in place.
7. Optionally, run `make remove-unnecessary` to remove the Makefile, brc
source, etc.
8. Replace the `/etc` configuration files (`passwd`, `shadow`, `group`,
`hostname`, `hosts`, etc) with those from your backup.  Do *not* overwrite the
new `/etc/profile`, though - you want the new one.
9. Read the [configuration instructions](configure.html) and, referencing your
previous configuration files, configure the new configuration files in their
new formats.
10. Reboot into Bedrock and log in with brroot.
11. Run `brp` to populate the new brpath.
