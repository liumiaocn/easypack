#!/bin/sh

. ./install.cfg

echo -e "\n##  kube-proxy service"
systemctl stop kube-proxy 2>/dev/null

mkdir -p ${ENV_KUBE_DIR_BIN} ${ENV_KUBE_DIR_ETC} ${ENV_KUBE_OPT_LOG_DIR} ${ENV_KUBE_PROXY_DIR_WORKING}
chmod 755 ${ENV_HOME_K8S}/*
cp -p ${ENV_HOME_K8S}/kube-proxy ${ENV_KUBE_DIR_BIN}
if [ $? -ne 0 ]; then
  echo "please check kube-proxy binary files existed in ${ENV_HOME_K8S}/ or not"
  exit 
fi

# create kube-proxy configuration file
cat >${ENV_KUBE_DIR_ETC}/${ENV_KUBE_PROXY_ETC} <<EOF
KUBE_PROXY_OPTS="--logtostderr=${ENV_KUBE_OPT_LOGTOSTDERR} \\
--v=${ENV_KUBE_OPT_LOG_LEVEL} \\
--log-dir=${ENV_KUBE_OPT_LOG_DIR} \\
--config=${ENV_KUBE_DIR_ETC}/${ENV_KUBE_PROXY_PROXY_CONFIG}"
EOF

cat >${ENV_KUBE_DIR_ETC}/${ENV_KUBE_PROXY_PROXY_CONFIG} <<EOF
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "${ENV_SSL_K8S_DIR}/${ENV_KUBECONFIG_KUBEPROXY}"
bindAddress: ${ENV_KUBE_NODE_HOSTNAME}
clusterCIDR: ${ENV_KUBE_OPT_CLUSTER_IP_RANGE}
healthzBindAddress: ${ENV_KUBE_NODE_HOSTNAME}:${ENV_KUBE_PROXY_CONFIG_PORT_HEALTH}
hostnameOverride: ${ENV_KUBE_NODE_HOSTNAME}
metricsBindAddress: ${ENV_KUBE_NODE_HOSTNAME}:${ENV_KUBE_PROXY_CONFIG_PORT_METRICS}
mode: "${ENV_KUBE_PROXY_CONFIG_MODE}"
EOF

# Create the kube-proxy service.
cat >${ENV_KUBE_PROXY_SERVICE} <<EOF
[Unit]
Description=Kubernetes Kube-Proxy Service
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
After=network.target

[Service]
WorkingDirectory=${ENV_KUBE_PROXY_DIR_WORKING}
EnvironmentFile=-${ENV_KUBE_DIR_ETC}/${ENV_KUBE_PROXY_ETC}
ExecStart=${ENV_KUBE_DIR_BIN}/kube-proxy \$KUBE_PROXY_OPTS
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n##  daemon reload service "
systemctl daemon-reload
echo -e "\n##  start kube-proxy service "
systemctl start kube-proxy
echo -e "\n##  enable kube-proxy service " 
systemctl enable kube-proxy
echo -e "\n##  check  kube-proxy status"
systemctl status kube-proxy |egrep '\.service|Active:|\-\-'
