#! /bin/bash
#
# Author : Diego Martin Gardella [dgardella@gmail.com]
# Desc : Plugin to verify if a file exists
#
#

PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`

. $PROGPATH/utils.sh

if [ "$1" = "" ]
then
	echo -e " Use : $PROGNAME <file_name> -- Ex : $PROGNAME /etc/hosts \n "
	exit $STATE_UNKNOWN
fi


if [ -f $1 ]
then
	echo "OK - $1 : EXISTS :: `head -3 $1`" # shows the first three lines of the file
	exit $STATE_OK
else
	echo "CRITICAL : $1 Does NOT exists "
	exit $STATE_CRITICAL
fi
