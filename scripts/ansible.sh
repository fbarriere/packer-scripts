#!/bin/bash

LOGDIR=/root

LOGFILE=${LOGDIR}/python_install.log

# Versions section
PYTHON_MAJOR=2.7
PYTHON_MINOR=13
PYTHON_VERSION=$PYTHON_MAJOR.$PYTHON_MINOR

PYTHON=/opt/python$PYTHON_VERSION

VERSIONS="1.9.6 2.0.2.0 2.1.5.0 2.2.2.0"

ANSIBLE_EXTRAS="ansible-lint ansible-review ansible-cmdb"

#
# Python install:
#

echo "*** Installing Python $PYTHON_VERSION "

TMP_PATH=~/tmp_install_python
INSTALL_PATH=/opt/python$PYTHON_VERSION

mkdir $TMP_PATH && cd $TMP_PATH

# Download and extract Python and Setuptools

echo "****** Downloading files."

wget --no-check-certificate https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz  > $LOGFILE 2>&1
#wget --no-check-certificate https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py  >> $LOGFILE 2>&1

echo "****** Extracting Python"

tar -zxf Python-$PYTHON_VERSION.tgz

echo "****** Building Python"

# Compile Python
cd $TMP_PATH/Python-$PYTHON_VERSION 
./configure --prefix=$INSTALL_PATH   >> $LOGFILE 2>&1
make                                 >> $LOGFILE 2>&1
make altinstall                      >> $LOGFILE 2>&1
export PATH="$INSTALL_PATH:$PATH"

# Install Setuptools and PIP

echo "****** Installing SetupTools and PIP"
cd $TMP_PATH
#$INSTALL_PATH/bin/python$PYTHON_MAJOR ez_setup.py
$INSTALL_PATH/bin/python$PYTHON_MAJOR get-pip.py   >> $LOGFILE 2>&1

# Finish installation
cd /
rm -rf $TMP_PATH

echo "****** Installing VirtualEnv"
$INSTALL_PATH/bin/pip install virtualenv   >> $LOGFILE 2>&1

#
# Ansible install:
#

echo "***** Installing ansible versions"      | /usr/bin/tee -a $LOGFILE

for VERSION in $VERSIONS
do
	LOGFILE=${LOGDIR}/ansible_${VERSION}.log
	[ -e $LOGFILE ] || /bin/touch $LOGFILE
	
	echo "********** Installing version: '${VERSION}'"                      | /usr/bin/tee -a $LOGFILE
	$PYTHON/bin/virtualenv /opt/ansible-${VERSION}                          >> $LOGFILE
	
	echo "**********         Installing: pip"                               | /usr/bin/tee -a $LOGFILE
	/opt/ansible-${VERSION}/bin/easy_install pip                            >> $LOGFILE
	
	echo "**********         Upgrading: setuptools"                         | /usr/bin/tee -a $LOGFILE
	/opt/ansible-${VERSION}/bin/pip install --upgrade setuptools==11.3      >> $LOGFILE
	
	echo "**********         Installing: markupsafe"                        | /usr/bin/tee -a $LOGFILE
	/opt/ansible-${VERSION}/bin/pip install markupsafe                      >> $LOGFILE
	
	echo "**********         Installing: redis"                             | /usr/bin/tee -a $LOGFILE
	/opt/ansible-${VERSION}/bin/pip install redis                           >> $LOGFILE
	
	echo "**********         Installing: ansible"                           | /usr/bin/tee -a $LOGFILE
	/opt/ansible-${VERSION}/bin/pip install ansible==${VERSION}             >> $LOGFILE
	
	for EXTRA in $ANSIBLE_EXTRAS
	do
		echo "**********         Installing: $EXTRA"                        | /usr/bin/tee -a $LOGFILE
		/opt/ansible-${VERSION}/bin/pip install $EXTRA                      >> $LOGFILE
	done
	
done

ln -s /opt/ansible-${VERSION} /opt/ansible-latest

sync

echo "***** Enable redis"
/bin/systemctl daemon-reload
/bin/systemctl enable redis.service


