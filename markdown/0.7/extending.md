Title: Bedrock Linux 0.7 Poki Extension
Nav: poki.nav

# Bedrock Linux 0.7 Poki Extension

~+Bedrock Linux~x's core functionality is largely distro and package manager
agnostic.  However, ~+Bedrock~x does provide distro and package manager
specific quality-of-life utilities.  This page documents expanding this
functionality.

Before attempting to usptream anything to ~+Bedrock~x, run `make check` and
resolve any complaints it may raise with your changes.

TableOfContents

## {id="brl-fetch-new-distros"} brl fetch New Distros

`brl fetch` bootstraps a minimal set of files from a given distribution for use
as a ~+Bedrock~x ~{stratum~}.  This should be enough for the user to bootstrap
whatever else he/she needs, such as a package manager and its (both explicitly
configured and assumed) dependencies.

Support for a new distro may be added by creating a file at:

- `/bedrock/share/brl-fetch/distros/~(distro-name~)` when testing on your
  system.
- `src/slash-bedrock/share/brl-fetch/distros/~(distro-name~)` when adding to
  ~+Bedrock~x's [code base](https://github.com/bedrocklinux/bedrocklinux-userland).

See surrounding files for examples.

### {id="brl-fetch-new-distros-allowed-executables"} Allowed commands

`brl fetch` is used to gather files from other distros.  Care must be taken to
avoid the catch-22 which results from `brl fetch` depending on functionality
from those distros.

`brl fetch` per-distro scripts only may use:

- Anything provided by ~+Bedrock~x's distributed `busybox` located at
  `/bedrock/libexec/busybox`.  This busybox is compiled with
  `CONFIG_FEATURE_PREFER_APPELTS` and consequently its own functionality is
  effectively ahead of everything else in the `$PATH`.
- Any of ~+Bedrock~x's static binaries in `/bedrock/libexec/`.  For example,
  ~{fetching~} some distros requires `zstd`, and so ~+Bedrock~x provides a copy
  for `brl fetch` use at `/bedrock/libexec/zstd`.
- Anything `brl fetch` bootstraps itself.  For example, if `brl fetch`
  bootstraps `debootstrap`, it may then execute `debootstrap`.

### {id="brl-fetch-new-distros-prelude"} Prelude

The per-distro `brl fetch` file should start with a fixed pattern of:

	#!/bedrock/libexec/busybox sh
	#
	# ~(distro~) bootstrap support
	#
	# ~(copyright message~)
	#
	
	# shellcheck source=src/slash-bedrock/libexec/brl-fetch
	. /bedrock/share/common-code
	trap 'fetch_abort "Unexpected error occurred."' EXIT

### {id="brl-fetch-new-distros-variables"} Variables

`brl fetch` sources the discussed file.  The following variables will be set
before `brl fetch` calls most per-distro functions are called and are safe to
utilize in most of the functions described below:

- `${target_dir}`: the location the distro's files should be placed.  This is
  usually `/bedrock/strata/~(new-stratum-name~).
- `${bootstrap_dir}`: a location suitable for temporary tooling.  This is
  generally used with temporary files which bootstrap the final distro.
  Software `chroot`ed here will see the `${target_dir}` at `/target-root`.
  `brl fetch`
  will automatically remove it when the ~{fetch~} is completed.
- `${target_mirror}`: the mirror to use when downloading the distro.
- `${target_release}`: the release of the given distro which should be ~{fetched~}.
- `${distro_arch}`: ~+Bedrock~x's name for the CPU architecture to grab.
- `${cache}`: A location for files which should be cached.  This can be used to
  speed up future ~{fetch~} operations and minimize network usage.

### {id="brl-fetch-new-distros-target-functions"} Target Functions

The file should populate the following functions:

- `check_supported()`: This should return `0` if there is a ~+Bedrock~x
  maintainer for the given distro and non-zero otherwise.  This determines if
  the distro is listed by `brl fetch -L` or `brl fetch -X`.  If it's written by
  someone reading this documentation, it should probably just contain `false`.
- `speed_test_url()`: This should return a path which, when append to one of
  the distro's package mirrors, points to a test file `brl fetch` will attempt
  to download when paring down the mirror list.  This both checks that the
  mirror is valid and its performance.  Pick a file which is unlikely to be
  moved, removed, or meaningfully change in size.  As a rule of thumb, aim for
  files _about_ 256 kB in size, although there is a lot of leeway regarding
  size.
- `list_mirrors()`: This should print mirrors `brl fetch` should consider if
  none is provided/configured.  One mirror per line.  Only `http` and `https`
  are supported due to `busybox` limitations.
- `brl_arch_to_distro()`: This should take the ~+Bedrock~x name for a given CPU
  architecture and print the distro's name for the architecture.
- `list_architectures()`: This should print the ~+Bedrock~x names for CPU
  architectures the distro supports (and which `brl fetch` should be able to
  fetch).  One architecture per line.
- `default_release()`: This should print the release of the distro `brl fetch`
  should gather by default if none are specified.  Favor the latest "stable"
  release.  If the distro is rolling and has no fixed releases, print
  "rolling."
- `list_releases()`: This should print all available releases of the given
  distro.  It effectively implements `brl fetch -R ~(distro~)`.
- `fetch()`: This is the primary function.  Its goal is to populate
  `${target_dir}` with a minimal set of target distro's files.

### {id="brl-fetch-new-distros-helper-functions"} Helper Functions

`brl fetch` provides a number of functions which may assist in implementing
`fetch()`:

- `list_links()`: filters out all an `html` page other than `href=` links.
  Intended for use in pipe chains.
- `find_link()`: parses http index pages to find a given regex URL.
- `download_files()`: downloads into the first argument the rest of the
  argument list.  Provides a progress bar when doing so.
- `setup_chroot()` sets up common `chroot` environment expectations such as
  `/proc`, `/sys` and `/etc/resolv.conf`.  This is commonly run against
  `${target_dir}` and `${bootstrap_dir}`.
- `tear_down_chroot()`: kills all processes and unmounts all mount points
  within a given directory.  Typically not explicitly needed by `fetch()` as
  `brl fetch` will perform such clean up automatically after `fetch()` is run.
- `progress_bar()`: prints a status bar indicating progress.  First argument is
  expected number of items.  Progress bar ticks for every line printed to its
  stdin.
- `progress_unknown()`: like `progress_bar()` but without a known expected
  number of tickets.
- `share_cache()`: bind-mounts a cache directory to help chrooted operations
  access it.
- `checksum_download()`: Downloads a file if either no such file already exists
  or if an existing file does not match the given checksum.  Intended to be
  used with `${cache}`.
- `checksum_downloads()`: Like `checksum_download()` but for multiple items.
  Intended to be used with `${cache}`.
- Various per-package-format commands:
	- `extract_debs()`
	- `extract_rpms()`
	- `extract_pacman_pkgs()`
- To avoid the catch-22 of needing another package manager's database parsing
  code to parse the database to bootstrap the package manager, `brl fetch`
  provides its own code to translate package manager databases into its own
  brldb ("BedRock Linux DataBase") format as well as corresponding code to
  parse brldb.
	- `debdb_to_brldb()`
	- `rpmdb_to_brldb()`
	- `pacmandb_to_brldb()`
	- `brldb_calculate_required_packages()`: parses a brldb to find URLs of
	  a provided list of packages and all of their dependencies.
- `step()` which provides a standardized progress indication.

### {id="brl-fetch-new-distros-strategies"} Fetch Strategies

Below are some strategies developed to implement `fetch()` for various distros.

#### {id="brl-fetch-new-distros-portable-bootstrap-utility"} Portable Bootstrap Utility

Some distros provide a portable utility which can bootstrap the distro.  For
example, ~+Alpine~x and ~+Void~x both provide a static, stand-alone version of
their respective package managers.  These can bootstrap the rest of their
distros without many assumed dependencies.

For such distros, the general strategy is to:

- Parse the mirror to find the portable package manager.
- Download and extract the package manager into `${bootstrap_dir}`.
- `setup_chroot "${bootstrap_dir}"`
- `chroot ${bootstrap_dir}` and use the utility to populate
  `/target-root`.


#### {id="brl-fetch-new-distros-double-bootstrap"} Double Bootstrap

Some distros provide a non-portable utility to bootstrap the distro.  For `brl
fetch` to use it, this must itself be bootstrapped.  For example, ~+Arch~x
provides `pacstrap`, ~+Debian~x provides `debootstrap`, and ~+Fedora~x provides
`dnf`.

For such distros, the general strategy is to:

- Convert the package manager database into `brldb`
- Use `brldb_calculate_required_packages()` to get the required list of package
  URLs.
- Download and extract all packages into `${bootstrap_dir}`.
- `setup_chroot "${bootstrap_dir}"`
- `chroot ${bootstrap_dir}` and use the utility to populate
  `/target-root`.

#### {id="brl-fetch-new-distros-rootfs-provided"} Rootfs provided

Some distros provide essentially exactly the files which are needed, such as in
a single compressed tarball file.  For example, ~+Gentoo~x, ~+KISS~x, and
~+OpenWRT~x all provide suitable tarballs of their userland as part of their
normal distribution method.  These just need to be downloaded and extracted
into `${target_dir}`.

## {id="pmm-new-package-managers"} pmm New Package Managers

`pmm` is a ~+Bedrock~x-aware tool which abstracts cross- and multi-package-manager operations.

Support for a new package manager may be added by creating a file at:

- `/bedrock/share/pmm/package_managers/~(package-manager~)` when testing on
  your system.
- `src/slash-bedrock/share/pmm/package_managers/~(package-manager~)` when
  adding to ~+Bedrock~x's [code base](https://github.com/bedrocklinux/bedrocklinux-userland).

See surrounding files for examples.

These files are predominantly `awk` array definitions which `pmm` sources.

After adding a package manager to `pmm` on a ~+Bedrock~x system, run

	pmm --check-pmm-configuration

to have `pmm` self-sanity check and ensure you are not missing a required
field.

### {id="pmm-new-package-managers-system-package-managers"} system\_package\_managers[]

Many distros are built around specific package managers.  For example, `apt`,
`dnf`, and `pacman`.  `pmm` considers these _system_ package managers.  They
are contrasted against auxiliary package managers such as `pip` or `yay`.

If the package manager you are adding is a system package manager, indicate so
by adding it to `system_package_managers[]`:

`system_package_managers["~(package-manager~)"]`

### {id="pmm-new-package-managers-package-manager-canary-executables"} package\_manager\_canary\_executables[]

`pmm` detects if a given ~{stratum~} provides a package manager by searching
its common `$PATH` locations for a ~{canary executable~}.  These are often
one-to-one with the package manager name, e.g. `apt`, `dnf`, and `pacman`.
However, this is not always the case.  For example, `xbps` does not provide a
`xbps` package manager, but rather uses `xbps-install`, `xbps-remove`, et al.

Tell `pmm` what executable to look for to detect a given package manager with
`package_manager_canary_executable[]`:

`package_manager_canary_executables["~(package-manager~)"] = "~(canary-executable~)"`

### {id="pmm-new-package-managers-supersedes"} supersedes[]

Some package managers wrap another package manager.  For example, `yay`
effectively supersedes `pacman`.  `pmm` must be aware of this to avoid
double-counting package ownership.

If the package manager you are adding supersedes another package manager,
indicate so with `supersedes[]`:

`supersedes["~(new-package-manager~)"] = "~(old-package-manager~)"`

### {id="pmm-new-package-managers-user-interfaces"} user\_interfaces[]

Rather than introduce a new user interface, `pmm` mimics that of other package
managers.  Any given package manager's interface is defined with the
`user_interfaces[]` array.

The expected format is:

`user_interfaces["~(package-manager~)", "~(interface-item~)"] = "~(pattern~)"`

For example:

`user_interfaces["apk", "upgrade-packages-full"] = "pmm upgrade"`

tells `pmm` that if it is configured to mimic `apk` and sees an input in the
form `pmm upgrade` the request is to upgrade all packages.

There are two types of interface items for second field:

- Flags
- Operations

These must match `pmm`'s name for the flag or operation.

See `/bedrock/share/pmm/help` for the list of interface items expected.  Note
the comments; some `help[]` entries are for package-manager-agnostic operations
which do not correspond to a given per-package-manager support file.

A pattern may contain `/` to indicate multiple legal values for the given
field.  For example:

`user_interfaces["apk", "quiet"] = "-q/--quiet"`

indicates that either `-q` or `--quiet` indicates the user provided the `quiet` flag.

A pattern may contain `~(...~)`.  This indicates one or more terms with varying
contents is expected at that position.  For example:

`user_interfaces["apk", "install-packages"] = "pmm add <pkgs>"`

tells `pmm` that if it is configured to mimic `apk` and sees `pmm add`
followed by at least one more term, the user requested is to install one or
more packages.

The exact contents of `~(...~)` for a given interface item must match the
`help[]` description output in `/bedrock/share/pmm/help`.  Otherwise, `pmm
--check-pmm-configuration` will raise concern that you populated the wrong
entry.

If a package manager does not surface a given flag or operation, populate its
value as an empty string.  Otherwise, `pmm --check-pmm-configuration` will
raise concern that you might have failed to implement a given entry.

### {id="pmm-new-package-managers-implementations"} implementations[]

A package manager's implementation of a given operation is indicated with
`implementations[]`  The expected format is:

`implementations["~(package-manager~)", "~(operation~)"] = "~(shell command~)"`

For example:

`implementations["apk", "install-packages"] = "strat -r ${stratum} apk ${flags} add ${items}"`

tells `pmm` how to instruct a given ~{stratum~}'s `apk` to install a package.

Before running `~(shell command~)`, `pmm` populates the following shell
variables for use in `implementations[]` commands:

- `${stratum}`: The ~{stratum~} whose package manager should be run.
- `${package_manager}`: The name of the package manager
- `${unprivileged_user}`: If `pmm` is run as root, this contains a `sudo -u
  ~(username~)` prefix which may be used to drop to an unprivileged user if the
  given package manager disallows running as root.  If `pmm` is not run as
  root, this is populated with an empty string.
- `${flags}`: this contains any specified flags, converted through the
  corresponding `user_interfaces[]` to be applicable for the given package
  manager.
- `${items}`: this is a list of variable, operation specific items.  For most
  commands where it is appropriate it is a list of one or more packages, but in
  some cases it may be a search string or other content.

Some `pmm` operations are combinations of primitive operations.  For example,
the operation `update-package-database,upgrade-packages-full` first updates the
package database then upgrades all packages.  Only implement these if the given
package manager can do so with a single command; otherwise, leave it an empty
string.  `pmm` will queue independent primitive operations automatically if a
combine operation is unimplemented.

Some `pmm` operation concepts do not align perfectly with the package manager
concepts.  When populating such `implementations[]`, if the concept does not
align perfectly, populate broadly.  For example, `apt` differentiates between
`apt upgrade` and `apt full-upgrade`, but `pacman` does not carry this difference.
If `pmm` is mimicking `apt` and either of these upgrade variations are passed
to `pacman`, `pacman` should perform its singular upgrade concept.  Thus,
`pacman`'s `implementations[]` include both

`implementations["pacman", "upgrade-packages-limited"] = "strat -r ${stratum} pacman ${flags} -Su"`

and

`implementations["pacman", "upgrade-packages-full"]    = "strat -r ${stratum} pacman ${flags} -Su"`

Some `implementations[]` are consumed by `pmm`, either for use internally
within `pmm` or to be altered before being provided to the end user.  These
commands should always be run in a non-interactive mode; they should never
prompt for input.  Moreover, these should have their output standardized.  See
`/bedrock/share/pmm/help` comments.

## {id="pmm-new-operations"} pmm New Operations

`pmm` is a ~+Bedrock~x-aware tool which abstracts cross- and multi-package-manager operations.

To add a new `pmm` operation, add an `operations[]` line to:

- `/bedrock/share/pmm/operations` when testing on your system.
- `src/slash-bedrock/share/pmm/operations` when adding to ~+Bedrock~x's code
  base.

The expected format is:

`operations["~(operation-name~)"] = "~(applicability-type~), ~(applicability-check~), ~(argument-count~), ~(pre-process~), ~(post-process~)"`

where:

- Applicability-type: This indicates which package manager(s) the given
  operation should apply to.  It may be overridden by `pmm` flags such as
`--every` and `--newest`.  Valid values are:
	- "first": Use first package manager which passes applicability-check.
	- "every": Use every package manager which which passes
	  applicability-check
	- "none":  No package managers are applicable; used for `pmm` specific
	  operations which do not correlate to individual package managers.

- Applicability-check: A check to see if a given package manager is applicable
  for the given operation.  May be extended by `pmm` flags such as
  `--exact-version`.  Valid values are:
	- "is-package-installed": Only consider package managers which have
	  package installed.
	- "is-package-available": Only consider package managers which have
	  package available.
	- "is-file-db-available": Only consider package managers which have
	  file db capabilities.
	- "brl-which": Only consider package managers from stratum which owns
	  file.
	- "-": No applicability check, allow all.

- Argument-count: This indicates the expected number of arguments an operation
  may take.  Valid values are:
	- "zero": No arguments expected.
	- "one": One argument expected.
	- "many": One or more arguments are expected.

- Pre-process: Action pmm must take before processing.  Valid values include:
	- "localize": Strip "/bedrock/strata/[^/]*" from input.
	- "-": No pre-processing.

- Post-process: some action to take after process.  Valid values are:
	- "prepend-full-path": prepend "/bedrock/strata/<stratum>" to stdout.
	- "prepend-pair": prepend "<stratum>:<package-manager>" to stdout.
	- "update-package-cache": If the package cache is enabled and running
	  as root, updated the package cache.
	- "-": No post-processing.

Additionally, add `--help` output for it to:

- `/bedrock/share/pmm/help` when testing on your system.
- `src/slash-bedrock/share/pmm/help` when adding to ~+Bedrock~x's [code base](https://github.com/bedrocklinux/bedrocklinux-userland).

and add `user_interfaces[]` and `implementations[]` entries for each existing
package manager per the [pmm new package manager
documentation](#pmm-new-package-managers).

After adding an operation to `pmm` on a ~+Bedrock~x system, run

	pmm --check-pmm-configuration

to have `pmm` self-sanity check and ensure you are not missing a required
field.
