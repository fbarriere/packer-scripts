#!/bin/bash

echo "****** Extracting designsync common volume content."

groupadd --gid 1479 syncmgr
useradd  --uid 1479 --gid 1479 syncmgr

mkdir -p /syncdata/designsync
mkdir -p /syncdata/vault

chown syncmgr:syncmgr /syncdata/designsync
chown syncmgr:syncmgr /syncdata/vault

echo "/dev/sdb1 /syncdata/designsync ext4 defaults,exec,auto  0 0" >> /etc/fstab
echo "/dev/sdc1 /syncdata/vault ext4 defaults,exec,auto  0 0" >> /etc/fstab
mount -a

cd /syncdata/designsync && tar xf /tmp/designsyncroot.tar.gz

chown -R syncmgr /syncdata/designsync
chgrp -R syncmgr /syncdata/designsync
