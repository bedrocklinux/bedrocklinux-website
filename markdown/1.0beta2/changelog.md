Title: Bedrock Linux 1.0beta2 Nyla Changelog
Nav: nyla.nav

Bedrock Linux 1.0beta2 Nyla Changelog
=====================================

The following are the major changes which were made from Bedrock Linux
1.0beta1 Hawky to Bedrock Linux 1.0beta2 Nyla:

- The term ~{client~} has been changed to ~{stratum~} to avoid confusion due to
  problematic associations with the word "~{client~}".
- Support for ~{hijack~} installation: installation steps such as partitioning,
  installing a bootloader and setting up full disk encryption can all be done
  via another distro's installer.
- Support for utilizing an init system from ~{stratum~}, chosen at boot time,
  via a new utility `brn`.
- Support for strata aliases
- Support for `brp` `pinning`: can now configure implicit items which
  out-prioritize `local` access.
- Much better error messages from `brc`
- Preparatory work done for binary distribution: build system now results in a
  relocatable tarball.
- Improvements to mount type detection.
- Disassociated ~{stratum~} configuration from ~{stratum~} state.
- Added new strata.conf configuration items
	- `enable` which indicates if a given ~{stratum~} should be enable at boot time
	- `init` to indicate a given ~{stratum~} can provide an init system (and what the system is)
	- `unmanaged` to indicate Bedrock Linux should not manage a given mount
	  point.  This is useful if a given ~{stratum~}'s root directory is a
	  mount point, such as if it is mounted over an NFS.
