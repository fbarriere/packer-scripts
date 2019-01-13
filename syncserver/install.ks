# Kickstart file automatically generated by anaconda.

#version=DEVEL
install
url --url=http://mirror.centos.org/centos-6/6/os/x86_64
lang en_US.UTF-8
keyboard fr
network --onboot yes --device eth0 --bootproto dhcp --ipv6 auto
rootpw  --iscrypted $6$OA9qHGWw23EN99Gv$RyJ3o8v4fFv9LzlrVTEzhSkha.b9U8BNzOpAIZH22Feui9ifdkSSs0jjiU6sYK0B8HoJRH8J77GM9k2cjQrYv0
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Europe/Paris
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

repo --name="CentOS"  --baseurl=http://mirror.centos.org/centos-6/6/os/x86_64 --cost=100

text
skipx
zerombr

#ignoredisk --only-use=sda
#clearpart  --drives=sda --all
clearpart --all

part /boot --fstype=ext4 --size=500
part pv.01 --grow --size=1

volgroup vg_dsroot --pesize=4096 pv.01
logvol / --fstype=ext3 --name=lv_root --vgname=vg_dsroot --grow --size=1024
logvol swap --name=lv_swap --vgname=vg_dsroot --size=1024

part /syncdata/designsync --fstype=ext3 --size=1024 --grow --ondisk=sdb
part /syncdata/vault      --fstype=ext3 --size=1024 --grow --ondisk=sdc


auth  --useshadow  --enablemd5
firstboot --disabled
reboot


%packages
@ Base
@core
@development
@directory-client
gcc
#msktutil
mutt
net-snmp
nfs-utils
ntp
postfix
python-ethtool
python-dmidecode
redhat-lsb-core
sysstat
-fprintd
-sendmail

%end

%post --log=/root/kickstart-post.log

date > /etc/vagrant_box_build_time

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

/usr/bin/yum -y update
/usr/bin/yum -y install sudo
/usr/sbin/groupadd -g 501 vagrant
/usr/sbin/useradd vagrant -u 501 -g vagrant -G wheel
echo "vagrant"|passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
echo "Defaults:vagrant !requiretty"                 >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

%end
