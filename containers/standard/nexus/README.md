![这里写图片描述](http://img.blog.csdn.net/20160901070831124)
Nexus作为私库管理最为流行的工具之一，用于包的管理和Docker镜像管理的私库管理场景中非常常用。Easypack利用最新版本的oss版Nexus作为基础镜像用于提供类似服务。本文将同时给出具体步骤结合Maven以实现使用Nexus进行包的管理。

#Why Nexus 3
这里整理了为什么使用Nexus 3的一些理由，在做选型的时候可以做一个简单参照。
|项目|详细
|--|--|
|为什么使用Nexus 3|http://blog.csdn.net/liumiaocn/article/details/62050525

#下载镜像
```
[root@liumiaocn ~]# docker pull liumiaocn/nexus
Using default tag: latest
latest: Pulling from liumiaocn/nexus
Digest: sha256:b93f9a6bba2b35ada33c324cd06bd2c732fc1bed352df186af1a013e228af8d8
Status: Image is up to date for liumiaocn/nexus:latest
[root@liumiaocn ~]#
```

#启动Nexus
```
[root@liumiaocn local]# mkdir -p /usr/local/nexus-data
[root@liumiaocn local]# docker run -d -p 8081:8081 --name nexus liumiaocn/nexus
844a9378ba1f101bad3de8688e2e665ea4ea8b68cb9e4b2457557e189daf922a
[root@liumiaocn local]#
```

#logon

|项目|详细
|--|--|
|URL|http://192.168.32.123:8081/
|用户名称|admin
|用户密码|admin123

![这里写图片描述](http://img.blog.csdn.net/20170315053706169?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

登陆之后
![这里写图片描述](http://img.blog.csdn.net/20170315053840379?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#创建Proxy私库
##仓库类型
具体仓库类型主要分为hosted/proxy/group三种。具体含义如下：
|项目|详细说明
|--|--|
|hosted| 本地存储，像官方仓库一样提供本地私库功能
|proxy| 提供代理其他仓库的类型
|group| 组类型，可以组合多个仓库为一个地址提供服务


##创建Maven仓库
使用Nexus官方镜像，我们会试图总结出最佳的实践方式，然后再此基础上不断地完善和进步。
|项目|详细说明
|--|--|
|实践1|根据项目情况，结合Maven特点将Snapshot和Release进行分离，分别创建snapshot和release的host类型仓库
|实践2|活用group类型，提供统一的对外URL
|实践3|可以使用-v将本地卷挂载进去，或者直接使用Named volume或者Data container使得数据从nexus容器中分离，方便数据的管理和备份等

##创建Snapshot的仓库
在Maven的Pom文件中的version标签内定义的以-SNAPSHOT结尾的版本tag统一在如下snapshot仓库中进行管理。
###创建blob store
在创建仓库之前，建议为每个仓库创建blob store。
|项目|详细说明
|--|--|
|实践4|为每个仓库创建一个blob store,这样其数据会在/nexus-data下分别管理起来
![这里写图片描述](http://img.blog.csdn.net/20170316210447279?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

###创建之后
![这里写图片描述](http://img.blog.csdn.net/20170316210544363?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

选择Server administration and configuration ->左侧的Administration -> repository -> repositories
![这里写图片描述](http://img.blog.csdn.net/20170315055813304?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

###创建仓库
|项目|详细说明
|--|--|
|类型|maven2(hosted)
![这里写图片描述](http://img.blog.csdn.net/20170315060836180?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

###创建
以下项目以外，使用default设定。

|项目|详细说明
|--|--|
|name|maven-snapshots
|version policy|snapshot
|deployment policy|allow redeploy
|blob store|maven-snapshots
![这里写图片描述](http://img.blog.csdn.net/20170315061017806?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
确认
![这里写图片描述](http://img.blog.csdn.net/20170315061058932?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

##创建release的仓库
在Maven的Pom文件中的version标签内定义的以-SNAPSHOT结尾以外的版本tag统一在如下release仓库中进行管理。创建release的仓库步骤以及所用到的信息如下：
|项目|详细说明
|--|--|
|类型|maven2(hosted)
|name|maven-releases
|deployment policy|allow redeploy
|blob store|maven-releases
![这里写图片描述](http://img.blog.csdn.net/20170316211658046?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

##创建proxy仓库
创建proxy仓库，default以外的值设定如下：
|项目|详细说明
|--|--|
|类型|maven2(proxy)
|name|maven-central
|location of the remote repository being proxied|https://repo1.maven.org/maven2
|blob store|maven-central
|Maximum component age|1440
![这里写图片描述](http://img.blog.csdn.net/20170316212712796?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

最后确认的时候才发现上图中的location of the remote repository being proxied选项写错了，无法下载到本地，所以建议URL方式的设定之前先手动确认一下是否正确
![这里写图片描述](http://img.blog.csdn.net/20170317052605146?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

##创建group仓库
为提供统一的URL进行管理，按照如下方式创建group仓库:
|项目|详细说明
|--|--|
|类型|maven2(group)
|name|maven-group
|blob store|maven-central
|member repositories|maven-snapshots
|member repositories|maven-releases
|member repositories|maven-central
![这里写图片描述](http://img.blog.csdn.net/20170315062259524?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#安装Maven
具体安装请参看如下文章：
|项目|详细
|--|--|
|容器方式|http://blog.csdn.net/liumiaocn/article/details/57064776
|裸机方式|http://blog.csdn.net/liumiaocn/article/details/61920553
此处为演示方便使用裸机方式，直接安装到centos上。
##安装后的确认
```
[root@liumiaocn ~]# which mvn
/usr/local/maven/apache-maven-3.3.9/bin/mvn
[root@liumiaocn ~]# mvn --version
Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-10T11:41:47-05:00)
Maven home: /usr/local/maven/apache-maven-3.3.9
Java version: 1.8.0_121, vendor: Oracle Corporation
Java home: /usr/local/java/jdk1.8.0_121/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-327.el7.x86_64", arch: "amd64", family: "unix"
[root@liumiaocn ~]#
```
##设定maven
```
[root@liumiaocn .m2]# pwd
/root/.m2
[root@liumiaocn .m2]# cat cat settings.xml
cat: cat: No such file or directory
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.1.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd">

  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
    <server>
      <id>nexus-releases</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
  </servers>

  <mirrors>
    <mirror>
      <id>central</id>
      <name>central</name>
      <url>http://192.168.32.123:8081/repository/maven-group/</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>

</settings>
[root@liumiaocn .m2]#
```

#设定project
|项目|详细说明
|--|--|
|demo项目|spring boot 的demo项目，显示hello world
|生成参照|http://blog.csdn.net/liumiaocn/article/details/53442364
注意事项：上面的参照的时候spring boot用的1.4.2, 现在稳定版本在1.5.2，不过使用SPRING INITIALIZR可以不用意识。或者使用自己的Maven项目，在pom中类似的设定即可。
```
[root@liumiaocn discoveryservice]# cp pom.xml pom.xml.bak
[root@liumiaocn discoveryservice]# vi pom.xml
[root@liumiaocn demo-repo-snapshot]# diff pom.xml pom.xml.bak
49,54d48
<   <repositories>
<     <repository>
<       <id>maven-group</id>
<       <url>http://192.168.32.123:8081/repository/maven-group</url>
<     </repository>
<   </repositories>
56,65d49
<    <distributionManagement>
<      <snapshotRepository>
<        <id>maven-snapshots</id>
<        <url>http://192.168.32.123:8081/repository/maven-snapshots/</url>
<      </snapshotRepository>
<      <repository>
<        <id>maven-releases</id>
<        <url>http://192.168.32.123:8081/repository/maven-releases/</url>
<      </repository>
<    </distributionManagement>
[root@liumiaocn demo-repo-snapshot]#
```

#执行确认
##mvn install
```
[root@liumiaocn demo-repo-snapshot]# mvn install
[INFO] Scanning for projects...
Downloading: http://192.168.32.123:8081/repository/maven-group/org/springframework/boot/spring-boot-starter-parent/1.5.2.RELEASE/spring-boot-starter-parent-1.5.2.RELEASE.pom
Downloaded: http://192.168.32.123:8081/repository/maven-group/org/springframework/boot/spring-boot-starter-parent/1.5.2.RELEASE/spring-boot-starter-parent-1.5.2.RELEASE.pom (8 KB at 2.5 KB/sec)
Downloading: http://192.168.32.123:8081/repository/maven-group/org/springframework/boot/spring-boot-dependencies/1.5.2.RELEASE/spring-boot-dependencies-1.5.2.RELEASE.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/org/springframework/security/spring-security-bom/4.2.2.RELEASE/spring-security-bom-4.2.2.RELEASE.pom (5 KB at 5.8 KB/sec)
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building demo-repo-snapshot 0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
Downloading: http://192.168.32.123:8081/repository/maven-group/org/springframework/boot/spring-boot-maven-plugin/1.5.2.RELEASE/spring-boot-maven-plugin-1.5.2.RELEASE.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/org/codehaus/plexus/plexus-utils/2.0.5/plexus-utils-2.0.5.jar (218 KB at 7.8 KB/sec)
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO] Copying 0 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ demo-repo-snapshot ---
Downloading: http://192.168.32.123:8081/repository/maven-group/org/apache/maven/maven-plugin-api/2.0.9/maven-plugin-api-2.0.9.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/com/google/collections/google-collections/1.0/google-collections-1.0.jar (625 KB at 10.8 KB/sec)
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to /root/demo-repo-snapshot/target/classes
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ demo-repo-snapshot ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /root/demo-repo-snapshot/src/test/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ demo-repo-snapshot ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to /root/demo-repo-snapshot/target/test-classes
[INFO]
[INFO] --- maven-surefire-plugin:2.18.1:test (default-test) @ demo-repo-snapshot ---
Downloading: http://192.168.32.123:8081/repository/maven-group/org/apache/maven/surefire/maven-surefire-common/2.18.1/maven-surefire-common-2.18.1.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/org/apache/commons/commons-lang3/3.1/commons-lang3-3.1.jar (309 KB at 12.1 KB/sec)
[INFO] Surefire report directory: /root/demo-repo-snapshot/target/surefire-reports
Downloading: http://192.168.32.123:8081/repository/maven-group/org/apache/maven/surefire/surefire-junit4/2.18.1/surefire-junit4-2.18.1.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/org/apache/maven/surefire/surefire-junit4/2.18.1/surefire-junit4-2.18.1.jar (67 KB at 14.3 KB/sec)

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
07:03:51.413 [main] DEBUG org.springframework.test.context.junit4.SpringJUnit4ClassRunner - SpringJUnit4ClassRunner constructor called with [class com.example.DemoRepoSnapshotApplicationTests]
......
07:03:52.138 [main] DEBUG org.springframework.core.env.StandardEnvironment - Adding [Inlined Test Properties] PropertySource with highest search precedence

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v1.5.2.RELEASE)
......
Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0

[INFO]
[INFO] --- maven-jar-plugin:2.6:jar (default-jar) @ demo-repo-snapshot ---
Downloading: http://192.168.32.123:8081/repository/maven-group/org/apache/maven/reporting/maven-reporting-api/2.2.1/maven-reporting-api-2.2.1.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/org/apache/commons/commons-compress/1.9/commons-compress-1.9.jar (370 KB at 18.9 KB/sec)
[INFO] Building jar: /root/demo-repo-snapshot/target/demo-repo-snapshot-0.0.1-SNAPSHOT.jar
[INFO]
[INFO] --- spring-boot-maven-plugin:1.5.2.RELEASE:repackage (default) @ demo-repo-snapshot ---
Downloading: http://192.168.32.123:8081/repository/maven-group/org/springframework/boot/spring-boot-loader-tools/1.5.2.RELEASE/spring-boot-loader-tools-1.5.2.RELEASE.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/com/google/guava/guava/18.0/guava-18.0.jar (2204 KB at 8.0 KB/sec)
[INFO]
[INFO] --- maven-install-plugin:2.5.2:install (default-install) @ demo-repo-snapshot ---
Downloading: http://192.168.32.123:8081/repository/maven-group/commons-codec/commons-codec/1.6/commons-codec-1.6.pom
......
Downloaded: http://192.168.32.123:8081/repository/maven-group/commons-codec/commons-codec/1.6/commons-codec-1.6.jar (228 KB at 7.3 KB/sec)
[INFO] Installing /root/demo-repo-snapshot/target/demo-repo-snapshot-0.0.1-SNAPSHOT.jar to /root/.m2/repository/com/example/demo-repo-snapshot/0.0.1-SNAPSHOT/demo-repo-snapshot-0.0.1-SNAPSHOT.jar
[INFO] Installing /root/demo-repo-snapshot/pom.xml to /root/.m2/repository/com/example/demo-repo-snapshot/0.0.1-SNAPSHOT/demo-repo-snapshot-0.0.1-SNAPSHOT.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 19:59 min
......
[root@liumiaocn demo-repo-snapshot]#

```

##确认maven-central
可以看到此spring boot的demo项目所需要的所有依赖都已经在proxy的maven-central中进行了管理。
![这里写图片描述](http://img.blog.csdn.net/20170317055031680?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


##确认demo
###执行
使用编译生成的jar包，启动spring boot
```
[root@liumiaocn demo-repo-snapshot]# java -jar target/demo-repo-snapshot-0.0.1-SNAPSHOT.jar

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v1.5.2.RELEASE)
......
```

###确认页面
可以看到使用编译出来的jar包，spring boot是能够正常动作的。
![这里写图片描述](http://img.blog.csdn.net/20170317060037834?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#CSDN
http://blog.csdn.net/liumiaocn/article/details/61931847
