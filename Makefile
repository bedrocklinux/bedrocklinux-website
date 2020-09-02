# Bedrock Linux Website Generator Makefile
#
#      This program is free software; you can redistribute it and/or
#      modify it under the terms of the GNU General Public License
#      version 2 as published by the Free Software Foundation.
#
# Copyright (c) 2012-2020 Daniel Thau <danthau@bedrocklinux.org>

OBJECTS=$(shell find markdown/ -type f ! -name "header" ! -name "footer" ! -name "*.nav" | sed -e 's/^markdown/html/g' -e 's/[.]md/.html/g') html/atom.xml

all: check-dependencies symlinks $(OBJECTS)

clean:
	rm -rf ./html/*

check-dependencies:
	@ command -v markdown >/dev/null 2>&1 || (echo "Missing dependency: markdown" ; false)

# make resolves symlinks; can't just have them be targets directly.
symlinks:
	@ if [ "$$(readlink html/0.7/compatibility-and-workarounds.html)" != "feature-compatibility.html" ]; then \
		echo rm -f html/0.7/compatibility-and-workarounds.html; \
		rm -f html/0.7/compatibility-and-workarounds.html; \
	fi
	@ if [ "$$(readlink html/0.7/distro-support.html)" != "distro-compatibility.html" ]; then \
		echo rm -f html/0.7/distro-support.html; \
		rm -f html/0.7/distro-support.html; \
	fi
	@ if ! [ -h html/0.7/compatibility-and-workarounds.html ]; then \
		mkdir -p html/0.7; \
		echo ln -s feature-compatibility.html html/0.7/compatibility-and-workarounds.html; \
		ln -s feature-compatibility.html html/0.7/compatibility-and-workarounds.html; \
	fi
	@ if ! [ -h html/0.7/distro-support.html ]; then \
		mkdir -p html/0.7; \
		echo ln -s distro-compatibility.html html/0.7/distro-support.html; \
		ln -s distro-compatibility.html html/0.7/distro-support.html; \
	fi

# Generate atom.xml
html/atom.xml: html/news.html
	@ echo "Creating $@"
	@ awk -F'"' ' \
		BEGIN { \
			while ((getline < "html/news.html") > 0) { \
				if (last_update == "" && /<p><small>[0-9-]*<\/small><\/p>/) { \
					gsub(/[^0-9-]/, ""); \
					last_update = $$0; \
					continue \
				} \
				if (/<h2 id=/) { \
					count++ \
				} \
			} \
			print "<?xml version=\"1.0\" encoding=\"utf-8\"?>"; \
			print ""; \
			print "<feed xmlns=\"http://www.w3.org/2005/Atom\">"; \
			print ""; \
			print "\t<title>Bedrock Linux</title>"; \
			print "\t<link href=\"http://bedrocklinux.org/atom.xml\" rel=\"self\" />"; \
			print "\t<link href=\"http://bedrocklinux.org/\"/>"; \
			print "\t<id>http://bedrocklinux.org/atom.xml</id>"; \
			print "\t<updated>" last_update "</updated>"; \
			print ""; \
		} \
		/^<h2 id=/ || /^<\/section>$$/ { \
			url = "http://bedrocklinux.org/news.html#"$$2; \
			title = substr($$3, 2, length($$3)-6); \
			if (in_content) { \
				print "\t\t</content>"; \
				print "\t</entry>" \
			} \
			in_content=0 \
		} \
		!/^$$/ && in_content { \
			gsub(/</, "\\&lt;", $$0); \
			gsub(/>/, "\\&gt;", $$0); \
			print "\t\t\t" $$0 \
		} \
		/^<p><small>[0-9-]*<\/small><\/p>/ { \
			date = substr($$0, 11, 10); \
			print "\t<entry>"; \
			print "\t\t<id>http://bedrocklinux.org/news/" (count--) "</id>"; \
			print "\t\t<title>" title "</title>"; \
			print "\t\t<link href=\"" url "\"/>"; \
			print "\t\t<updated>" date "</updated>"; \
			print "\t\t<content type=\"html\">"; \
			in_content = 1 \
		} \
		END { \
			print "</feed>" \
		} \
	' html/news.html > html/atom.xml

# Translate markdown
html/%.html: markdown/%.md markdown/header markdown/footer markdown/*.nav markdown/*/*.nav
	@ echo "Creating $@"
	@ # Ensure containing directory exists
	@ mkdir -p $$(dirname $@)
	@ # Create header
	@ sed \
		-e "s@TITLEGOESHERE@$$(sed -n 's/^Title:[ ]\+//p' $<)@" \
		-e "s@RELATIVEPATH@$$(dirname $@ | sed -e 's/[^\/]\+/../g' -e 's/^.//')@" \
		markdown/header > $@
	@ # Create naviation bar
	@ markdown $$(dirname $<)/$$(sed -n 's/^Nav:[ ]\+//p' $<) | sed 's/<ul>/<ul id=nav>/' >> $@
	@ cat markdown/footer >> $@
	@ echo '<section>' >> $@
	@ # cut the non-standard-markdown Title: and Nav: lines
	@ sed '1,2d' $< |\
		# Create table of contents \
		awk ' \
			$$0 == "TableOfContents" { \
				while ((getline < "$<") > 0) { \
					if (!/^#.*{id=/) { \
						continue \
					} \
					split($$0, a, "} "); \
					title = a[2]; \
					split($$0, a, "\""); \
					link = a[2]; \
					indent = substr($$0, 3); \
					gsub(/[^#]/, "", indent); \
					gsub(/#/, "\t", indent); \
					printf "%s- [%s](#%s)\n", indent, title, link \
				} \
				next \
			} \
			1 \
		' |\
		# Convert markdown to html \
		markdown |\
		# Create tables \
		awk '\
			/^<p>[|]/ { \
				in_table = 1; \
				print "<p><table><tr>"; \
				len = split($$0, a, / *[|] */); \
				for (i = 2; i < len; i++) { \
					print "<th>"a[i]"</th>" \
				} \
				print "</tr>"; \
				next \
			} \
			/^[|]/ && in_table { \
				print "<tr>"; \
				len = split($$0, a, / *[|] */); \
				for (i = 2; i < len; i++) { \
					if (a[i] ~ /[0-9]#/) { \
						span=a[i]; \
						sub(/^[0-9]*#/, "", a[i]); \
						sub(/#.*/, "", span); \
						print "<td rowspan=\""span"\">"a[i]"</td>" \
					} else { \
						print "<td align=\"center\">"a[i]"</td>" \
					} \
				} \
				print "</tr>"; \
				next \
			} \
			in_table { \
				print "</table>"; \
				in_table = 0 \
			} \
			{ \
				print \
			} \
			END { \
				if (in_table) { \
					print "</table>" \
				} \
			} \
		' |\
		# First unordered-list entry indicates class for entire list \
		awk -F"[{}]" ' \
			$$0 == "<ul>" { \
				getline; \
				if (/^<li>{/) { \
					printf "<ul %s>\n", $$2 \
				} else { \
					printf "<ul>\n%s\n", $$0 \
				} \
				next \
			} \
			1 \
		' |\
		# Substitutions for inline classes \
		# Remove markdown default of <code> automatically nested in <pre> \
		sed \
			-e 's,~(,<code class="changethis">,g' \
			-e 's,~),</code>,g' \
			-e 's,~{,<code class="keyword">,g' \
			-e 's,~},</code>,g' \
			-e 's,~#,<span class="comment">,g' \
			-e 's,~+,<span class="distro">,g' \
			-e 's,~%,<span class="okay">,g' \
			-e 's,~^,<span class="warn">,g' \
			-e 's,~!,<span class="alert">,g' \
			-e 's,~x,</span>,g' \
			-e 's/<\([^>]\+\)>{\([^}]\+\)}[ ]\+/<\1 \2>/g' \
			-e 's,<pre><code,<pre,g' \
			-e 's,</code></pre>,</pre>,g' |\
		cat >> $@
	@ echo '</section>' >> $@

# If the source isn't markdown, copy it as-is
html/%: markdown/%
	@ echo "Copying  $@"
	@ mkdir -p $$(dirname $@)
	@ cp -a $< $@
