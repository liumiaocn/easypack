#!/bin/sh

# read env vars and common functions
. ./install.cfg
. ./common-util.sh

install_heapster(){
  check_image ${ENV_HEAPSTER_YAML_DIR}/${ENV_HEAPSTER_YAML_FILE}
  check_image ${ENV_HEAPSTER_YAML_DIR}/${ENV_HEAPSTER_GRAFANA_YAML_FILE}
  check_image ${ENV_HEAPSTER_YAML_DIR}/${ENV_HEAPSTER_INFLUXDB_YAML_FILE}

  reset_service ${ENV_HEAPSTER_YAML_DIR}

  echo "## begin check heapster, wait for ${ENV_DEFAULT_SLEEP_INTERVAL}s ..."
  sleep ${ENV_DEFAULT_SLEEP_INTERVAL}

  kubectl get all -n kube-system |egrep -e 'heapster|monitoring|NAME'
}

install_heapster
