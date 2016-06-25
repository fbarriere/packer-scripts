#!/bin/bash

LOGFILE=/root/provisioners.log

[ -e $LOGFILE ] || /bin/touch $LOGFILE

echo "***** Installing extra packages"        | /usr/bin/tee -a $LOGFILE

yum -y install redis                          | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install bash-completion                | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install lapack                         | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install lapack-devel                   | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install blas                           | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install blas-devel                     | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install git                            | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install cmake28                        | /usr/bin/tee -a $LOGFILE 2>&1

yum -y install devtoolset-1.1                 | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install devtoolset-2-perftools         | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install devtoolset-2-vc                | /usr/bin/tee -a $LOGFILE 2>&1
yum -y install devtoolset-2-toolchain         | /usr/bin/tee -a $LOGFILE 2>&1

