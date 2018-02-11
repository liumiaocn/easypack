###############################################################################
#
#IMAGE:   Jenkins(Alpine)
#VERSION: 2.89.3
#
###############################################################################
FROM openjdk:8u121-jdk-alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

###############################################################################
#ARG Setting
###############################################################################
ARG http_port=8080
ARG agent_port=50000
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_VERSION=${JENKINS_VERSION:-2.89.3}
ARG JENKINS_SHA=79f176e9388cdeb0deb0e6af49ff9d1ff4b7a3c47102af11e3e9461bf268983a
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war
ARG TINI_SHA=6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd
ARG JENKINS_UC=https://updates.jenkins.io
ARG JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ARG JENKINS_HOME="/data/jenkins"
ARG TINI_VERSION=0.14.0
ARG JENKINS_HOME="/data/jenkins"
ARG JENKINS_SLAVE_VER="3.9"
ARG JENKINS_ADMIN_ID=${JENKINS_ADMIN_ID:-root}
ARG JENKINS_ADMIN_PW=${JENKINS_ADMIN_PW:-hello123}
ARG JENKINS_SLAVE_AGENT_PORT=${agent_port}
ARG COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log
ARG MAVEN_HOME="/usr/local/share/maven"
ARG MAVEN_VER="3.5.2"
ARG SONAR_HOME="/usr/local/share/sonar"
ARG SONAR_SCANNER_VER="3.0.3.778"
ARG KUBECTL_VER="1.7.10"
ARG TIMEZONE="Asia/Shanghai"

###############################################################################
#Install && Setting
###############################################################################
RUN  apk add --no-cache git openssh-client curl unzip bash ttf-dejavu coreutils \
  && apk add --update py-pip postgresql-dev gcc python-dev musl-dev \
  && echo "mkdir -p ${JENKINS_HOME}" \
  && mkdir -p ${JENKINS_HOME} \
  && addgroup -g ${gid} ${group} \ 
  && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user} \
  && mkdir -p /usr/share/jenkins/ref/init.groovy.d  \
  && curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini \
  && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c - \
  && curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c - \
  && curl -L -o /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JENKINS_SLAVE_VER}/remoting-${JENKINS_SLAVE_VER}.jar.  \
  && curl -L -o apache-maven-$MAVEN_VER-bin.tar.gz http://apache.mirror.cdnetworks.com/maven/maven-3/$MAVEN_VER/binaries/apache-maven-$MAVEN_VER-bin.tar.gz \
  && tar xf apache-maven-$MAVEN_VER-bin.tar.gz       \
  && mv apache-maven-$MAVEN_VER $MAVEN_HOME          \
  && rm apache-maven-$MAVEN_VER-bin.tar.gz           \
  && curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VER/bin/linux/amd64/kubectl         \
  && chmod a+x /usr/local/bin/kubectl                \
  && curl -L -o sonar-scanner-$SONAR_SCANNER_VER.zip https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VER.zip  \
  && unzip sonar-scanner-$SONAR_SCANNER_VER.zip      \
  && mv sonar-scanner-$SONAR_SCANNER_VER $SONAR_HOME \
  && rm sonar-scanner-$SONAR_SCANNER_VER.zip         \
  && pip install --no-cache-dir decorator Django django-filter djangorestframework docutils \
  && pip install --no-cache-dir Markdown psycopg2 PyMySQL requests robotframework \
  && pip install --no-cache-dir robotframework-databaselibrary robotframework-ftplibrary \
  && pip install --no-cache-dir robotframework-requests robotframework-ride \
  && pip install --no-cache-dir robotframework-selenium2library \
  && ln -s /usr/share/maven/bin/* /usr/local/bin \
  && ln -s /usr/share/sonar/bin/* /usr/local/bin \
  && mkdir -p /data/jenkins  \
  && mkdir -p /data/maven    \
  && mkdir -p /data/kube     \
  && mkdir -p /data/sonar    \
  && apk del --purge postgresql-dev gcc python-dev musl-dev \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*.apk       \
  && chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

###############################################################################
#Prepare Setting
###############################################################################
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
COPY init_login.groovy /usr/share/jenkins/ref/init.groovy.d/set-user-security.groovy
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

###############################################################################
#Install plugins
###############################################################################
RUN /usr/local/bin/install-plugins.sh gitlab-plugin sonar redmine docker-build-step ansible build-pipeline-plugin buildgraph-view workflow-aggregator pipeline-maven pipeline-utility-steps ssh-slaves

###############################################################################
#Volume Setting
###############################################################################
VOLUME /var/jenkins_home

###############################################################################
#expose Setting
###############################################################################
# for main web interface:
EXPOSE ${http_port}
# will be used by attached slave agents:
EXPOSE ${agent_port}

USER ${user}

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
