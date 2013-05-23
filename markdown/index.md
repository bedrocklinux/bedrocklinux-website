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

## {id="tllts-podcast"} Bedrock Linux Interviews
<small>2013-05-23</small>

The founder and lead developer of Bedrock Linux was interviewed on not one, but
two Linux podcasts in the last few days:  Linux in the Ham Shack and The Linux
Link Tech Show.  If you would like to listen in, both were recorded.  Linux in
the Ham Shack's podcast is not up yet, but you can listen to TLLTS here:

http://tllts.org/rsspage.php

Look for episode 506 on May 22, 2013.  The discussion veers away from Bedrock
Linux after about the first hour.

Another news item will likely be put up once the Linux in the Ham Shack
interview, episode 107, goes up.

## {id="switch-osx"} Bedrock Switching to OSX (April Fools 2013)
<small>2013-04-01</small>

The April fools joke for 2013:

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
