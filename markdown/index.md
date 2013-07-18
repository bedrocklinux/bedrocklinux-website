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

## {id="flopsie-delay"} Bedrock Linux 1.0alpha4 "Flopsie" delayed, additional features planned
<small>2013-07-17</small>

At this point in time it does not look like Bedrock Linux 1.0alph4 "Flopsie"
will be completed by the previous target date of "end of summer 2013".  The new
target date is January 1st, 2014.

The delay is entirely due entirely to time availability expectations not being
met, and is not the result of any unforeseen technical issues; the plans for
Flopsie still seem viable at this point in time.  The additional time allows
for additional goals for the next release.  In total, expect the following:

 - A fix for the /etc issue
 - Installation scripts; much less manual installation work.
 - Moving to musl as the standard C library for core components.
 - Updates to`brs` to let it setup/teardown clients on-the-fly
 - Updates to `bri` including:
     - the ability to indicate which client is providing a given PID.
 - Updates to `brw` (essentially aliasing `bri -w/W` if provided at least one argument).
 - A script to automate acquiring and setting up (some) client distributions.
 - a new `brp` which:
     - updates the BRPATH on-the-fly (no more manually running `brp`)
     - can force a given executable to always be provided by the same client (out-prioritizing local-to-client executables).
     - can force a given executable to always be provided *only* locally, even if it could be provided to another client.  Good to avoid confusion in some cases (e.g.: local `python` vs shared `python2`)

See the [Flopsie Plans page](1.0alpha4/plans.html) for more details.

## {id="lhs-podcast"} Bedrock on LHS Podcast 107 Now Available
<small>2013-06-30</small>

As was mentioned in the last news item, Bedrock Linux was on two podcasts
recently; however, only one was available online at the time.  The other
podcast is now available online, and can be found here:

http://lhspodcast.info/2013/06/lhs-episode-107-sorry-for-party-bedrocking/

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

[See older news items](news.html)
