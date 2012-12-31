Title: Bedrock Linux 1.0alpha3 Bosco Known Issues
Nav: bosco.nav

# Bedrock Linux 1.0alpha3 Bosco Known Issues

- [/etc File Sync Issue](#etc)
- [Difficulty Statically Compiling Busybox](#static)
- [Man pages do not work across clients](#manpages)
- [Debian-based clients: statoverride problems](#statoverride)

## {id="etc"} /etc File Sync Issue

Individual files, when "shared" via bind mounts, cannot be moved
over.  This is particularly problematic for files such as `/etc/passwd` which are normally updated by creating a new file and moving it over the previous one.

Work arounds:

- You could share these files and manually "update" them.  If the "groupadd" command is run, it will fail and leave a temporary file such as "/etc/group+" behind.  You can cat this file over the normal "/etc/group" file to finalize the command yourself, like so:

		cat /etc/group+ > /etc/group && rm /etc/group+

- You could avoid sharing these files files through the brclients.conf system and manually sync them when one changes.  For example, if "groupadd" is run, you could run the following:

		cp /etc/group /tmp/ && brl cp /tmp/group /etc/group && rm /tmp/group

This assumes `/tmp` is shared between clients.

Work is underway to create a daemon to automate this second option.  See here for its current state, see [here](http://bedrocklinux.org/issues/issue-a158e55ccf9aa3f6eb8036fb086f83c8cdab0cd9.html).

See [here](http://bedrocklinux.org/issues/issue-ed10277445e2bc796171ca53603f0894f300a5ef.html) for issue tracker page for the issue.

## {id="static"} Difficulty Statically Compiling Busybox

Difficulty statically compiling busybox have been noted, somewhat dependent on
the client/installer host used. This is caused by conscious limitations placed
in libraries available in many Linux distributions, particularly glibc.

Work arounds:


- One of the changes since Momo is that Bosco supports using pre-compiled
  static busybox from another Linux distribution, such as (infact, preferably)
  from a client.  You just have to make sure it [meets a a few
  requirements](install.html#busybox-test).
- Compile against a different library, such as [uclibc](http://www.uclibc.org/)
  (a sister project of busybox) or [musl](http://www.musl-libc.org/).  If you'd
  like to try using uclibc, look into
  [buildroot](http://buildroot.uclibc.org/), a tool to aid with such things.
  If you'd rather try musl, note that the [sabotage
  linux](https://github.com/rofl0r/sabotage) project uses musl to compile
  busybox and may be worth looking into.

## {id="manpages"} Man pages do not work across clients

While Bedrock Linux ensures executables work across clients, no work has yet
been done to get man pages to work similarly.  See
[here](http://bedrocklinux.org/issues/issue-2e03cf889532e11876db8b76a2263e206fabdab4.html)
for the issue tracker.

## {id="statoverride"} Debian-based clients: statoverride problems

Occasionally, apt/dpkg will complain about issues with "statoverride". This
most likely occurs because it expects a daemon should be running, but it is
not. This can be fixed in this instance by simply removing the contents of
/var/lib/dpkg/statoverride. Simply leave an empy file in that location. This
may come up repeatedly - no work has yet been done to find a permanent
solution.  See
[here](http://bedrocklinux.org/issues/issue-5b1deb0fff09c4e796bd9421b7014ccb89894f99.html)
for the issue tracker.
