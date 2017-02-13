# easypack
##让Linux下没有难装的流行开源软件
##Make popular OSS easily installed in linux

![这里写图片描述](http://img.blog.csdn.net/20161017215750901)

#Usage ：1.4
#Step 1: Get easypack_kubernetes.sh
>git clone or download or copy-paste to create local easypack_kubernetes.sh   
git clone https://github.com/liumiaocn/easypack

#Step 2: Create Master
>cd easypack/k8s   
sh easypack_kubernetes.sh MASTER

#Step 3: Join Node
>git clone https://github.com/liumiaocn/easypack   
>cd easypack/k8s   
>sh easypack_kubernetes.sh NODE token MASTERIP

---
#使用方法
#Step 1: 取得easypack_kubernetes.sh
>使用git clone或者直接下载或者拷贝粘贴生成本地的easypack_kubernetes.sh文件    
git clone https://github.com/liumiaocn/easypack

#Step 2: 
>需要记住Master创建时候所生成的Token，后面Node在Join的时候需要用到    
>cd easypack/k8s   
sh easypack_kubernetes.sh MASTER

#Step 3: Join Node
>在node所在节点执行，需要知道Master创建时候所生成的Token和Master的IP地址   
>git clone https://github.com/liumiaocn/easypack   
>cd easypack/k8s   
>sh easypack_kubernetes.sh NODE token MASTERIP
#Dashboard
##创建
>命令： kubectl create -f kubernetes-dashboard.yaml
```
[root@host31 k8s]# kubectl create -f kubernetes-dashboard.yaml
deployment "kubernetes-dashboard" created
service "kubernetes-dashboard" created
[root@host31 k8s]#
```

##确认Deployment
```
[root@host31 k8s]# kubectl get deployments --namespace=kube-system
NAME                   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-discovery         1         1         1            1           2h
kube-dns               1         1         1            1           2h
kubernetes-dashboard   1         1         1            1           3m
[root@host31 k8s]#
```

##确认Dashboard
>命令：kubectl describe svc kubernetes-dashboard --namespace=kube-system
```
[root@host31 k8s]# kubectl describe svc kubernetes-dashboard --namespace=kube-system
Name:                   kubernetes-dashboard
Namespace:              kube-system
Labels:                 app=kubernetes-dashboard
Selector:               app=kubernetes-dashboard
Type:                   NodePort
IP:                     10.4.41.47
Port:                   <unset> 80/TCP
NodePort:               <unset> 31276/TCP
Endpoints:              10.36.0.1:9090
Session Affinity:       None
No events.[root@host31 k8s]#
注解：NodePort 31276 为此服务对外暴露的端口号，通过它和IP即可访问Kubernetes1.4的Dashboard了
```

>访问URL：http://192.168.32.31:31276 

![这里写图片描述](http://img.blog.csdn.net/20161110063058276)

>namespace和node信息，可以清楚地看到其是由4台机器构成的kubernetes集群。

![这里写图片描述](http://img.blog.csdn.net/20161110063435109)

#问题详细查询
>（LOG文件）：/tmp/k8s_install.$$.log
#教程
##http://blog.csdn.net/liumiaocn/article/details/53017671
##http://blog.csdn.net/liumiaocn/article/details/53095472
##http://blog.csdn.net/liumiaocn/article/details/53112069
##http://blog.csdn.net/liumiaocn/article/details/53125541
##http://blog.csdn.net/liumiaocn/article/details/53137936
##http://blog.csdn.net/liumiaocn/article/details/53150288
##http://blog.csdn.net/liumiaocn/article/details/53155479
#Usage：1.5
##自动脚本：easypack_kubernetes_1.5.1_nowall.sh
##安装文章：Easypack: 30分钟安装kubernetes1.5.1：http://blog.csdn.net/liumiaocn/article/details/54132880
##限制：一部分安装文件暂时没有找到稳定的国内的源，上述文章在VPN中确认完毕
