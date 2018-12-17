Title: Bedrock Linux 0.7 Poki Known Issues
Nav: poki.nav

Bedrock Linux 0.7 Poki Known Issues
===================================

Issues listed here are supplemental to [issues listed in the compatibility section](compatibility-and-workarounds.html).

## {id="x11-repeated"} /bedrock/cross/bin/X11/

The `/bedrock/cross/bin/X11` directory recursively contains many `X11` directories.

This is because many distros contain a symlink at `/usr/bin/X11` which points to `.` which `/bedrock/cross/bin` tries to expand.

A possible fix for this would be for `cross-bin` to ignore directories.
