#!/bin/bash

LOGDIR=/root

LOGFILE=${LOGDIR}/centos5-dependencies.log

#
# Fix CA certificates:
#
echo "**** Fixing CA certificates"           | /usr/bin/tee -a ${LOGFILE}  2>&1
mv /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt.bak
cp /tmp/cacert.pem /etc/pki/tls/certs/ca-bundle.crt

#
# OpenSSL
#
cd /tmp
echo "**** Extracting OpenSSL package"       | /usr/bin/tee -a ${LOGFILE}  2>&1
tar xvfz openssl-1.0.2u.tar.gz               >> ${LOGFILE}  2>&1

echo "**** Configuring OpenSSL package"      | /usr/bin/tee -a ${LOGFILE}  2>&1
cd openssl-1.0.2u
./Configure --prefix=/usr/local linux-x86_64 >> ${LOGFILE}  2>&1
mv Makefile Makefile.orig
cat Makefile.orig | sed -e 's/CFLAGS = /CFLAGS = -fPIC/' > Makefile

echo "**** Compiling OpenSSL package"        | /usr/bin/tee -a ${LOGFILE}  2>&1
make                                         >> ${LOGFILE}  2>&1
echo "**** Installing OpenSSL package"       | /usr/bin/tee -a ${LOGFILE}  2>&1
make install                                 >> ${LOGFILE}  2>&1

#
# OpenSSH
#
cd /tmp
echo "**** Extracting OpenSSH package"       | /usr/bin/tee -a ${LOGFILE}  2>&1
tar xvfz openssh-9.0p1.tar.gz                >> ${LOGFILE}  2>&1
cd openssh-9.0p1

echo "**** Configuring OpenSSH package"      | /usr/bin/tee -a ${LOGFILE}  2>&1
export LDFLAGS="-L/usr/local/lib64" && ./configure --prefix=/usr/local --with-ssl-dir=/usr/local >> ${LOGFILE}  2>&1

echo "**** Compiling OpenSSH package"        | /usr/bin/tee -a ${LOGFILE}  2>&1
make                                         >>  ${LOGFILE} 2>&1
echo "**** Installing OpenSSH package"      vi  | /usr/bin/tee -a ${LOGFILE}  2>&1
make install                                 >>  ${LOGFILE} 2>&1

#
# SSHD
#
echo "**** Updating sshd setup"              | /usr/bin/tee -a ${LOGFILE}  2>&1
mv /etc/init.d/sshd /etc/init.d/sshd.orig
cat /etc/init.d/sshd.orig | sed -e 's,SSHD=/usr/bin/sshd,SSHD=/usr/local/bin/sshd,' | sed -e 's,KEYGEN=/usr/bin/ssh-keygen,KEYGEN=/usr/local/bin/ssh-keygen,' > /etc/init.d/sshd
chmod ugo+x /etc/init.d/sshd

echo "**** Restarting sshd"                  | /usr/bin/tee -a ${LOGFILE}  2>&1
/sbin/service sshd restart                   | /usr/bin/tee -a ${LOGFILE}  2>&1

#
# Python 2.7
#
cd /tmp
echo "**** Extracting Python1.7"             | /usr/bin/tee -a ${LOGFILE}  2>&1
tar xvfz Python-2.7.18.tgz                   >>  ${LOGFILE} 2>&1

echo "**** Configuring Python2.7"            | /usr/bin/tee -a ${LOGFILE}  2>&1
cd Python-2.7.18
mv Modules/Setup.dist Modules/Setup.dist.orig
cat Modules/Setup.dist.orig | \
    sed -e 's,#SSL=/usr/local/ssl,SSL=/usr/local,' | \
    sed -e 's,#_ssl ,_ssl ,' | \
    sed -e 's,#[\s\t]*-DUSE_SSL, -DUSE_SSL,' | \
    sed -e 's,#[\s\t]*-L\$(SSL)/lib, -L\$(SSL)/lib64,' > Modules/Setup.dist 

./configure --prefix=/usr/local              >>  ${LOGFILE} 2>&1

echo "**** Compiling Python2.7"              | /usr/bin/tee -a ${LOGFILE}  2>&1
make                                         >>  ${LOGFILE} 2>&1

echo "**** Installing Python2.7"             | /usr/bin/tee -a ${LOGFILE}  2>&1
make install                                 >>  ${LOGFILE} 2>&1

echo "**** Setting up pip"                   | /usr/bin/tee -a ${LOGFILE}  2>&1
/usr/local/bin/python -m ensurepip --upgrade >>  ${LOGFILE} 2>&1

echo "**** Upgrading pip"                    | /usr/bin/tee -a ${LOGFILE}  2>&1
/usr/local/bin/pip install --upgrade pip     >>  ${LOGFILE} 2>&1



