Title: Bedrock Linux 1.0beta1 Hawky Changelog
Nav: hawky.nav

Bedrock Linux 1.0beta1 Hawky Changelog
=========================================

The following are the major changes which were made from Bedrock Linux
1.0alpha4 Flopsy to Bedrock Linux 1.0beta1 Hawky:

- brp was rewritten as a fuse filesystem
	- it now updates on-the-fly
	- it now supports files other than just executables, such as man pages and
	.desktop files.
- A new client.conf configuration item, `share`, can be used in place of `bind`
  where users would like new mount points to be default ~{global~}.
- Numerous improvements to brs
	- Now supports "update" which can add new configuration settings to
	  existing ~{clients~} without first disabling them.
	- Now has hooks to run programs before/after a ~{client~} is enabled/disabled.
- Various improvements to bri
	- bri -s now provides more output should a ~{client~} not be properly enabled,
	  such as if a mount point is missing or a mount point is not the type of
	  mount point it should be.
	- bri -m now indicates if a given mount point is "OK" or not what it is
	  expected/configured to be (which would be indicative of a problem).
	- Various parts of bri have been refactored to no longer assume PID1 is in
	  the core in preperation for supporting init systems from ~{clients~}.
