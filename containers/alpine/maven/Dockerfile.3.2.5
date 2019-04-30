###############################################################################
#
#IMAGE:   Maven
#VERSION: 3.2.5
#VERSION: jdk:ora7u79
#VERSION: alpine3.9
#VERSION: glibc2.29
#
###############################################################################
FROM liumiaocn/jdk:ora7u79-alpine3.9-glibc2.29

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

RUN apk add --no-cache curl tar bash procps

ARG MAVEN_VERSION=3.2.5
ARG USER_HOME_DIR="/root"
ARG SHA=0cdbf4c1e045ac7f96c176058f19ebb838bd46caadc4fb479e11eda67efbb66218fe67c370ddec6d2e4d91091ac9e81ff9eea8d64174cbe1e6d5f7e15962cfc5
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]
