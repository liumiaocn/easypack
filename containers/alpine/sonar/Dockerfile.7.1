###############################################################################
#
#IMAGE:   Sonarqube(Alpine)
#VERSION: 7.1
#
###############################################################################
FROM openjdk:8-alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

###############################################################################
#ENV
###############################################################################
ENV SONAR_VERSION=7.1 \
    SOFTWARE=SONARQUBE \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

###############################################################################
#PORT
###############################################################################
# Http port
EXPOSE 9000

###############################################################################
#USER
###############################################################################
RUN addgroup -S sonarqube && adduser -S -G sonarqube sonarqube

###############################################################################
#DOWNLOAD & PREPARE
###############################################################################
RUN set -x \
    && apk add --no-cache gnupg unzip \
    && apk add --no-cache libressl wget \
    && apk add --no-cache su-exec \
    && apk add --no-cache bash \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && mkdir /opt \
    && cd /opt \
    && wget -O sonarqube.zip --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && wget -O sonarqube.zip.asc --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

###############################################################################
#VOLUME
###############################################################################
VOLUME "$SONARQUBE_HOME/data"

###############################################################################
#SETTING
###############################################################################
WORKDIR $SONARQUBE_HOME
COPY run.${SOFTWARE}.${SONAR_VERSION}.sh $SONARQUBE_HOME/bin/run.sh
ENTRYPOINT ["./bin/run.sh"]
