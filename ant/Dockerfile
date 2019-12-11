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
ARG ANT_SHA=4638c7066750f5bac6949cb6614b659200a8f82a742b7f43ed25f4aaad8b8e9d554e223fc48cdbb96c8acad485eee33bcb73d2367a2037559c47d23a8bbe947d
ARG BASE_URL=http://mirrors.tuna.tsinghua.edu.cn/apache//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz

RUN apk update \
  && apk add --no-cache curl tar bash \
  && mkdir -p /usr/local/ant \
  && curl -fsSL -o /tmp/apache-ant.tar.gz ${BASE_URL} \ 
  && ls -l /tmp/apache-ant.tar.gz \
  && echo "${ANT_SHA} /tmp/apache-ant.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-ant.tar.gz -C /usr/local/ant --strip-components=1 \
  && rm -f /tmp/apache-ant.tar.gz \
  && ln -s /usr/local/ant/bin/ant /usr/bin/ant

ENV ANT_HOME /usr/local/ant
ENV PATH $PATH:${ANT_HOME}

CMD ["ant"]
