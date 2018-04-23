FROM centos:7

MAINTAINER Francois Barriere <francois.barriere@microchip.com>

RUN yum clean all -y 
RUN yum update -y 
RUN yum -y install epel-release
RUN yum install -y doxygen
RUN yum install -y robodoc
RUN yum install -y publican
RUN yum install -y wget
RUN yum install -y dos2unix

RUN yum -y clean all

RUN wget -O /tmp/xsddoc-1.0.tar.gz https://sourceforge.net/projects/xframe/files/xsddoc/xsddoc-1.0/xsddoc-1.0.tar.gz/download
RUN tar xfz /tmp/xsddoc-1.0.tar.gz -C /opt
RUN dos2unix /opt/xsddoc-1.0/bin/xsddoc

ENV JAVA_HOME=/etc/alternatives/jre

CMD [ "/bin/bash" ]
