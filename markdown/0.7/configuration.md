Title: Bedrock Linux 0.7 Poki Configuration
Nav: poki.nav

Bedrock Linux 0.7 Poki Configuration
====================================

All Bedrock Linux configuration is centralized in a single ini-format file at `/bedrock/etc/bedrock.conf`.  After making any changes to it, run (as root) `brl apply` to apply them.

It may be worthwhile to read through the comments in `/bedrock/etc/bedrock.conf`.

## {id="locale"} Locale

### {id="locale-timezone"} timezone

Different programs in different distros handle timezone details slightly
differently.  Bedrock attempts to enforce a single standard across the system.
The `[locale]/timezone` field indicates the desired Olson timezone.

Bedrock will attempt to detect this in a hijack install and populate the field
accordingly.

### {id="locale-localgen"} localgen

Many distros use `/etc/local.gen` to manage their locale information.  If `[locale]/localegen` is populated, `brl fetch` will configure corresponding ~{strata~} during the fetch.

Bedrock will attempt to detect this in a hijack install and populate the field
accordingly.

### {id="locale-LANG"} LANG

Many programs use a `$LANG` variable to manage their locale.  If `[locale]/LANG` is populated, Bedrock will enforce this value across the system.

## {id="init"} Init

Bedrock provides an init-selection menu during the boot process which can be used to select which ~{stratum~}:`init` pair to use as the init for the given session.

### {id="init-timeout"} timeout

The `[init]/timeout` field is used to indicate how many seconds the init selection menu will be displayed before automatically choosing the default ~{stratum~}:`init`, if a default is specified.

### {id="init-default"} default

The `[init]/default` field is used to indicate the desired default ~{stratum~}:`init` pair.  This will be selected automatically once `[init]/timeout` expires, or upon hitting `enter` at a blank init-selection prompt.

Bedrock will attempt to detect this in a hijack install and populate the field
accordingly.

### {id="init-paths"} paths

The init selection menu offers every `[init]/paths` executable found in every non-hidden ~{stratum~}.  If it is missing an init system you would like, feel free to append it to the list.

## {id="global"} global

The `[global]` section is used to configure ~{global~} paths.

### {id="global-share"} share

`[global]/share` lists directories which should be considered ~{global~}.  Moreover, any new mount points created within these directories will also be ~{global~}.

### {id="global-bind"} bind

`[global]/bind` lists directories which should be considered ~{global~}.  However, any new mount points created within these directories will be ~{local~}.  This is primarily intended to avoid recursion when sharing nested mount points.

### {id="global-etc"} etc

The technique used for `share` and `bind` above do not work with `/etc` files.  Thus, a separate configuration item, `[global]/etc`, is used for files and directories within `/etc` that should be global.

## {id="symlinks"} symlinks

Bedrock has two systems to enforce the fact that certain file paths should be symlinks.  Any `filepath = linkpath` pairs under `[symlinks]` are enforced when ~{enabling~} ~{strata~}.

## {id="etc-symlinks"} etc-symlinks

Bedrock has two systems to enforce the fact that certain file paths should be symlinks.  Any `filepath = linkpath` pairs under `[etc-symlinks]` are enforced whenever the filepaths are read.

## {id="etc-inject"} etc-inject

Bedrock ensures that, if a file within `/etc` exists, it contains certain file contents.  For example, if a user installs `zsh` from a ~{stratum~} which creates `/etc/zsh/zshenv`, Bedrock ensures that the file contains zsh-specific Bedrock configuration.

## {id="env-vars"} env-vars

Many programs search environment variables consisting of a colon-separated
list of directories.  Bedrock alters various configuration files to ensure Bedrock ~{cross~} paths are searched as well.

## {id="cross"} cross

`/bedrock/cross` is dynamically populated with files from various ~{strata~} to allow transparent ~{cross~}-~{strata~} file access.  `brl which` may be used to query which ~{stratum~} provides a given `/bedrock/cross` file.

### {id="cross-priority"} priority

Bedrock populates files within `/bedrock/cross` with read-only copies of files from ~{enabled~} (and ~{shown~}) ~{strata~}.  If multiple ~{strata~} can fulfill the same file, the `[cross]/priority` field controls which takes priority.

## {id="cross-pass"} cross-pass

Files within `[cross-pass]` are populated in the corresponding `/bedrock/cross` file path unaltered.

## {id="cross-bin"} cross-bin

`[cross-bin]` file paths are populated with binaries that internally redirect to the corresponding ~{stratum~}'s binary.

## {id="cross-bin-restrict"} cross-bin-restrict

`[cross-bin-restrict]` file paths are populated with binaries that internally redirect to the corresponding ~{stratum~}'s binary, and are implicitly ran through `strat -r`'s restrictions.

## {id="cross-ini"} cross-ini

`[cross-ini`] file paths are populated with the backing files, but altered so that `Exec` keys have their values prefixed with `strat ~(stratum~)`.  This allows the files to work across ~{strata~} boundaries.

## {id="cross-font"} cross-font

`[cross-font`] file paths are treated as Xorg font directories.  Most files are passed unaltered, but some special files such as `fonts.dir` are dynamically populated with the merged contents.

## {id="brl-fetch-mirrors"} brl-fetch-mirrors

If given no information about which mirror to use, `brl fetch` will attempt to automatically detect the mirror each time.  The mirror detection logic is time consuming and may ultimately settle on a non-ideal mirror.  A mirror can be provided with the `-m` flag, but manually looking this up and specifying it may become tedious every fetch.  `[brl-fetch-mirrors`] may be used to tell `brl fetch` which mirrors to use to avoid these concerns.

`[brl-fetch-mirrors]/mirror-prefix` may specify a mirror that provides multiple distros, with the distro-specific directory at the end of the path removed.  If you have a local mirror that provides many distros you are interested in, consider populating it here.

`[brl-fetch-mirrors]/~(distro~)` may be used to specify a desired mirror for each distro.

## {id="miscellaneous"} miscellaneous

### {id="color"} color

`[miscellaneous]/color` may be set to `false` to `brl`'s use of ANSI colors.

While a lot of Bedrock functionality "just works", some features require a work around or do not work at all.  Continue to the [compatibility and work-arounds documentation](compatibility-and-workarounds.html) to properly gauge expectations.
