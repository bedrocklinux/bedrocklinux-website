Title: Bedrock Linux Poki Progress
Nav: poki.nav

Bedrock Linux "Poki" Progress
=============================

This documents the state of Bedrock Linux's "Poki" release as of 2018-05-05.

## {id="rationale"} Rationale for feature choice

Bedrock Linux has a relatively small development team and thus has had to be
very judicious with its application of developer hours.  Historically, the vast
majority of effort has been put into researching and developing the underlying
technologies needed to reach Bedrock's goals, which has sadly come at the
expense of user experience.  Bedrock's rough but functional state that the more
adventurous could test has resulted in a fair bit of useful feedback and
vindicated the general strategy.  Now that the underlying technology has
matured adequately to be useful to a broad audience, the upcoming release's
focus shifts towards providing a more enjoyable user experience.

## {id="ux"} User Experience (completion: 100%)

The following items are user experience design and theory which have been
mapped out and completed "on paper" but whose corresponding code may not
necessarily be fully implemented:

- Listing and describing features in documentation has been found to be, on its
  own, inadequate in terms of familiarizing users with the entirety of
  Bedrock's functionality.  Various changes have been made to improve the
  discoverability of Bedrock functionality.
	- All user-facing Bedrock commands are now placed behind a single
	  master command, `brl`, with sub-commands providing the various pieces
	  of functionality.  This functions somewhat similarly to commands such
	  as `apt` and `git`.  Once users are aware of one `brl` subcommand,
	  they will know where to find where to explore for other Bedrock
	  functionality.  `brc/strat` is also made available without prefixing
	  `brl` due to its usage frequency.
	- All user-facing Bedrock configuration is now contained within a
	  single file.  Once users have been directed towards changing one
	  configuration item, they will know where to look for other
	  configurable items.
- The `br*` command naming scheme was found, unsurprisingly, to be problematic.
  Moving to one master command with user-friendly subcommand names alleviates
  most of the concern.  Non-user-facing commands are also being renamed away
  from `br*` to names that communicate something about their usage as well.
- Some users found to be hesitant to perform operations on Bedrock subsystems
  which are not explicitly listed as allowed, such as removing strata.  To
  alleviate this, such operations are explicitly listed as subcommands of
  `brl`, e.g. `brl remove` and `brl alias`.
- In Nyla, various pieces of configuration had to be updated in multiple
  places; there was no single source of truth.  For example, creating a stratum
  alias required both updating `strata.conf` and creating a symlink in
  `/bedrock/strata`.  Very reasonably, users disliked having to repeat
  themselves.  Occasionally, users would fail to update all required locations
  and confuse Bedrock with the inconsistency.  With Poki, an effort has been
  made to remove this redundancy.
- The `global` and `rootfs` strata aliases have been a consistent point of
  confusion.  It was apparent during Nyla's development that `global` and
  `rootfs` shouldn't be necessary in theory, as there exists a single
  filesystem layout which provides the benefits of both.  At the time,
  it was not apparently how to convert an existing Linux distribution
  install ("hijack") to this layout.  With Poki, converting to this layout
  during the install process is now a priority such that `global` and `rootfs`
  can be dropped.
- Nyla proved the "hijack" install process could work.  However, it was a very
  manual process.  With Poki, the process can be almost entirely automated.
  The user should only have to:
	- Install and setup a traditional distro
	- Run the Bedrock Linux installation script (as root)
	- Okay a confirmation dialogue (to confirm they understand
	  that this will modify the existing system).
	- Provide a name for the existing files as a stratum.
	- Reboot
- With previous Bedrock releases, acquiring strata has been a tedious process.
  Moreover, the documentation to do so occasionally becomes out of date as
  various upstream distros change.  With Poki, new functionality (`brl fetch`
  aka `brg`) will fully automate the process.  While there will be various
  options to configure the process, the user should require no more than `brl
  fetch <supported-distro>`, e.g. `brl fetch gentoo`.
- As upstream distros change, `brl fetch` will invariably become out of date.
  Thus, Poki also requires an update mechanism.  `brl update` will provide not
  only updates to `brl fetch` subsystems, but also general fixes and small
  improvements.  It is unlikely it will support a full release-to-release
  update, but the system as designed should be fairly flexible and the option
  remains open.
- Given that `brl update` will provide point updates, the versioning scheme in
  use through Nyla no longer makes sense.  Starting with Poki, the versioning
  scheme will change to [Semantic Versioning](https://semver.org/).  Since Poki
  is the seventh pre-stable release, it will be `0.7.0`.  A following update
  performing a minor fix would then be `0.7.1`, and the next major release (one
  which breaks backwards compatibility) would be `0.8.0`.
- Users would occasionally become confused about which stratum provides a given
  file.  `brl which` will support reporting which stratum provides any given
  file path.

## {id="build"} Build System (completion: 100%)

The build system has seen various improvements:

- The build system is now more parallelized, resulting in faster build times.
- The build system now automatically detects unneeded busybox applets and
  removes them from the busybox build, resulting in a small
  distribution/install size.  The `x86_64` installer is currently projected to
  be under 1.44MB and, in theory, distributable on a 3.5 inch floppy disk.
- The build system's file structure has been reorganized.
- The build system now supports embedding GnuPG signatures into the output
  distributable.  `brl update` will verify these signatures before applying
  updates.

## {id="strat"} strat (previously: brc) (completion: 95%)

Nyla's `brc` has been renamed to `strat` as part of a general move away from
the `br*` executable naming pattern.

- `strat` has been updated to support the new filesystem layout and configuration.
- `strat` now can now set `argv[0]`.
	- This is needed to properly support cross-stratum login shells, as
	  `/sbin/login` communicates to the given shell that it is a login
	  shell through `argv[0]`.  Nyla's `brsh` had to work around this in
	  much less clean ways.
	- Some other programs also make use of `argv[0]`, such as `busybox`.
- `strat` now uses more aggressive security checks.
- With Nyla, it was found to occasionally be necessary to disable cross-stratum
  functionality.  For example, when building system, it may be useful to ensure
  the build is not dependent across strata.  `strat` now supports
  `-l`/`--local` which disables cross-stratum functionality for its subcommand.
  For example, `strat -l arch make` will run arch's `make` where `make` only
  sees arch's executables.

## {id="bouncer"} bouncer (completion: 100%)

Nyla made use of scripts such as:

	#!/bedrock/libexec/busybox sh
	exec /bedrock/bin/brc ${stratum} ${command} "$@"

to create user-facing commands that transparently redirect to the appropriate
stratum's instance.  However, `#!` executables lose `argv[0]` and these scripts
were found to be unsuitable situations which leverage `argv[0]`.  A new binary
executable was created to fulfill this role while retaining `argv[0]`:
`bouncer`.

Modifying bouncer's internal content to indicate the desired stratum/command,
as is done with the `#!` scripts, may be unwise.  Instead, `bouncer` checks its
own `user.bedrock.stratum` and `user.bedrock.localpath` extended filesystem
attributes to determine which stratum/executable to redirect to, then executes
`strat` with the appropriate flags.

## {id="crossfs"} crossfs (previously: brp) (completion: 95%)

Nyla's `brp` has been renamed to `crossfs` as part of a general move away from
the `br*` executable naming pattern.

- `brp`'s performance was found to be lacking in Nyla, and thus a fair bit of
  effort has been placed into improving `crossfs` performance in Poki.
	- Single threaded performance has improved by about 35% in `ls -l` tests on large directories.
	- Multithreading support has been added, further improving performance in multi-threaded scenarios (dependent on the number of simultaneous accesses).
	- Work has been made to support FUSE's "readdirplus".  [Sadly "readdirplus" does not appear to work with the latest libfuse and Linux kernel](https://sourceforge.net/p/fuse/mailman/fuse-devel/thread/878tcgxvp2.fsf@vostro.rath.org/#msg36209107).  Once it is fixed, `brl update` should be able to push out an update to take advantage of it for further performance improvements.
- `crossfs` populates the extended filesystem attributes on its files.  This is both used for `bouncer` to learn where to redirect and for `brl which` to determine which stratum provides a given file in `crossfs`'s path.
- `crossfs` supports merging font directories.  This allows Poki to support fonts across strata.  One may install a font in one stratum, and both xorg servers and xorg client programs from other strata will detect the new font.
- `crossfs` configuration handling has been improved.

## {id="etcfs"} etcfs (previously bru) (completion: 25%)

Nyla's `bru` has been renamed to `etcfs` as part of a general move away from
the `br*` executable naming pattern.

`etcfs` has only had preliminary work completed thus far.

- `etcfs` is less performance sensitive than `crossfs` and has more permissions
  related concerns (e.g. `crossfs` is read-only).  `etcfs` will likely receive
  a subset of the `crossfs` performance improvements (e.g. multithreading), but not all.
- Nyla's `bru` made process lists ugly.  This should be remedied with Poki's `etcfs`.
	- `bru` took configuration via a very long list of command line
	  arguments which flooded `htop` output.  `etcfs` will likely inherit
	  `crossfs` runtime configuration handling and have a more reasonable
	  argument list.
	- `bru` had to have one instance per stratum.  Early research shows
	  `etcfs` may be able to get away with a single instance irrelevant of
	  the number of strata.  As a beneficial side effect, this may also
	  reduce RAM usage.
- Nyla made use of two different systems to enforce configuration values in
  `/etc` files, both of which were enforced at stratum-enable time.  Both were
  found to be inadequate, in part because the files may be updated between
  stratum-enable calls.  Since all calls to `/etc` files will go through
  `etcfs`, `etcfs` is suited to enforce configuration state on every single
  read.  Sadly this will likely come at the cost of increased code complexity
  and a slight performance hit, but it should prove to be worthwhile.

## {id="brl"} brl (previously various executables) (completion: 25%)

Various commands have all been moved under the banner of a new, single command:
`brl`.

`brl` has only had preliminary work completed thus far.

Work which has been completed on `brl` includes:

- `brl strat` which simply passes through to `strat`.
- Prototyping work for `brl fetch`, a subcommand which automatically acquires
  strata.  The prototype supports twelve distros (plus one distro variation):
  alpine, arch, centos, crux, debian, devuan, fedora, gentoo, opensuse, solus,
  ubuntu, void, void-musl.  This is likely the extent of what will be pursued
  for Poki's initial release, but additional distros may be added with point
  updates post release.
- Most of `brl which`, a subcommand which indicates which stratum provides
  a given object.  This supports not only executables in your `$PATH` (like the
  "normal" `which` command), but also filepaths, processes, and xorg windows
  (provided `xprop` is available).
- Some tab-completion for `bash`, `zsh`, and `fish`.  Full tab completion for
  those three shells is expected for both `strat` and all `brl` subcommands by
  Poki's release.

Planned features include:

- Various stratum-management subcommands including: `remove`, `rename`,
  `enable`, `disable`, `fix`, `ignore`, `unignore`, `alias`, and `deref`.
- `update`, a subcommand which updates the Bedrock install.
- `report`, a subcommand which creates a report about the current Bedrock
  system.  This is intended to be used to aid debugging problems.

## {id="installer-updater"} The installer/updater (completion: 5%)

The build system produces a single eventual output file, named something along the lines of

	bedrock-linux-${version}-${arch}.sh

Only preliminary work completed thus far on this feature.

It is planned to serve three purposes:

- It will hijack existing Linux distribution installs, converting them into Bedrock installs.
- It will support installing into a directory for use with "manual" installs.
- It will support updating existing Bedrock installs of the same major version.

## {id="init"} init (previously brn) (completion: 5%)

Nyla's `brn` has been renamed to `init` as part of a general move away from
the `br*` executable naming pattern.

In order to work, Bedrock runs code before the target init system runs.
Amongst other things, this provides a menu which can be used to select the
desired init for the given session.

In Nyla, the hijacked distro's `/sbin/init` had to be retained on the root of
the offline filesystem, and thus `brn` had to be elsewhere on the filesystem.
To ensure `brn` was run rather than what the bootloader saw at `/sbin/init`,
the user was expected to configure the bootloader.  This was found to be
problematic.  Poki's new filesystem layout moves all of the hijacked install's
~{local files~} (including `/sbin/init`) from the root of the offline
filesystem to `/bedrock/strata/~(stratum~)/`.  This frees Poki to place its own
init system at `/sbin/init` on the offline filesystem, which is the path most
bootloaders default to utilizing.

## {id="documentation"} Documentation (completion: 0%)

A full suite of documentation must be created to accompany Poki's release.
Most of the user-facing improvements simplify things which should reduce the
documentation load to a significant degree.  However, no documentation for
Poki's release has yet been written.

Depending on time constraints, man pages may or may not be created for `brl`
and `strat`.  If they are not, the website's documentation and `--help` are
expected to suffice.

## {id="presentation"} Video presentation (20%)

Bedrock is difficult to explain succinctly in text.  A short video
demonstrating Bedrock is expected to be better received by some audiences.
Past attempts at videos have not gone terribly well.  Efforts have been made to
improve Poki's:

- New audio capture hardware has been acquired.
- The script is better organized and makes fewer assumptions about the audience
  than past attempts.
