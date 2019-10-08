###############################################################################
#
#IMAGE:   JMeter(Alpine)
#VERSION: 5.1.1
#BASE:    Alpine 3.10.2
#
###############################################################################
FROM alpine:3.10.2

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>


###############################################################################
#ARG Setting
###############################################################################
ARG VERSION_JMETER="5.1.1"

###############################################################################
#ENV Setting
###############################################################################
ENV FILENAME_JMETER      apache-jmeter-${VERSION_JMETER}
ENV HOME_JMETER          /usr/local/${FILENAME_JMETER}
ENV DOWNLOAD_URL_JMETER  https://archive.apache.org/dist/jmeter/binaries/${FILENAME_JMETER}.tgz
ENV DOWNLOAD_DIR_LOCAL   /tmp/download
ENV PATH                 $PATH:${HOME_JMETER}/bin

###############################################################################
#Install && Setting
###############################################################################
RUN apk update                                       \
    && apk upgrade                                   \
    && apk add --update openjdk8-jre curl unzip bash \
    && mkdir -p /tmp/download                        \
    && curl -L --silent ${DOWNLOAD_URL_JMETER} >  ${DOWNLOAD_DIR_LOCAL}/${FILENAME_JMETER}.tgz  \
    && mkdir -p /opt  ${DOWNLOAD_DIR_LOCAL}          \
    && tar -xzf ${DOWNLOAD_DIR_LOCAL}/${FILENAME_JMETER}.tgz -C /usr/local  \
    && rm -rf /var/cache/apk/*                       \
    && rm -rf ${DOWNLOAD_DIR_LOCAL}

###############################################################################
#Prepare Setting
###############################################################################
#COPY    entrypoint.sh /
WORKDIR	${HOME_JMETER}/bin

# ENTRYPOINT ["/entrypoint.sh"]

