Title: Bedrock Linux 0.7 Poki Installation Instructions
Nav: poki.nav

Bedrock Linux 0.7 Poki Installation Instructions
================================================

To install Bedrock Linux:

- Install a traditional Linux distro to use as a starting point.  See [here](distro-support.html) for reports of how well Bedrock interacts with various distros.
- Download the latest installer corresponding to your CPU architecture [from here](https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases) or build your own [from here](https://github.com/bedrocklinux/bedrocklinux-userland/tree/0.7).
- Run the script as root with the `--hijack` flag: `{class="rcmd"} sh ./bedrock-linux-~(release~)-~(arch~).sh --hijack`
- Reboot.

If you see a new init selection menu during the boot process, congratulations!  You're now running Bedrock Linux.

Bedrock Linux is a bit different from other, traditional Linux distributions.  [Continue to basic usage](basic-usage.html) for a quick overview of Bedrock specific concepts you will need to utilize the new install.
