#!/bin/sh

. ./install.cfg

echo -e "\n##  kube-scheduler service"
systemctl stop kube-scheduler 2>/dev/null

mkdir -p ${ENV_KUBE_DIR_BIN} ${ENV_KUBE_DIR_ETC} ${ENV_KUBE_OPT_LOG_DIR}
chmod 755 ${ENV_HOME_K8S}/*
cp -p ${ENV_HOME_K8S}/kube-scheduler ${ENV_KUBE_DIR_BIN}
if [ $? -ne 0 ]; then
  echo "please check kube-scheduler binary files existed in ${ENV_HOME_K8S}/ or not"
  exit 
fi

# create kube-scheduler configuration file
cat >${ENV_KUBE_DIR_ETC}/${ENV_KUBE_SCH_ETC} <<EOF
KUBE_SCHEDULER_OPTS="--logtostderr=true \
--v=${ENV_KUBE_OPT_LOG_LEVEL} \
--log-dir=${ENV_KUBE_OPT_LOG_DIR} \
--master=${ENV_KUBE_MASTER_ADDR} \
--leader-elect"
EOF

# Create the kube-scheduler service.
cat >${ENV_KUBE_SCH_SERVICE} <<EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
EnvironmentFile=-${ENV_KUBE_DIR_ETC}/${ENV_KUBE_SCH_ETC}
ExecStart=${ENV_KUBE_DIR_BIN}/kube-scheduler \$KUBE_SCHEDULER_OPTS
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n##  daemon reload service "
systemctl daemon-reload
echo -e "\n##  start kube-scheduler service "
systemctl start kube-scheduler
echo -e "\n##  enable kube-scheduler service " 
systemctl enable kube-scheduler
echo -e "\n##  check  kube-scheduler status"
systemctl status kube-scheduler

# sleep 2 seconds for checking
sleep 2

echo -e "\n##  get cs"
kubectl get cs
