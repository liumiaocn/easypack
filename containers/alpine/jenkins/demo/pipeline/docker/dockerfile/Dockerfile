###############################################################################
# 
#IMAGE:   angular-cli
#VERSION: 8.0.3
#
###############################################################################
FROM liumiaocn/nodejs:10.15.3

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

RUN apk update \
  && npm install -g @angular/cli@8.0.3 \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache clear --force \
  && yarn cache clean \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd
