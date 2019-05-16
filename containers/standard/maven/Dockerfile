###############################################################################
# 
#IMAGE:   Maven-Oracle-JDK-Image
#VERSION: Maven:3.2.5
#VERSION: JDK  :Oracle 7u79
#
###############################################################################
FROM liumiaocn/jdk:ora7u79

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

ARG VER_MAVEN=3.2.5
ARG MAVEN_DOWNLOAD_URL=https://apache.osuosl.org/maven/maven-3/${VER_MAVEN}/binaries
ARG DIR_MAVEN_BASE=/usr/local/share/maven
ARG USER_HOME_DIR="/root"

RUN mkdir -p ${DIR_MAVEN_BASE} && \
    curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_DOWNLOAD_URL}/apache-maven-${VER_MAVEN}-bin.tar.gz &&\
    tar -xzf /tmp/apache-maven.tar.gz -C ${DIR_MAVEN_BASE} --strip-components=1 &&\
    rm -f /tmp/apache-maven.tar.gz &&\
    ln -s ${DIR_MAVEN_BASE}/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME   ${DIR_MAVEN_BASE}
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV LANG         zh_CN.UTF8

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]
