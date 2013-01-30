Bedrock Linux Website
=====================

This is a repo of the [Bedrock Linux website](http://bedrocklinux.org).

Most of it is in plain markdown, with a few minor tweaks.  If you would like to
submit a change to the website (such as a typo fix, a work around for a known
bugs etc), it should be pretty easy to figure out what is going on and make
such changes.

To generate the website from the markdown source, simply run the
generate_website.sh script.  The only dependency in addition to UNIX utilities
(sh, awk, sed, grep, find, etc) is markdown and *gnu* awk ("gawk").  I might
later drop the gnu-isms from awk if there is interest.  If you don't have
markdown in your repository (apparently Gentoo lacks it?), it's just a perl
script you can download from
[here](http://daringfireball.net/projects/markdown/).

If you're interested in digging deeper, note that the website generation code
was not necessarily designed to be portable to other projects.  The atom.xml
for example is hardcoded to refer to Bedrock Linux.  If you want to press on
anyways, the relevant information follows:

- First line of a .md file should be `Title: <title>`, where `<title>` is what
  you would like the website title to be.
- Second line of a .md file should be `Nav: <nav>`, where `<nav>`
  directs to the file which contains the nav bar that will be used.  This will
  also be treated as markdown; however, all unordered lists will be given the
  `id="nav"`
- To add an `id`, `class`, etc section within an opening tag, start the very
  beginning of the relevant section with a `{...} `, where the `...` will be
  placed accordingly.  Note the space after the closing brace.  For example,
  `## {id="website_overhaul"} Website Overhaul` will turn into `<h2
  id="website_overhaul">Website Overhaul</h2>`
- Since `<ul>` and `<ol>` are both immediately followed by another tag, if you
  would like to place an `id`, `class`, etc inside `<ul>/<ol>`, make the
  *first* list item just `{...}` (note lack of space at the end).  e.g.: `-
  {class="rcmd"}`
- Something within `~(...~)` will be converted to `<code class="changethis">`.
- Markdown tends to nest `<code>` directly inside of `<pre>`.  The inner
  `<code>` tags are removed from this part.
- The file `header1` in the root of the `markdown` directory contains the
  beginning chunk of all of the websites.
  Baring a few things described below, this will be the same for every page.
  - The string `TITLEGOESHERE` in header1 will be replaced by the title set by
    `Title: <title>`
  - The string `RELATIVEPATH` will be replaced with the path to the root
    directory, ie, a bunch of `../../..`'s as needed.  This can be used to
    ensure everything is relative, which is useful in development.
- Immediately following `header1`'s content will be the nav as set in `Nav: <nav>`
- Following the nav is `header2's` content.
- Following `header2's` content is the actual markdown generated html from the markdown code.
- Following the markdown code is the content of `footer`
- Any files that don't end in `.md`, don't end in `.nav`, and aren't `header1`
  `header2` or `footer` are copied directly into the output section without
  change, as are directories.  This includes `.html` files.
- An `atom.xml` feed is generated from parsing `news.html` (which is generated
  from `news.md`) in the root of website.  It expects `news.html` to be set up in
  a very specific manner:
  - Each item starts with `<h2 id="X">TITLE</h2>`, where `X` is
    used to get the hyperlink (`http://bedrocklinux.org/news.html#X`) and
    `TITLE` indicates the title of the news item.  This should be followed by a
    blank line.
  - Next should be an ISO8601 date without any time information, such as
    "1900-01-01", within `<small>` and `<p>` tags.  This, too,
    should be followed by a blank line.
  - The next line(s) should be wrapped in a `<p>` tag.  The *first* paragraph
    will be dumped into the summary; after that everything is ignored until the
    next title/hyperlink line.
