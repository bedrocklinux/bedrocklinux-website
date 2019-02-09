Title: Bedrock Linux Possible Future Work
Nav: home.nav

Bedrock Linux Possible Future Work
==================================

Possible future updates for Bedrock Linux may include:

##{id="performance"} Performance improvements

- The init selection menu takes too long to discover inits to show.
- `brl` status management commands are too slow.
- `etcfs` and `crossfs` currently do not utilize readdirplus [because it was broken when last investigated](https://github.com/libfuse/libfuse/issues/235).  However, [later libfuse comments](https://github.com/libfuse/libfuse/commit/7b0075c06f171cdac7a3d565463c0e5938dff04d) reference readdirplus, and so it might have since been fixed.

##{id="compatibility"} Compatibility improvements

Efforts should be made to improve [the various compatibility items which do not just work](0.7/compatibility-and-workarounds.html).  For example, users should not have to manually create symlinks for desktop environment detection to work across ~{strata~}.

##{id="pmm"} Package Manager Manager

Bedrock would benefit from a new subsystem called "Package Manager Manager", or pmm.  It should:

- Allow operations that consider multiple package managers.  For example, if today someone wanted to install scron without caring where it comes from, he or she may search Debian's repos and not find it, then Arch's repos and not find it, then Gentoo's repos and not find it, then finally find it in Void's.  Or for another example, one may want a specific version of a package, and would again have to run multiple queries today.  The upcoming pmm should let me perform such cross-package-manager operations in a single command.
	- Querying multiple package managers can be slow, and so we should have some kind of caching in place.  Maybe pmm will read the databases of other package managers and create its own unified one from them.
- Allow for a single UI that will work across multiple package managers, as using multiple package managers with slightly different UIs results in a lot of silly muscle-memory typos.  Repeatedly switching between slightly different package manager UIs can be confusing, resulting in typos such as `xbps install ~(package~)`, `apk install ~(package~)`, `pacman add ~(package~)`, `apt -S ~(package~)`, and `emerge-install ~(package~)`, none of which work.
- This idea raises the question of which package manager UI should we use.  Will the command to install a package be `pmm -S ~(package~)` or `pmm install ~(package~)` or `pmm add ~(package~)` or `pmm-install ~(package~)`? Bedrock's goal isn't to get strictly packages from other distros, but whatever is feasible.  This would, then, include package manager UIs.  Perhaps we should have the mapping between pmm and the supported package managers be two way such that pmm could be configured to mimic backing package manager UIs.  Ideally, users with a background in any Linux package manager should find a comfortable experience.  Or, of course, make their own.

##{id="cpu-architectures"} CPU Architectures

At the time of writing, Bedrock Linux 0.7 Poki supports `x86_64` and `armv7l`.  Support for additional architectures should be added, especially `x86` and `aarch64`.

##{id="man-pages"} Man pages

Bedrock provides documentation on its website and the various commands have `--help` flags, but we do not currently have man pages for our own utilities.  This should be remedied.

##{id="build-with-clang"} Support clang with build system.

Bedrock's build system currently hardcodes `gcc`.  If possible, this should be generalized to be independent of the compiler.  Otherwise, explicit support for `clang` should be added.
