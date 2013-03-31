Title: Bedrock OSX
Nav:   home.nav

Bedrock OSX
=============

Bedrock OSX is a project to allow a user to get the benefits of multiple
releases of Apple OSX - the world's most advanced desktop operating system -
simultaneously and transparently, without the overhead of virtual machines.
You can simply store the contents of a various OSX release on-disk, then use
the Bedrock OSX system to have components of these older OSX releases
integrated with each other.  You get all of the flawless beautify and
simplicity of Apple's current masterpieces without losing the flawless beautify
and simplicity of Apple's previous masterpieces.

## {id="switch-osx"} Bedrock Switching to OSX
<small>2013-04-01</small>

The primary complaint about the Bedrock OS project throughout its history is
that it is insufficiently user friend.  To quote Jonathan Corbert of Linux
Weekly News:

> [Bedrock Linux] may be especially well suited for those users who have gotten
> frustrated with the way distributions like Gentoo do everything for them.

Clearly, this needs to be remedied.  The Bedrock Linux developers feel very
strong that if you're going to do something, you should do it right, and no
Linux-based operation system has ever gotten the reputation for
user-friendliness that OSX has.  Switching to OSX is a necessity if the Bedrock
OS is ever going to become truly user friendly.

From a technical standpoint it seems quite doable.  The crux of how Bedrock
works under the hood - chroot() - is available on OSX as well.  Apple OSX is
UNIX.  Moreover, work to make things like CUPS or webkit work on Bedrock will
cleanly carry over.

Really, there isn't any downside.  This Linux thing was never going to catch on
anyways.  The upsides, though, are tremendous.  Consider:

- Rosetta - the PowerPC-x86 binary translator for OSX - is not supported on OSX
  as of 10.7 "Lion".  What about those poor people who bought software like
  Diablo 2 for OSX in the PowerPC days?  With Bedrock OSX, they can just use an
  older OSX release that supports Rosetta and play Diablo 2 on their shiny
  newer OSX!

- The latest version of OSX, as of the time of writing, has some applications
  crash when a user enters "FILE:///" into a number of text objects, such as a
  Finder window's search box.  Prior releases of OSX did not have this.  You
  could simply use an older Finder release until this is fixed!

- With Linux, the lack of standardization makes developing Bedrock OS a pain.
  If some obscure distro does things in a way the Bedrock developers are not
  familiar, it might not work out of the box as a client.  OSX, however, has a
  known number of releases.  We just have to support those.  Much easier.
  Bedrock development will likely speed up greatly once the switch has occurred.

However, converting the base project will take about one year.  Expect Bedrock
OSX to be available on April 1st, 2014.

[See older news items](news.html)
