#!/bin/bash

LOGFILE=/root/provisioners.log

[ -e $LOGFILE ] || /bin/touch $LOGFILE

echo "***** Installing extra repositories"    | /usr/bin/tee -a $LOGFILE

echo "***** Installing EPEL rpm"              | /usr/bin/tee -a $LOGFILE
yum -y install epel-release                   | /usr/bin/tee -a $LOGFILE 2>&1

