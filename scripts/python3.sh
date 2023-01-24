#!/bin/bash

LOGFILE=/root/provisioners.log
[ -e $LOGFILE ] || /bin/touch $LOGFILE

###################################################################
# Python3
###################################################################

PYTHON_VERSION="3.7.16 3.8.16 3.9.16 3.10.9 3.11.1"

for PYTHON_VERSION in ${PYTHON_VERSIONS}
do
    echo "*** Installing Python $PYTHON_VERSION "
    
    PYTHON=/opt/python$PYTHON_VERSION
    TMP_PATH=~/tmp_install_python_${PYTHON_VERSION}
    INSTALL_PATH=/opt/python${PYTHON_VERSION}
    
    mkdir $TMP_PATH && cd $TMP_PATH
    
    # Download and extract Python
    
    echo "****** Downloading files."
    
    wget --no-check-certificate https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz  >> $LOGFILE 2>&1
    
    echo "****** Extracting Python"
    
    tar -zxf Python-$PYTHON_VERSION.tgz
    
    echo "****** Building Python"
    
    # Compile Python
    cd $TMP_PATH/Python-$PYTHON_VERSION 
    ./configure --prefix=$INSTALL_PATH --with-ensurepip=upgrade >> $LOGFILE 2>&1
    make                                                        >> $LOGFILE 2>&1
    make altinstall                                             >> $LOGFILE 2>&1
    
    echo "****** Updating pip"
    $PYTHON/bin/pipython3 -m pip install --upgrade pip >> $LOGFILE 2>&1
done

###################################################################
# Enable and start redis at startup.
###################################################################

echo "***** Enable redis"
/bin/systemctl daemon-reload
/bin/systemctl enable redis.service


