#!/bin/sh
# a very simple script to test for required attributes of a busybox executable
# to ensure it is suitable for Bedrock Linux 1.0alpha3 Bosco

if [ -z "$1" ]
then
	echo "Please provide the busybox you would like to test as an argument."
	exit 1
fi

echo -n "Testing $1 for being statically compiled... "

if ! ldd $1 1>/dev/null
then
	echo "PASSED"
else
	echo "FAILED"
	echo "You may have to find or compile another busybox which is statically compiled."
	exit 2
fi

echo -n "Testing $1 for applets... "
# fsck should be optional, removed it from the list below
MISSINGAPPLETS=""
for APPLET in "\[" ar awk basename cat chmod chroot chvt clear\
	cmp cp cut dd df dirname echo ed env expand expr false find\
	free getty grep head hostname hwclock id init install\
	kill last length ln ls mdev mkdir more mount mt od passwd\
	printf ps readlink reset rm route sed seq sh sleep sort\
	split stat swapon sync tail time top touch true tty umount\
	uname vi wc wget which xargs yes
do
	if $1 | awk 'p==1{print$0}/^Currently/{p=1}' | grep "^$APPLET$"
	then
		MISSINGAPPLETS="$APPLET "
	fi
done
if [ -z "$MISSINGAPPLETS" ]
then
	echo "PASSED"
else
	echo "FAILED"
	echo "$1 is missing: $MISSINGAPPLETS"
	echo "You may have to find or compile another busybox which includes those."
	exit 3
fi

echo -n "Testing $1 for --install... "

if $1 | grep -q -- "--install"
then
	echo "PASSED"
elif strings $1 | grep -q -- "--install"
then
	echo "MAYBE?"
	echo "  The --install flag doesn't appear in busybox's general output, but"
	echo "  it shows up in the executable.  It is probably safe to proceed as"
	echo "  though it exists."
else
	echo "FAILED"
	echo "$1 doesn't seem to support \"--install\"."
	echo "You may have to find or compile another busybox which does support it."
	exit 4
fi

echo -n "Testing for getty/login bug... "
VERSION=$($1 | awk 'NR==1{print substr($2,2)}')
if echo $VERSION | awk -F"." '{if($1 > 1 || $2 > 19){exit 0}else{exit 1}}'
then
	echo "Probably PASSED"
	echo "  Your busybox is version $VERSION."
	echo "  Busyboxes prior to 1.20 seem to have a bug with the getty applet"
	echo "  which keeps them from being sufficient to work for Bedrock Linux."
	echo "  This has not been hunted down to the exact commit and could be a"
	echo "  bit off. Since it is equal to or newer than 1.20,"
	echo "  $1 probably does not have the bug."
else
	echo "Probably failed."
	echo "  Your busybox is version $VERSION."
	echo "  Busyboxes prior to 1.20 seem to have a bug with the getty applet"
	echo "  which keeps them from being sufficient to work for Bedrock Linux."
	echo "  This has not been hunted down to the exact commit and could be a"
	echo "  bit off. Since it older than 1.20,"
	echo "  $1 probably has the bug."
	exit 5
fi

echo ""
echo "All tests appear to have PASSED."
echo "$1 will probably suffice for Bedrock Linux 1.0alpha3 Bosco."
