# Bedrock Linux Website Generator Makefile
#
#      This program is free software; you can redistribute it and/or
#      modify it under the terms of the GNU General Public License
#      version 2 as published by the Free Software Foundation.
#
# Copyright (c) 2012-2020 Daniel Thau <danthau@bedrocklinux.org>

OBJECTS=$(shell find markdown/ -type f ! -name "header" ! -name "footer" ! -name "*.nav" | sed -e 's/^markdown/html/g' -e 's/[.]md/.html/g') html/atom.xml

all: check-dependencies $(OBJECTS)

check-dependencies:
	@ command -v markdown >/dev/null 2>&1 || (echo "Missing dependency: markdown" ; false)

clean:
	rm -rf ./html

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
html/%.html: markdown/%.md markdown/header markdown/footer
	@ echo "Creating $@"
	@ # Ensure containing directory exists
	@ mkdir -p $$(dirname $@)
	@ # Create header and navigation bar
	@ sed \
		-e "s@TITLEGOESHERE@$$(sed -n 's/^Title:[ ]\+//p' $<)@" \
		-e "s@RELATIVEPATH@$$(dirname $@ | sed -e 's/[^\/]\+/../g' -e 's/^.//')@" \
		markdown/header > $@
	@ markdown $$(dirname $<)/$$(sed -n 's/^Nav:[ ]\+//p' $<) | sed 's/<ul>/<ul id=nav>/' >> $@
	@ cat markdown/footer >> $@
	@ # Create body
	@ # - initial sed cuts the non-standard-markdown Title: and Nav: lines
	@ # - awk block creates tables
	@ # - awk block allows first unordered-list entry to indicate class for entire list
	@ # - sed substitutions control inline class
	@ # - sed substitutions remove markdown default of <code> automatically nested in <pre>
	@ echo '<section>' >> $@
	@ sed '1,2d' $< |\
		markdown |\
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
					print "<td>"a[i]"</td>" \
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
		sed \
			-e 's,~(,<code class="changethis">,g' \
			-e 's,~),</code>,g' \
			-e 's,~{,<code class="keyword">,g' \
			-e 's,~},</code>,g' \
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
