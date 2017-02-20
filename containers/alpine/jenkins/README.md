# easypack
##让Linux下没有难装的流行开源软件
##Make popular OSS easily installed in linux

![这里写图片描述](http://img.blog.csdn.net/20160809065608330)

在Easypack中的Alpine容器中，我们将会挑选一些非常流行的工具进行自定义设定以及进行最佳实践的整理，基本思路都是在官方镜像的最新版本之上进行强化。本次为持续集成利器Jenkins。
#强化之处
* 尺寸较小，base镜像均基于alpine
* 可以自由调整版本，官方镜像的最新版往往滞后一段时间
* 初期化时候需要交互处理去除，直接内嵌缺省用户，无须设定
* 内嵌pipeline等常用plugin
* 内嵌与sonarqube和gitlab等结合的最佳实践方式

#Autobuild
与dockerhub结合，自动构建，时刻保证最新版本。每月两次版本调整。

#当前版本
当前版本：2.47
jenkins官方稳定最新版本：2.32


#docker pull
```
命令：docker pull liumiaocn/jenkins
```
示例:
```
[root@liumiaocn ~]# docker pull liumiaocn/jenkins
Using default tag: latest
latest: Pulling from liumiaocn/jenkins
b7f33cc0b48e: Already exists
43a564ae36a3: Already exists
b294f0e7874b: Already exists
95e0d3c0853e: Pull complete
73da9914c05d: Pull complete
9a2ad7929221: Pull complete
ea622e6bd2ca: Pull complete
160635bb13db: Pull complete
376727ffb49d: Pull complete
4d157a0aabbb: Pull complete
fc80347b39b3: Pull complete
9d89a0c6e5c8: Pull complete
2ae3afd18e3b: Pull complete
d1be3db512d1: Pull complete
71af28be6b37: Pull complete
Digest: sha256:c563458ec704976da717429d2e65359936819bd68d1bfeb73d5749a0c49c9f68
Status: Downloaded newer image for liumiaocn/jenkins:latest
[root@liumiaocn ~]#
```

#docker run
```
命令：docker run -d -p 8080:8080 -p 50000:50000 --name jenkins liumiaocn/jenkins
```
示例:
```
[root@liumiaocn ~]# docker run -d -p 8080:8080 -p 50000:50000 --name jenkins liumiaocn/jenkins
faf2cea49e0b212da20049918e72c42758373a4d9086ee7e711ab5e6467f4676
[root@liumiaocn ~]#
```  

#页面确认
可以看到此处不再有Jenkins2以后必须要进行交互的部分。
![这里写图片描述](http://img.blog.csdn.net/20170213075314386?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

|缺省登陆用户名：admin
|用户密码：admin|

#自定义方式
##修改缺省登陆用户名及密码
 * 对象文件：init_login.groovy
 * 修正内容：adminID="admin" adminPW="admin"
后续会使用环境变量等侵入性小的方式进行

##更新版本的Jenkins
 * 对象文件：Dockerfile
 * 修正内容：ENV JENKINS_VERSION ${JENKINS_VERSION:-2.45}  以及 ARG JENKINS_SHA=6631f46903b6f325880ab95d47718d22308e6e3a 

#CSDN详细
http://blog.csdn.net/liumiaocn/article/details/55004120
