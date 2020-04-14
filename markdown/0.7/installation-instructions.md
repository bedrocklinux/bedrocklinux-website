Title: Bedrock Linux 0.7 Poki Installation Instructions
Nav: poki.nav

# Bedrock Linux 0.7 Poki Installation Instructions

## {id="pre-installation-checks"} Pre-installation checks

While ~+Bedrock Linux~x works well for many users, it has known limitations
with some distros and features and is not suitable for everyone.  Before
installing ~+Bedrock~x, review:

- [The distro compatibility page](distro-compatibility.html)
- [The feature compatibility page](feature-compatibility.html)
- [Known issues](known-issues.html)

to make sure you don't run into any surprises.

There are likely as yet undiscovered compatibility issues unlisted above.
Consider testing ~+Bedrock~x in a VM or spare machine and exercising your
projected workflow before installing ~+Bedrock~x on a production machine.

Finally, back up your existing system, much as one would do before installing a
traditional Linux distribution.

## {id="installation"} Installation

~+Bedrock~x allows users to mix and match parts of other distros.  The install
process is considered such a feature.  To "get" the install process from
another distro, ~+Bedrock~x converts an install of another distro into
~+Bedrock~x in-place.

Thus, first, install some Linux distro.  When choosing such a distro:

- Consider if it has an install process you like.  This is the entire point of
  ~+Bedrock~x's ability to use another distro's installer.
- [Consider compatibility with Bedrock](distro-compatibility.html).
- Do *not* consider if you like the distro's files.  [You can swap out key
  components with those from other distros from it and remove it
  later](workflows.html#removing-the-hijacked-stratum).

While ~+Bedrock~x's hijack install is only officially tested against fresh
installs of other distros, no known issues exist hijacking a long-running
install.  Just make sure to back up first.

Next, get the hijack installer onto the target system.  Download the latest installer corresponding to your CPU architecture [from here](https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases) or build your own [from here](https://github.com/bedrocklinux/bedrocklinux-userland/tree/0.7).

Run the script as root with the `--hijack` flag:

	{class="rcmd"} sh ./bedrock-linux-~(release~)-~(arch~).sh --hijack

Finally, reboot.

If you see a new init selection menu during the boot process, congratulations!  You're now running Bedrock Linux.

## {id="post-installation-steps"} Post-installation steps

After logging in, consider running

	{class="cmd"} brl tutorial basics

for an interactive tutorial covering ~+Bedrock~x's basic usage.
