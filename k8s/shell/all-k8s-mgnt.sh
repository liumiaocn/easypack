#!/bin/sh

usage(){
  echo "Usage: $0 ACTION TYPE"
  echo "       ACTION:start|stop|restart|status|install"
  echo "       TYPE:master|node|docker|ssl|apiserver|scheduler|controller"
  echo "            kubelet|kubeproxy|flannel|etcd"
  echo ""
}

ACTION=$1
TYPE=$2

if [ $# -ne 2 ]; then
  usage
  exit 1
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
