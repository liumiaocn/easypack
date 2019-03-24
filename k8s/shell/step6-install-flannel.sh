#!/bin/sh

. ./install.cfg

# set cfssl tools in search path
chmod 755 ${ENV_HOME_CFSSL}/*
if [ $? -ne 0 ]; then
  echo "prepare downloaded cfssl tools in ${ENV_HOME_CFSSL} in advance"
  exit
fi

export PATH=${ENV_HOME_CFSSL}:$PATH

mkdir -p ${ENV_SSL_FLANNEL_DIR}
cd  ${ENV_SSL_FLANNEL_DIR}
if [ $? -ne 0 ]; then
  echo "failed to create dir :${ENV_SSL_FLANNEL_DIR}"
  exit
fi

cat > ${ENV_SSL_FLANNEL_CSR} <<EOF
{
  "CN": "${ENV_SSL_FLANNEL_CSR_CN}",
  "hosts": [],
  "key": {
    "algo": "${ENV_SSL_KEY_ALGO}",
    "size": ${ENV_SSL_KEY_SIZE}
  },
  "names": [
    {
      "C": "${ENV_SSL_NAMES_C}",
      "ST": "${ENV_SSL_NAMES_L}",
      "L": "${ENV_SSL_NAMES_ST}",
      "O": "${ENV_SSL_NAMES_O}",
      "OU": "${ENV_SSL_NAMES_OU}"
    }
  ]
}
EOF

cfssl gencert -ca=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
  -ca-key=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY} \
  -config=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CONFIG} \
  -profile=${ENV_SSL_PROFILE_K8S} ${ENV_SSL_FLANNEL_CSR} | cfssljson -bare ${ENV_SSL_FLANNEL_CERT_PRIFIX}

ls ${ENV_SSL_FLANNEL_DIR}/*pem

ETCD_ENDPOINTS=`echo ${ENV_ETCD_HOSTS} |awk -v port=${ENV_ETCD_CLIENT_PORT} -F" " '{
    for(cnt=1; cnt<NF; cnt++){
        printf("https://%s:%s,",$cnt,port);
    }
    printf("https://%s:%s",$cnt,port);
}'`

# flannel v0.10 : not support etcd v3
ETCDCTL_API=2 etcdctl \
  --endpoints=${ETCD_ENDPOINTS} \
  --ca-file=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
  --cert-file=${ENV_SSL_FLANNEL_DIR}/${ENV_SSL_FLANNEL_CERT_PRIFIX}.pem \
  --key-file=${ENV_SSL_FLANNEL_DIR}/${ENV_SSL_FLANNEL_CERT_PRIFIX}-key.pem \
  set ${ENV_FLANNEL_ETCD_NETWORK_PREFIX}/config '{"Network":"'${ENV_KUBE_OPT_CLUSTER_IP_RANGE}'", "SubnetLen": 21, "Backend": {"Type": "vxlan"}}'

echo -e "\n##  flanneld service"
systemctl stop flanneld 2>/dev/null

mkdir -p ${ENV_FLANNEL_DIR_BIN} ${ENV_FLANNEL_DIR_ETC} ${ENV_FLANNEL_DIR_RUN}
chmod 755 ${ENV_HOME_FLANNEL}/{flanneld,mk-docker-opts.sh} 
cp -p ${ENV_HOME_FLANNEL}/{flanneld,mk-docker-opts.sh} ${ENV_FLANNEL_DIR_BIN}
if [ $? -ne 0 ]; then
  echo "please check flanneld binary file and mk-docker-opts.sh existed in ${ENV_HOME_FLANNEL}/ or not"
  exit 
fi

# create flannel configuration file
cat >${ENV_FLANNEL_DIR_ETC}/${ENV_FLANNEL_ETC} <<EOF
FLANNELD_OPTS="-etcd-cafile=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \\
  -etcd-certfile=${ENV_SSL_FLANNEL_DIR}/${ENV_SSL_FLANNEL_CERT_PRIFIX}.pem \\
  -etcd-keyfile=${ENV_SSL_FLANNEL_DIR}/${ENV_SSL_FLANNEL_CERT_PRIFIX}-key.pem \\
  -etcd-endpoints=${ETCD_ENDPOINTS} \\
  -etcd-prefix=${ENV_FLANNEL_ETCD_NETWORK_PREFIX} \\
  -iface=${ENV_FLANNEL_OPT_IFACE} \\
  -ip-masq"
EOF

# Create flannel service.
cat >${ENV_FLANNEL_SERVICE} <<EOF
[Unit]
Description=Flanneld Service
Documentation=https://github.com/coreos/flannel
After=network.target
After=network-online.target
Wants=network-online.target
After=etcd.service
Before=docker.service

[Service]
EnvironmentFile=-${ENV_FLANNEL_DIR_ETC}/${ENV_FLANNEL_ETC}
ExecStart=${ENV_FLANNEL_DIR_BIN}/flanneld \$FLANNELD_OPTS
ExecStartPost=${ENV_FLANNEL_DIR_BIN}/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d ${ENV_FLANNEL_DIR_RUN}/docker
Restart=always
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
EOF

echo -e "\n##  daemon reload service "
systemctl daemon-reload
echo -e "\n##  start flannel service "
systemctl start flanneld
#for creating /run/flannel/docker
systemctl restart flanneld
echo -e "\n##  enable flannel service " 
systemctl enable flanneld
echo -e "\n##  check  flannel status" |egrep '\.service|Active:|\-\-'
systemctl status flanneld
