Title: Contributing to Bedrock Linux
Nav:   home.nav

# Contributing to Bedrock Linux

There are several ways to contribute to ~+Bedrock Linux~x depending on your
background and time.

Some users have reported coming here looking for low hanging programming
tickets to help knock out.  For better or worse, ~+Bedrock~x's long development
history, care to avoid feature creep, and care to avoid unnecessary churn has
left few such possibilities at this point.

TableOfContents

## {id="help-support-others"} Help support others

The primary limiting factor for ~+Bedrock~x development is user support.
Helping here would free up limited resources for research and development
efforts.

Consider learning ~+Bedrock Linux~x well yourself, such as from using it and
watching others answer questions.  Then, once you are adequately knowledgable,
consider watching places such as:

- [IRC: #bedrock on libera.chat](https://libera.chat)
- [Discord](https://invite.gg/bedrocklinux)
- [LQ forum](http://www.linuxquestions.org/questions/bedrock-linux-118/)
- [Reddit](http://reddit.com/r/bedrocklinux)
- [Userland Github](https://github.com/bedrocklinux/bedrocklinux-userland)
- [Website Github](https://github.com/bedrocklinux/bedrocklinux-website)

and if you see questions you are adequately confident you know how to answer,
help out.

## {id="documentation-and-code-review"} Documentation and code review

English isn't amenable to unit tests.  Consider reviewing ~+Bedrock Linux~x's
[website/documentation](https://github.com/bedrocklinux/bedrocklinux-website).
Look not only for spelling and grammar issues but also out of date information
or insufficiently clear expression of concepts.

Similarly, consider reviewing [the code
base](https://github.com/bedrocklinux/bedrocklinux-userland).  Given enough
eyeballs, all bugs are shallow.

## {id="distro-maintainer"} Become a distro maintainer

Traditional Linux distributions have package maintainers: people who maintain a
given package for the distribution.  They watch upstream changes to ensure
nothing breaks and actively fix issues as they arise.

~+Bedrock Linux~x's equivalent are distro maintainers.  We need people who know
both a given traditional distro *and* ~+Bedrock~x well.  These people would
then do things such as:

- Actively use the distro in conjunction with ~+Bedrock~x.
- Proactively watch the distro's development and prepare for any potentially
  breaking changes.
- Regularly test that the ~+Bedrock~x hijack install process works against the
  distro.
- Regularly test that `brl fetch` knows how to fetch the distro.

The current list of distro-maintainer pairings can be found
[here](0.7/distro-support.html).

At the time of writing, no distro has multiple maintainers.  This is not a
deliberate limitation.  If you can help out and take pressure off an existing
distro maintainer, please do so.

While there are no formal requirements, a history of "unofficially" maintaining
a distro by actively helping with it in the ~+Bedrock~x community would be
beneficial before seeking the associated title.

If you are seriously considering this, please contact paradigm.

## {id="compatibility"} R&D for compatibility issues

While quite a lot "just works" with ~+Bedrock~x, some things require
work-arounds and others do not work at all.

If you have adequate background, consider researching open compatibility
problems:

- [Distro compatibility](0.7/distro-compatibility.html)
- [Feature compatibility](0.7/feature-compatibility.html)

or [known issues](0.7/known-issues.html).

If you see a way to improve things, consider coding and [upstreaming
it](https://github.com/bedrocklinux/bedrocklinux-userland)

If there is limited documentation available on a given issue, it's likely
because there is limited research into it at this point.  Many of these issues
may require quite some digging to resolve.
