#!/bin/bash

LOGFILE=/root/provisioners.log

[ -e $LOGFILE ] || /bin/touch $LOGFILE

echo "***** Installing VBoxAddition" | /usr/bin/tee -a $LOGFILE

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)

cd /tmp                                                                | /usr/bin/tee -a $LOGFILE 2>&1

echo "********** Mounting VBoxAddition ISO"                            | /usr/bin/tee -a $LOGFILE
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt  | /usr/bin/tee -a $LOGFILE 2>&1


echo "********** Running VBoxAddition installer"                       | /usr/bin/tee -a $LOGFILE
/bin/bash /mnt/VBoxLinuxAdditions.run                                  | /usr/bin/tee -a $LOGFILE 2>&1

echo "********** Cleaning up VBoxAddition"                             | /usr/bin/tee -a $LOGFILE
umount /mnt                                                            | /usr/bin/tee -a $LOGFILE 2>&1
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso                          | /usr/bin/tee -a $LOGFILE 2>&1

