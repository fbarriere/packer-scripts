#!/bin/bash

VERSIONS="1.9.5 1.9.6 2.0.2.0 2.1.0.0"

LOGDIR=/root

echo "***** Installing ansible versions"

for VERSION in $VERSIONS
do
	LOGFILE=${LOGDIR}/ansible_${VERSION}.log
	[ -e $LOGFILE ] || /bin/touch $LOGFILE
	
	echo "********** Installing version: '${VERSION}'"
	virtualenv /opt/ansible-${VERSION}                          > $LOGFILE 2>&1
	
	echo "**********         Installing: pip"
	/opt/ansible-${VERSION}/bin/easy_install pip                > $LOGFILE 2>&1
	
	echo "**********         Installing: markupsafe"
	/opt/ansible-${VERSION}/bin/pip install markupsafe          > $LOGFILE 2>&1
	
	echo "**********         Installing: ansible"
	/opt/ansible-${VERSION}/bin/pip install ansible==${VERSION} > $LOGFILE 2>&1
done
