#!/bin/sh

. ./install.cfg

echo -e "\n##  kubelet service"
systemctl stop kubelet 2>/dev/null

mkdir -p ${ENV_KUBE_DIR_BIN} ${ENV_KUBE_DIR_ETC} ${ENV_KUBE_OPT_LOG_DIR} ${ENV_KUBELET_DIR_WORKING}
chmod 755 ${ENV_HOME_K8S}/*
cp -p ${ENV_HOME_K8S}/kubelet ${ENV_KUBE_DIR_BIN}
if [ $? -ne 0 ]; then
  echo "please check kubelet binary files existed in ${ENV_HOME_K8S}/ or not"
  exit 
fi

# create kubelet configuration file
cat >${ENV_KUBE_DIR_ETC}/${ENV_KUBE_KUBELET_ETC} <<EOF
KUBELET_OPTS="--logtostderr=${ENV_KUBE_OPT_LOGTOSTDERR} \\
--v=${ENV_KUBE_OPT_LOG_LEVEL} \\
--log-dir=${ENV_KUBE_OPT_LOG_DIR} \\
--root-dir=${ENV_KUBELET_DIR_WORKING} \\
--cert-dir=${ENV_SSL_K8S_DIR} \\
--fail-swap-on=${ENV_KUBELET_OPT_FAIL_SWAP_ON} \\
--hostname-override=${ENV_KUBE_NODE_HOSTNAME} \\
--bootstrap-kubeconfig=${ENV_SSL_K8S_DIR}/${ENV_KUBECONFIG_BOOTSTRAP} \\
--kubeconfig=${ENV_KUBE_DIR_ETC}/${ENV_KUBELET_KUBECONFIG} \\
--config=${ENV_KUBE_DIR_ETC}/${ENV_KUBELET_OPT_CONFIG} \\
--pod-infra-container-image=${ENV_KUBE_OPT_PAUSE} \\
--event-qps=${ENV_KUBELET_OPT_EVENT_QPS} \\
--kube-api-qps=${ENV_KUBELET_OPT_KPI_QPS} \\
--kube-api-burst=${ENV_KUBELET_OPT_API_BRUST} \\
--registry-qps=${ENV_KUBELET_OPT_REG_QPS} \\
--image-pull-progress-deadline=${ENV_KUBELET_OPT_IMG_PULL_DEADLINE}"
EOF

# create kubelet config yaml file for config option
cat >${ENV_KUBE_DIR_ETC}/${ENV_KUBELET_OPT_CONFIG} <<EOF 
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: ${ENV_KUBELET_CONFIG_OPT_ANONYMOUS}
  webhook:
    enabled: ${ENV_KUBELET_CONFIG_OPT_WEBHOOK}
  x509:
    clientCAFile: "${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM}"
authorization:
  mode: ${ENV_KUBELET_CONFIG_OPT_MODE}
clusterDomain: "${ENV_KUBELET_CONFIG_OPT_CLUSTER_DOMAIN}"
clusterDNS:
  - "${ENV_KUBELET_CONFIG_OPT_CLUSTER_DNS}"
podCIDR: "${ENV_KUBE_OPT_CLUSTER_IP_RANGE}"
maxPods: ${ENV_KUBELET_CONFIG_OPT_MAXPODS}
serializeImagePulls: ${ENV_KUBELET_CONFIG_OPT_SERIALIZE_IMG_PULL}
hairpinMode: ${ENV_KUBELET_CONFIG_OPT_HAIRPIN}
cgroupDriver: ${ENV_KUBELET_CONFIG_OPT_CGROUP_DRIVER}
runtimeRequestTimeout: "${ENV_KUBELET_CONFIG_OPT_REQUEST_TMO}"
rotateCertificates: ${ENV_KUBELET_CONFIG_OPT_ROTATE_CERT}
serverTLSBootstrap: ${ENV_KUBELET_CONFIG_OPT_TLS_BOOTSTRAP}
readOnlyPort: ${ENV_KUBELET_CONFIG_OPT_READONLY_PORT}
port: ${ENV_KUBELET_CONFIG_OPT_PORT}
address: "${ENV_KUBE_NODE_HOSTNAME}"
EOF

# Create the kubelet service.
cat >${ENV_KUBE_KUBELET_SERVICE} <<EOF
[Unit]
Description=Kubernetes Kubelet Service
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=${ENV_KUBELET_DIR_WORKING}
EnvironmentFile=-${ENV_KUBE_DIR_ETC}/${ENV_KUBE_KUBELET_ETC}
ExecStart=${ENV_KUBE_DIR_BIN}/kubelet \$KUBELET_OPTS
Restart=always
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n##  daemon reload service "
systemctl daemon-reload
echo -e "\n##  start kubelet service "
systemctl start kubelet
echo -e "\n##  enable kubelet service " 
systemctl enable kubelet
echo -e "\n##  check  kubelet status"
systemctl status kubelet |egrep '\.service|Active:|\-\-'


echo
echo -e "\n##  get csr information"
kubectl get csr

echo -e "##  kubectl get nodes "
kubectl get nodes -o wide
