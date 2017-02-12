###############################################################################
#
#IMAGE:   Redmine(Alpine)
#VERSION: 3.3.0
#
###############################################################################
FROM alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apk --update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT 2016-09-13

# Redmine Environment Info
ENV RAILS_ENV=production
ENV REDMINE_VERSION=3.3.0
ENV REDMINE_DOWNLOAD_MD5=0c0abb2d4efde455c3505d8caf01cb2d

# Gem Environment Info
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME"
ENV BUNDLE_BIN="$GEM_HOME/bin"
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

# Work Directory
WORKDIR /usr/src/redmine

RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc \
	&& mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"
RUN apk --update add --virtual .redmine-rundeps \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
		ruby \
		ruby-irb \
		ruby-rdoc \
		ruby-bigdecimal \
		ruby-bundler \
		gosu \
		imagemagick \
		mariadb-client-libs \
		sqlite-libs \
		libxslt \
		git \
		openssh-client \
		tzdata \
	&& apk --update add --virtual .build-deps \
		build-base \
		ruby-dev \
		libxslt-dev \
		imagemagick-dev \
		mariadb-dev \
		sqlite-dev \
		linux-headers \
		patch \
		coreutils \
		tar \
		curl \
	&& curl -fSL "http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz" -o redmine.tar.gz \
	&& echo "$REDMINE_DOWNLOAD_MD5 redmine.tar.gz" | md5sum -c - \
	&& tar -xvf redmine.tar.gz --strip-components=1 \
	&& rm redmine.tar.gz files/delete.me log/delete.me \
	&& mkdir -p tmp/pdf public/plugin_assets \
	&& bundle install --without development test \
	&& for adapter in mysql2 sqlite3; do \
		echo "$RAILS_ENV:" > ./config/database.yml; \
		echo "  adapter: $adapter" >> ./config/database.yml; \
		bundle install --without development test; \
	done \
	&& rm ./config/database.yml \
	&& rm /usr/local/bundle/cache/* \
	&& apk --purge del .build-deps \
	&& rm -rf /var/cache/apk/* \
	&& adduser -h ${PWD} -D -H -s /sbin/nologin redmine \
	&& chown -R redmine:redmine ./

VOLUME /usr/src/redmine/files

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
