#!/bin/bash

LOGFILE=/root/provisioners.log

[ -e $LOGFILE ] || /bin/touch $LOGFILE

echo "***** Cleaning up *****" | /usr/bin/tee -a $LOGFILE

yum -y clean all                | /usr/bin/tee -a $LOGFILE 2>&1
rm -rf VBoxGuestAdditions_*.iso | /usr/bin/tee -a $LOGFILE 2>&1
rm -rf /tmp/rubygems-*          | /usr/bin/tee -a $LOGFILE 2>&1
