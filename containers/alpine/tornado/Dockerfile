###############################################################################
#
#IMAGE:   tornado
#VERSION: 5.0.2
#
###############################################################################
FROM alpine:latest

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

COPY daemon.py /usr/local/bin/daemon.py

###############################################################################
#install
###############################################################################
RUN apk upgrade --update-cache; \
    apk add py-pip; \
    pip install --upgrade pip; \
    pip install tornado; \
    rm -rf /tmp/* /var/cache/apk/*

CMD python /usr/local/bin/daemon.py "Default Service"
