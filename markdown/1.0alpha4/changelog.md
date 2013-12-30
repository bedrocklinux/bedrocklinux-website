Title: Bedrock Linux 1.0alpha4 Flopsie Changelog
Nav: flopsie.nav

Bedrock Linux 1.0alpha4 Flopsie Changelog
=========================================

The following are the major changes which were made from Bedrock Linux 1.0alpha3 Bosco:

- A new `bru` union filesystem which remedies difficulties sharing /etc files between clients.
- Installation scripts; much less manual work is now necessary to install Bedrock Linux.
- Moved to musl as the standard C library for core components.
- Updates to `brs` to setup/teardown clients on running systems.
- Changes to `bri` including new flags to indicate which client provides which processes.
- `brw` will now alias to `bri -w` if provided an argument.
- `brl` now has -c argument to add a conditional for running the rest of the arguments.
- The ability to "disable" a client.
- Reworked configuration files.
