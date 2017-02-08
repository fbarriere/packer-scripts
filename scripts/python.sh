#!/bin/bash

LOGFILE=${LOGDIR}/python_install.log

echo "*** Installing Python $PYTHON_VERSION "

# Versions section
PYTHON_MAJOR=2.7
PYTHON_MINOR=12
PYTHON_VERSION=$PYTHON_MAJOR.$PYTHON_MINOR

TMP_PATH=~/tmp_install_python
INSTALL_PATH=/opt/python$PYTHON_VERSION

mkdir $TMP_PATH && cd $TMP_PATH

# Download and extract Python and Setuptools

echo "****** Downloading files."

wget --no-check-certificate https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
#wget --no-check-certificate https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py

echo "****** Extracting Python"

tar -zxf Python-$PYTHON_VERSION.tgz

echo "****** Building Python"

# Compile Python
cd $TMP_PATH/Python-$PYTHON_VERSION 
./configure --prefix=$INSTALL_PATH   > $LOGFILE 2>&1
make && make altinstall              > $LOGFILE 2>&1
export PATH="$INSTALL_PATH:$PATH"

# Install Setuptools and PIP

echo "****** Installing SetupTools and PIP"
cd $TMP_PATH
#$INSTALL_PATH/bin/python$PYTHON_MAJOR ez_setup.py
$INSTALL_PATH/bin/python$PYTHON_MAJOR get-pip.py

# Finish installation
cd /
rm -rf $TMP_PATH

echo "****** Installing VirtualEnv"
$INSTALL_PATH/bin/pip install virtualenv
