#!/bin/bash

SRC_DIR="/tmp"

ARCH="x86_64"

PACKAGES="CollabNetSubversion-client-1.7.19-1 CollabNetSubversion-client-1.8.18-1 CollabNetSubversion-client-1.9.6-1"

rm -rf /opt/CollabNet*
rm -rf /opt/svn*

cp ${SRC_DIR}/svn /opt/svn
chmod ugo+x /opt/svn

for PACKAGE in $PACKAGES
do
echo "Installing: ${PACKAGE}"
	rpm -U ${SRC_DIR}/${PACKAGE}.${ARCH}.rpm
	cp -r /opt/CollabNet_Subversion /opt/${PACKAGE}
	rpm -e ${PACKAGE}
	MAJOR_MINOR=`echo ${PACKAGE} | /bin/sed -e 's/[^0-9]*\([0-9]\.[0-9]\).*/\1/'`
	ln -s /opt/svn /opt/svn-${MAJOR_MINOR}
done

tar xfz ${SRC_DIR}/doxygen-1.7.6-rhel5.tar.gz -C /opt
