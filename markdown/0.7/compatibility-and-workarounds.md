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
<td>cross-stratum executables</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum application</td>
<td><a href="#application-launchers">minor workaround</a></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum bash completion</td>
<td>mostly works</td>
<td>install bash-completion in all strata; some completions fail.</td>
</tr>
<tr>
<td>cross-stratum fish completion</td>
<td>just works</td>
<td>install fish in all strata</td>
</tr>
<tr>
<td>cross-stratum zsh completion</td>
<td>mostly works</td>
<td>install zsh in all strata; some completions fail</td>
</tr>
</tr>
<td>cross-stratum login shells</td>
<td>just works</td>
<td><a href="#login-shells">specifying stratum requires special configuration</a></td>
</tr>
<tr>
<td>cross-stratum dbus</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum firmware</td>
<td>mostly works</td>
<td>kernel will detect firmware across strata, initrd-building software may not</td>
</tr>
<tr>
<td>cross-stratum Xorg fonts</td>
<td>mostly works</td>
<td><a href="#firefox-fonts">firefox needs about:config tweak</a></td>
</tr>
<tr>
<td>cross-stratum vt fonts</td>
<td>does not work</td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum Wayland fonts</td>
<td>needs testing</td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum themes</td>
<td>mostly works</td>
<td>themes that support XDG_DATA_DIRS work</td>
</tr>
<tr>
<td>cross-stratum info pages</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum man pages</td>
<td>just works</td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum desktop environments</td>
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
<tr>
<td>chromium-based programs (e.g. chromium, chrome, discord, electron, signal, steam, etc)</td>
<td><a href="#chromium">minor workaround</a></td>
<td></td>
</tr>
<tr>
<td>build tools (e.g. make, configure scripts, gcc, etc)</td>
<td>minor work-around</td>
<td>prefix with `strat -r <stratum>` and install missing dependencies</td>
</tr>
<tr>
<td>ptrace (e.g. gdb, strace)</td>
<td>minor work-around</td>
<td>install in same stratum as traced program, use strat to specify stratum</td>
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
<td>SysV init (e.g. Slackware, CRUX)</td>
<td>does not work</td>
<td>needs investigation</td>
</tr>
<tr>
<td>cross-stratum libraries</td>
<td>does not work</td>
<td>theoretically possible but unsupported due to complexity/messiness concerns</td>
</tr>
</table>

## {id="work-arounds"} Work-arounds

### {id="application-launchers"} Application launchers

Many application launchers cache known applications and/or their icons.  Some may fail to recognize new applications in `/bedrock/cross/applications` or icons in `/bedrock/cross/icons`.

Some such applications can be prompted to build the cache by removing `~/.cache/menus`.  Others may need to be restarted (such as by logging out and back in, or rebooting the computer).

### {id="login-shells"} Login shells

Linux systems typically store *the full path* to a login shell in `/etc/passwd`.  Default login shell paths are ~{local~} and will not be visible to another ~{stratum~}'s init system.  Bedrock automatically changes any ~{local~} login shell to a ~{cross~} path in `/bedrock/cross/bin/` to work around this concern.

If you would like to use a *specific* ~{stratum~}'s shell [rather than the highest priority one](configuration.html#cross-priority), [create a pin entry in cross-bin](workflows.html#pinning) with the desired shell.  After `brl apply`ing the new configuration, add the new pin path to `/etc/shells` and `chsh` to it.

### {id="init-configuration"} Init configuration

Every ~{stratum~} sees its own init configuration and only its own init configuration.  By default, an init from one ~{stratum~} will not know how to manage a service from another ~{stratum~}'s init.

It is possible to work around this by hand crafting init configuration.  For example, one may make a runit run directory whose `run` file calls `strat`.  For another example, one may make a systemd unit file whose `Exec=` line calls `strat`.

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

### {id="chromium"} Chromium

[A bug in Chromium](https://bugs.chromium.org/p/chromium/issues/detail?id=811403) results in Chromium and everything which builds upon it, including Chrome, Discord, Electron, [Signal](https://github.com/signalapp/Signal-Desktop/issues/3085), and [Steam](https://github.com/ValveSoftware/steam-for-linux/issues/5612) failing to properly understand the (common, standard) `TZ` format Bedrock utilizes.  While there have been efforts to fix this upstream, [they appear to have stalled](https://chromium-review.googlesource.com/c/chromium/deps/icu/+/1006219/).

To work around this, run the program with `TZ` set to your Olson time zone.  For example:

	TZ="America/New_York" chromium

### {id="firefox-fonts"} Firefox fonts

Firefox's sandboxing mechanisms disallows fonts from other strata by default.  See [this page on the Mozilla wiki](https://wiki.mozilla.org/Security/Sandbox).  To lessen the sandboxing strictness, go to `about:config` and change `security.sandbox.content.level` from the default `4` down to `2`.  Otherwise, if you prefer the default stricter sandboxing, install the desired font in the `firefox`-providing ~{stratum~}.
