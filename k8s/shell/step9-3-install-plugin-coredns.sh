#!/bin/sh

# read env vars and common functions
. ./install.cfg
. ./common-util.sh

install_coredns(){
  check_image ${ENV_COREDNS_YAML_DIR}/${ENV_COREDNS_YAML_FILE}

  cd ${ENV_COREDNS_YAML_DIR}
  echo "## the following keyword needs to be replaced"
  grep -n ${ENV_COREDNS_KEYWORD} ${ENV_COREDNS_YAML_FILE}
  echo

  echo "## replace __PILLAR__DNS__DOMAIN__"
  sed -i -e "s/__PILLAR__DNS__DOMAIN__/${ENV_KUBELET_CONFIG_OPT_CLUSTER_DOMAIN}/" ${ENV_COREDNS_YAML_FILE}
  echo "## replace __PILLAR__DNS__SERVER__"
  sed -i -e "s/__PILLAR__DNS__SERVER__/${ENV_KUBELET_CONFIG_OPT_CLUSTER_DNS}/" ${ENV_COREDNS_YAML_FILE}

  reset_service `pwd`

  echo "## check service "
  kubectl get svc -n kube-system

  echo "## begin check pods, wait for ${ENV_DEFAULT_SLEEP_INTERVAL}s ..."
  sleep ${ENV_DEFAULT_SLEEP_INTERVAL}
  kubectl get pods -n kube-system
}

install_coredns
