#!/bin/sh

usage(){
  echo "Usage: $0 ACTION TYPE"
  echo "       ACTION:start|stop|restart|status|install|clear"
  echo "       TYPE:master|node|docker|ssl|apiserver|scheduler|controller"
  echo "            kubelet|kubeproxy|flannel|etcd|dashboard|coredns|heapster"
  echo ""
}

ACTION=$1
TYPE=$2

. ./install.cfg

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

if [ _"$ACTION" = _"clear" ]; then
  # stop service first
  sh $0 stop all

  # in order to avoid rm -rf / : here hard coding for default dir
  echo "## data dir clear operation begins..."
  echo " # clear ssl dirs "
  rm -rf /etc/ssl/{ca,etcd,flannel,k8s} 
  echo " # clear etc dirs " 
  rm -rf /etc/{docker,flannel,k8s,etcd,kubernetes}
  echo " # clear log dirs "
  rm -rf /var/log/kubernetes
  echo " # cler ~/.kube"
  rm -rf ~/.kube
  echo " # clear working dirs or data dirs"
  umount_dirs=`rm -rf /var/lib/kubelet /var/lib/k8s /var/lib/docker /var/lib/etcd 2>&1 |awk -F\' '{print $2}'`
  for umount_dir in $umount_dirs
  do
    echo "#   umount $umount_dir"
    umount $umount_dir
  done
  echo "## data dir clear operation ends  ..."
  exit 0
fi

if [ _"$ACTION" = _"install" ]; then
  if [ ! -d ${ENV_HOME_BINARY} ]; then
    echo "## Error: offline binary files directory does not exist"
    echo "   please check dir [$ENV_HOME_BINARY]"
    exit
  fi 
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"ssl" ]; then
  sh k8s-mgnt.sh $ACTION "ssl"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"etcd" ]; then
  sh k8s-mgnt.sh $ACTION "etcd"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"apiserver" ]; then
  sh k8s-mgnt.sh $ACTION "apiserver"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"scheduler" ]; then
  sh k8s-mgnt.sh $ACTION "scheduler"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"master" -o _"$TYPE" = _"controller" ]; then
  sh k8s-mgnt.sh $ACTION "controller"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"flannel" ]; then
  sh k8s-mgnt.sh $ACTION "flannel"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"docker" ]; then
  sh k8s-mgnt.sh $ACTION "docker"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"kubelet" ]; then
  sh k8s-mgnt.sh $ACTION "kubelet"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"node" -o _"$TYPE" = _"kubeproxy" ]; then
  sh k8s-mgnt.sh $ACTION "kubeproxy"
fi

if [ _"$TYPE" = _"all" -o _"$TYPE" = _"init" ]; then
  sh k8s-mgnt.sh $ACTION "init"
  sh k8s-mgnt.sh $ACTION "coredns"
fi

if [ _"$TYPE" = _"coredns" ]; then
  sh k8s-mgnt.sh $ACTION "coredns"
fi

if [ _"$TYPE" = _"dashboard" ]; then
  sh k8s-mgnt.sh $ACTION "dashboard"
fi

if [ _"$TYPE" = _"heapster" ]; then
  sh k8s-mgnt.sh $ACTION "heapster"
fi
