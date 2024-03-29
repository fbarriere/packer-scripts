#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use network installation
url --url="http://mirrors.standaloneinstaller.com/centos/7.9.2009/os/x86_64/"
# Use graphical install
# graphical
# Run the Setup Agent on first boot
firstboot --disabled
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=fr --xlayouts='fr','us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --noipv6 --activate
network  --hostname=localhost.localdomain

firewall --disabled
selinux --disabled

# Root password
rootpw --iscrypted $6$EXXiZEv68RGWMuXF$85SQdRBab60EhQr4AB42m6cUtT.KAed8dnPprdeoY/zgE4/kbcTP945rDSGU92OABTpBgAqAKloXeUt03dFc1/
# System services
services --disabled="chronyd"
# System timezone
timezone Europe/Paris --isUtc --nontp
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
clearpart --none --initlabel

reboot

%packages
@^minimal
@core
@development
kexec-tools
python-virtualenv
libffi-devel
openssl-devel
wget
krb5-workstation
nfs-utils

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

#
#�Post install: install Vagrant
#

%post --log=/root/vagrant-install.log

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
#�Install EPEL and Ansible extra packages (sshpass and redis)
#

%post --log=/root/epel-install.log

/usr/bin/yum -y install epel-release

/usr/bin/yum -y install sshpass
/usr/bin/yum -y install redis

%end

#
# SSH config update:
#   - Disable DNS
#   - Disable GSSAPI
#

%post --log=/root/sshd_config.log

/bin/mv /etc/ssh/sshd_config /etc/ssh/sshd_config.rpmsave
/bin/cat /etc/ssh/sshd_config.rpmsave | /bin/sed -e '/UseDNS/s/.*/UseDNS no/' | /bin/sed -e '/GSSAPIAuthentication/s/.*/GSSAPIAuthentication no/' > /etc/ssh/sshd_config

%end


