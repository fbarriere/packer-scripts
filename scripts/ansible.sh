#!/bin/bash

###################################################################
# Python2 and Ansible < 2.10
###################################################################

LOGDIR=/root

LOGFILE=${LOGDIR}/python_install.log

# Versions section
PYTHON_MAJOR=2.7
PYTHON_MINOR=15
PYTHON_VERSION=$PYTHON_MAJOR.$PYTHON_MINOR

PYTHON=/opt/python$PYTHON_VERSION

VERSIONS="2.8.20 2.9.20"

ANSIBLE_PREREQ="markupsafe redis junit_xml pyghmi pyvmomi"
ANSIBLE_EXTRAS="ansible-lint ansible-review ansible-cmdb"

#
#�Python install:
#

echo "*** Installing Python $PYTHON_VERSION "

TMP_PATH=~/tmp_install_python
INSTALL_PATH=/opt/python$PYTHON_VERSION

mkdir $TMP_PATH && cd $TMP_PATH

# Download and extract Python and Setuptools

echo "****** Downloading files."

wget --no-check-certificate https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz  > $LOGFILE 2>&1

echo "****** Extracting Python"

tar -zxf Python-$PYTHON_VERSION.tgz

echo "****** Building Python"

# Compile Python
cd $TMP_PATH/Python-$PYTHON_VERSION 
./configure --prefix=$INSTALL_PATH --with-ensurepip=upgrade >> $LOGFILE 2>&1
make                                                        >> $LOGFILE 2>&1
make altinstall                                             >> $LOGFILE 2>&1
#make install                                                >> $LOGFILE 2>&1
export PATH="$INSTALL_PATH:$PATH"

# Finish installation
cd /
rm -rf $TMP_PATH

echo "**********         Upgrading: pip"             | /usr/bin/tee -a $LOGFILE
$PYTHON/bin/pip2.7 install --upgrade pip             >> $LOGFILE

echo "**********         Upgrading: setuptools"      | /usr/bin/tee -a $LOGFILE
$PYTHON/bin/pip install --upgrade setuptools==11.3   >> $LOGFILE

echo "********** Installing virtualenv: "            | /usr/bin/tee -a $LOGFILE
$PYTHON/bin/pip install virtualenv                   >> $LOGFILE
    
#
# Ansible install:
#

echo "***** Installing ansible versions"      | /usr/bin/tee -a $LOGFILE

for VERSION in $VERSIONS
do
	LOGFILE=${LOGDIR}/ansible_${VERSION}.log
	[ -e $LOGFILE ] || /bin/touch $LOGFILE
	
    echo "********** Installing Ansible version: '${VERSION}'"              | /usr/bin/tee -a $LOGFILE
    $PYTHON/bin/virtualenv /opt/ansible-${VERSION}                          >> $LOGFILE
    
	for PREREQ in $ANSIBLE_PREREQ
	do
		echo "**********         Installing: $PREREQ"                       | /usr/bin/tee -a $LOGFILE
		/opt/ansible-${VERSION}/bin/pip install $PREREQ                     >> $LOGFILE
	done
	
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

###################################################################
# Python3 and Ansible >= 2.10
###################################################################

# Versions section
PYTHON_MAJOR=3.7
PYTHON_MINOR=10
PYTHON_VERSION=$PYTHON_MAJOR.$PYTHON_MINOR

PYTHON=/opt/python$PYTHON_MAJOR

ANSIBLE_PREREQ="pipenv virtualenv markupsafe redis junit_xml pyghmi pyvmomi"
ANSIBLE_EXTRAS="ansible-lint ansible-review ansible-cmdb"

VERSIONS="2.10.7"

#
#�Python install:
#

echo "*** Installing Python $PYTHON_VERSION "

TMP_PATH=~/tmp_install_python
INSTALL_PATH=/opt/python$PYTHON_MAJOR

mkdir $TMP_PATH && cd $TMP_PATH

# Download and extract Python and Setuptools

echo "****** Downloading files."

wget --no-check-certificate https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz  > $LOGFILE 2>&1

echo "****** Extracting Python"

tar -zxf Python-$PYTHON_VERSION.tgz

echo "****** Building Python"

# Compile Python
cd $TMP_PATH/Python-$PYTHON_VERSION 
./configure --prefix=$INSTALL_PATH --with-ensurepip=upgrade >> $LOGFILE 2>&1
make                                                        >> $LOGFILE 2>&1
make altinstall                                             >> $LOGFILE 2>&1
export PATH="$INSTALL_PATH:$PATH"

echo "****** Updating pip"
$PYTHON/bin/pip3.7 install --upgrade pip >> $LOGFILE 2>&1

for PREREQ in $ANSIBLE_PREREQ
do
    echo "**********         Installing: $PREREQ"        | /usr/bin/tee -a $LOGFILE
    $PYTHON/bin/pip install $PREREQ                     >> $LOGFILE
done
    
#
# Install Ansible versions:
#

for VERSION in $VERSIONS
do
    LOGFILE=${LOGDIR}/ansible_${VERSION}.log
    [ -e $LOGFILE ] || /bin/touch $LOGFILE
    
    echo "********** Installing Ansible version: '${VERSION}'"              | /usr/bin/tee -a $LOGFILE
    $PYTHON/bin/virtualenv /opt/ansible-${VERSION}                          >> $LOGFILE
    
    echo "**********         Installing: ansible"                           | /usr/bin/tee -a $LOGFILE
    /opt/ansible-${VERSION}/bin/pip install ansible==${VERSION}             >> $LOGFILE
    
    for EXTRA in $ANSIBLE_EXTRAS
    do
        echo "**********         Installing: $EXTRA"                        | /usr/bin/tee -a $LOGFILE
        /opt/ansible-${VERSION}/bin/pip install $EXTRA                      >> $LOGFILE
    done
    
done

###################################################################
# Enable and start redis at startup.
###################################################################

echo "***** Enable redis"
/bin/systemctl daemon-reload
/bin/systemctl enable redis.service


