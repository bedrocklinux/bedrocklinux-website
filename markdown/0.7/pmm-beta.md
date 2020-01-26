Title: Bedrock Linux 0.7 Package Manager Manager Beta
Nav: poki.nav

Package Manager Manager Beta
============================

Bedrock Linux's Package Manager Manager, or `pmm`, is now available in
Bedrock's beta channel.  This subsystem provides Bedrock-aware abstractions for
multi-package-manager and cross-package-manager operations.

If you would like to help test it, first [register your system with the beta
channel](beta-channel.html) and update to the latest beta.  Make sure you merge
any update-provided `/bedrock/etc/bedrock.conf` files into your main
`bedrock.conf, as this feature includes a new `[pmm]` configuration section.

`pmm` will not be accessible immediately after updating to the corresponding
beta.  You will need to first populate the `user_interface` field of the new `[pmm]`
section in `bedrock.conf`.  See the comments above `user_interface`.  Once you
have done that,  run `brl apply` as root.  `pmm` should now be in your `$PATH`;
try running `pmm --help`.

## {id="things-to-test"} Things to test

Things to test include:

- All `[pmm]` configuation fields.
	- Known issue: The `ignore-non-system-package-managers` field is effectively a no-op, as pmm does not support any non-system package managers at this point in time.  Some are planned to be added later.
- All user interfaces available fit the general usage pattern of the package manager they are mimicking.
- All functionality from all user interfaces available work as described/expected.
- All underlying package manager operations work as described/expected.
- All pmm-specific flags (e.g. `--every`, `--newest`) work as expected
- The pmm-specific world file operations (e.g. `--diff-world`) work as expected.
- Everything works when updating from a previous release to the beta.
- Everything works from a fresh install of the given beta.

## {id="adding-new-package-managers"} Adding new package managers

The focus of the beta is intended to be polishing the existing functionality rather than extending it.  However, if you wish to begin preliminary work on new `pmm` functionality while `pmm` is still in beta, note:

- Create a new file in `/bedrock/share/pmm/package_managers/` named after the new package manager.
- Populate the same set of fields found in other `/bedrock/share/pmm/package_managers/` entries.
- See `/bedrock/share/pmm/help` for descriptions of corresponding fields.
	- Additionally, note the presence of `system_package_managers[<package-manager>]` is used to indicate the package manager is a system package manager and central to the corresponding stratum.
	- Additionally, `package_manager_canary_executable[]` is used to map a package manager name to an executable whose presence indicates the package manager exists in the stratum.  These are usually the same (e.g. the `apt` package manager provides the `apt` executable) but not always (e.g. the `xbps` package manager does not have an `xbps` executable).
- If the package manager does not surface a given piece of functionality such that there is no correpsonding user interface for it, create an empty `user_interface[]` value for the given functionality.
- Do not populate a combine `implementations[]` field if the package manager cannot do all operations in one command.  Instead, implement the component `implementations[]`; `pmm` will break an instruction up into components accordingly.
- If the package manager does not cleanly implement a given operation, make a judgement call about what should be done if the `implementations[]` is _requested_ by the user.  Is there something similar enough that is likely what the user meant?  If so, populate `implementations[]` accordingly.  Is there nothing which makes sense?  Then leave it blank.
- If there are multiple valid names to refer to a given package, ensure the `Internal pmm operations` handles all of them.  For example `emerge` understands that `vim` refers to `app-editors/vim`; ensure `pmm` does as well.
- Run `pmm --check-pmm-configuration` to sanity check your changes before attempting to submit them to Bedrock.

## {id="adding-new-package-managers"} Adding new operations

The focus of the beta is intended to be polishing the existing functionality rather than extending it.  However, if you wish to begin preliminary work on new `pmm` functionality while `pmm` is still in beta, note:

- Add the new field to `/bedrock/share/pmm/help`, describing what it does.
- Add the new field to `/bedrock/share/pmm/operations`.  If it is similar enough to another `pmm` operation, you may be able to share the same pattern as an existing operation.  Otherwise, you may need to extend core `pmm` functionality in `/bedrock/libexec/pmm` to support it.
- If it the operation is `pmm` specific, add it to `/bedrock/share/pmm/package_managers/pmm` utilizig the `"*"` package manager name.
- If it the operation is a general package manager concept, add it to all `/bedrock/share/pmm/package_managers/*` files other than `pmm`.
- Run `pmm --check-pmm-configuration` to sanity check your changes before attempting to submit them to Bedrock.
