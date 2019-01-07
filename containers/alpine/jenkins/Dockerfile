###############################################################################
#
#IMAGE:   Jenkins(Alpine)
#VERSION: 2.150.1
#BASE:    Jenkins LTS Version
#INTEGRATION:
#         Jenkins Slave: 3.28
#         tini         : 0.18.0
#         maven        : 3.6.0
#         sonar-scanner: 3.2.0.1227
#         kubectl      : 1.10.0
#         docker       : 1.13.1
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
# ARG user=jenkins
# ARG group=jenkins
# ARG uid=1000
# ARG gid=1000
ARG JENKINS_VERSION=${JENKINS_VERSION:-2.150.1}
ARG JENKINS_SHA=7a38586d5a3a1a83498809a83715728bb2f01b58a7dd3a88366f076efdaf6669
ARG JENKINS_URL=http://mirrors.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war
ARG TINI_SHA=eadb9d6e2dc960655481d78a92d2c8bc021861045987ccd3e27c7eae5af0cf33
ARG JENKINS_HOME="/data/jenkins"
ARG TINI_VERSION=0.18.0
ARG JENKINS_HOME="/data/jenkins"
ARG JENKINS_MODE="${JENKINS_MODE:-master}"
ARG JENKINS_SLAVE_VER="3.28"
ARG JENKINS_ADMIN_ID=${JENKINS_ADMIN_ID:-root}
ARG JENKINS_ADMIN_PW=${JENKINS_ADMIN_PW:-hello123}
ARG JENKINS_SLAVE_AGENT_PORT=${agent_port}
ARG COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log
ARG MAVEN_HOME="/usr/local/share/maven"
ARG MAVEN_VER="3.6.0"
ARG SONAR_HOME="/usr/local/share/sonar"
ARG SONAR_SCANNER_VER="3.2.0.1227"
ARG KUBECTL_VER="1.7.10"
ARG TIMEZONE="Asia/Shanghai"

###############################################################################
#ENV Setting
###############################################################################
ENV JENKINS_HOME ${JENKINS_HOME}
ENV JENKINS_MODE ${JENKINS_MODE}
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV TINI_VERSION 0.18.0
ENV TINI_SHA eadb9d6e2dc960655481d78a92d2c8bc021861045987ccd3e27c7eae5af0cf33
ENV JENKINS_VERSION ${JENKINS_VERSION}
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

###############################################################################
#Install && Setting
###############################################################################
RUN  apk add --no-cache git openssh-client curl unzip bash ttf-dejavu coreutils \
  && apk add --update py-pip postgresql-dev gcc python-dev musl-dev \
  && echo "mkdir -p ${JENKINS_HOME}" \
  && mkdir -p ${JENKINS_HOME} \
  && mkdir -p /usr/share/jenkins/ref/init.groovy.d  \
  && curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini \
  && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c - \
  && curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c - \
  && curl -L -o /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JENKINS_SLAVE_VER}/remoting-${JENKINS_SLAVE_VER}.jar.  \
  && curl -L -o apache-maven-$MAVEN_VER-bin.tar.gz http://apache.mirror.cdnetworks.com/maven/maven-3/$MAVEN_VER/binaries/apache-maven-$MAVEN_VER-bin.tar.gz \
  && tar xf apache-maven-$MAVEN_VER-bin.tar.gz      \
  && mv apache-maven-$MAVEN_VER $MAVEN_HOME          \
  && rm apache-maven-$MAVEN_VER-bin.tar.gz           \
  && curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VER/bin/linux/amd64/kubectl         \
  && chmod a+x /usr/local/bin/kubectl                \
  && curl -L -o sonar-scanner-$SONAR_SCANNER_VER.zip https://github.com/SonarSource/sonar-scanner-cli/archive/$SONAR_SCANNER_VER.zip           \
  && unzip sonar-scanner-$SONAR_SCANNER_VER.zip      \
  && mv sonar-scanner-cli-$SONAR_SCANNER_VER sonar-scanner-$SONAR_SCANNER_VER     \
  && mv sonar-scanner-$SONAR_SCANNER_VER $SONAR_HOME \
  && rm sonar-scanner-$SONAR_SCANNER_VER.zip         \
  && pip install --no-cache-dir decorator Django django-filter djangorestframework docutils \
  && pip install --no-cache-dir Markdown psycopg2 PyMySQL requests robotframework \
  && pip install --no-cache-dir robotframework-databaselibrary robotframework-ftplibrary \
  && pip install --no-cache-dir robotframework-requests robotframework-ride \
  && pip install --no-cache-dir robotframework-selenium2library \
  && ln -s /usr/local/share/maven/bin/mvn /usr/local/bin/mvn \
  && ln -s /usr/local/share/sonar/bin/sonar-scanner /usr/local/bin/sonar-scanner \
  && mkdir -p /data/jenkins  \
  && mkdir -p /data/maven    \
  && mkdir -p /data/kube     \
  && mkdir -p /data/sonar    \
  && apk del --purge postgresql-dev gcc python-dev musl-dev \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*.apk
#  && chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

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
RUN /usr/local/bin/install-plugins.sh gitlab-plugin sonar redmine docker-build-step ansible build-pipeline-plugin buildgraph-view workflow-aggregator pipeline-maven pipeline-utility-steps ssh-slaves blueocean

###############################################################################
#Volume Setting
###############################################################################
VOLUME ["/usr/share/jenkins/", "/data/jenkins", "/data/maven", "/data/kube", "/data/sonar", "/data/robot"]

###############################################################################
#expose Setting
###############################################################################
# for main web interface:
EXPOSE ${http_port}
# will be used by attached slave agents:
EXPOSE ${agent_port}

#USER ${user}

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
