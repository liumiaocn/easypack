###############################################################################
# 
#IMAGE:   Oracle-JDK-Image
#VERSION: Alpine: 3.9
#VERSION: JDK   :Oracle 12.0.1
#
###############################################################################
FROM alpine:3.9

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

ARG VER_JAVA_MAJOR=12.0.1
ARG VER_JAVA_MINOR=12
ARG DIR_JAVA_BASE=/usr/local/share/java
ARG DIR_JAVA_HOME=${DIR_JAVA_BASE}/jdk-${VER_JAVA_MAJOR}
ARG ARC_MODE=x64
ARG JDK_DOWNLOAD_URL=https://download.oracle.com/otn-pub/java/jdk/${VER_JAVA_MAJOR}+${VER_JAVA_MINOR}/69cfe15208a647278a19ef0990eea691/jdk-${VER_JAVA_MAJOR}_linux-${ARC_MODE}_bin.tar.gz
ARG VER_GLIBC=2.29-r0
ARG GLIBC_DOWNLOAD_URL=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${VER_GLIBC}

RUN mkdir -p ${DIR_JAVA_HOME} && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JDK_DOWNLOAD_URL} &&\
    tar zxf jdk-${VER_JAVA_MAJOR}_linux-${ARC_MODE}_bin.tar.gz -C ${DIR_JAVA_BASE} && \
    apk upgrade --update-cache &&\
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub &&\
    wget ${GLIBC_DOWNLOAD_URL}/glibc-${VER_GLIBC}.apk &&\
    wget ${GLIBC_DOWNLOAD_URL}/glibc-bin-${VER_GLIBC}.apk &&\
    wget ${GLIBC_DOWNLOAD_URL}/glibc-i18n-${VER_GLIBC}.apk &&\
    apk  add glibc-${VER_GLIBC}.apk glibc-bin-${VER_GLIBC}.apk glibc-i18n-${VER_GLIBC}.apk &&\
    sleep 2 &&\
    rm -rf /tmp/* /var/cache/apk/* jdk-${VER_JAVA_MAJOR}_linux-${ARC_MODE}_bin.tar.gz &&\
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

ENV JAVA_HOME ${DIR_JAVA_HOME}
ENV PATH      $PATH:${DIR_JAVA_HOME}/bin
ENV LANG      en_US.UTF8
