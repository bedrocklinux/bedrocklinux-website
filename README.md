Bedrock Linux Website
=====================

This is a repo of the [Bedrock Linux website](http://bedrocklinux.org).

Most of it is in plain markdown, with a few minor tweaks.  If you would like to
submit a change to the website (such as a typo fix, a work around for a known
bugs etc), it should be pretty easy to figure out what is going on and make
such changes.

To generate the website from the markdown source, simply run the
generate_website.sh script.  The only dependency in addition to UNIX utilities
(sh, awk, sed, grep, find, etc) is markdown.

If you're interested in digging deeper, note that the website generation code
was not necessarily designed to be portable to other projects.  The atom.xml
for example is hardcoded to refer to Bedrock Linux.  If you want to press on
anyways, the relevant information follows:

- First line of a .md file should be "Title: &lt;title&gt;", where "&lt;title&gt;" is what
  you would like the website title to be.
- Second line of a .md file should be "Nav: &lt;nav&gt;", where "&lt;nav&gt;"
  directs to the file which contains the nav bar that will be used.  This will
  also be treated as markdown; however, all unordered lists will be given the
  id="nav"
- To add an "id", "class", etc section within an opening tag, start the very
  beginning of the relevant section with a "{...}", where the "..." will be
  placed accordingly.  For example, '## {id="website_overhaul"} Website
  Overhaul' will turn into '&lt;h2 id="website_overhaul"&gt;Website Overhaul&lt;/h2&gt;'
- The file "header1" in the root of the "markdown" directory contains the
  beginning chunk of all of the websites.
  Baring a few things described below, this will be the same for every page.
  - The string TITLEGOESHERE in header1 will be replaced by the title set by
    "Title: &lt;title&gt;"
  - The string RELATIVEPATH will be replaced with the path to the root
    directory, ie, a bunch of "../../.."'s as needed.  This can be used to
    ensure everything is relative, which is useful in development.
- Immediately following "header1's" content will be the nav as set in "Nav: &lt;nav&gt;"
- Following the nav is "header2's" content.
- Following "header2's" content is the actual markdown generated html from the markdown code.
- Following the markdown code is the content of "footer"
- Any files that don't end in ".md", don't end in ".nav", and aren't "header1"
  "header2" or "footer" are copied directly into the output section without
  change, as are directories.  This includes ".html" files.
- An atom.xml feed is generated from parsing news.html (generated from news.md)
  in the root of website.  It expects news.html to be set up in a very specific
  manner:
  - Each item starts with '&lt;h2 id="X"&gt;TITLE&lt;/h2&gt;', where "X" is used to get the
    hyperlink (http://bedrocklinux.org/news.html#X) and TITLE indicates the
    title of the news item.  This should be followed by a blank line.
  - Next should be an ISO8601 date without any time information, such as
    "1900-01-01", within &lt;small&gt; and &lt;p&gt; tags.  This, too, should
    be followed by a blank line.
  - The next line(s) should be wrapped in a &lt;p&gt; tag.  The *first* paragraph
    will be dumped into the summary; after that everything is ignored until the
    next title/hyperlink line.
