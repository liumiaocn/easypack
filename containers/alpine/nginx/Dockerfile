###############################################################################
# 
#IMAGE:   nginx(Alpine)(https)
#VERSION: 1.17.6
#
###############################################################################
FROM nginx:1.17.6-alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

ARG VAR_CN_INFO=www.devops.com

COPY default.conf /etc/nginx/conf.d/default.conf
COPY create_https_certs.sh /etc/nginx/ssl/

RUN apk update \
  && apk add --no-cache openssl \
  && cd /etc/nginx/ssl         \
  && sh create_https_certs.sh ${VAR_CN_INFO} 
