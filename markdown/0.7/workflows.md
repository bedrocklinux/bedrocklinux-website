Title: Bedrock Linux 0.7 Poki Workflows
Nav: poki.nav

Bedrock Linux 0.7 Poki Workflows
================================

## {id="manually-adding-strata"} Manually Adding Strata

[brl fetch](commands.html#brl-fetch) can be used to automate acquiring Linux
distributions for use as ~{strata~}.  However, this supports a limited number of
distros and requires an internet connection.  ~{Strata~} may also be created
manually, which may be preferred in some situations.

To manually add a ~{stratum~}, get its contents into a new directory within
`/bedrock/strata` corresponding to the new ~{stratum~}'s name.  For example:

- {class="rcmd"}
- mkdir -p /mnt/~(example~)
- mount /dev/sda1 /mnt/~(example~)
- cp -a /mnt/~(example~) /bedrock/strata/~(example~)

Or for another example:

- {class="rcmd"}
- mkdir -p /bedrock/strata/~(example~)
- cd /bedrock/strata/~(example~)
- wget http://example.com/root.tar
- tar xf root.tar
- rm root.tar

Ensure the new ~{stratum~} name does not contain any whitespace characters, forward or back slashes, colons, equal signs, dollar signs, or single or double quotes.  Moreover, ensure it does not start with a dash character.  At the time of writing, Bedrock's implementation naively assumes these constraints to be in place.

By default, new ~{strata~} are ~{hidden~} to avoid accidentally being ~{enabled~} while the files are mid transfer into place.  Once you have completed placing the new ~{stratum~}'s files into `/bedrock/strata`, ~{show~} the ~{stratum~}:

- {class="rcmd"}
- brl show ~(new-stratum~)

Finally, to actually use the stratum, ~{enable~} it:

- {class="rcmd"}
- brl enable ~(new-stratum~)

New, manually acquired ~{strata~} may complain about missing users or groups.  If so, you may need to manually add them.  Such ~{strata~} may also complain about locale issues, in which case you may need to manually set up the given ~{stratum~}'s locale.

## {id="removing-the-hijacked-stratum"} Removing the Hjiacked Stratum

The ~{stratum~} resulting from the ~{hijack~} of the initial install may be removed.  Some considerations:

- The ~{stratum~} *currently* providing `init` may not be removed (as that would crash the system).  If you are using the ~{hijacked~} ~{stratum~}, first reboot and select another ~{stratum~} to provide `init` for the session.
- By default, the ~{hijacked~} ~{stratum~} maintains your bootloader.  After removing the ~{hijacked~} ~{stratum~} the bootloader will continue to work - you can boot - but it will not automatically update with new kernels or initrds.  If you know how to manually maintain the bootloader, you are welcome to do so.  If you would prefer to have another ~{stratum~} maintain the bootloader, simply install its bootloader over the existing one.  Many distros provide a `grub` or `grub2` package which is suitable.  It may be wise to do this *first*, before removing the ~{hijacked~} ~{stratum~}, to ensure the bootloader hand-off goes smoothly before removing the ~{hijacked~} ~{stratum~}.
- Bedrock creates a `hijacked` ~{alias~} during the ~{hijack~} process which can be used to determine which ~{stratum~} is the ~{hijacked~} one, should you have forgotten: `brl deref hijacked`
- [brl remove](commands.html#brl-remove) command can be used to remove ~{strata~}, such as the `hijacked` ~{stratum~}:

`{class="rcmd"} brl remove $(brl deref hijacked)`

## {id="pinning"} Pinning executables to strata

If multiple strata provide the same command, absent any additional indication of which to use Bedrock will choose one by default in a given context.  Which it chooses may be configured, which is referred to as "pinning."

`/bedrock/etc/bedrock.conf`'s `[cross-bin]` section is used to configure executable binaries in `/bedrock/cross`.  In this section,

	pin/bin/~(command~) = ~(stratum~):~(/local/path/to/command~)

entries are used to specify the specified ~(stratum~):~(path~) pair should provide the given ~(command~), should the pair exist.  For example,

	pin/bin/vim = arch:/usr/bin/vim

indicates that the `arch` ~{stratum~} should provide `vim` by default if it has it (and if `strat` is not used to manually specify which ~{stratum~} should provide the command).

Multiple ~{stratum~}:~{path~} pairs may be specified, in which case the first which provides the ~{path~} will provide the command.  For example,

	pin/bin/firefox = clear:/usr/bin/firefox, arch:/usr/bin/firefox

`~(stratum~):` may be left off with only a ~(path~) provided, in which case all enabled ~{strata~} are considered.  However, this is not useful for pinning.

If you typically [~{restrict~} the command](basic-usage.html#restriction), you can specify it should be ~{restricted~} by default by placing it under the `[cross-bin-restrict]` section instead.  Just as `strat` can be used to specify which ~{stratum~} should provide a given command, overriding the above described pinning, `strat` without `-r` will disable any configured ~{restriction~}.

## {id="chroot-fix-boot"} Chrooting into Bedrock to fix /boot

Bedrock is dependent on various runtime items being in placed, and thus one may not simply mount a Bedrock partition and `chroot` into it.

One common need to `choot` into some system is to fix a broken `/boot`.  While a generalized `chroot` is not available, a limited one for this purpose is.  There are three main differences from a typical rescue `chroot`:

- Instead of setting up and `chroot`'ing directly into the mount, setup and `chroot` into `~(mount~)/bedrock/strata/~(stratum~)` for some ~{stratum~} which will perform the repair operation.
- In addition to the typical `proc`, `dev`, etc setup, also bind-mount `~(mount~)/boot` to `~(mount~)/bedrock/strata/~(stratum~)/boot`.  This will make the ~{global~} `/boot` accessible for manipulation by the given ~{stratum~}.
- Try to avoid installing packages, manipulating users or groups, or other things which may consider ~{global~} or ~{cross~} file paths, as without Bedrock's hooks in place this may cause subtle problems.  Restrict operations within the `chroot` to repairing `/boot`.
