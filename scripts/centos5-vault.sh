#!/bin/bash

LOGDIR=/root

LOGFILE=${LOGDIR}/centos5-repos.log

echo "**** Backing up original repos files"  | /usr/bin/tee -a ${LOGFILE}  2>&1

for REPO in `ls /etc/yum.repos.d/*.repo`
do
    echo "Saving ${REPO} as ${REPO}.bak"     | /usr/bin/tee -a ${LOGFILE}  2>&1
    mv ${REPO} ${REPO}.bak                   | /usr/bin/tee -a ${LOGFILE}  2>&1
done

echo "**** Creating vault repo file"         | /usr/bin/tee -a ${LOGFILE}  2>&1

/bin/cat > /etc/yum.repos.d/CentOS-Base.repo <<EOF
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the 
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-\$releasever - Base
baseurl=https://vault.centos.org/5.11/os/\$basearch
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1

#released updates 
[updates]
name=CentOS-\$releasever - Updates
baseurl=https://vault.centos.org/5.11/updates/\$basearch
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1

#packages used/produced in the build but not released
[addons]
name=CentOS-\$releasever - Addons
baseurl=https://vault.centos.org/5.11/addons/\$basearch
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1

#additional packages that may be useful
[extras]
name=CentOS-\$releasever - Extras
baseurl=https://vault.centos.org/5.11/extras/\$basearch
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-\$releasever - Plus
baseurl=hhttps://vault.centos.org/5.11/centosplus/\$basearch
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#contrib - packages by Centos Users
[contrib]
name=CentOS-\$releasever - Contrib
baseurl=https://vault.centos.org/5.11/contrib/\$basearch
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

EOF

#yum update -y

