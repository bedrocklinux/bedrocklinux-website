Title: Bedrock Linux 0.7 Poki Debugging
Nav: poki.nav

# Bedrock Linux 0.7 Poki Debugging

TableOfContents

## {id="restriction"} restriction

Occasionally Bedrock's ability to integrate ~{strata~} can confuse software.  For example, when compiling software a build system may attempt to detect build dependencies on the system and become confused to see `python2`, `python3`, *and* ` python`.

If a command acts strangely, considering prefixing it with `strat -r ~(stratum~)` to restrict it to the given ~{stratum~}'s commands.  For example:

- {class="cmd"}
- ~## restrict build system to Debian
- strat -r debian ./configure && strat -r make
- ~## restrict build system to Arch
- strat -r arch makepkg

## {id="brl-status-and-repair"} brl status and repair

If things are not working as expected, run `brl status` to query the system for the status of the enabled ~{strata~}.  If any ~{strata~} report as ~{broken~}, try to `brl repair` them.

If `bedrock.conf` specifies a certain file path must be a symlink but `brl repair` finds a non-symlink file both at the symlink location *and* the target location, it will abort and instruct you to inspect both, decide which you want to keep, and remove the other.

If `brl repair` fails and does not indicate you need to perform some action to resolve the situation, and you are okay with losing the ~{broken~} ~{stratum~}'s state, try the more aggressive `brl repair --clear ~(strata~)`.  If even that fails, the only remaining option is to reboot.  If rebooting fails, seek assistance from the Bedrock community.  Consider generating a `brl report` when doing so.

## {id="bedrock-init"} bedrock init

You may bypass the init-selection menu by placing

	bedrock_init=~(stratum~):~(init-path~)

on the kernel line in your bootloader.  This is useful in case there are issues with the init-selection menu.  For example, a kernel line with this in place may look like:

`/boot/vmlinuz-4.9.0-8-amd64 root=/dev/sda1 ro quiet bedrock_init=debian:/sbin/init`

Many bootloaders allow users to alter the kernel line for a session.

## {id="chroot-fix-boot"} Chrooting into Bedrock to fix /boot

Bedrock is dependent on various runtime items being in placed, and thus one may not simply mount a Bedrock partition and `chroot` into it.

One common need to `choot` into some system is to fix a broken `/boot`.  While a generalized `chroot` is not available, a limited one for this purpose is.  There are three main differences from a typical rescue `chroot`:

- Instead of setting up and `chroot`'ing directly into the mount, setup and `chroot` into `~(mount~)/bedrock/strata/~(stratum~)` for some ~{stratum~} which will perform the repair operation.
- In addition to the typical `proc`, `dev`, etc setup, also bind-mount `~(mount~)/boot` to `~(mount~)/bedrock/strata/~(stratum~)/boot`.  This will make the ~{global~} `/boot` accessible for manipulation by the given ~{stratum~}.
- Try to avoid installing packages, manipulating users or groups, or other things which may consider ~{global~} or ~{cross~} file paths, as without Bedrock's hooks in place this may cause subtle problems.  Restrict operations within the `chroot` to repairing `/boot`.
