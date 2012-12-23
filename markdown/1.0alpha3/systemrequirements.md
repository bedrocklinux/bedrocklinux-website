Title: Bedrock Linux 1.0alpha3 Bosco System Requirements
Nav: bosco.nav

# Bedrock Linux 1.0alpha3 Bosco System Requirements

Note that the system requirements for this release of Bedrock Linux (1.0alpha3
Bosco) have not changed from either prior release.

Bedrock Linux itself is quite minimal and will run on very limited hardware.
However, the client software Bedrock Linux will use will most likely require
significantly higher system requirements. See the documentation for the
specific client distributions you wish to use.

- [CPU Architecture](#cpu-arch)
- [CPU Speed](#cpu-speed)
- [RAM](#ram)
- [Storage](#storage)

## {id="cpu-arch"} CPU Architecture

Bosco has been tested on (32-bit) x86 and (64-bit) x86-64 systems. In theory it
should be possible to set it up on non-x86 architecture with only minor changes
- such as swapping out the bootloader - being necessary, but no effort was put
into ensuring this was an option and no testing was done to actually check that
this is possible.

## {id="cpu-speed"} CPU Speed

Prior releases have been show to run smoothly on both a 1.6GHz Intel Atom and
800MHz Intel Celeron-M (ie, two different ASUS Eee PCs), and it is expected
that Bosco should only improve upon this. Presumably significantly slower CPUs
will also suffice. Remember, though, some client software will likely have
higher requirements to run adequately. 

## {id="ram"} RAM

Prior releases have been shown to run without trouble on 512MB of RAM with huge
amounts of room to spare, and Bosco should only improve upon this. Much smaller
amounts of RAM would likely work fine for the core Bedrock Linux software, but
higher amounts will likely be expected by some client software you may choose
to run.

## {id="storage"} Storage

Depending on what you choose to compile into the Linux Kernel and Busybox, Bosco
fit snuggly within only a handful of megabytes of disk space (although a
fully-loaded Linux Kernel can take tens if not hundreds of megabytes). However,
Bedrock is nearly useless without any clients, and the clients can take quite a
bit of space. See the disk space requirements for the client Linux
distributions you are interested in. As a rule of thumb, a gigabyte of disk
space should be set aside for each client distribution, with more preferred. 
