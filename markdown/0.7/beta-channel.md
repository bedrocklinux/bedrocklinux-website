Title: Bedrock Linux 0.7 Poki Beta Channel
Nav: poki.nav

Bedrock Linux 0.7 Poki Beta Channel
===================================

Bedrock Linux offers a beta channel for those who are interested in testing
upcoming updates and willing to bear the associated risk.

Generally, a new Bedrock Linux release will first be tested by the developers.
After some time it will be made available in the beta channel, then after any
newly discovered issues are resolved, filtered down to the stable channel.

Beta releases are not generally announced.  To stay on top of such releases,
either watch the beta release document:

<https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7beta/releases>

or, if you have configured your system to watch for beta updates, simply run

- {class="rcmd"}
- brl update

## {id="using-beta"} Using the beta channel

Stable 0.7 Poki releases are listed at:

<https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases>

and beta 0.7 Poki releases are at:

<https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7beta/releases>

If you are interested in beta releases, it is best to configure your system to watch both so that you also receive any stable updates which supersede beta ones.

In your `/bedrock/etc/bedrock.conf` you should find a `mirrors` field under either `[miscellaneous]` or `[brl-update]`.  To configure your system to watch both mirrors, set the field to them, comma separated:

`mirrors = https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases, https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7beta/releases`

When you next `brl update` it will look for the newest available update, stable or beta.

## {id="reverting-to-stable"} Reverting to the stable channel

To revert to the stable channel, first first change the `mirrors` field under either `[miscellaneous]` or `[brl-update]` in your `/bedrock/etc/bedrock.conf` to only check the stable channel:

`mirrors = https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases`

This will only restrict future updates, but will not revert the existing install to a previous one.  To revert to a stable release, download the latest stable release from

<https://raw.githubusercontent.com/bedrocklinux/bedrocklinux-userland/0.7/releases>

and pass it to `brl update` with the `--force` flag to instruct `brl update` to continue despite the operation being a down-grade:

- {class="rcmd"}
- /bedrock/bin/brl update --force ./bedrock-linux-~(version~)-~(architecture~).sh

If your system is broken to the point where this does not work, you can run the installer/updater script directly with the `--force-update` flag:

- {class="rcmd"}
- sh ./bedrock-linux-~(version~)-~(architecture~).sh --force-update

However, this bypasses the cryptographic signature verification `brl update` would have performed, and thus should be avoided if `brl update` is available.

Upgrading to a newer release will indicate whether or not a reboot is required.  However, downgrading will not.  It may be wise to reboot following a downgrade just in case.
