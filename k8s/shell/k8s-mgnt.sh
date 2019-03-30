#!/bin/sh


usage(){
  echo "Usage: $0 ACTION TYPE"
  echo "       ACTION:start|stop|restart|status|install|uninstall"
  echo "       TYPE:master|node|docker|apiserver|scheduler|controller"
  echo "            kubelet|kubeproxy|flannel|etcd|dashboard|coredns|heapster"
  echo ""
}

# read env vars and common functions
. ./install.cfg
. ./common-util.sh

service_action(){
  act_type=$1
  act_obj=$2

  if [ _"$act_obj" = _"ssl" ]; then
    service_name=""
    cmds="step1-prepare-cert.sh step1-2-prepare-admin-cert.sh step1-3-prepare-setting.sh"
  elif [ _"$act_obj" = _"etcd" ]; then
    service_name="etcd"
    cmds="step2-install-etcd.sh"
  elif [ _"$act_obj" = _"apiserver" ]; then
    service_name="kube-apiserver"
    cmds="step3-install-apiserver.sh"
  elif [ _"$act_obj" = _"scheduler" ]; then
    service_name="kube-scheduler"
    cmds="step4-install-scheduler.sh"
  elif [ _"$act_obj" = _"controller" ]; then
    service_name="kube-controller-manager"
    cmds="step5-install-controller-manager.sh"
  elif [ _"$act_obj" = _"flannel" ]; then
    service_name="flanneld"
    cmds="step6-install-flannel.sh"
  elif [ _"$act_obj" = _"docker" ]; then
    service_name="docker"
    cmds="step7-install-docker.sh"
  elif [ _"$act_obj" = _"kubelet" ]; then
    service_name="kubelet"
    cmds="step8-1-prepare-node.sh step8-2-install-kubelet.sh"
  elif [ _"$act_obj" = _"kubeproxy" ]; then
    service_name="kube-proxy"
    cmds="step8-3-install-kubeproxy.sh"
  elif [ _"$act_obj" = _"init" ]; then
    service_name=""
    cmds="step9-1-setting-for-init.sh"
  elif [ _"$act_obj" = _"dashboard" ]; then
    service_name=""
    cmds="step9-2-install-plugin-dashboard.sh"
  elif [ _"$act_obj" = _"coredns" ]; then
    service_name=""
    cmds="step9-3-install-plugin-coredns.sh"
  elif [ _"$act_obj" = _"heapster" ]; then
    service_name=""
    cmds="step9-4-install-plugin-heapster.sh"
  else
    service_name=""
    echo "[no action executed]"
  fi
  echo "## `date` ACTION: $act_type  Service: $act_obj begins ..."
  if [ _"$act_type" = _"install" -o "$act_type" = _"INSTALL" ]; then
    for cmd in $cmds
    do
      sh $cmd
    done
  else
    if [ _"$service_name" != _"" ]; then
      systemctl daemon-reload
      systemctl $act_type $service_name
    fi
  fi
  echo "## `date` ACTION: $act_type  Service: $act_obj ends  ..."
  echo
}

ACTION=$1
TYPE=$2

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

if [ _"$ACTION" = _"stop" -o _"$ACTION" = _"STOP" ]; then
  service_action ${ACTION} ${TYPE}
elif [ _"$ACTION" = _"start" -o _"$ACTION" = _"START" ]; then
  service_action ${ACTION} ${TYPE}
elif [ _"$ACTION" = _"restart" -o _"$ACTION" = _"RESTART" ]; then
  service_action ${ACTION} ${TYPE}
elif [ _"$ACTION" = _"status" -o _"$ACTION" = _"STATUS" ]; then
  service_action ${ACTION} ${TYPE} |egrep '\.service|Active:|\-\-| ACTION: ' 
  echo
elif [ _"$ACTION" = _"install" -o _"$ACTION" = _"INSTALL" ]; then
  service_action ${ACTION} ${TYPE}
else
  usage
  exit 1
fi

