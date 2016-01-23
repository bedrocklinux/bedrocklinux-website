Title: Bedrock Linux 1.0beta2 Nyla Plans
Nav: nyla.nav

Bedrock Linux 1.0beta2 Nyla Plans
=================================

This page serves to describe plans for the then-upcoming release of Bedrock
Linux 1.0beta2 "Nyla".  Nyla has since been released on January 16th, 2016.

## Init from clients

As of 1.0beta1 Hawky, Bedrock Linux utilizes its own, very limited, init.  This
was intended as a stop-gap solution until Bedrock Linux was able to utilize
init from other distributions.  1.0beta2 Nyla should finally reach this goal.

The primary difficulty in doing this is a catch-22 situation: init systems
expect to be the first thing which is run; however, Bedrock Linux needs to run
~{client~} setup code before anything from a ~{client~} is run.  For example, systemd
expects to be PID1.  If another process is run first to setup the ~{client~} and
forks off systemd, systemd cannot be PID1.  If systemd is run directly without
setup, it will not utilize the ~{local~}/~{global~} system and either fail to
run properly due to missing ~{local~} dependencies or fail to see ~{global~}
files such as `/etc/passwd`.

The plan to solve this revolves around the fact that the `exec()` system call
*does not change PIDs*.  The parent process is *replaced* by the new code.
Thus, if the kernel/initrd calls a Bedrock Linux `/sbin/init`, that can setup
~{clients~} and then `exec()` the ~{client~}'s init (through `brc`) such that the
~{client~}'s init is still technically PID1.

Additional considerations must be made.  For example, systemd attempts to
change the [shared/slave/private attribute](http://lwn.net/Articles/159077/) of
the root filesystem.  When doing this, it assumes that the root directory `/`
is a mount point.  This is, typically, a very reasonable assumption.  However,
the way Bedrock Linux works as of Hawky, this is not necessarily the case.  In
order to handle this, Nyla will require some if not all ~{clients~} to have
their ~{local~} root directory be a mount point.  This can be achieved quite
easily via a bind-mount; however, various Bedrock Linux utilities and
configuration formats must be adjusted to handle this change.

Another concern is that, while the `exec()` plan will allow Bedrock Linux to
run code at boot in a way that does not interfere with a ~{client~} init, the
same technique may not be used to run code at shutdown.  ~{Client~} inits may
not be able to properly umount mount points from other ~{clients~}.  Bedrock
Linux may need to hook into ~{client~} inits to run shutdown code.  This may
involve running `brs disable` on other ~{clients~} followed by a `pivot_root`
to disable Bedrock Linux's ~{local~}/~{global~} system for the init ~{client~}.
At the time of writing, a generic way to have run Bedrock Linux code when a
~{client~} init is shutting down is an open problem.

## Breaking the core into "global" and "fallback"

As of Bedrock Linux 1.0beta1 Hawky, a chunk of the system usually referred to
as "the core" or "bedrock-as-a-~{client~}" serves multiple purposes in a way that
is not immediately clear to new users.

1. It serves as the location where the one copy of ~{global~} files reside.
2. It provides basic services, such commands like `ls` and `sh`, in case other
   ~{clients~} fail to do so.

The core shows up in commands such as `bri -l` as "bedrock".  This name does
not imply either of the services it provides.  Moreover, it results in a bit of
a smurf-style filesystem.  When installing Bedrock Linux, users will have a
`/mnt/bedrock/bedrock/clients/bedrock` path.  The word "bedrock" loses meaning
in such situations.  It also seems to encourage the idea that Bedrock Linux is
doing something similar to containers, as some of the system is `chroot()`'d
while some is, debatably, not; this results in a fair bit of confusion.

To remedy the above issues, bedrock-as-a-~{client~} should be broken up into two
~{clients~}: "global" and "fallback".

The global client will *only* contain (1) ~{global~} files, (2) the `/bedrock`
directory (which contains various Bedrock Linux subsystem related executables,
the clients, etc), (3) /boot, and (4) /sbin/init as is needed for [this
issue](https://github.com/bedrocklinux/bedrocklinux-userland/issues/5).  Global
should not have a `/etc/init.d/` or `/bin/` directory in its root or anything
else that is typically ~{local~}.  `/sbin/init` will call
`/bedrock/bin/busybox` to get its required executables.  It will be technically
possible to run a shell with ~{global~} files as the ~{local~} files it via
`brc global /bedrock/bin/busybox sh`.  The only processes that will be
typically run in the global ~{client~} are: `/sbin/init` (and only for a short
time to bootstrap another ~{client~}'s init) and `brp` (as the filesystem it
makes should be ~{global~}).  The global client will not have a client.conf
file - its access will be hardcoded into the various Bedrock Linux utilities.

Fallback will be technically optional but recommended.  Fallback will contain a
`/bin` and other things which are typically expected to be available on a Linux
system, albeit a minimal version.  It will provide a minimal init - effectively
what is being used as of Hawky as *the* init.  It will use a client.conf like
every other ~{client~}; it can be disabled or removed entirely.

## BedRock Get ("brg")

Nyla will yet again attempt to include the `brg` utility which was previous
planned for 1.0alpha4 Flopsie.  This utility will be used to automate acquiring
~{clients~}.  Ideally, a single command can be run which will automatically
acquire and setup all the files necessary for a ~{client~} from a desired Linux
distribution.  This command could be used both during normal Bedrock Linux
usage as well as during installation (which could then be used to automate
acquiring a kernel during installation, for example).

Various tools exist to bootstrap Linux distributions; however, many of these
require distribution-specific code.  For example, `debootstrap` can be used to
bootstrap Debian-based systems; however, it requires `dpkg`.  Similarly, `yum`
can be used to install a new RHEL-based system; however, `yum` itself must be
available for this.  This results in a catch-22 situation for Bedrock Linux
users: to acquire a ~{client~}, one must first have a similar ~{client~}.

Various strategies are being pursued to bootstrap the bootstrap code in a
portable manner, some of which are discussed
[here](https://github.com/bedrocklinux/bedrocklinux-userland/issues/13#issuecomment-47219088).

## brp pinning

As of Hawky, when accessing a ~{local~} file, if the file exists:

- If the file is accessed ~{directly~}, the process will see the instance of
  the file corresponding to its ~{client~}.
- If the file is accessed ~{explicitly~}, the process will see the instance of
  the file from the specified ~{client~}.
- If the file is accessed ~{implicitly~}, either the ~{direct~} version will be
  provided if it exists, or, failing that, the process will get the instance of
  the file from the highest-priority ~{client~} that can provide the file.

The way ~{implicit~} access is handled is potentially problematic in that it
may seem inconsistent:

- The ~{direct~} version will change depending on the calling process's
  ~{client~}.  For example, if file is a pdf reader, and the user attempts to
  run the pdf reader from a `bash` prompt where `bash` is provided by a gentoo
  ~{client~} and gentoo provides the pdf reader, gentoo's pdf reader will start.
  However, if the pdf reader is automatically launched from a web browser, and
  the web browser if from an arch ~{client~}, and arch provides the pdf reader,
  arch's instance will start instead.
- If only one (relatively low-priority) ~{client~} provides a file, a user may
  become accustomed to expecting that file from that ~{client~}.  If another
  higher-priority ~{client~} gets the file, such as from a
  `{class=rcmd} apt-get dist-upgrade`, which ~{client~} provides the discussed
  file will change.

While this is often acceptable (differences in versions of the `ls` utility are
quite minor across distributions), there may be times when a user would prefer
the same version of a file be accessed consistently.  To provide this
functionality, `brp` will be expanded to include the ability to create new
directories which will be placed at the very front of the `$PATH`-like
environmental variables.  The files generated in these new directories will
thus always be the versions accessed via ~{implicit~} access.

Which files are pinned will be determined by:

- Automated Bedrock Linux systems where needed.  For example, commands such as
  `reboot` should always be provided from the ~{client~} that provides the init
  process.
- Configuration the end-user can set.  If a given Bedrock Linux system ends up
  with multiple ~{clients~} being able to provide `startx`, but the user would
  like a given ~{client~} to *always* provide `startx`, this can be configured via
  pinning.

Additionally, it may be possible to configure the given item to effectively
disable the ~{implicit~} access for a given item so it is always accessed
either from the same client or ~{explicitly~} or not at all, if this is
desired.
