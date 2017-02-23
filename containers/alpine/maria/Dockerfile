###############################################################################
#
#IMAGE:   MariaDB(Alpine)
#VERSION: latest
#
###############################################################################
FROM alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

#Copy init_mysql.sh for using
COPY ./init_mysql.sh /

#Build Mysql 
RUN addgroup -S mysql \
    && adduser -S mysql -G mysql \
    && apk add --no-cache mysql mysql-client \
    && rm -f /var/cache/apk/* \
    && awk '{ print } $1 ~ /\[mysqld\]/ && c == 0 { c = 1; print "skip-host-cache\nskip-name-resolve\nlower_case_table_names=1"}' /etc/mysql/my.cnf > /tmp/my.cnf \
    && mv /tmp/my.cnf /etc/mysql/my.cnf \
    && mkdir /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && chmod -R 777 /run/mysqld

#Port
EXPOSE 3306

#Starting
ENTRYPOINT ["/init_mysql.sh"]
CMD ["mysqld", "--user=mysql"]
