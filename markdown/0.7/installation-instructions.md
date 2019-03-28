Title: Bedrock Linux 0.7 Poki Installation Instructions
Nav: poki.nav

Bedrock Linux 0.7 Poki Installation Instructions
================================================

Bedrock Linux's goal of letting users enjoy features from other Linux
distributions includes the installation process.  To achieve, this Bedrock
provides a script which hijacks a given traditional Linux distribution install
and converts it into a Bedrock Linux install.

Thus, the first step is to install a traditional Linux distribution.  Some
considerations to help you decide which traditional Linux distribution to
install include:

- Bedrock Linux currently supports `x86_64` and `arm7vl`.
	- Other architectures may work but will require you compile the installer and updates yourself.  They will also lack `brl fetch` functionality.
- All of the initial install's distro-specific files may later be easily removed.
	- It may be best to think of the hijack install process as installing Bedrock *under* the initial install, not *over* it.  Bedrock becomes the base of the system, with the initial install's files a removable layer on top.  Hence Bedrock's name.
- People have reported success hijacking Debian, Fedora, Manjaro, OpenSUSE, Ubuntu, and Void Linux (both glibc and musl).  Most other, similar distros should work as well.
- There are known difficulties hijacking CentOS, CRUX, Devuan, GoboLinux, GuixSD, NixOS, and Slackware.

Prepare the install as you usually would.  Setup a user account, networking, etc.

Download the latest installer corresponding to your CPU architecture [from here](https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases) or build your own [from here](https://github.com/bedrocklinux/bedrocklinux-userland/tree/0.7).

Run the script as root with the `--hijack` flag:

    {class="rcmd"} sh bedrock-linux-~(release~)-~(arch~).sh --hijack

Confirm at the prompt you understand what the script is doing, then allow it to
convert the existing install into Bedrock Linux.  Finally, once it has
completed successfully, reboot.

If you see a new init selection menu during the boot process, congratulations!  You're now running Bedrock Linux.

Bedrock Linux is a bit different from other, traditional Linux distributions.  [Continue to basic usage](basic-usage.html) for a quick overview of Bedrock specific concepts you will need to utilize the new install.
