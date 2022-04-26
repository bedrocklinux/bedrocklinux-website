Title: Bedrock Linux 0.8 Naga Design Plans
Nav: naga.nav

# Bedrock Linux 0.8 Naga Plans

TableOfContents

## {id="test-coverage"} Test coverage

Historically, major Bedrock releases coincide with substantial architectural and code changes.  This pattern reduced confidence in the ROI on writing tests.  However, recent Bedrock releases has each reduced the scope of architectural changes.  Confidence in Bedrock's architecture has reached the point where Naga's code should receive a fair bit of unit and integration test coverage, as well as the usual static analysis tool coverage.

## {id="manual-install"} Reintroduction of manual install option

Nyla supported two installation options:

- A hands-on manual install
- Hijacking another distro's install

Poki's hijack option was sufficiently polished that the expectation was interest in the competing manual install option would be dropped.  However:

- This resulted in more kickback from experienced Bedrock community members than expected.
- Poki's hijack install is _so_ smooth it causes users to misunderstand what is going on.
- The manual install is easier to automate, which will be important for test automation.

Thus, the manual option will be reintroduced in Naga.

## {id="filesystem-layout"} Filesystem layout

In Poki, most Bedrock-specific files were available in `/bedrock`.  As a result, many users never interact with the `bedrock` stratum.  This exacerbated confusion over what Bedrock Linux _is_, as it _appears_ to simply be a `/bedrock` directory placed "on top" of another distro install.  To resolve this, Naga will move Bedrock specific files into the `bedrock` stratum.  This should cause users to interact with the `bedrock` stratum in the same manner they do other strata, making it appear to be at least a coequal part of the system.  For example (using Poki's filesystem layout):

- If you want to run a program from a certain distro:
	- Arch: /bedrock/cross/bin/pacman
	- Debian: /bedrock/cross/bin/apt
	- Bedrock: /bedrock/cross/bin/pmm
- If you want to edit a config from a certain distro:
	- Arch: /bedrock/strata/arch/etc/pacman.conf
	- Debian: /bedrock/strata/debian/etc/apt.conf
	- Bedrock: /bedrock/strata/bedrock/etc/bedrock.conf

Two concepts need to be accessible to all strata:

- Poki's `/bedrock/strata` equivalent, so that files from other strata may be read or written to by other strat.
- Poki's `/bedrock/cross` equivalent, so that resources from other strata may be consumed transparently.

Given the above goals, there are two options currently being considered:

- All strata will have `/strata`, comparable to Poki's `/bedrock/strata`, and `/cross`, comparable to Poki's `/bedrock/cross` on their root directory.
	- Users will find binaries such as `strat`, `pmm`, `apt`, `pacman`, `vlc`, and `firefox` in `/cross/bin/`
	- Users will find stratum local `/etc` files in `/strata/<stratum>/etc`.
	- This introduces two directories on the root of all strata.  This is both aesthetically displeasing and causes more cognitive overhead for new users learning about Bedrock than a single directory would.
- All strata will have a `/bedrock` directory on their root, comparable to Poki's `/bedrock/cross`.  In addition to the usual `/bedrock/cross` content will be a `/bedrock/strata` directory comparable to Poki's `/bedrock/strata`.
	- Users will find binaries such as `strat`, `pmm`, `apt`, `pacman`, `vlc`, and `firefox` in `/bedrock/bin/`
	- Users will find stratum local `/etc` files in `/bedrock/strata/<stratum>/etc`.
	- The read-write `/bedrock/strata` directory neighboring read-only directories (e.g. `/bedrock/applications`) might cause confusion.
	- When utilizing `/bedrock/strata/...` paths, this results in longer file paths than the competing option due to the `/bedrock` prefix.

## {id="unified-docs"} Unified documentation source

As of the time of writing, Bedrock independently reproduces similar documentation content both on its website and in the release's `--help` output.  Moreover, it lacks Bedrock specific man pages.

Nyla's development will shift documentation into a single source from which the website, `--help` output, and man pages will be generated.  Once implemented, this will reduce the documentation maintenance burden.

## {id="fuse-fs-arch"} crossfs and etcfs modular architecture.

Over Poki's life, crossfs and etcfs have not evolved quite as originally expected, and technical debt is slowing further development.  They will be rewritten with the following architecture in order to expedite future development:

- A core that:
	- Reads Bedrock configuration
	- Implements stub `struct fuse_operations` functions that forward calls to module functions per the incoming file path categorization per the Bedrock configuration.
	- Handles locking on config changes
	- Handles a trigger for and consumption of config changes.
	- Implements helpers such as thread-safe `chroot()` call wrappers.
	- Initializes FUSE.
- Modules to implement the actual `struct fuse_operations` functions.  For example:
	- For crossfs, a module for binaries.
	- For crossfs, a module for `.desktop` files
	- For etcfs, a module to redirect to local files, which will be default.
	- For etcfs, a module to redirect to global.
	- For etcfs, a module to ensure config files contain a line.
	- For etcfs, a module for caching requests.  This could be used to (slightly) improve `/etc/localtime` access performance.

This modular architecture should expedite support for new Bedrock cross-stratum feature subsystems, such as eventual cross-stratum service and desktop environment support.

## {id="single-etcfs"} etcfs single instance.

In Poki, each stratum has its own `etcfs` instance.  This both pollutes the process list and consumes more memory than necessary.  `etcfs` will be rewritten so that only one instance is needed, similar to `crossfs`.

## {id="brl-fetch"} brl fetch

- In Poki, `brl fetch` requires per-distro support files to be busybox shell scripts using an esoteric `brl fetch` specific format.  Naga will generalize the API, treating them as general executables.  This will make them easier to understand and implement for people new to the code base.
- Poki's `brl fetch` does not support verifying bootstrap packages.  Naga development will investigate the possibility of maintaining and utilizing distro-specific package verification keys.

## {id="status-management"} Stratum status management

The stratum status management code will be rewritten with the following goals:

- Drop `brl repair`, as people seem to misunderstand what it does.  Instead, move the functionality into `brl enable`, making `brl enable` idempotent.
- Significantly improve performance.
- Remove the assumption stratum roots are on the parent directory's partition, opening up the possibility of strata being on their own partition.
- Reintroduction of pre/post enable/disable hooks.
	- If a stratum is on its own partition, a pre-enable hook could be used to mount the stratum's partition.
	- Some distros, such as NixOS, require a runtime daemon.  A post-enable hook could be used to activate the daemon so things work transparently.
- Have `brl status` report show/hide status
- Alias `brl unhide` to `brl show`.

## {id="init"} Init selection menu

The Bedrock init selection menu will be rewritten with the following goals:

- Performance improvement.
- Various input handling tweaks, such as having user input pause the default selection timeout.
- Possibly an ASCII animation on the Bedrock logo while waiting for user input and/or initializing strata.

## {id="pmm"} pmm

- Performance improvements.
- Support per-user user interface configuration to better support multi-user systems.
- Support on-the-fly user interface configuration.
- _Possibly_ parallelization options, for example when updating package databases.
- Configuration format rework.
- Add a `brl tutorial pmm`.
