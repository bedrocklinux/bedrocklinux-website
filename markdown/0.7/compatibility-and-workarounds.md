Title: Bedrock Linux 0.7 Poki Compatibility and Work-Arounds
Nav: poki.nav

Bedrock Linux 0.7 Poki Compatibility and Work-Arounds
=====================================================

While much of Bedrock Linux "just works", some features require work-arounds or
do not work at all.  See the table below.

<table>
<tr>
<th>Feature</th>
<th>How well it works</th>
<th>Notes</th>
<td></td>
</tr>
<tr>
<td>cross-strata executables</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-strata application</td>
<td><a href="#application-launchers">minor workaround</a></td>
<td><a href="known-issues.html#missing-application-icons">application icons may be missing</a></td>
</tr>
<tr>
<td>cross-strata bash completion</td>
<td>mostly works</td>
<td>install bash-completion in all strata; some completions fail.</td>
</tr>
<tr>
<td>cross-strata fish completion</td>
<td>just works</td>
<td>install fish in all strata</td>
</tr>
<tr>
<td>cross-strata zsh completion</td>
<td>mostly works</td>
<td>install zsh in all strata; some completions fail</td>
</tr>
</tr>
<td>cross-stratum login shells</td>
<td>just works</td>
<td><a href="#login-shells">specifying stratum requires special configuration</a></td>
</tr>
<tr>
<td>cross-strata dbus</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-strata firmware</td>
<td>mostly works</td>
<td>kernel will detect firmware across strata, initrd-building software may not</td>
</tr>
<tr>
<td>cross-strata Xorg fonts</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-strata vt fonts</td>
<td>does not work</td>
<td>-</td>
</tr>
<tr>
<td>cross-strata Wayland fonts</td>
<td>needs testing</td>
<td>-</td>
</tr>
<tr>
<td>cross-strata themes</td>
<td>mostly works</td>
<td>themes that support XDG_DATA_DIRS work</td>
</tr>
<tr>
<td>cross-strata info pages</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-strata man pages</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-strata desktop environments</td>
<td>does not work</td>
<td>get your init, display manager, and desktop environment from the same stratum.</td>
</tr>
<td>any stratum's init</td>
<td>just works</td>
<td>select the desired init in the init-selection menu at boot</td>
</tr>
<tr>
<td>any stratum's kernel</td>
<td>just works</td>
<td>install kernel from stratum then update bootloader</td>
</tr>
<tr>
<td>cross-stratum init configuration</td>
<td><a href="#init-configuration">major work-around</a></td>
<td>-</td>
</tr>
<tr>
<td>nvidia proprietary drivers</td>
<td><a href="#nvidia-drivers">medium work-around</a></td>
<td>-</td>
</tr>
</tr>
<td>steam</td>
<td><a href="#steam">minor workaround</a></td>
<td></td>
</tr>
<tr>
<td>Arch AUR</td>
<td>minor work-around</td>
<td>prefix with `strat -r arch`</td>
</tr>
<tr>
<td>SELinux</td>
<td>does not work</td>
<td>Bedrock disables it on hijack</td>
</tr>
<tr>
<td>AppArmor, TOMOYO, SMACK</td>
<td>testing needed</td>
<td>Default profiles probably will not work</td>
</tr>
<tr>
<td>ACLs</td>
<td>do not work on /etc</td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum libraries</td>
<td>does not work</td>
<td>theoretically possible but unsupported due to complexity/messiness concerns</td>
</tr>
<tr>
<td>neofetch</td>
<td>in progress</td>
<td><a href="https://github.com/dylanaraps/neofetch/pull/1118">see github PR to add bedrock support</a></td>
</tr>
</table>

## {id="work-arounds"} Work-arounds

### {id="application-launchers"} Application launchers

Many application launchers cache known applications at `~/.cache/menus`.  Some may fail to recognize new applications in `/bedrock/cross/applications` and automatically update the cache.  If this happens, delete the cache at `~/.cache/menus` to force the application launcher to re-scan the applications.

### {id="login-shells"} Login shells

Linux systems typically store *the full path* to a login shell in `/etc/passwd`.  Default login shell paths are ~{local~} and will not be visible to another ~{stratum~}'s init system.  Bedrock automatically changes any ~{local~} login shell to a ~{cross~} path in `/bedrock/cross/bin/` to work around this concern.

If you would like to use a *specific* ~{stratum~}'s shell [rather than the highest priority one](configuration.html#cross-priority), [create a pin entry in cross-bin](configuration.html#cross-bin) with the desired shell.  After `brl apply`ing the new configuration, add the new pin path to `/etc/shells` and `chsh` to it.

### {id="init-configuration"} Init configuration

Every ~{stratum~} sees its own init configuration and only its own init configuration.  By default, an init from one ~{stratum~} will not know how to manage a service from another ~{stratum~}'s init.

It is possible to work-around this by hand crafting init configuration.  For example, one may make a runit run directory whose `run` file calls `strat`.  For another example, one may make a systemd unit file whose `Exec=` line calls `strat`.

If you find hand creating init configuration is intimidating or bothersome, consider simply picking one ~{stratum~} to provide your init and get all init-related services from that ~{stratum~}.

### {id="nvidia-drivers"} Nvidia proprietary drivers

Most Linux graphics drivers have two components:

- A kernel module
- A userland component

Most F/OSS Linux graphics drivers strive to make the two components forward and backward compatible such that their versions do not have to sync up perfectly.  This allows a kernel from one ~{stratum~} to work with an Xorg server from another ~{stratum~}.  However, the proprietary Nvidia drivers require these two components be in sync.  Since the kernel module is shared across ~{strata~}, this means every ~{stratum~} that does anything with the graphics card requires the exact same version.  Bedrock does not know how to enforce this itself.  To work around this, one must manually install distro-agnostic portable proprietary Nvidia in all ~{strata~}.

[Download the proprietary Nvidia driver](https://www.nvidia.com/object/unix.html).  Then run

- {class="rcmd"}
- strat -r ~(kernel-stratum~) sh ./NVIDIA-Linux-~(arch~)-~(version~).run

where ~(kernel-stratum~) is the ~{stratum~} providing your kernel.  This may require a `linux-headers` package be installed in the ~(kernel-stratum~).  Note the `-r`: this is important to keep the Nvidia driver installer from "cleaning" graphics related files in other ~{strata~}.

Next, run

- {class="rcmd"}
- strat -r ~(stratum~) sh ./NVIDIA-Linux-~(arch~)-~(versino~).run --no-kernel-module

for all remaining ~(strata~) that require graphics drivers.

The `bedrock` stratum and other strata that do not utilize the graphics acceleration do not require the Nvidia drivers.

### {id="steam"} steam

[A bug in steam](https://github.com/ValveSoftware/steam-for-linux/issues/5612) breaks the ability to log into its friends/chat service with Bedrock's timezone handling.  To work around this, run steam with `TZ` set to your Olson time zone.  For example:

	TZ="America/New_York" steam
