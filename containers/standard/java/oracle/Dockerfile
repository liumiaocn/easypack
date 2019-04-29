###############################################################################
# 
#IMAGE:   Oracle-JDK-Image
#VERSION: JDK  :Oracle 7u79
#
###############################################################################
FROM centos:7.6.1810

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

ARG VER_JAVA_MAJOR=7u79
ARG VER_JAVA_MINOR=b15
ARG DIR_JAVA_BASE=/usr/local/share/java
ARG DIR_JAVA_HOME=${DIR_JAVA_BASE}/jdk1.7.0_79
ARG ARC_MODE=x64
ARG JDK_DOWNLOAD_URL=https://download.oracle.com/otn/java/jdk/${VER_JAVA_MAJOR}-${VER_JAVA_MINOR}/jdk-${VER_JAVA_MAJOR}-linux-${ARC_MODE}.tar.gz

COPY jdk-${VER_JAVA_MAJOR}-linux-${ARC_MODE}.tar.gz /tmp

RUN mkdir -p ${DIR_JAVA_HOME} && \
    tar xvf /tmp/jdk-${VER_JAVA_MAJOR}-linux-${ARC_MODE}.tar.gz -C ${DIR_JAVA_BASE} && \
    sleep 2 &&\
    rm /tmp/jdk-${VER_JAVA_MAJOR}-linux-${ARC_MODE}.tar.gz

ENV JAVA_HOME ${DIR_JAVA_HOME}
ENV PATH $PATH:${DIR_JAVA_HOME}/bin
