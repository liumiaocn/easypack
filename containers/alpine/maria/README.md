![这里写图片描述](http://img.blog.csdn.net/20170223100315718?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#MariaDB
* 2009年|Michael Widenius创建新项目Michael以规避关系型数据库开源的可能风险．直到5.5的版本，一直按照MySQL的版本进行发行。使用者基本上不会感受到和MySQL不同的地方。
* 2012年|MariaDB开始按照自己的节奏和版本发行方式进行发行，初始版本为：10.0.0，此版本以MySQL5.5为基础，同时合并了MySQL5.6的相关功能。

#当前版本
* 目前稳定版本|10.1

#docker pull
```
[root@liumiaocn ~]# docker pull liumiaocn/maria
Using default tag: latest
Trying to pull repository docker.io/liumiaocn/maria ...
latest: Pulling from docker.io/liumiaocn/maria
0a8490d0dfd3: Already exists
3a48a96147f6: Pull complete
4fe500b60fc8: Pull complete
Digest: sha256:359ea5cc2d8dcbd8245ca99a777e687f527c26a1e43c3bb12d05adf31ee7b1c2
Status: Downloaded newer image for docker.io/liumiaocn/maria:latest
[root@liumiaocn ~]# docker images |grep maria
docker.io/liumiaocn/maria                                latest              48db9d7b6891        8 hours ago         178.2 M
[root@liumiaocn ~]#
```

#缺省启动镜像
```
[root@liumiaocn ~]# docker run --name maria -d liumiaocn/maria
22d21c9fc299ef0107a67e5cd790a335a2399fe9611c38490eebf0eacec3310d
[root@liumiaocn ~]#
```

#连接镜像
```
[root@liumiaocn ~]# docker exec -it maria /bin/sh
/ # hostname
22d21c9fc299
/ # which mysql
/usr/bin/mysql
/ #
```

#版本确认
```
/ # mysql --version
mysql  Ver 15.1 Distrib 10.1.21-MariaDB, for Linux (x86_64) using readline 5.1
/ #
```

#确认数据库
```
/ # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 9
Server version: 10.1.21-MariaDB MariaDB Server

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)

MariaDB [(none)]>
```
#创建数据库
使用create database test创建名为test的数据库
```
MariaDB [(none)]> create database test;
Query OK, 1 row affected (0.01 sec)

MariaDB [(none)]>
MariaDB [(none)]> show databases
    -> ;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+
4 rows in set (0.00 sec)

MariaDB [(none)]>
```
#连接数据库
使用use 数据库名 命令去连接所指定的数据库，比如use test，将会连接刚刚创建的test数据库，在连接之后的操作比如创建表，在没有指明数据库名的情况下均对于当前所连接的数据库起作用。
```
MariaDB [(none)]> use test
Database changed
MariaDB [test]>
```

#基本操作
##版本确认
虽然mysql --version也可以确认版本，就像Oracle一样，在连接实例之后才能进行的确认方式，不过没有Oracle那样复杂庞大的系统视图而已。
```
MariaDB [test]> select version();
+-----------------+
| version()       |
+-----------------+
| 10.1.21-MariaDB |
+-----------------+
1 row in set (0.00 sec)

MariaDB [test]>
```
##字符串处理
```
MariaDB [test]> select "hello world"
    -> ;
+-------------+
| hello world |
+-------------+
| hello world |
+-------------+
1 row in set (0.00 sec)

MariaDB [test]>
```
##简单计算
类似Oracle里面的select from dual, mysql里面可以直接select
```
MariaDB [test]> select 3*7;
+-----+
| 3*7 |
+-----+
|  21 |
+-----+
1 row in set (0.00 sec)

MariaDB [test]>
```

#CSDN
http://blog.csdn.net/liumiaocn/article/details/56665800
