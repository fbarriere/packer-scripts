# Kickstart file automatically generated by anaconda.

#version=DEVEL
install
url --url=http://mirror.centos.org/centos-7/7/os/x86_64
lang en_US.UTF-8
keyboard fr
network --onboot yes --device eth0 --bootproto dhcp --ipv6 auto
rootpw  --iscrypted $6$OA9qHGWw23EN99Gv$RyJ3o8v4fFv9LzlrVTEzhSkha.b9U8BNzOpAIZH22Feui9ifdkSSs0jjiU6sYK0B8HoJRH8J77GM9k2cjQrYv0
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Europe/Paris
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

repo --name="CentOS"  --baseurl=http://mirror.centos.org/centos-7/7/os/x86_64 --cost=100

text
skipx
zerombr

clearpart --all --initlabel
autopart

auth  --useshadow  --enablemd5
firstboot --disabled
reboot


%packages
@additional-devel
@base
@compat-libraries
@console-internet
@core
@debugging
@desktop-debugging
@development
@directory-client
@emacs
@fonts
@graphical-admin-tools
@graphics
@input-methods
@internet-applications
@internet-browser
@java-platform
@legacy-unix
@legacy-x
@network-file-system-client
@network-tools
@performance
@perl-runtime
@postgresql-client
@postgresql
@print-client
@remote-desktop-clients
@ruby-runtime
@scientific
@technical-writing
@virtualization-client
@virtualization-platform
@x11
libgcrypt-devel
libXinerama-devel
openmotif-devel
libXmu-devel
xorg-x11-proto-devel
startup-notification-devel
libgnomeui-devel
libbonobo-devel
junit
libXau-devel
libXrandr-devel
popt-devel
libdrm-devel
libxslt-devel
libglade2-devel
gnutls-devel
mtools
pax
python-dmidecode
oddjob
wodim
sgpio
genisoimage
device-mapper-persistent-data
systemtap-client
abrt-gui
desktop-file-utils
ant
rpmdevtools
jpackage-utils
rpmlint
samba-winbind
certmonger
pam_krb5
krb5-workstation
netpbm-progs
tcp_wrappers
openmotif
libXmu
libXp
perl-DBD-MySQL
ebtables
perl-DBD-SQLite
numpy
atlas
libvirt-java

xorg-x11-server-Xvfb
net-snmp
lynx
gstreamer-plugins-base-devel
gstreamer-plugins-good-devel
expat-devel
gd-devel
libtiff-devel
libungif-devel


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

#
# Install EPEL devtoolset
#

%post --log=/root/epel-devtoolset-install.log

/usr/bin/yum -y install epel-release
/usr/bin/yum -y install centos-release-scl-rh
/usr/bin/yum -y install devtoolset-4

%end


