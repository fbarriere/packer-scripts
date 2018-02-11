FROM centos:6.9

MAINTAINER Francois Barriere <francois.barriere@microchip.com>

WORKDIR /tmp

ADD centos6 /tmp
ADD files/* /tmp/
ADD scripts /scripts

RUN yum clean all -y 
RUN yum update -y 
RUN yum install -y `cat install.ks | sed -e '1,/%packages/d' | sed -e '/%post/,$d' | sed -e '/%end/d'`

RUN rpm --import /tmp/RPM-GPG-KEY-csvn.asc
RUN /scripts/epel.sh
RUN /scripts/compilation_packages.sh
RUN /scripts/svn_install.sh
RUN yum -y clean all

ADD files/doxygen-1.7.6-rhel6.tar.gz /opt/

CMD [ "/bin/bash" ]
