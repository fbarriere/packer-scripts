FROM centos:5.11

MAINTAINER Francois Barriere <francois.barriere@microchip.com>

WORKDIR /tmp

ADD centos5 /tmp
ADD files/* /tmp/
ADD scripts /scripts

RUN sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
RUN sed -i 's/mirrorlist/#mirrorlist/' /etc/yum.repos.d/*.repo
RUN sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/5.11|' /etc/yum.repos.d/*.repo

RUN yum clean all -y 
RUN yum update -y 
RUN yum install -y `cat install.ks | sed -e '1,/%packages/d' | sed -e '/%post/,$d' | sed -e '/%end/d'`

RUN rpm --import /tmp/RPM-GPG-KEY-csvn.asc
RUN /scripts/epel.sh
RUN /scripts/compilation_packages.sh
RUN /scripts/svn_install.sh
RUN yum -y clean all

ADD files/doxygen-1.7.6-rhel5.tar.gz /opt/

CMD [ "/bin/bash" ]
