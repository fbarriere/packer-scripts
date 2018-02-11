#!/bin/bash

SRC_DIR="/tmp"

OSVER=`lsb_release -rs | sed -e 's/\..*//'`

echo "****** Installing Doxygen."
tar xfz ${SRC_DIR}/doxygen-1.7.6-rhel${OSVER}.tar.gz -C /opt
