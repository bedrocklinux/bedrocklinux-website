Title: Bedrock Linux 1.0alpha4 Flopsie System Requirements
Nav: flopsie.nav

# Bedrock Linux 1.0alpha4 Flopsie System Requirements

Bedrock Linux itself is relatively minimal and will run on very limited hardware.
However, the client software Bedrock Linux will use will most likely require
significantly higher system requirements. See the documentation for the
specific client distributions you wish to use.

- [CPU Architecture](#cpu-arch)
- [CPU Speed](#cpu-speed)
- [RAM](#ram)
- [Storage](#storage)

## {id="cpu-arch"} CPU Architecture

Bosco has been tested on (32-bit) x86 and (64-bit) x86-64 systems. In theory it
should be possible to set it up on any architecture
[musl-libc](http://www.musl-libc.org/) supports.

## {id="cpu-speed"} CPU Speed

Prior releases have been show to run smoothly on both a 1.6GHz Intel Atom and
800MHz Intel Celeron-M (ie, two different ASUS Eee PCs).  Presumably
significantly slower CPUs will also suffice. Remember, though, some client
software will likely have higher requirements to run adequately. 

## {id="ram"} RAM

Prior releases have been shown to run without trouble on 512MB of RAM with huge
amounts of room to spare. Much smaller amounts of RAM would likely work fine
for the core Bedrock Linux software, but higher amounts will likely be expected
by some client software you may choose to run.  Some additional RAM will be
required due to the fact that there will be multiple copies of some libraries
(such as the main libc libraries) and thus Bedrock Linux may not be suitable
for embedded-style systems.

## {id="storage"} Storage

Depending on what you choose to compile into the Linux Kernel and Busybox, Flopsie
fit snuggly within only a handful of megabytes of disk space (although a
fully-loaded Linux Kernel can take tens if not hundreds of megabytes). However,
Bedrock Linux is of limited use without any clients, and the clients can take quite a
bit of space. See the disk space requirements for the client Linux
distributions you are interested in. As a rule of thumb, a gigabyte of disk
space should be set aside for each client distribution, with more preferred.
