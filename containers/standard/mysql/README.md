![这里写图片描述](http://img.blog.csdn.net/20170222150651784?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
#MYSQL
* 1995年| Michael Widenius, David Axmark和Allan Larsson创立MYSQL AB公司
* 2008年| Michael 以10亿$的价格将MYSQL卖于Sun公司
* 2010年| Oracle买下Sun同时拥有了MySQL

#当前最新版本
* 目前最新版本|8.0

#docker pull
```
[root@liumiaocn ~]# docker pull liumiaocn/mysql
Using default tag: latest
Trying to pull repository docker.io/liumiaocn/mysql ...
latest: Pulling from docker.io/liumiaocn/mysql
5040bd298390: Already exists
d380e9ce206d: Pull complete
d2cdbfa8c9e8: Pull complete
3f3b43330ab6: Pull complete
63a2c442cd4c: Pull complete
755b18be0122: Pull complete
d5138eacfabf: Pull complete
e37972099ff1: Pull complete
9f125c251d92: Pull complete
73f300a76ee1: Pull complete
ad6380b5f40b: Pull complete
Digest: sha256:bbf6ece5678975f1558123d32f0122da300dc1729007ff3a576a0eafe89aa4cf
Status: Downloaded newer image for docker.io/liumiaocn/mysql:latest
[root@liumiaocn ~]# docker images |grep mysql
docker.io/liumiaocn/mysql                                latest              bf27235475d1        8 hours ago         431.9 MB
[root@liumiaocn ~]#
```

#启动镜像
```
[root@liumiaocn ~]# docker run --name mysql -e MYSQL_ROOT_PASSWORD=new123 -d liumiaocn/mysql
6df4033390f8df4a6631513073318f121460d55ad7b581555a05dd86975cd318
[root@liumiaocn ~]#
```

#连接镜像
```
[root@liumiaocn ~]# docker exec -it mysql /bin/sh
# hostname
6df4033390f8
# which mysql
/usr/bin/mysql
#
```

#版本确认
```
# mysql --version
mysql  Ver 14.14 Distrib 8.0.0-dmr, for Linux (x86_64) using  EditLine wrapper
#
```

#确认数据库
```
# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 8.0.0-dmr MySQL Community Server (GPL)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.04 sec)

mysql>
```
#创建数据库
使用create database test创建名为test的数据库
```
mysql> create database test;
Query OK, 1 row affected (0.04 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test               |
+--------------------+
5 rows in set (0.00 sec)

mysql>
```
#连接数据库
使用use 数据库名 命令去连接所指定的数据库，比如use test，将会连接刚刚创建的test数据库，在连接之后的操作比如创建表，在没有指明数据库名的情况下均对于当前所连接的数据库起作用。
```
mysql> use test
Database changed
mysql>
```

#基本操作
##版本确认
虽然mysql --version也可以确认版本，就像Oracle一样，在连接实例之后才能进行的确认方式，不过没有Oracle那样复杂庞大的系统视图而已。
```
mysql> select version();
+-----------+
| version() |
+-----------+
| 8.0.0-dmr |
+-----------+
1 row in set (0.00 sec)

mysql>
```
##字符串处理
```
mysql> select "hello world";
+-------------+
| hello world |
+-------------+
| hello world |
+-------------+
1 row in set (0.00 sec)

mysql>
```
##简单计算
类似Oracle里面的select from dual, mysql里面可以直接select
```
mysql> select 3*7;
+-----+
| 3*7 |
+-----+
|  21 |
+-----+
1 row in set (0.01 sec)

mysql>
```

#环境变量
* MYSQL_ROOT_PASSWORD
* MYSQL_DATABASE
* MYSQL_USER
* MYSQL_PASSWORD
* MYSQL_ALLOW_EMPTY_PASSWORD
* MYSQL_RANDOM_ROOT_PASSWORD
* MYSQL_ONETIME_PASSWORD
