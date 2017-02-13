# easypack
##让Linux下没有难装的流行开源软件
##Make popular OSS easily installed in linux

![这里写图片描述](http://img.blog.csdn.net/20170113065226244?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
#机器构成
6台机器构成：3主3从。
![这里写图片描述](http://img.blog.csdn.net/20170114085344238?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#Mesos启动确认
![这里写图片描述](http://img.blog.csdn.net/20170113081010310?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#Marathon启动确认
![这里写图片描述](http://img.blog.csdn.net/20170113081443406?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGl1bWlhb2Nu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)



每台机器只需要INSTALL和INIT两个步骤。
##使用方法
```
[root@host33 tmp]# sh easypack_mesos.sh INSTALL MASTER
Usage: easypack_mesos.sh ACTION TYPE NODE
       ACTION: INSTALL|INIT|UNINSTALL|STATUS|START|STOP|RESTART
       TYPE  : MASTER|SLAVE
       NODE  : 1|2|3|ALL
[root@host33 tmp]#      
```
##Master节点
```
[root@host33 tmp]# sh easypack_mesos.sh INSTALL MASTER 2
## Intall Log file : /tmp/tmp_log_file.10340.log
## Install for Master Node:            :OK
## Config for Master Node: /etc/hosts  :OK
## Config   for Master Node:           :OK
[root@host33 tmp]#
[root@host33 tmp]# sh /tmp/easypack_mesos.sh INIT MASTER 1
## Intall Log file : /tmp/tmp_log_file.10753.log
## Init     for Master Node:           :OK
[root@host33 tmp]# 
```

##Slave节点
```
root@host43 ~]# sh /tmp/easypack_mesos.sh INSTALL SLAVE 2
## Intall Log file : /tmp/tmp_log_file.1751.log
## Install for Slave   Node:             OK
## Config   for Slave   Node:            OK
[root@host43 ~]# sh /tmp/easypack_mesos.sh INIT SLAVE 3
## Intall Log file : /tmp/tmp_log_file.2011.log
## Init     for Slave   Node:            OK
[root@host43 ~]#
```
#详细参照
http://blog.csdn.net/liumiaocn/article/details/54405044
