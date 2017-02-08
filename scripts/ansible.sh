#!/bin/bash

PYTHON_VERSION=2.7.12
PYTHON=/opt/python$PYTHON_VERSION

VERSIONS="1.9.6 2.0.2.0-1 2.1.3.0 2.1.4.0 2.2.0.0 2.2.1.0"

LOGDIR=/root

echo "***** Installing extra packages"        | /usr/bin/tee -a $LOGFILE

yum -y install redis                          | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install sshpass                        | /usr/bin/tee -a $LOGFILE 2>&1


echo "***** Installing ansible versions"

for VERSION in $VERSIONS
do
	LOGFILE=${LOGDIR}/ansible_${VERSION}.log
	[ -e $LOGFILE ] || /bin/touch $LOGFILE
	
	echo "********** Installing version: '${VERSION}'"
	$PYTHON/bin/virtualenv /opt/ansible-${VERSION}                          > $LOGFILE 2>&1
	
	echo "**********         Installing: pip"
	/opt/ansible-${VERSION}/bin/easy_install pip                > $LOGFILE 2>&1
	
	echo "**********         Upgrading: setuptools"
	/opt/ansible-${VERSION}/bin/pip install --upgrade setuptools==11.3 > $LOGFILE 2>&1
	
	echo "**********         Installing: markupsafe"
	/opt/ansible-${VERSION}/bin/pip install markupsafe          > $LOGFILE 2>&1
	
	echo "**********         Installing: ansible"
	/opt/ansible-${VERSION}/bin/pip install ansible==${VERSION} > $LOGFILE 2>&1
	
	echo "**********         Installing: ansible-cmdb"
	/opt/ansible-${VERSION}/bin/pip install ansible-cmdb
done
