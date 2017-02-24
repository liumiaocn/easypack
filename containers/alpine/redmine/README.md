![这里写图片描述](http://img.blog.csdn.net/20170223103203336?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#事前准备
##所需镜像
基于镜像方式的Redmine，我们需要redmine的镜像和MySQL的镜像，当然除了MySQL之外，PostgreSQL 等也完全没有问题。

* redmine镜像|3.3|docker pull liumiaocn/redmine
* mysql镜像|8.0|docker pull liumiaocn/mysql

关于MySQL的简单使用可以参看下面这篇文章以便迅速入门
* 项目|http://blog.csdn.net/liumiaocn/article/details/56485588

##取得MySQL镜像
```
[root@liumiaocn ~]# docker pull liumiaocn/mysql
Using default tag: latest
Trying to pull repository docker.io/liumiaocn/mysql ...
latest: Pulling from docker.io/liumiaocn/mysql

Digest: sha256:bbf6ece5678975f1558123d32f0122da300dc1729007ff3a576a0eafe89aa4cf
Status: Image is up to date for docker.io/liumiaocn/mysql:latest
[root@liumiaocn ~]#
```
##取得Redmine镜像
```
[root@liumiaocn ~]# docker pull liumiaocn/redmine
Using default tag: latest
Trying to pull repository docker.io/liumiaocn/redmine ...
latest: Pulling from docker.io/liumiaocn/redmine

0a8490d0dfd3: Already exists
7a621d30439b: Pull complete
caa9dcd302d7: Pull complete
4f84a7468e35: Pull complete
31c3539d7d18: Pull complete
Digest: sha256:f8bfc6c5bea230d62f8fe059bd4907c89ef1b2351f52ea7ad9dcb0eccf14f4a0
Status: Downloaded newer image for docker.io/liumiaocn/redmine:latest
[root@liumiaocn ~]#
```

#普通方式
使用普通方式使用redmine，　一般事前现行启动mysql容器，然后再启动redmine的时候通过link参数指定所启动的mysql容器即可。
|项目|启动命令
|--|--|
|启动mysql容器|docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=redmine liumiaocn/mysql
|启动redmine容器|docker run -p 3000:3000 -d --name redmine --link mysql:mysql liumiaocn/redmine
|启动redmine容器(proxy)|docker run -e http_proxy=${http_proxy} -e https_proxy=${https_proxy} -p 3000:3000 -d --name redmine --link mysql:mysql liumiaocn/redmine

```
注意事项：由于Redmine是基于ROR的软件，所以有大量的版本的更新连接操作时很难避免的要连接网络，如果在企业的内网之内的话，proxy可能会挡住redmine的更新。所以使用-e将相关的环境变量传入即可，当然所传入的环境变量在本机或者至少在当前终端需要有设定才可。
```

##启动mysql容器
```
[root@liumiaocn ~]# docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=redmine liumiaocn/mysql
895ab55ca55ebb102bace76ed95b075476bb8c85579dc4436c76d0df2c03d86b
[root@liumiaocn ~]#
```
##启动redmine容器
```
[root@liumiaocn ~]# docker run -p 3000:3000 -d --name redmine --link mysql:mysql liumiaocn/redmine
61d6ebd632ea6332e5f2a1daa0affb06e20607af514b3346d6aa9dcc0007223f
[root@liumiaocn ~]#
```
```
注意事项：由于更新和初期化数据库等操作需要一定时间，请耐心等待一段时间，所谓的一段时间的长短根网络速度有很大关系，可以通过docker logs redmine来确认具体进度，出现了“INFO  WEBrick::HTTPServer#start: pid=1 port=3000”的ｌｏｇ信息就表明redmine已经就绪了。
```

##确认redmine
![这里写图片描述](http://img.blog.csdn.net/20170223151209596?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

关于redmine的简单使用的介绍，可以参看如下文章
* Ticket管理工具：Redmine|http://blog.csdn.net/liumiaocn/article/details/52107410
* Bitnami Redmine安装配置指南|http://blog.csdn.net/liumiaocn/article/details/53523604

#docker-compose方式
多个镜像的单机编排，自然少不了docker-compose显示身手，所以也可以直接使用docker-compose方式，在Easypack对redmine的使用也提供了docker-compose方式。
##proxy情况下的yml文件
```
[root@liumiaocn ~]# cat docker-compose.yml
version: '2'

services:

  redmine:
    image: liumiaocn/redmine
    ports:
      - 3000:3000
    environment:
      http_proxy: ${http_proxy}
      https_proxy: ${https_proxy}
      REDMINE_DB_MYSQL: redmine
      REDMINE_DB_PASSWORD: secret
    depends_on:
      - redminedb
    restart: never

  redminedb:
    image: liumiaocn/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: redmine
    restart: never
[root@liumiaocn ~]#
```
直接连接网络，不经过代理的情况可以直接删除http_proxy和https_proxy两行设定即可。
##启动
使用docker-compose方式启动只需要一条命令即可，当然前提是docker-compose已经安装完毕，在docker-compose还没有跟docker合体之前，目前需要分别安装，可以参看如下文章进行安装：
* docker-compose的安装和设定|http://blog.csdn.net/liumiaocn/article/details/52148274
启动log如下：
```
[root@liumiaocn ~]# docker-compose up
Creating network "root_default" with the default driver
Pulling redminedb (liumiaocn/mysql:latest)...
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
Pulling redmine (liumiaocn/redmine:latest)...
Trying to pull repository docker.io/liumiaocn/redmine ...
latest: Pulling from docker.io/liumiaocn/redmine
0a8490d0dfd3: Pull complete
7a621d30439b: Pull complete
caa9dcd302d7: Pull complete
4f84a7468e35: Pull complete
31c3539d7d18: Pull complete
Digest: sha256:f8bfc6c5bea230d62f8fe059bd4907c89ef1b2351f52ea7ad9dcb0eccf14f4a0
Status: Downloaded newer image for docker.io/liumiaocn/redmine:latest
Creating root_redminedb_1
Creating root_redmine_1
Attaching to root_redminedb_1, root_redmine_1
redminedb_1  | Initializing database
．．．．．．
redmine_1    | [2017-02-22 21:46:02] INFO  ruby 2.3.3 (2016-11-21) [x86_64-linux-musl]
redmine_1    | [2017-02-22 21:46:02] INFO  WEBrick::HTTPServer#start: pid=1 port=3000
```

##确认redmine
![这里写图片描述](http://img.blog.csdn.net/20170223161726291?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#CSDN
http://blog.csdn.net/liumiaocn/article/details/56254955
