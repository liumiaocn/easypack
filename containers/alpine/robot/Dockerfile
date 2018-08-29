###############################################################################
#
#IMAGE:   robotframework
#VERSION: latest
#
###############################################################################
FROM alpine:3.8

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

#update apk for install
RUN apk update \
    && apk add python py-pip \
    && pip install --upgrade pip \
    && pip install robotframework \
    && pip install robotframework-selenium2library \
    && pip install robotframework-databaselibrary  \
    && pip install robotframework-yamllibrary      \
    && rm -rf /var/cache/apk/*

#volume
volume /data/robot

workdir /data/robot
