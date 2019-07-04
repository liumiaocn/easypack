#!/bin/sh

# read env vars and common functions
. ./install.cfg
. ./common-util.sh

install_coredns(){
  docker load -i ${ENV_HOME_IMAGE_COREDNS}

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

  echo "## begin check coredns, wait for ${ENV_DEFAULT_SLEEP_INTERVAL}s ..."
  sleep ${ENV_DEFAULT_SLEEP_INTERVAL}
  kubectl get all -n kube-system |egrep -e 'dns|NAME'
}

install_coredns
