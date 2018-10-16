FROM alpine:3.5

ENV GOPATH=/go
ENV PATH=${GOPATH}/bin:${PATH}
ENV DOCKER_API_VERSION=1.24
ARG DOCKER_VERSION=${DOCKER_VERSION:-latest}
ARG CLAIRCTL_VERSION=${CLAIRCTL_VERSION:-master}
ARG CLAIRCTL_COMMIT=

RUN apk add --update curl \
 && apk add --virtual build-dependencies go gcc build-base glide git \
 && adduser clairctl -D \
 && mkdir -p /reports \
 && chown -R clairctl:clairctl /reports /tmp \
 && curl https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz -o docker.tgz \
 && tar xfvz docker.tgz --strip 1 -C /usr/bin/ docker/docker \
 && rm -f docker.tgz \
 && go get -u github.com/jteeuwen/go-bindata/... \
 && curl -sL https://github.com/jgsqware/clairctl/archive/${CLAIRCTL_VERSION}.zip -o clairctl.zip \
 && mkdir -p ${GOPATH}/src/github.com/jgsqware/ \
 && unzip clairctl.zip -d ${GOPATH}/src/github.com/jgsqware/ \
 && rm -f clairctl.zip \
 && mv ${GOPATH}/src/github.com/jgsqware/clairctl-* ${GOPATH}/src/github.com/jgsqware/clairctl \
 && cd ${GOPATH}/src/github.com/jgsqware/clairctl \
 && glide install -v \
 && go generate ./clair \
 && go build -o /usr/local/bin/clairctl -ldflags "-X github.com/jgsqware/clairctl/cmd.version=${CLAIRCTL_VERSION}-${CLAIRCTL_COMMIT}" \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/.glide/ \
 && rm -rf /go \
 && echo $'clair:\n\
  port: 6060\n\
  healthPort: 6061\n\
  uri: http://clair\n\
  priority: Low\n\
  report:\n\
    path: /home/clairctl/reports\n\
    format: html\n\
clairctl:\n\
  port: 44480\n\
  tempfolder: /home/clairctl/tmp'\
    > /home/clairctl/clairctl.yml

USER clairctl

WORKDIR /home/clairctl/

EXPOSE 44480

VOLUME ["/tmp/", "/reports/"]
 
CMD ["/usr/sbin/crond", "-f"]
