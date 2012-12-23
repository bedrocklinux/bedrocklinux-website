#!/bin/sh

# ensure working directory is clean
rm -r html 2>/dev/null
mkdir html 2>/dev/null

# move into markdown directory to make some path stuff easier
cd markdown

# make directory structure
for DIRECTORY in $(find . -mindepth 1 -type d)
do
	mkdir ../html/$DIRECTORY
done

# generate pages from markdown
for PAGE in $(find . -type f -name "*.md")
do
	OUTFILE=$(echo "../html/$PAGE" | sed 's/.md$/.html/')
	DIRNAME=$(dirname $PAGE)
	TITLE=$(cat $PAGE | sed -n 's/^Title:[ ]\+//p')
	NAVFILE=$(cat $PAGE | sed -n 's/^Nav:[ ]\+//p')
	RELATIVEPATH=$(echo $DIRNAME | sed 's/[^\/]\+/../g' | sed 's/^.//')

	cat header1 |\
		sed "s/TITLEGOESHERE/$TITLE/" |\
		sed "s,RELATIVEPATH,$RELATIVEPATH," > $OUTFILE
	markdown $DIRNAME/$NAVFILE |\
		sed 's/<ul>/<ul id=nav>/' >> $OUTFILE
	cat header2 >> $OUTFILE
	sed '1,2d' $PAGE |\
		markdown |\
		awk -F"{|}" '
			/^<ul>$/{
				X=1
			}
			/^<li>{/ && X==1{
				print "<ul "$2">"
				X=2
			}
			!/^<ul>$/{
				if(X==1){
					print "<ul>"
					print $0
				}else
				if(X==0){
					print $0
				}
				X=0
			}
		' |\
		sed 's,~(,<code class="changethis">,g' |\
		sed 's,~),</code>,g' |\
		sed 's/<\([^>]\+\)>{\([^}]\+\)}[ ]\+/<\1 \2>/g' |\
		sed 's,<pre><code,<pre,g' |\
		sed 's,</code></pre>,</pre>,g' >> $OUTFILE
	cat footer >> $OUTFILE
done

# copy non-page files
for FILE in $(find . -type f)
do
	if ! basename $FILE | grep -q '.md$' &&\
		! basename $FILE | grep -q '.nav$' &&\
		! basename $FILE | grep -q '^header1$' &&\
		! basename $FILE | grep -q '^header2$' &&\
		! basename $FILE | grep -q '^footer$'
	then
		cp $FILE ../html/$FILE
	fi
done

# generate atom.xml
OUTFILE="../html/atom.xml"
LASTUPDATE=$(gawk '/^<p><small>[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]<\/small><\/p>$/{print substr($0,11,10);exit}' ../html/news.html)
NUMBER_OF_ITEMS=$(grep -c "<h2 id" ../html/news.html)

cat << EOF >$OUTFILE
<?xml version="1.0" encoding="utf-8"?>

<feed xmlns="http://www.w3.org/2005/Atom">

	<title>Bedrock Linux</title>
	<link href="http://bedrocklinux.org/atom.xml" rel="self" />
	<link href="http://bedrocklinux.org/"/>
	<id>http://bedrocklinux.org/atom.xml</id>
	<updated>$LASTUPDATE</updated>

EOF

gawk -F\" '
BEGIN{
	ITEMCOUNTER='$NUMBER_OF_ITEMS'
}
/^<h2 id=/||/^<\/section>$/{
	URL="http://bedrocklinux.org/news.html#"$2
	TITLE=substr($3,2,length($3)-6)
	if(IN_CONTENT==1){
		print "\t\t</content>"
		print "\t</entry>"
	}
	IN_CONTENT=0
}
!/^$/&&(IN_CONTENT==1){
	gsub(/</,"\\&lt;",$0)
	gsub(/>/,"\\&gt;",$0)
	print "\t\t\t"$0
}
/^<p><small>[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]<\/small><\/p>/{
	DATE=substr($0,11,10)
	print "\t<entry>"
	print "\t\t<id>http://bedrocklinux.org/news/"ITEMCOUNTER"</id>"
	print "\t\t<title>"TITLE"</title>"
	print "\t\t<link href=\""URL"\"/>"
	print "\t\t<updated>"DATE"</updated>"
	print "\t\t<content type=\"html\">"
	IN_CONTENT=1
	ITEMCOUNTER=ITEMCOUNTER-1
}
' ../html/news.html >> $OUTFILE

echo '</feed>' >> $OUTFILE
