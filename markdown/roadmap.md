Title: Bedrock Linux Roadmap
Nav: home.nav

Bedrock Linux Roadmap
=====================

The specific details of what Bedrock Linux hopes to accomplish varies from
release to release as new techniques are found to enable functionality
previously out of reach.  Should major discoveries be found, the roadmap may
change drastically.  Below is a rough roadmap assuming no such major surprises
occur.

## Near future releases

There are several broad areas of improvement Bedrock Linux will focus on in the
near future release:

- Ensuring features from various distributions "just work" in a Bedrock Linux
  environment.  For example, a known issue in 1.0beta2 Nyla is that ACLs and
  supplementary groups do not work with files in `/etc`.  This should be
  resolved eventually.

- Ensuring features from various distributions "just work" with each other.
  For example, as of 1.0beta2 Nyla, if a user installs an Xorg font from one
  distro it may not be immediately visible to an Xorg server from another
  distro.  While there are manual work-arounds to make things like this work,
  eventually they should be made to "just work" such that a user can install an
  Xorg font from any distro and have it immediately work with software from
  other distros.

- Automation should be made available for various tasks both during
  installation/setup and day-to-day usage of a Bedrock Linux system.  For
  example, as of 1.0beta2 Nyla, if a user would like to see a list of the
  various versions of a given package available on a Bedrock Linux system, that
  user would have to manually run several commands, one for each package
  manager available on the system.  While this strategy should remain available
  for those who want it, utilities should be made available to allow
  abstraction over the various package managers so that a single command would
  search all of them.

## Far future releases

Given the ambitious nature of the project, there is no guarantee *every* issue
covered by the "near future releases" may be solvable.  Eventually those
working on Bedrock Linux will reach some limit with regards to how far Bedrock
Linux can be pushed.  Once this limit is reached, the development focus will
move from research and user-facing polish towards improving underlying code
quality.

While concepts such as high percent unit test coverage are admirable, the
time/effort they require is largely wasted on early Bedrock Linux releases in
which it is not only possible but likely a new feature will require a
substantial change in strategy and, consequently, code.  Once ideas to push
Bedrock Linux have been exhausted and the general code churn slows this will
change.  Substantial refactoring/rewrites may be made as should they found to
be beneficial, along with heavy use of tooling (e.g. `valgrind`) and test
suites to minimize the chance of any Bedrock Linux bugs hampering a post-beta
"stable" release.

## Very far future releases

Bedrock Linux development has a number of self-imposed limitations followed to
maximize the flexibility and minimize the maintenance efforts of the resulting
system.  For example, users should not be required to regularly compile kernel
modules for Bedrock Linux specific features.  Post 1.0 stable, the project may
explore the benefits of dropping some of these requirements.  For example, it
may be worthwhile to have a single kernel module which handles all of the
filesystem redirection and abstraction on which Bedrock Linux depends.  If it
becomes evident a substantially improved system would result, work towards a
2.x release to replace 1.x may then follow.  If it becomes evident there is a
trade-off with no clear net win or loss, a 2.x may follow along to be developed
alongside a maintained 1.x for those who prefer it.
