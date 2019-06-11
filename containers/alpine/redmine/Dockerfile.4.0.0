
###############################################################################
#
#IMAGE:   Redmine
#VERSION: 4.0.0
#
###############################################################################
FROM ruby:2.6-slim-stretch

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>
RUN groupadd -r redmine && useradd -r -g redmine redmine

RUN set -eux; \
apt-get update; \
apt-get install -y --no-install-recommends \
ca-certificates \
wget \
unzip \
\
bzr \
git \
mercurial \
openssh-client \
subversion \
\
# https://github.com/docker-library/redmine/issues/132
# (without "gsfonts" we get "Magick::ImageMagickError (non-conforming drawing primitive definition `text' @ error/draw.c/DrawImage/3265):")
gsfonts \
imagemagick \
; \
rm -rf /var/lib/apt/lists/*

RUN set -eux; \
savedAptMark="$(apt-mark showmanual)"; \
apt-get update; \
apt-get install -y --no-install-recommends \
dirmngr \
gnupg \
; \
rm -rf /var/lib/apt/lists/*; \
\
dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
\
# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
export GOSU_VERSION='1.11'; \
wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
export GNUPGHOME="$(mktemp -d)"; \
gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
gpgconf --kill all; \
rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
chmod +x /usr/local/bin/gosu; \
gosu nobody true; \
\
# grab tini for signal processing and zombie killing
# https://github.com/krallin/tini/releases
export TINI_VERSION='0.18.0'; \
wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini-$dpkgArch"; \
wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini-$dpkgArch.asc"; \
export GNUPGHOME="$(mktemp -d)"; \
gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5; \
gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini; \
gpgconf --kill all; \
rm -r "$GNUPGHOME" /usr/local/bin/tini.asc; \
chmod +x /usr/local/bin/tini; \
tini -h; \
\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
apt-mark auto '.*' > /dev/null; \
[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

ENV RAILS_ENV production
WORKDIR /usr/src/redmine

# https://github.com/docker-library/redmine/issues/138#issuecomment-438834176
# (bundler needs this for running as an arbitrary user)
ENV HOME /home/redmine
RUN set -eux; \
[ ! -d "$HOME" ]; \
mkdir -p "$HOME"; \
chown redmine:redmine "$HOME"; \
chmod 1777 "$HOME"

ENV REDMINE_VERSION 4.0.0
ENV REDMINE_DOWNLOAD_MD5 816992eb005cbaa636ad7f8962cb6e0d

RUN wget -O redmine.tar.gz "https://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz" \
&& echo "$REDMINE_DOWNLOAD_MD5 redmine.tar.gz" | md5sum -c - \
&& tar -xvf redmine.tar.gz --strip-components=1 \
&& rm redmine.tar.gz files/delete.me log/delete.me \
&& mkdir -p log public/plugin_assets sqlite tmp/pdf tmp/pids \
&& chown -R redmine:redmine ./ \
# log to STDOUT (https://github.com/docker-library/redmine/issues/108)
&& echo 'config.logger = Logger.new(STDOUT)' > config/additional_environment.rb \
# fix permissions for running as an arbitrary user
&& chmod -R ugo=rwX config db sqlite \
&& find log tmp -type d -exec chmod 1777 '{}' +

RUN set -eux; \
\
savedAptMark="$(apt-mark showmanual)"; \
apt-get update; \
apt-get install -y --no-install-recommends \
dpkg-dev \
gcc \
libmagickcore-dev \
libmagickwand-dev \
libmariadbclient-dev \
libpq-dev \
libsqlite3-dev \
make \
patch \
\
# tiny_tds 1.0.x requires OpenSSL 1.0
# see https://github.com/rails-sqlserver/tiny_tds/commit/3269dd3bcfbe4201ab51aa2870a6aaddfcbdfa5d (tiny_tds 1.2.x+ is required for OpenSSL 1.1 support)
libssl1.0-dev \
; \
rm -rf /var/lib/apt/lists/*; \
\
# https://github.com/travis-ci/travis-ci/issues/9391 (can't let "tiny_tds" download FreeTDS for us because FTP)
# https://github.com/rails-sqlserver/tiny_tds/pull/384 (newer version uses HTTP!)
# https://github.com/rails-sqlserver/tiny_tds/pull/345 (... but then can't download it for us)
# http://www.freetds.org/files/stable/?C=M;O=D
# (if/when we update to Debian Buster and thus get FreeTDS newer than 0.95 in the distro, we can switch back to simply installing "freetds-dev" from Debian)
wget -O freetds.tar.bz2 'http://www.freetds.org/files/stable/freetds-1.00.91.tar.bz2'; \
echo '8d71f9f29be0fe0637e443dd3807b3fd *freetds.tar.bz2' | md5sum -c -; \
mkdir freetds; \
tar -xf freetds.tar.bz2 -C freetds --strip-components=1; \
rm freetds.tar.bz2; \
( cd freetds && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && ./configure --build="$gnuArch" --enable-silent-rules && make -j "$(nproc)" && make -C src install && make -C include install ); \
rm -rf freetds; \
gosu redmine bundle config build.tiny_tds --enable-system-freetds; \
\
gosu redmine bundle install --without development test; \
for adapter in mysql2 postgresql sqlserver sqlite3; do \
echo "$RAILS_ENV:" > ./config/database.yml; \
echo "  adapter: $adapter" >> ./config/database.yml; \
gosu redmine bundle install --without development test; \
cp Gemfile.lock "Gemfile.lock.${adapter}"; \
done; \
rm ./config/database.yml; \
# fix permissions for running as an arbitrary user
chmod -R ugo=rwX Gemfile.lock "$GEM_HOME"; \
rm -rf ~redmine/.bundle; \
\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
apt-mark auto '.*' > /dev/null; \
[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
find /usr/local -type f -executable -exec ldd '{}' ';' \
| awk '/=>/ { print $(NF-1) }' \
| sort -u \
| grep -v '^/usr/local/' \
| xargs -r dpkg-query --search \
| cut -d: -f1 \
| sort -u \
| xargs -r apt-mark manual \
; \
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false


COPY themes.tar.gz /usr/src/redmine/public/

# install thems
RUN  cd /usr/src/redmine/public/themes \
&& wget https://github.com/mrliptontea/PurpleMine2/archive/v2.5.0.zip \
&& wget https://github.com/akabekobeko/redmine-theme-minimalflat2/archive/v1.6.0.zip \
&& unzip v2.5.0.zip \
&& unzip v1.6.0.zip \
&& rm v1.6.0.zip v2.5.0.zip \
&& cd /usr/src/redmine/public/themes/PurpleMine2-2.5.0/stylesheets \
&& sed -i s/36266b/438972/g *.css \
&& sed -i s/614ba6/11aa87/g *.css \
&& cd /usr/src/redmine/public/ \
&& tar xvpf themes.tar.gz \
&& rm themes.tar.gz

VOLUME /usr/src/redmine/files

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
