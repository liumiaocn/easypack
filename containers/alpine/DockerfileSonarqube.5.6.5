###############################################################################
#
#IMAGE:   Sonarqube(Alpine)
#VERSION: 5.6.5
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
ENV SONAR_VERSION=5.6.5 \
    SOFTWARE=SONARQUBE \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

###############################################################################
#PORT
###############################################################################
EXPOSE 9000

###############################################################################
#DOWNLOAD & PREPARE
###############################################################################
RUN set -x \
    && apk add --no-cache gnupg unzip curl \
    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && mkdir /opt \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

###############################################################################
#SETTING
###############################################################################
VOLUME "$SONARQUBE_HOME/data"
WORKDIR $SONARQUBE_HOME
COPY run.${SOFTWARE}.${SONAR_VERSION}.sh $SONARQUBE_HOME/bin/run.sh
ENTRYPOINT ["./bin/run.sh"]
