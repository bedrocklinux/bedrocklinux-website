Title: Bedrock Linux 1.0alpha4 Flopsie Known Issues
Nav: flopsie.nav

# Bedrock Linux 1.0alpha4 Flopsie Known Issues

- [Man pages do not work across clients](#manpages)
- [Debian-based clients: statoverride problems](#statoverride)
- [No init hooks for daemons](#init)

## {id="manpages"} Man pages do not work across clients

While Bedrock Linux ensures executables work across clients, no work has yet
been done to get man pages to work similarly.  See
[here](http://bedrocklinux.org/issues/issue-2e03cf889532e11876db8b76a2263e206fabdab4.html)
for the issue tracker.

## {id="statoverride"} Debian-based clients: statoverride problems

Occasionally, apt/dpkg will complain about issues with "statoverride". This
most likely occurs because it expects a daemon should be running, but it is
not. This can be fixed in this instance by simply removing the contents of
/var/lib/dpkg/statoverride. Simply leave an empty file in that location.

## {id="init"} No init hooks for daemons

On typical Linux distributions, upon installing a package which should start a
daemon at boot, the package would somehow leave indications for the init system
on how it should be started.  Bedrock Linux does not currently recognize any of
these.  It is still possible to utilize daemons (start them at boot, stop at
shutdown, start/stop/restart/get-status during normal usage, etc); however, it
is up to the user to determine exactly what commands should be run to make this
happen and configure the system to do these manually.
