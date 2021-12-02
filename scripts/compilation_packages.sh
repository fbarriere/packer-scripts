 #!/bin/bash

TOOLSET_RELEASES="7 8 9"

LOGFILE=/root/provisioners.log

[ -e $LOGFILE ] || /bin/touch $LOGFILE

echo "***** Installing extra packages"        | /usr/bin/tee -a $LOGFILE

yum -y install redis                          >> $LOGFILE 2>&1
yum -y install bash-completion                >> $LOGFILE 2>&1
yum -y install lapack                         >> $LOGFILE 2>&1
yum -y install lapack-devel                   >> $LOGFILE 2>&1
yum -y install blas                           >> $LOGFILE 2>&1
yum -y install blas-devel                     >> $LOGFILE 2>&1
yum -y install git                            >> $LOGFILE 2>&1
yum -y install cmake28                        >> $LOGFILE 2>&1

#yum -y install devtoolset-1.1                 >> $LOGFILE 2>&1
#yum -y install devtoolset-2-perftools         >> $LOGFILE 2>&1
#yum -y install devtoolset-2-vc                >> $LOGFILE 2>&1
#yum -y install devtoolset-2-toolchain         >> $LOGFILE 2>&1

yum -y install gmp-devel                      >> $LOGFILE 2>&1
yum -y install mpfr-devel                     >> $LOGFILE 2>&1
yum -y install libmpc-devel                   >> $LOGFILE 2>&1

for RELEASE in $TOOLSET_RELEASES
do
    echo "***** Installing devtoolset $RELEASE"                   | /usr/bin/tee -a $LOGFILE
    yum -y install centos-release-scl                             >> $LOGFILE
    yum-config-manager --enable rhel-server-rhscl-${RELEASE}-rpms >> $LOGFILE
    yum -y install devtoolset-${RELEASE}                          >> $LOGFILE
done

