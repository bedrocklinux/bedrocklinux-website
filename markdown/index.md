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

## {id="olf-2012-video"} Ohio Linuxfest 2012 Presentation Video
<small>2013-10-31</small>

The audio from the Bedrock Linux presentation at the 2012 Ohio Linuxfest was
recorded.  This has been played over the slides and is available to be viewed
as a video [here](https://www.youtube.com/watch?v=7lIWagDFm6c).  The audio
recording can be found [here](https://archive.org/details/BedrockLinux) and the
slides can be found [here](media/bedrocklinux-olf.pdf)

## {id="bosco-backport-bru"} Flopsie feature backported to Bosco
<small>2013-10-13</small>

Flopsie plans discussed [here](http://bedrocklinux.org/1.0alpha4/plans.html)
are showing promising results.  One of the features, the union filesystem intended to fix the /etc-issue, has been backported to Bosco for those who are interested in trying it out before Flopsie is ready.  See [here](http://bedrocklinux.org/1.0alpha3/backports.html) for instructions on how to install the backport.

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
 - Updates to `brs` to let it setup/teardown clients on-the-fly
 - Updates to `bri` including:
     - the ability to indicate which client is providing a given PID.
 - Updates to `brw` (essentially aliasing `bri -w/W` if provided at least one argument).
 - A script to automate acquiring and setting up (some) client distributions.
 - a new `brp` which:
     - updates the BRPATH on-the-fly (no more manually running `brp`)
     - can force a given executable to always be provided by the same client (out-prioritizing local-to-client executables).
     - can force a given executable to always be provided *only* locally, even if it could be provided to another client.  Good to avoid confusion in some cases (e.g.: local `python` vs shared `python2`)

See the [Flopsie Plans page](1.0alpha4/plans.html) for more details.

[See older news items](news.html)
