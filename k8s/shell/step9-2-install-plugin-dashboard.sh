#!/bin/sh

. ./install.cfg
. ./common-util.sh

check_image ${ENV_DASHBOARD_YAML_DIR}/${ENV_DASHBOARD_YAML_FILE}

cd ${ENV_DASHBOARD_YAML_DIR}
echo "## the following keyword needs to be replaced"
grep -n ${ENV_DASHBOARD_KEYWORD} ${ENV_DASHBOARD_YAML_FILE}
echo

echo "## replace ENV_DASHBOARD_KEYWORD"
sed -i -e "s/__DASHBOARD_NODE_PORT__/${ENV_DASHBOARD_NODEPORT}/" ${ENV_DASHBOARD_YAML_FILE}

reset_service `pwd`

# create and display dashboard token
create_dashboard_token
sleep ${ENV_DEFAULT_SLEEP_INTERVAL}

display_dashboard_token
sleep ${ENV_DEFAULT_SLEEP_INTERVAL}

echo "## display dashboard information"
sleep ${ENV_DEFAULT_SLEEP_INTERVAL}

kubectl get all -n kube-system |egrep -e 'dashboard|NAME'
