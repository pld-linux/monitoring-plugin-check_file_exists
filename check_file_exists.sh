#!/bin/sh
#
# Author : Diego Martin Gardella [dgardella@gmail.com]
# Desc : Plugin to verify if a file exists
#
# v1.0: Initial version by Diego Martin Gardella [dgardella@gmail.com]
# v1.1: Add negate support, by Elan Ruusamäe <glen@pld-linux.org>

PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`

. $PROGPATH/utils.sh

usage() {
	echo "Usage: $PROGRAM [-n] [file]

Options:
  -n, --negate    negate the result
"
}

state_name() {
	case "$STATE" in
		$STATE_OK)
			echo OK
			;;
		$STATE_CRITICAL)
			echo CRITICAL
			;;
	esac
}

exists() {
	$negate && STATE=$STATE_CRITICAL || STATE=$STATE_OK
	echo "$(state_name): $1 EXISTS :: `head -3 $1`" # shows the first three lines of the file
}

exists_dir() {
    $negate && STATE=$STATE_CRITICAL || STATE=$STATE_OK
    echo "$(state_name): $1 EXISTS :: Directory" # don't show the first three lines of the file
}

not_exists() {
	$negate && STATE=$STATE_OK || STATE=$STATE_CRITICAL
	echo "$(state_name): $1 Does NOT exist"
}

# parse command line args
t=$(getopt -o n --long negate -n "$PROGNAME" -- "$@")
[ $? != 0 ] && exit $?
eval set -- "$t"

negate=false
while :; do
	case "$1" in
	-n|--negate)
		negate=true
	;;
	--)
		shift
		break
	;;
	*)
		echo >&2 "$PROGRAM: Internal error: [$1] not recognized!"
		exit 1
	;;
	esac
	shift
done

STATE=$STATE_UNKNOWN
if [ "$1" = "" ]; then
	usage
	exit $STATE
fi

if [ -f "$1" ]; then
	exists "$1"
elif [ -d "$1" ]; then
    exists_dir "$1"
else
	not_exists "$1"
fi
exit $STATE
