###############################################################################
#
#IMAGE:   ClamAV
#VERSION: 0.100.0
#
###############################################################################
FROM centos

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

WORKDIR /usr/local/clamav

#Install dependencies
RUN yum install gcc openssl openssl-devel wget -y 

#Volume
#VOLUME /usr/local/clamav/database
#VOLUME /usr/local/clamav/logs
VOLUME /usr/local/clamav/tools
VOLUME /usr/local/clamav/src
VOLUME /usr/local/clamav/rpt

#Install from compiling source
RUN FILE_VERSION=0.100.0 \
    && FILE_TAR_GZ=clamav-${FILE_VERSION} \
    && DOWNLOAD_URL="http://www.clamav.net/downloads/production/${FILE_TAR_GZ}.tar.gz" \
    && mkdir -p /tmp/download_dir \
    && cd /tmp/download_dir \
    && wget  ${DOWNLOAD_URL} \
    && tar xvpf ${FILE_TAR_GZ}.tar.gz \
    && cd ${FILE_TAR_GZ} \
    && ./configure --prefix=/usr/local/clamav \
    && make \
    && make install \
    && groupadd clamav \
    && useradd -g clamav clamav \
    && cd /usr/local/clamav \
    && mkdir -p logs database worktmp \
    && chown clamav:clamav database \
    && touch logs/freshclam.log \
    && chown clamav:clamav logs/freshclam.log \
    && cd etc \
    && cp freshclam.conf.sample freshclam.conf \
    && sed -i s@Example@#Example@g freshclam.conf \
    && sed -i s@'#DatabaseDirectory /var/lib/clamav'@'DatabaseDirectory /usr/local/clamav/database/'@g freshclam.conf \
    && sed -i s@'#UpdateLogFile /var/log/freshclam.log'@'UpdateLogFile /usr/local/clamav/logs/freshclam.log'@g freshclam.conf \
    && sed -i s@'#PidFile /var/run/freshclam.pid'@'PidFile /usr/local/clamav/worktmp/freshclam.pid'@g freshclam.conf \
    && cd .. \
    && bin/freshclam \
    && rm -rf /var/yum/cache/* \
    && rm -rf /tmp/download_dir

ENV PATH $PATH:/usr/local/clamav/bin
