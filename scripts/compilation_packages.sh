#!/bin/bash

LOGFILE=/root/provisioners.log

[ -e $LOGFILE ] || /bin/touch $LOGFILE

echo "***** Installing extra packages"        | /usr/bin/tee -a $LOGFILE

yum -y install ansible                        | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install redis                          | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install bash-completion                | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install lapack                         | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install lapack-devel                   | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install blas                           | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install blas-devel                     | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install git                            | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install cmake28                        | /usr/bin/tee -a $LOGFILE 2>&1



