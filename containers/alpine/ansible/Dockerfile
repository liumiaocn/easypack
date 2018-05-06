###############################################################################
#
#IMAGE:   ansible
#VERSION: latest
#
###############################################################################
FROM alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

#update apk for install
RUN apk update

#install ansible and openssh
RUN apk add ansible openssh

#init ansible hosts file
RUN mkdir -p /etc/ansible
RUN echo "localhost" >/etc/ansible/hosts

#init rsa ssh key pair
RUN ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

#delete cache files 
RUN rm -rf /var/cache/apk/*
