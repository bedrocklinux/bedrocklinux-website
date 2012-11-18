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
	if [ $DIRNAME = "." ]
	then
		RELATIVEPATH="."
	else
		RELATIVEPATH=$(echo $DIRNAME | sed 's/[^\/]\+/../g')
	fi

	cat header1 |\
		sed "s/TITLEGOESHERE/$TITLE/" |\
		sed "s/RELATIVEPATH/$RELATIVEPATH/"              > $OUTFILE
	cat $NAVFILE                                        >> $OUTFILE
	cat header2                                         >> $OUTFILE
	sed '1,2d' $PAGE |\
		markdown |\
		sed 's/<\([^>]\+\)>{\([^}]\+\)}[ ]\+/<\1 \2>/g' >> $OUTFILE
	cat footer                                          >> $OUTFILE
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
LASTUPDATE=$(awk '/^<p><small>[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]<\/small><\/p>$/{print substr($0,11,10);exit}' ../html/news.html)
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

awk -F\" '
BEGIN{
	ITEMCOUNTER='$NUMBER_OF_ITEMS'
}
!/^$/&&(IN_SUMMARY==1){
	if(substr($0,0,3)=="<p>"){
		print "\t\t\t"substr($0,4)
	}else if(substr($0,length($0)-3)=="</p>"){
		IN_SUMMARY=0
		print "\t\t\t"substr($0,0,length($0)-4)
		print "\t\t</summary>"
		print "\t</entry>"
	}else{
		print "\t\t\t"$0
	}
}
/^<h2 id=/{
	URL="http://bedrocklinux.org/news.html#"$2
	TITLE=substr($3,2,length($3)-6)
}
/^<p><small>[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]<\/small><\/p>/{
	DATE=substr($0,11,10)
	print "\t<entry>"
	print "\t\t<id>http://bedrocklinux.org/news/"ITEMCOUNTER"</id>"
	print "\t\t<title>"TITLE"</title>"
	print "\t\t<link>"URL"</link>"
	print "\t\t<updated>"DATE"</updated>"
	print "\t\t<summary>"
	IN_SUMMARY=1
	ITEMCOUNTER=ITEMCOUNTER-1
}


' ../html/news.html >> $OUTFILE



echo '</feed>'                                                     >> $OUTFILE
