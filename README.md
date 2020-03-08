Bedrock Linux Website
=====================

This repository tracks the source code of the [Bedrock Linux website](http://bedrocklinux.org).

To build the website, install:

- [`markdown`](https://daringfireball.net/projects/markdown/).
- `make`
- Standard UNIX utilities such as `awk` and `sed`.

Then run `make`.  It may be parallelized, e.g. `make -j4`.

The bulk of the syntax is [the original markdown](https://daringfireball.net/projects/markdown/)
with various project specific alterations.  An incomplete list of such changes
include:

- Various simple project-specific markup such as `~(foo~)`
- Tables
- Page title and navigation bar information
