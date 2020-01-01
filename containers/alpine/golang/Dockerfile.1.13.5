###############################################################################
#
#IMAGE:   Go Language
#VERSION: 1.13.5
#BASE:    Alpine 3.11
#
###############################################################################
FROM alpine:3.11

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

###############################################################################
#ENVIRONMENT VARS
###############################################################################
ENV GOLANG_VERSION 1.13.5
ENV GOPATH=${GOPATH:-/go}
ENV GO111MODULE on
ENV GOPROXY=${GOPROXY:-https://goproxy.cn,direct}
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

###############################################################################
#Install
###############################################################################
RUN set -eux; \
    apk add --no-cache ca-certificates; \
    [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf; \
	apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go; \
	export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
		GOOS="$(go env GOOS)" \
		GOARCH="$(go env GOARCH)" \
		GOHOSTOS="$(go env GOHOSTOS)" \
		GOHOSTARCH="$(go env GOHOSTARCH)"; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) export GOARM='6' ;; \
		armv7) export GOARM='7' ;; \
		x86) export GO386='387' ;; \
	esac; \
	wget -O go.tgz "https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz"; \
	echo '27d356e2a0b30d9983b60a788cf225da5f914066b37a6b4f69d457ba55a626ff *go.tgz' | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	cd /usr/local/go/src; \
	./make.bash; \
	rm -rf /usr/local/go/pkg/bootstrap usr/local/go/pkg/obj; \
	apk del .build-deps; \
	export PATH="/usr/local/go/bin:$PATH"; \
	go version ; \
	mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

###############################################################################
#Setting
###############################################################################
WORKDIR $GOPATH

###############################################################################
#Entrypoint
###############################################################################
