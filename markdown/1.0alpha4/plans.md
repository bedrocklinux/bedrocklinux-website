Title: Bedrock Linux 1.0alpha4 Flopsie Plans
Nav: flopsie.nav

# Bedrock Linux 1.0alpha4 Flopsie Plans

This page serves to describe plans for the then-upcoming release of Bedrock Linux,
1.0alpha4 "Flopsie". Flopsie has since been released on 2013/12/30.  The
following is thus out-of-date, but is kept in case anyone is curious.

## /etc issue fix

All public releases of Bedrock Linux prior to Flopsie have been unable to
properly share several files in `/etc` such as `/etc/passwd`.  Manual
work-arounds have been available but are unsatisfactory in the long term.
Flopsie will include a new FUSE union filesystem (tentatively named "brf")
which should be able to properly handle the /etc issue situation.  In theory
this new filesystem could completely replace bind-mounts for Bedrock Linux and
significantly simplify the mount table; however, brf will likely have a
non-negligable performance overhead and is thus only current intended to patch
corner-cases in which bind-mounts are insufficient.

## Installation scripts

Most of Bedrock Linux's development time has gone towards how it works
under-the-hood.  Aspects of installation have been extremely low priority.
Flopsie will being the efforts to turn this around.  It will include a POSIX
shell script which will automate some of Flopsie's installation steps.  To aid
this, several things which were previously up to the end-user will now be
standardized.  This includes the standard C library for core components
(planned to be musl) and the installation location for clients (planned to be
/bedrock/clients/)

## brs updates

`brs` will be updated to include the following capabilities:

- Set up mount points for a client on a live, running system.  Combine with
  `brg` below this should make it relatively easy to spin up a new client.
- Remove all mount points for a client on a live, running system.
    - This will make it easy to either temporarily disable a given client or remove it completely.
- Detect the state of a given client.
   - Has all required mounts, has some required mounts, has no required mounts
   - Is providing some processes, is not providing any processes

## bri updates

`bri` will be updated to include the follow changes:

- `bri` will be able to indicate which client is providing a given process
    - It can tell from a given PID or program name (it will use busybox's `pidof` internally)
- `bri` will be able to list all of the process provided by a given client.
- Some changes will be made to `-w` and/or `-W`
    - People have been finding the difference between the two confusing; one will likely be dropped.

## brw updates

As of Bosco, `brw` is just a short alias to `bri -n`; that is, `brw` will
indicate which client provides calling program (usually a shell).  Flopsie will
have `brw` be an alias for `bri -w` (or `-W`) if at least one argument is
provided so that `brw ~(program-name~)` will indicate which client will provide a
given executable, since this, like `bri -n`, is very commonly used.

## brg (delayed to hawky)

Flopsie will include a new Bedrock Linux utility, `brg`, which can be used to
acquire a new client.  For example (syntax still tentative):

    brg debian 6.0 amd64 wheezy

Could be used to install a x86_64 Debian 6.0 client in `/bedrock/clients/wheezy`.
This will hopefully be able to get the client from one of the following
sources:

- an [openvz template](http://openvz.org/Download/template/precreated) (very portable, should almost always be available)
- [debootstrap](http://wiki.debian.org/Debootstrap) or [febootstrap 2.X](http://people.redhat.com/~rjones/supermin/) (if the command is available - install in a client to use)
- [archbootstrap](https://github.com/tokland/arch-bootstrap/) if dependencies are met (currently depends on bash which is not provided by busybox).
- gentoo stage3 tarballs

Note that it will *only* provide a client available from sources which are
available.  If you'd like to install a Linux distribution which is not provided
from one of the above sources, you will have to fall back to installing it
manually (such as via its normal installation method on another partition or in
a VM and then copying the contents out).

## brp update (delayed to hawky)

The current release of Bedrock Linux, 1.0alpha3 "Bosco", requires users run the
`brp` utility every time an executable is added or remove from the system.

Bosco also lacks the ability to cleanly ensure that a given executable is
always provided by a given client, or that a given executable is always
provided *only* locally.

Flopsie plans to address both of these issues with a new `brp`.  This `brp`
will be a FUSE filesystem that will effectively populate the brpath directories
on-the-fly and thus always be up-to-date.  It will be configurable to ensure a
listed executables are always provided by a given client or never provided
through the brpath system at all.

Additionally, Bosco does not have a clean way to ensure a given executable is
*always* provided by the same client, irrelevant of what the client may have
natively.  These two issues will be addressed with a FUSE virtual filesystem .
It will be mounted at `/bedrock/brpath/` and have something along the following
root-level directory structure:

- `/bedrock/brpath/prebin/`
- `/bedrock/brpath/presbin/`
- `/bedrock/brpath/postbin/`
- `/bedrock/brpath/postsbin/`
- `/bedrock/brpath/reparse_configs`

To improve performance, the contents of the configuration files this new `brp`
will utilize will be cached rather than re-read as needed.  Thus manual work is
necessary to inform a mounted `brp` filesystem that their contents have
changed.  Something like this is expected:

    {class="rcmd"} echo 1 > /bedrock/brpath/reparse_configs

## brinfo virtual filesystem (cancelled)

There were prior plans to include a virtual filesystem which can be accessed to
get information about Bedrock-related systems akin to procfs or sysfs.
However, this is no longer planned for Flopsie.  It may or may not be picked up
again in another release.
