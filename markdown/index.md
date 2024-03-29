Title: Bedrock Linux
Nav:   home.nav

Bedrock Linux
=============

~+Bedrock Linux~x is a meta Linux distribution which allows users to
mix-and-match components from other, typically incompatible distributions.
~+Bedrock~x integrates these components into one largely cohesive system.

For example, one could have:

- ~+Debian~x's stable coreutils
- ~+Arch~x's cutting edge kernel
- ~+Void~x's runit init system
- A pdf reader with custom patches automatically maintained by ~+Gentoo~x's portage
- A font from ~+Arch~x's AUR
- Games running against ~+Ubuntu~x's libraries
- Business software running against ~+CentOS~x's libraries

All at the same time and working together mostly as though they were packaged
for the same distribution.

## {id="xz-5.6.0-compromise"} Security alert (xz, CVE-2024-3094)
<small>2024-03-29</small>

A common compression project, `xz`, appears to have recent releases 5.6.0 and
5.6.1 compromised, tracked as
[CVE-2024-3094](https://nvd.nist.gov/vuln/detail/CVE-2024-3094).  **No stable
Bedrock Linux release uses such a new `xz` build, and we are confident stable
channel users remain unaffected.**

0.7.30beta1 did build against `xz` 5.6.1.  However:

- The exploit build code is only included in the `xz` source tarball
  releases.[<sup>[0]</sup>](https://www.openwall.com/lists/oss-security/2024/03/29/4)
  Bedrock Linux builds `xz` from git.  We checked for and were unable to find
  any code path which builds/includes the exploit.  We do not believe the
  exploit was ever built or included in 0.7.30beta1 despite the `xz` version.

- The exploit appears to depend on glibc's ifunc
  functionality.[<sup>[0]</sup>](https://www.openwall.com/lists/oss-security/2024/03/29/4)
  Bedrock Linux builds against musl-libc, which does not offer this
  functionality, and thus the exploit, were it included, is unlikely to work.

- The exploit appears to explicitly check for known `argv[0]` such as
  `/usr/sbin/sshd`.[<sup>[0]</sup>](https://www.openwall.com/lists/oss-security/2024/03/29/4)
  While not impossible it, this has yet to be reported to check for the only
  Bedrock Linux component which is built against `xz`, `kmod`.

[0] https://www.openwall.com/lists/oss-security/2024/03/29/4

**While we do not believe 0.7.30beta1 users are vulnerable, as a precaution we
have pulled the release and push 0.7.30beta2 built against the older xz 5.4.6
and encourage beta channel users to update to it immediately.**

## {id="0.7.29-released"} Bedrock Linux 0.7.29 released
<small>2023-08-06</small>

- Build system updates
- Fixed brl-fetch Arch
- Fixed brl-fetch Artix
- Fixed brl-fetch Exherbo
- Fixed brl-fetch Fedora
- Improve build system dynamic link detection
- Various dependency updates
- Work-around systemd shutdown freeze

## {id="0.7.28-released"} Bedrock Linux 0.7.28 released
<small>2022-08-11</small>

- Improved brl-fetch handling of GPT and multi-partition images
- Removed redundant Ubuntu vt.handoff hack handling
- Fixed brl-fetch arch, artix, gentoo, exherbo

[See older news items](news.html)
