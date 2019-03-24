#!/bin/sh

. ./install.cfg

echo -e "\n##  kube-controller-manager service"
systemctl stop kube-controller-manager 2>/dev/null

mkdir -p ${ENV_KUBE_DIR_BIN} ${ENV_KUBE_DIR_ETC} ${ENV_KUBE_OPT_LOG_DIR}
chmod 755 ${ENV_HOME_K8S}/*
cp -p ${ENV_HOME_K8S}/kube-controller-manager ${ENV_KUBE_DIR_BIN}
if [ $? -ne 0 ]; then
  echo "please check kube-controller-manager binary files existed in ${ENV_HOME_K8S}/ or not"
  exit 
fi

# create kube-controller-manager configuration file
cat >${ENV_KUBE_DIR_ETC}/${ENV_KUBE_CM_ETC} <<EOF
KUBE_CONTROLLER_MANAGER_OPTS="--logtostderr=${ENV_KUBE_OPT_LOGTOSTDERR} \
--v=${ENV_KUBE_OPT_LOG_LEVEL} \
--log-dir=${ENV_KUBE_OPT_LOG_DIR} \
--master=${ENV_KUBE_MASTER_ADDR} \
--leader-elect=${ENV_KUBE_OPT_LEADER_ELECT} \
--address=${ENV_KUBE_OPT_LOCALHOST} \
--service-cluster-ip-range=${ENV_KUBE_OPT_CLUSTER_IP_RANGE} \
--cluster-name=${ENV_KUBE_OPT_CLUSTER_NAME} \
--cluster-signing-cert-file=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
--cluster-signing-key-file=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY}  \
--root-ca-file=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
--service-account-private-key-file=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY}"
EOF

# Create the kube-controller-manager service.
cat >${ENV_KUBE_CM_SERVICE} <<EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
EnvironmentFile=-${ENV_KUBE_DIR_ETC}/${ENV_KUBE_CM_ETC}
ExecStart=${ENV_KUBE_DIR_BIN}/kube-controller-manager \$KUBE_CONTROLLER_MANAGER_OPTS
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n##  daemon reload service "
systemctl daemon-reload
echo -e "\n##  start kube-controller-manager service "
systemctl start kube-controller-manager
echo -e "\n##  enable kube-controller-manager service " 
systemctl enable kube-controller-manager
echo -e "\n##  check  kube-controller-manager status"
systemctl status kube-controller-manager |egrep '\.service|Active:|\-\-'

# sleep 2 seconds for checking
sleep 2

echo -e "\n##  get cs"
kubectl get cs
