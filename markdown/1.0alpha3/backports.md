Title: Bedrock Linux 1.0alpha3 Bosco Backports
Nav: bosco.nav

Functionality Backported From Flopsie
=====================================

One of the key features of the upcoming release of Bedrock Linux, Flopsie, is a
new union filesystem intended to fix the
[/etc-issue](http://bedrocklinux.org/issues/issue-ed10277445e2bc796171ca53603f0894f300a5ef.html).  This has been backported to Bosco for those who would like to try it out without having to wait for Flopsie's release.
Note that this backport has had minimal testing and may be potentially
problematic.  If you experience problems, rolling back to Bosco's setup is
advised.

Note: This filesystem is named "bru".  The utility update utility previously
known as "bru" will be merged into another utility, tentatively named "pmm".
Apologies for the confusion - it is best to get it out of the way now while the
project is still in alpha.

Additionally note that this requires support for FUSE either built-in to the
kernel or as a readily accessible kernel module.

Upgrade instructions
--------------------

Make a directory in which to download and compile the necessary components as
well as a directory in which to "install" a local development stack.

	mkdir -p ~(/tmp/backport/src~) ~(/tmp/backport/dev~)

Download the backported version of bru from [here](https://raw.github.com/paradigm/bedrocklinux-userland/501f506c5892cf6ffec141633c5ad33578802180/src/bru/bru.c) and source for the musl libc library from [here](http://www.musl-libc.org/) and FUSE [here](http://fuse.sourceforge.net/) into ~(/tmp/backport/src~).  Note that both projects have patches for bru and, at the time of writing, the latest version development (HEAD from git) of both is required.  At the time of writing the version of latest stable musl is 0.9.14, and so most likely any later version *not* including that version most likely will work.  For FUSE, bru will require 3.X.

Compile and install musl with the `--prefix` into the local development stack
location.

- {class="cmd"}
- cd ~(/tmp/backport/src/musl~)
- make clean
- ./configure --prefix=~(/tmp/backport/dev~) --disable-shared --enable-static
- make
- make install

Compile and install FUSE, again with the `--prefix` into the local development
stack location.  Use the `musl-gcc` wrapper created by musl as the `CC`.

- {class="cmd"}
- cd ~(/tmp/backport/src/fuse-fuse~)
- make clean
- ./makeconf.sh
- ./configure --prefix=~(/tmp/backport/dev~) --disable-shared --enable-static --disable-util --disable-example
- make CC=~(/tmp/backport/dev/bin/musl-gcc~)
- make install

Utilize this newly created development stack to compile bru.c.  Make the output
name `brU` with a capital "u" to differentiate it from Bosco's `bru` update
utility.  In the following release it will just be `bru` and what is now `bru`
will be merged into a placeholder for `pmm`.

- {class="cmd"}
- cd ~(/tmp/backport/src~)
- ~(/tmp/backport/dev/bin/musl-gcc~) -Wall bru.c -o brU -lfuse3

Install `brU`.

	{class="rcmd"} cp /tmp/backport/src/brU /bedrock/sbin/brU

Comment out the share items from your `/bedrock/etc/brclients.conf` which share
files in `/etc`.  This will be setup to be shared with `brU` directly in `brs`
- keep the list.

Next `brU` should be added to `brs` so that it is set up at boot.  First, back
up `brs` so that you can undo this later:

	{class="rcmd"} cp /bedrock/sbin/brs /bedrock/sbin/brs-backup

Open up `/bedrock/sbin/brs` in your preferred text editor and add the
following:

	if [ "$CLIENT" != "bedrock" ]
	then
		brc $CLIENT /bedrock/sbin/brU /etc /var/chroot/$CLIENT/etc \
		/var/chroot/bedrock/etc ~(/profile /hostname /hosts /passwd \
		/group /shadow /sudoers /resolv.conf~) &
	fi

after the `done` in the inner for loop (and just above the final `fi` in the
script).  Adjust the arguments *after* `/var/chroot/bedrock/etc` to the list of
files you would like shared in `/etc`.

Finally, you need to make sure the FUSE module is `modprobe`'d.  *If* you
compiled your kernel with fuse built-in, you can skip this step.  Otherwise,
add the following to `brs` just before the line `RESULTS=0`:

	brc ~(client~) modprobe fuse

Where ~(client~) is a client which has a version of `modprobe` which can load
the module.  Some distros compress their modules; distros which do not may not
have `modprobe` configured to decompress modules.

At this point you should be good to go - all you need to do is reboot.

Rolling back the backport
-------------------------

If the backport is not working for you, you can roll it back by doing the
following:

	{class="rcmd"} cp /bedrock/sbin/brs-backup /bedrock/sbin/brs

and then re-adding the commented out `/etc` items from
`/bedrock/etc/brclients.conf`.

