###############################################################################
# 
#IMAGE:   ant
#VERSION: 1.10.7
#
###############################################################################
FROM openjdk:8-jdk-alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

ARG ANT_VERSION=1.10.7
ARG ANT_SHA=838ce70c7dbd2b53068ce17b169c0b3fbed5e0ab7be5c707f052418fb6a4a1620f2d4017ceca1379cd25edce3e46d70bb2b5de4e1c5c52e2e1275deec1228084
ARG BASE_URL=https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz

RUN apk update \
  && apk add --no-cache curl tar bash \
  && mkdir -p /usr/local/ant \
  && curl -fsSL -o /tmp/apache-ant.tar.gz ${BASE_URL} \ 
  && sha512sum /tmp/apache-ant.tar.gz \
  && echo "${ANT_SHA}  /tmp/apache-ant.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-ant.tar.gz -C /usr/local/ant --strip-components=1 \
  && rm -f /tmp/apache-ant.tar.gz \
  && ln -s /usr/local/ant/bin/ant /usr/bin/ant

WORKDIR /data

ENV ANT_HOME /usr/local/ant
ENV PATH $PATH:${ANT_HOME}

CMD ["ant"]
