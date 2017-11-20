###############################################################################
#
#IMAGE:   Jenkins(Alpine)
#VERSION: 2.90
#
###############################################################################
FROM openjdk:8u121-jdk-alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

#Update
RUN apk add --no-cache git openssh-client curl unzip bash ttf-dejavu coreutils

###############################################################################
#ENV
###############################################################################
ARG http_port=8080
ARG agent_port=50000

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

###############################################################################
#User
###############################################################################
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN addgroup -g ${gid} ${group} \
    && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

#Volume setting
VOLUME /var/jenkins_home

#Create Init groovy dir
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd

# Use tini as subreaper in Docker container to adopt zombie processes 
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c -

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

#set for default login user
COPY init_login.groovy /usr/share/jenkins/ref/init.groovy.d/set-user-security.groovy

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.90}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=1f697e7db6e42b3c34f3c9b77a8df9bc25b699ed3be24928b265a1bcd9520196

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum 
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

ENV JENKINS_UC https://updates.jenkins.io
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

USER ${user}

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

RUN /usr/local/bin/install-plugins.sh mailer sonar redmine gitlab-plugin docker-build-step

#COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
#RUN /usr/local/bin/install-plugins.sh ansible build-pipeline-plugin buildgraph-view docker-build-step gitlab-plugin workflow-aggregator pipeline-maven pipeline-utility-steps redmine sonar ssh-slaves
RUN /usr/local/bin/install-plugins.sh gitlab-plugin sonar redmine docker-build-step ansible build-pipeline-plugin buildgraph-view workflow-aggregator pipeline-maven pipeline-utility-steps
