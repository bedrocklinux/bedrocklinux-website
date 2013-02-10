Title: Bedrock Linux
Nav:   home.nav

Bedrock Linux
=============

Bedrock Linux is a Linux distribution created with the aim of making most of
the (often seemingly mutually-exclusive) benefits of various other Linux
distributions available simultaneously and transparently.

If one would like a rock-solid stable base (for example, from Debian or a RHEL
clone) yet still have easy access to cutting-edge packages (from, say, Arch
Linux), automate compiling packages with Gentoo's portage, and ensure that
software aimed only for the ever popular Ubuntu will run smoothly - all at the
same time, in the same distribution - Bedrock Linux will provide a means to
achieve this.  [Watch a
demonstration](http://www.youtube.com/watch?v=MuYMBCcgs98) and read the
[introduction](introduction.html) and [FAQ](faq.html) for more.

## {id="bosco-update"} Bedrock Linux 1.0alpha3 Bosco update
<small>2013-01-16</small>

Bosco has been updated, fixing various issues.  If you are currently using a
Bosco installation from before 2012-01-16, it is recommended you update.
Download and untar the [userland](1.0alpha3/bedrock-userland-1.0alpha3.tar.gz)
to a temporary directory (such as `/tmp/bosco-update`), and replace the
following files from the core system with those from the userland tarball:

- /etc/init.d/rcS
- /etc/init.d/rcK
- /etc/init.d/rc.local
	- careful not to overwrite any settings you may have placed in here
- /bedrock/bin/brc
	- you'll have to compile the updated brc.c
		- `gcc -Wall brc.c -o /bedrock/brc/brc -static -lcap`
		- `{class="rcmd"} setcap cap_sys_chroot=ep /bedrock/bin/brc`
- /bedrock/sbin/bru

## {id="bosco-release"} Bedrock Linux 1.0alpha3 Bosco released
<small>2012-12-25</small>

The third Bedrock Linux release, 1.0alpha3 Bosco has been released.
See the high-level changelog [here](1.0alpha3/changelog.html)

## {id="linux.com-new-distros"} Bedrock Linux mentioned on linux.com
<small>2012-12-12</small>

Bedrock Linux was mentioned in an [article on
linux.com](https://www.linux.com/news/hardware/desktops/679646-6-linux-distros-born-in-2012/)
about new Linux distributions created in 2012.

[See older news items](news.html)
