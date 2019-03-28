这篇文章整理一下单机版本的kubernetes的所有安装脚本的执行过程，之所以使用单机版本，主要是便于说明，脚本化以及变量可配置化之后，基本上的内容修改设定文件即可，应该可以简单实现1主n从的设定。本文以脚本的方式进行固化，内容仍然放在github的easypack上，鉴于脚本内容也非常简单，无非就是，设定systemd的service文件与参数，拷贝离线二进制文件，启动服务并确认，所以内容不再说明，代码本身少量的注释应该已经足够说明，如有错误可直接在csdn联系或者github上联系均可。

* 安装单机版kubernetes离线设定文件，使用如下步骤即可。
# 步骤1：下载easypack
>
>[root@host131 tmp]# git clone https://github.com/liumiaocn/easypack.git
Cloning into 'easypack'...
...省略
[root@host131 tmp]#

# 步骤2: 下载相关离线二进制文件
* 修改并确定要下砸的各组件的版本号
```shell
[root@host131 tmp]# cd easypack/k8s/shell/
[root@host131 shell]# head -n11 step0-get-binaries.sh 
#!/bin/sh

TYPE_OS=linux
TYPE_ARCH=amd64
VER_CFSSL=R1.2
VER_KUBERNETES=v1.13.4
VER_ETCD=v3.3.12
VER_DOCKER=17.03.2-ce
VER_CNI=v0.7.4
VER_FLANNEL=v0.10.0
DIR_DOWNLOAD=/tmp
[root@host131 shell]#
```
执行如下命令即可完成下载
> sh step0-get-binaries.sh

缺省的情况下会在/tmp/binaries下进行二进制的收集，可自行修改
```shell
[root@host131 shell]# head -n10 install.cfg 
#!/bin/sh

#######BEGIN: SETTING: BASIC#########
ENV_HOME_BINARY=/tmp/binaries
ENV_HOME_CFSSL=${ENV_HOME_BINARY}/cfssl
ENV_HOME_ETCD=${ENV_HOME_BINARY}/etcd
ENV_HOME_FLANNEL=${ENV_HOME_BINARY}/flannel
ENV_HOME_DOCKER=${ENV_HOME_BINARY}/docker
ENV_CURRENT_HOSTIP="192.168.163.131"
#######END  : SETTING: BASIC#########
[root@host131 shell]#
```
下载请自行完成，如无法完成二进制下载，后续可提供百度网盘，这实在是

# 步骤3: 调整配置
最简单的方式，就是把如下的配置文件中的IP进行全文替换应该即可：192.168.163.131
```shell
[root@host131 shell]# ls install.cfg 
install.cfg
[root@host131 shell]#
```

# 步骤4: 清空数据并安装
# 管理脚本的说明
目前的功能，稍微包了一下，参看如下usage即可知道：
```shell
[root@host131 shell]# sh all-k8s-mgnt.sh 
Usage: all-k8s-mgnt.sh ACTION TYPE
       ACTION:start|stop|restart|status|install|clear
       TYPE:master|node|docker|ssl|apiserver|scheduler|controller
            kubelet|kubeproxy|flannel|etcd

[root@host131 shell]#
```
主要是一行行的systemctl和执行各个脚本太繁琐，稍作简化。需要说明的是clear会删除所有的临时文件和设定文件，请各位执行之前务必确认不要删错
```shell
if [ _"$ACTION" = _"clear" ]; then
  # in order to avoid rm -rf / : here hard coding for default dir
  echo "## data dir clear operation begins..."
  echo " # clear ssl dirs "
  rm -rf /etc/ssl/{ca,etcd,flannel,k8s} 
  echo " # clear etc dirs " 
  rm -rf /etc/{docker,flannel,k8s,etcd,kubernetes}
  echo " # clear log dirs "
  rm -rf /var/log/kubernetes
  echo " # clear working dirs or data dirs"
  rm -rf /var/lib/kubelet /var/lib/k8s /var/lib/docker /var/lib/etcd 
  echo "## data dir clear operation ends  ..."
  exit 0
fi
```
之所以没有参数化是因为，rm -rf 太容易传错，万一产生了个/ xxx的错误参数传进，锅就大了，请诸君谨慎为之。
另外需要说明的是pause镜像。另外众所周知，需要使用到pause镜像，这个镜像本来在download的脚本中取得，配置化最为合适，但是不知道源，只能使用docker pull取下，而且这样需要download脚本安装docker，但是由于pause的源码很少，size也很小，所以将此镜像pull下来压缩之后放到了源码目录中，我也很绝望。

>执行命令：
sh all-k8s-mgnt.sh stop all; sh all-k8s-mgnt.sh clear all; sh all-k8s-mgnt.sh install all

* 执行日志
```shell
[root@host131 shell]# sh all-k8s-mgnt.sh stop all; sh all-k8s-mgnt.sh clear all; sh all-k8s-mgnt.sh install all
## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: ssl begins ...
## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: ssl ends  ...

## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: etcd begins ...
## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: etcd ends  ...

## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: apiserver begins ...
## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: apiserver ends  ...

## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: scheduler begins ...
## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: scheduler ends  ...

## Fri Mar 29 05:57:32 CST 2019 ACTION: stop  Service: controller begins ...
## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: controller ends  ...

## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: flannel begins ...
## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: flannel ends  ...

## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: docker begins ...
## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: docker ends  ...

## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: kubelet begins ...
## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: kubelet ends  ...

## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: kubeproxy begins ...
## Fri Mar 29 05:57:33 CST 2019 ACTION: stop  Service: kubeproxy ends  ...

## data dir clear operation begins...
 # clear ssl dirs 
 # clear etc dirs 
 # clear log dirs 
 # clear working dirs or data dirs
## data dir clear operation ends  ...
## Fri Mar 29 05:57:33 CST 2019 ACTION: install  Service: ssl begins ...
2019/03/29 05:57:33 [INFO] generating a new CA key and certificate from CSR
2019/03/29 05:57:33 [INFO] generate received request
2019/03/29 05:57:33 [INFO] received CSR
2019/03/29 05:57:33 [INFO] generating key: rsa-2048
2019/03/29 05:57:34 [INFO] encoded CSR
2019/03/29 05:57:34 [INFO] signed certificate with serial number 585243779407386144618990056827689634538064257244
/etc/ssl/ca/ca-key.pem	/etc/ssl/ca/ca.pem

2019/03/29 05:57:34 [INFO] generate received request
2019/03/29 05:57:34 [INFO] received CSR
2019/03/29 05:57:34 [INFO] generating key: rsa-2048
2019/03/29 05:57:34 [INFO] encoded CSR
2019/03/29 05:57:34 [INFO] signed certificate with serial number 708327339669302515990753380895187969493749436475
2019/03/29 05:57:34 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
/etc/ssl/etcd/cert-etcd-key.pem  /etc/ssl/etcd/cert-etcd.pem
2019/03/29 05:57:34 [INFO] generate received request
2019/03/29 05:57:34 [INFO] received CSR
2019/03/29 05:57:34 [INFO] generating key: rsa-2048
2019/03/29 05:57:34 [INFO] encoded CSR
2019/03/29 05:57:34 [INFO] signed certificate with serial number 587917703148608899305012971587486783056748335259
2019/03/29 05:57:34 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
/etc/ssl/k8s/cert-k8s-key.pem  /etc/ssl/k8s/cert-k8s.pem
## Fri Mar 29 05:57:34 CST 2019 ACTION: install  Service: ssl ends  ...

## Fri Mar 29 05:57:34 CST 2019 ACTION: install  Service: etcd begins ...

##  stop etcd service

##  daemon reload service 

##  start etcd service 

##  enable etcd service 

##  check  etcd status
● etcd.service - Etcd Server
   Loaded: loaded (/usr/lib/systemd/system/etcd.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:57:35 CST; 168ms ago
   CGroup: /system.slice/etcd.service
           └─10661 /usr/local/bin/etcd --name=etcd-01 --data-dir=/var/lib/etcd//default.etcd --listen-peer-urls=https://192.168.163.131:2380 --listen-client-urls=https://192.168.163.131:2379,http://127.0.0.1:2379 --advertise-client-urls=https://192.168.163.131:2379 --initial-advertise-peer-urls=https://192.168.163.131:2380 --initial-cluster=etcd-01=https://192.168.163.131:2380 --initial-cluster-token=etcd-cluster --initial-cluster-state=new --cert-file=/etc/ssl/etcd/cert-etcd.pem --key-file=/etc/ssl/etcd/cert-etcd-key.pem --peer-cert-file=/etc/ssl/etcd/cert-etcd.pem --peer-key-file=/etc/ssl/etcd/cert-etcd-key.pem --trusted-ca-file=/etc/ssl/ca/ca.pem --peer-trusted-ca-file=/etc/ssl/ca/ca.pem

##  etcd version
etcd Version: 3.3.12
Git SHA: d57e8b8
Go Version: go1.10.8
Go OS/Arch: linux/amd64

##  etcd cluster health
https://192.168.163.131:2379 is healthy: successfully committed proposal: took = 1.709415ms
## Fri Mar 29 05:57:35 CST 2019 ACTION: install  Service: etcd ends  ...

## Fri Mar 29 05:57:35 CST 2019 ACTION: install  Service: apiserver begins ...

##  kube-apiserver service

##  daemon reload service 

##  start kube-apiserver service 

##  enable kube-apiserver service 

##  check  kube-apiserver status
● kube-apiserver.service - Kubernetes API Server
   Loaded: loaded (/usr/lib/systemd/system/kube-apiserver.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:57:36 CST; 408ms ago
   CGroup: /system.slice/kube-apiserver.service
           └─10747 /usr/local/bin/kube-apiserver --logtostderr=true --v=4 --log-dir=/var/log/kubernetes --etcd-servers=https://192.168.163.131:2379 --bind-address=192.168.163.131 --secure-port=6443 --advertise-address=192.168.163.131 --allow-privileged=true --service-cluster-ip-range=172.200.0.0/16 --enable-admission-plugins=NamespaceLifecycle,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota,NodeRestriction --authorization-mode=RBAC,Node --enable-bootstrap-token-auth --token-auth-file=/etc/k8s/token.csv --service-node-port-range=30000-50000 --tls-cert-file=/etc/ssl/k8s/cert-k8s.pem --tls-private-key-file=/etc/ssl/k8s/cert-k8s-key.pem --client-ca-file=/etc/ssl/ca/ca.pem --service-account-key-file=/etc/ssl/ca/ca-key.pem --etcd-cafile=/etc/ssl/ca/ca.pem --etcd-certfile=/etc/ssl/etcd/cert-etcd.pem --etcd-keyfile=//etc/ssl/etcd/cert-etcd-key.pem
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517456   10747 flags.go:33] FLAG: --basic-auth-file=""
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517461   10747 flags.go:33] FLAG: --bind-address="192.168.163.131"
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517468   10747 flags.go:33] FLAG: --cert-dir="/var/run/kubernetes"
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517476   10747 flags.go:33] FLAG: --client-ca-file="/etc/ssl/ca/ca.pem"
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517482   10747 flags.go:33] FLAG: --cloud-config=""
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517488   10747 flags.go:33] FLAG: --cloud-provider=""
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517494   10747 flags.go:33] FLAG: --cloud-provider-gce-lb-src-cidrs="130.211.0.0/22,209.85.152.0/22,209.85.204.0/22,35.191.0.0/16"
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517506   10747 flags.go:33] FLAG: --contention-profiling="false"
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517513   10747 flags.go:33] FLAG: --cors-allowed-origins="[]"
Mar 29 05:57:36 host131 kube-apiserver[10747]: I0329 05:57:36.517525   10747 flags.go:33] FLAG: --default-not-ready-toleration-seconds="300"

##  kubectl version
Client Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.4", GitCommit:"c27b913fddd1a6c480c229191a087698aa92f0b1", GitTreeState:"clean", BuildDate:"2019-02-28T13:37:52Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.4", GitCommit:"c27b913fddd1a6c480c229191a087698aa92f0b1", GitTreeState:"clean", BuildDate:"2019-02-28T13:30:26Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}

##  get cs
NAME                 STATUS      MESSAGE                                                                                     ERROR
scheduler            Unhealthy   Get http://127.0.0.1:10251/healthz: dial tcp 127.0.0.1:10251: connect: connection refused   
controller-manager   Unhealthy   Get http://127.0.0.1:10252/healthz: dial tcp 127.0.0.1:10252: connect: connection refused   
etcd-0               Healthy     {"health":"true"}                                                                           
## Fri Mar 29 05:57:50 CST 2019 ACTION: install  Service: apiserver ends  ...

## Fri Mar 29 05:57:50 CST 2019 ACTION: install  Service: scheduler begins ...

##  kube-scheduler service

##  daemon reload service 

##  start kube-scheduler service 

##  enable kube-scheduler service 

##  check  kube-scheduler status
● kube-scheduler.service - Kubernetes Scheduler
   Loaded: loaded (/usr/lib/systemd/system/kube-scheduler.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:57:50 CST; 321ms ago
   CGroup: /system.slice/kube-scheduler.service
           └─10831 /usr/local/bin/kube-scheduler --logtostderr=true --v=4 --log-dir=/var/log/kubernetes --master=127.0.0.1:8080 --leader-elect

##  get cs
NAME                 STATUS      MESSAGE                                                                                     ERROR
controller-manager   Unhealthy   Get http://127.0.0.1:10252/healthz: dial tcp 127.0.0.1:10252: connect: connection refused   
etcd-0               Healthy     {"health":"true"}                                                                           
scheduler            Healthy     ok                                                                                          
## Fri Mar 29 05:57:53 CST 2019 ACTION: install  Service: scheduler ends  ...

## Fri Mar 29 05:57:53 CST 2019 ACTION: install  Service: controller begins ...

##  kube-controller-manager service

##  daemon reload service 

##  start kube-controller-manager service 

##  enable kube-controller-manager service 

##  check  kube-controller-manager status
● kube-controller-manager.service - Kubernetes Controller Manager
   Loaded: loaded (/usr/lib/systemd/system/kube-controller-manager.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:57:54 CST; 350ms ago
   CGroup: /system.slice/kube-controller-manager.service
           └─10908 /usr/local/bin/kube-controller-manager --logtostderr=true --v=4 --log-dir=/var/log/kubernetes --master=127.0.0.1:8080 --leader-elect=true --address=127.0.0.1 --service-cluster-ip-range=172.200.0.0/16 --cluster-name=kubernetes --cluster-signing-cert-file=/etc/ssl/ca/ca.pem --cluster-signing-key-file=/etc/ssl/ca/ca-key.pem --root-ca-file=/etc/ssl/ca/ca.pem --service-account-private-key-file=/etc/ssl/ca/ca-key.pem
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451641   10908 flags.go:33] FLAG: --controllers="[*]"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451665   10908 flags.go:33] FLAG: --deleting-pods-burst="0"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451672   10908 flags.go:33] FLAG: --deleting-pods-qps="0.1"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451681   10908 flags.go:33] FLAG: --deployment-controller-sync-period="30s"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451689   10908 flags.go:33] FLAG: --disable-attach-detach-reconcile-sync="false"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451696   10908 flags.go:33] FLAG: --enable-dynamic-provisioning="true"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451702   10908 flags.go:33] FLAG: --enable-garbage-collector="true"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451709   10908 flags.go:33] FLAG: --enable-hostpath-provisioner="false"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451714   10908 flags.go:33] FLAG: --enable-taint-manager="true"
Mar 29 05:57:54 host131 kube-controller-manager[10908]: I0329 05:57:54.451720   10908 flags.go:33] FLAG: --experimental-cluster-signing-duration="8760h0m0s"

##  get cs
NAME                 STATUS    MESSAGE             ERROR
scheduler            Healthy   ok                  
etcd-0               Healthy   {"health":"true"}   
controller-manager   Healthy   ok                  
## Fri Mar 29 05:57:57 CST 2019 ACTION: install  Service: controller ends  ...

## Fri Mar 29 05:57:57 CST 2019 ACTION: install  Service: flannel begins ...
2019/03/29 05:57:57 [INFO] generate received request
2019/03/29 05:57:57 [INFO] received CSR
2019/03/29 05:57:57 [INFO] generating key: rsa-2048
2019/03/29 05:57:57 [INFO] encoded CSR
2019/03/29 05:57:57 [INFO] signed certificate with serial number 23477008470875121871556145634653991153550817337
2019/03/29 05:57:57 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
/etc/ssl/flannel/flanneld-key.pem  /etc/ssl/flannel/flanneld.pem
{"Network":"172.200.0.0/16", "SubnetLen": 21, "Backend": {"Type": "vxlan"}}

##  flanneld service

##  daemon reload service 

##  start flannel service 

##  enable flannel service 
● flanneld.service - Flanneld Service
   Loaded: loaded (/usr/lib/systemd/system/flanneld.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:57:58 CST; 253ms ago
     Docs: https://github.com/coreos/flannel
 Main PID: 11029 (flanneld)
   CGroup: /system.slice/flanneld.service
           └─11029 /usr/local/bin/flanneld -etcd-cafile=/etc/ssl/ca/ca.pem -etcd-certfile=/etc/ssl/flannel/flanneld.pem -etcd-keyfile...

Mar 29 05:57:58 host131 systemd[1]: flanneld.service failed.
Mar 29 05:57:58 host131 systemd[1]: Starting Flanneld Service...
Mar 29 05:57:58 host131 systemd[1]: Started Flanneld Service.
Mar 29 05:57:59 host131 flanneld[11029]: I0329 05:57:59.063944   11029 main.go:488] Using interface with name enp0s3 and addre...163.131
Mar 29 05:57:59 host131 flanneld[11029]: warning: ignoring ServerName for user-provided CA for backwards compatibility is deprecated
Mar 29 05:57:59 host131 flanneld[11029]: I0329 05:57:59.094697   11029 main.go:505] Defaulting external address to interface a...63.131)
Mar 29 05:57:59 host131 flanneld[11029]: I0329 05:57:59.095806   11029 main.go:235] Created subnet manager: Etcd Local Manager...40.0/21
Mar 29 05:57:59 host131 flanneld[11029]: I0329 05:57:59.095820   11029 main.go:238] Installing signal handlers
Mar 29 05:57:59 host131 flanneld[11029]: I0329 05:57:59.179367   11029 main.go:353] Found network config - Backend type: vxlan
Mar 29 05:57:59 host131 flanneld[11029]: I0329 05:57:59.179438   11029 vxlan.go:120] VXLAN config: VNI=1 Port=0 GBP=false Dire...g=false
Hint: Some lines were ellipsized, use -l to show in full.
## Fri Mar 29 05:57:59 CST 2019 ACTION: install  Service: flannel ends  ...

## Fri Mar 29 05:57:59 CST 2019 ACTION: install  Service: docker begins ...

##  docker service

##  daemon reload service 

##  start docker service 

##  enable docker service 

##  check  docker status
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:57:59 CST; 264ms ago
   CGroup: /system.slice/docker.service
           ├─11123 /usr/local/bin/dockerd --bip=172.200.240.1/21 --ip-masq=false --mtu=1450 --registry-mirror=https://hub-mirror.c.163.com -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --selinux-enabled=false --log-opt max-size=1g
           └─11126 docker-containerd -l unix:///var/run/docker/libcontainerd/docker-containerd.sock --metrics-interval=0 --start-timeout 2m --state-dir /var/run/docker/libcontainerd/containerd --shim docker-containerd-shim --runtime docker-runc

##  check docker version
Client:
 Version:      17.03.2-ce
 API version:  1.27
 Go version:   go1.7.5
 Git commit:   f5ec1e2
 Built:        Tue Jun 27 01:35:00 2017
 OS/Arch:      linux/amd64

Server:
 Version:      17.03.2-ce
 API version:  1.27 (minimum version 1.12)
 Go version:   go1.7.5
 Git commit:   f5ec1e2
 Built:        Tue Jun 27 01:35:00 2017
 OS/Arch:      linux/amd64
 Experimental: false

##  load pause imgage for kubelet
e17133b79956: Loading layer [==================================================>] 744.4 kB/744.4 kB
Loaded image: gcr.io/google_containers/pause-amd64:3.1
## Fri Mar 29 05:58:01 CST 2019 ACTION: install  Service: docker ends  ...

## Fri Mar 29 05:58:01 CST 2019 ACTION: install  Service: kubelet begins ...
2019/03/29 05:58:01 [INFO] generate received request
2019/03/29 05:58:01 [INFO] received CSR
2019/03/29 05:58:01 [INFO] generating key: rsa-2048
2019/03/29 05:58:02 [INFO] encoded CSR
2019/03/29 05:58:02 [INFO] signed certificate with serial number 575829489757904973631963781092908148602885563837
2019/03/29 05:58:02 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
/etc/ssl/k8s/cert-kubeproxy-key.pem  /etc/ssl/k8s/cert-kubeproxy.pem
Cluster "kubernetes" set.
User "kubelet-bootstrap" set.
Context "default" created.
Switched to context "default".
Cluster "kubernetes" set.
User "kube-proxy" set.
Context "default" created.
Switched to context "default".
clusterrolebinding.rbac.authorization.k8s.io/kubelet-bootstrap created

##  kubelet service

##  daemon reload service 

##  start kubelet service 

##  enable kubelet service 

##  check  kubelet status
● kubelet.service - Kubernetes Kubelet Service
   Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:58:05 CST; 358ms ago
   CGroup: /system.slice/kubelet.service
           ├─11334 /usr/local/bin/kubelet --logtostderr=true --v=4 --log-dir=/var/log/kubernetes --root-dir=/var/lib/kubelet --cert-dir=/etc/ssl/k8s --fail-swap-on=false --hostname-override=192.168.163.131 --bootstrap-kubeconfig=/etc/ssl/k8s/bootstrap.kubeconfig --kubeconfig=/etc/k8s/kubelet.kubeconfig --config=/etc/k8s/kubelet-config.yaml --pod-infra-container-image=gcr.io/google_containers/pause-amd64:3.1 --allow-privileged=true --event-qps=0 --kube-api-qps=1000 --kube-api-burst=2000 --registry-qps=0 --image-pull-progress-deadline=30m
           └─11362 systemd-run --description=Kubernetes systemd probe --scope true
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.281387   11334 flags.go:33] FLAG: --cgroup-root=""
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.281393   11334 flags.go:33] FLAG: --cgroups-per-qos="true"
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.281399   11334 flags.go:33] FLAG: --chaos-chance="0"
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.281412   11334 flags.go:33] FLAG: --client-ca-file=""
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.281424   11334 flags.go:33] FLAG: --cloud-config=""
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.281431   11334 flags.go:33] FLAG: --cloud-provider=""
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.281437   11334 flags.go:33] FLAG: --cluster-dns="[]"
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.305541   11334 flags.go:33] FLAG: --cluster-domain=""
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.305557   11334 flags.go:33] FLAG: --cni-bin-dir="/opt/cni/bin"
Mar 29 05:58:05 host131 kubelet[11334]: I0329 05:58:05.305566   11334 flags.go:33] FLAG: --cni-conf-dir="/etc/cni/net.d"


##  get csr information
No resources found.
##  kubectl get nodes 
No resources found.
## Fri Mar 29 05:58:06 CST 2019 ACTION: install  Service: kubelet ends  ...

## Fri Mar 29 05:58:06 CST 2019 ACTION: install  Service: kubeproxy begins ...

##  kube-proxy service

##  daemon reload service 

##  start kube-proxy service 

##  enable kube-proxy service 

##  check  kube-proxy status
● kube-proxy.service - Kubernetes Kube-Proxy Service
   Loaded: loaded (/usr/lib/systemd/system/kube-proxy.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-03-29 05:58:06 CST; 381ms ago
   CGroup: /system.slice/kube-proxy.service
           ├─11417 /usr/local/bin/kube-proxy --logtostderr=true --v=4 --log-dir=/var/log/kubernetes --config=/etc/k8s/kube-proxy-config.yaml
           └─11461 modprobe -- nf_conntrack_ipv4
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771396   11417 flags.go:33] FLAG: --proxy-port-range=""
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771402   11417 flags.go:33] FLAG: --resource-container="/kube-proxy"
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771407   11417 flags.go:33] FLAG: --skip-headers="false"
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771414   11417 flags.go:33] FLAG: --stderrthreshold="2"
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771418   11417 flags.go:33] FLAG: --udp-timeout="250ms"
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771424   11417 flags.go:33] FLAG: --v="4"
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771432   11417 flags.go:33] FLAG: --version="false"
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771439   11417 flags.go:33] FLAG: --vmodule=""
Mar 29 05:58:06 host131 kube-proxy[11417]: I0329 05:58:06.771444   11417 flags.go:33] FLAG: --write-config-to=""
## Fri Mar 29 05:58:06 CST 2019 ACTION: install  Service: kubeproxy ends  ...

[root@host131 shell]#
```

整体33秒执行完毕，然后手动approve csr，虽然这么多年没有玩游戏，但是依然宝刀不老，保持良好的竞技状态，保证了一分钟之内看到kublet节点，当然你也可以直接在将这几行写到脚本里，由于后续确保多节点的配置，所以这里的approve操作，先手动进行了。
```shell
[root@host131 shell]# kubectl get csr
NAME                                                   AGE   REQUESTOR           CONDITION
node-csr-bsqF7Cc5M0dMi17o-4C8peI7q8JW1HZHE8nIZ5uCno0   10s   kubelet-bootstrap   Pending
[root@host131 shell]# kubectl certificate approve node-csr-bsqF7Cc5M0dMi17o-4C8peI7q8JW1HZHE8nIZ5uCno0
certificatesigningrequest.certificates.k8s.io/node-csr-bsqF7Cc5M0dMi17o-4C8peI7q8JW1HZHE8nIZ5uCno0 approved
[root@host131 shell]# 
[root@host131 shell]# kubectl get nodes -o wide
NAME              STATUS   ROLES    AGE   VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION          CONTAINER-RUNTIME
192.168.163.131   Ready    <none>   6s    v1.13.4   192.168.163.131   <none>        CentOS Linux 7 (Core)   3.10.0-957.el7.x86_64   docker://17.3.2
[root@host131 shell]# 
[root@host131 shell]# kubectl version
Client Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.4", GitCommit:"c27b913fddd1a6c480c229191a087698aa92f0b1", GitTreeState:"clean", BuildDate:"2019-02-28T13:37:52Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.4", GitCommit:"c27b913fddd1a6c480c229191a087698aa92f0b1", GitTreeState:"clean", BuildDate:"2019-02-28T13:30:26Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
[root@host131 shell]# kubectl get cs
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok                  
scheduler            Healthy   ok                  
etcd-0               Healthy   {"health":"true"}   
[root@host131 shell]# 
[root@host131 shell]# date
Fri Mar 29 05:58:30 CST 2019
[root@host131 shell]#
```

# 总结
使用简化的脚本，快速完成了kubernetes1.13.4的版本安装，理论上对于其他版本主要在于启动参数的微调即可满足，可自行设定即可。

注：本来名字是3分钟部署单机版kubernetes，觉得有点标题党的意思，看了一下由于安装在1分之内完成，于是默默地把标题写了了1分钟部署单机版kubernetes了，纯粹一个乐子而已，诸君不必在意。

# 整体操作
* https://blog.csdn.net/liumiaocn/article/details/88413428
