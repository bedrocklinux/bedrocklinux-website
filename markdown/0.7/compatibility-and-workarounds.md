Title: Bedrock Linux 0.7 Poki Compatibility and workarounds
Nav: poki.nav

Bedrock Linux 0.7 Poki Compatibility and workarounds
=====================================================

While much of Bedrock Linux "just works", some features require workarounds or
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
<td><span style="color:#00aa55">just works</span></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum application</td>
<td><span style="color:#888800">minor workaround</span></td>
<td><a href="#application-launchers">may need to clear cache</a></td>
</tr>
<tr>
<td>cross-stratum bash completion</td>
<td><span style="color:#00aa55">mostly works</span></td>
<td>install bash-completion in all strata; some completions fail.</td>
</tr>
<tr>
<td>cross-stratum fish completion</td>
<td><span style="color:#00aa55">just works</span></td>
<td>install fish in all strata</td>
</tr>
<tr>
<td>cross-stratum zsh completion</td>
<td><span style="color:#00aa55">mostly works</span></td>
<td>install zsh in all strata; some completions fail</td>
</tr>
</tr>
<td>cross-stratum login shells</td>
<td><span style="color:#00aa55">just works</span></td>
<td><a href="#login-shells">specifying stratum requires special configuration</a></td>
</tr>
<tr>
<td>cross-stratum dbus</td>
<td><span style="color:#00aa55">just works</span></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum firmware</td>
<td><span style="color:#00aa55">mostly works</span></td>
<td>kernel will detect firmware across strata, initrd-building software may not</td>
</tr>
<tr>
<td>cross-stratum Xorg fonts</td>
<td><span style="color:#00aa55">just works</span></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum vt fonts</td>
<td><span style="color:#aa0055">does not work</span></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum Wayland fonts</td>
<td><span style="color:#888800">needs testing</span></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum themes</td>
<td><span style="color:#00aa55">mostly works</span></td>
<td>themes that support XDG_DATA_DIRS work</td>
</tr>
<tr>
<td>cross-stratum info pages</td>
<td><span style="color:#00aa55">just works</span></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum man pages</td>
<td><span style="color:#00aa55">just works</span></td>
<td>-</td>
</tr>
<tr>
<td>cross-stratum desktop environments</td>
<td><span style="color:#aa0055">does not work</span></td>
<td>get your init, display manager, and desktop environment from the same stratum.</td>
</tr>
<td>any stratum's init</td>
<td><span style="color:#00aa55">just works</span></td>
<td>select the desired init in the init-selection menu at boot</td>
</tr>
<tr>
<td>any stratum's kernel</td>
<td><span style="color:#00aa55">just works</span></td>
<td>install kernel from stratum then update bootloader</td>
</tr>
<tr>
<td>cross-stratum init configuration</td>
<td><span style="color:#aa0055">major workaround</span></td>
<td><a href="#init-configuration">create configs manually</a></td>
</tr>
<tr>
<td>nvidia proprietary drivers</td>
<td><span style="color:#aa0055">medium workaround</span></td>
<td><a href="#nvidia-drivers">manually install drivers</a></td>
</tr>
<tr>
<td>build tools (e.g. make, configure scripts, gcc, etc)</td>
<td><span style="color:#888800">minor workaround</span></td>
<td>prefix with `strat -r <stratum>` and install missing dependencies</td>
</tr>
<tr>
<td>ptrace (e.g. gdb, strace)</td>
<td><span style="color:#888800">minor workaround</span></td>
<td>install in same stratum as traced program, strat -r</td>
</tr>
<tr>
<td>SELinux</td>
<td><span style="color:#aa0055">does not work</span></td>
<td>Bedrock disables it on hijack</td>
</tr>
<tr>
<td>AppArmor, TOMOYO, SMACK</td>
<td><span style="color:#888800">needs testing</span></td>
<td>Default profiles probably will not work</td>
</tr>
<tr>
<td>ACLs</td>
<td><span style="color:#00aa55">mostly works</span></td>
<td>does not work on /etc</td>
</tr>
<tr>
<td>SysV init (e.g. Slackware, CRUX)</td>
<td><span style="color:#aa0055">does not work</span></td>
<td>needs investigation</td>
</tr>
<tr>
<td>cross-stratum libraries</td>
<td><span style="color:#aa0055">does not work</span></td>
<td>theoretically possible but unsupported due to complexity/messiness concerns</td>
</tr>
</table>

## {id="workarounds"} workarounds

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
