#!/bin/sh

. ./install.cfg

echo -e "\n##  stop etcd service"
systemctl stop etcd 2>/dev/null

if [ _"INSTALL_MODE" = _"manual" ]; then
  echo "## are you sure to delete ${ENV_ETCD_DATA_DIR} with all files in it ? "
  read answers
else
  answers="y"
fi

if [ _"${answers}" = _"y" -o _"${answers}" = _"Y" ]; then
  rm -rf "${ENV_ETCD_DATA_DIR}/default.etcd"
fi

mkdir -p ${ENV_ETCD_DIR_BIN}
chmod 755 ${ENV_HOME_ETCD}/etc*
cp -p ${ENV_HOME_ETCD}/etc* ${ENV_ETCD_DIR_BIN}
if [ $? -ne 0 ]; then
  echo "please check etcd binary files existed in ${ENV_HOME_ETCD}/ or not"
  exit 
fi

# create etcd config dir when needed
mkdir -p `dirname ${ENV_ETCD_CONF}`

# The etcd configuration file. 
cat <<EOF >${ENV_ETCD_CONF}
#[ETCD Member Settings]
ETCD_NAME="${ENV_ETCD_CURRENT_NAME}"
ETCD_DATA_DIR="${ENV_ETCD_DATA_DIR}/default.etcd"
ETCD_LISTEN_PEER_URLS="https://${ENV_CURRENT_HOSTIP}:${ENV_ETCD_PEER_PORT}"
ETCD_LISTEN_CLIENT_URLS="https://${ENV_CURRENT_HOSTIP}:${ENV_ETCD_CLIENT_PORT}"

#[ETCD Clustering Settings]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://${ENV_CURRENT_HOSTIP}:${ENV_ETCD_PEER_PORT}"
ETCD_ADVERTISE_CLIENT_URLS="https://${ENV_CURRENT_HOSTIP}:${ENV_ETCD_CLIENT_PORT}"
EOF

echo ${ENV_ETCD_HOSTS} |awk -v etcd_names="${ENV_ETCD_NAMES}" \
-v port=${ENV_ETCD_PEER_PORT} -F" " 'BEGIN{
    split(etcd_names,names);
    printf("ETCD_INITIAL_CLUSTER=\"");
}
{
    for(cnt=1; cnt<NF; cnt++){
        printf("%s=https://%s:%s,",names[cnt],$cnt,port);
    }
    printf("%s=https://%s:%s\"\n",names[cnt],$cnt,port);
}' >>${ENV_ETCD_CONF} 

cat <<EOF >>${ENV_ETCD_CONF} 
ETCD_INITIAL_CLUSTER_TOKEN="${ENV_ETCD_INITIAL_CLUSTER_TOKEN}"
ETCD_INITIAL_CLUSTER_STATE="${ENV_ETCD_INITIAL_CLUSTER_STATE}"

#[ETCD TLS Certificate Settings]
ETCD_CERT_FILE="${ENV_SSL_ETCD_DIR}/${ENV_SSL_ETCD_CERT_PRIFIX}.pem"
ETCD_KEY_FILE="${ENV_SSL_ETCD_DIR}/${ENV_SSL_ETCD_CERT_PRIFIX}-key.pem"
ETCD_PEER_CERT_FILE="${ENV_SSL_ETCD_DIR}/${ENV_SSL_ETCD_CERT_PRIFIX}.pem"
ETCD_PEER_KEY_FILE="${ENV_SSL_ETCD_DIR}/${ENV_SSL_ETCD_CERT_PRIFIX}-key.pem"
ETCD_TRUSTED_CA_FILE="${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM}"
ETCD_PEER_TRUSTED_CA_FILE="${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM}"

#[ETCD Other Settings]
ETCD_LOCALHOST_CLIENT="${ENV_ETCD_LOCALHOST_CLIENT}"
EOF

mkdir -p ${ENV_ETCD_DATA_DIR}

# The etcd servcie configuration file.
cat <<EOF >${ENV_ETCD_SERVICE}
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
EnvironmentFile=-${ENV_ETCD_CONF}
WorkingDirectory=${ENV_ETCD_DATA_DIR}

ExecStart=${ENV_ETCD_DIR_BIN}/etcd \\
EOF

cat <<"EOF" >> ${ENV_ETCD_SERVICE}
--name=${ETCD_NAME} \
--data-dir=${ETCD_DATA_DIR} \
--listen-peer-urls=${ETCD_LISTEN_PEER_URLS} \
--listen-client-urls=${ETCD_LISTEN_CLIENT_URLS},${ETCD_LOCALHOST_CLIENT} \
--advertise-client-urls=${ETCD_ADVERTISE_CLIENT_URLS} \
--initial-advertise-peer-urls=${ETCD_INITIAL_ADVERTISE_PEER_URLS} \
--initial-cluster=${ETCD_INITIAL_CLUSTER} \
--initial-cluster-token=${ETCD_INITIAL_CLUSTER_TOKEN} \
--initial-cluster-state=new \
--cert-file=${ETCD_CERT_FILE} \
--key-file=${ETCD_KEY_FILE} \
--peer-cert-file=${ETCD_PEER_CERT_FILE} \
--peer-key-file=${ETCD_PEER_KEY_FILE} \
--trusted-ca-file=${ETCD_TRUSTED_CA_FILE} \
--peer-trusted-ca-file=${ETCD_PEER_TRUSTED_CA_FILE}

Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n##  daemon reload service "
systemctl daemon-reload
echo -e "\n##  start etcd service "
systemctl start etcd
echo -e "\n##  enable etcd service " 
systemctl enable etcd
echo -e "\n##  check  etcd status"
systemctl status etcd |egrep '\.service|Active:|\-\-'

echo -e "\n##  etcd version"
etcd --version

echo -e "\n##  etcd cluster health"
export ETCDCTL_API=3
for etcd_member in ${ENV_ETCD_HOSTS}
do
  etcdctl --endpoints=https://${etcd_member}:2379 --cacert=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} --cert=${ENV_SSL_ETCD_DIR}/${ENV_SSL_ETCD_CERT_PRIFIX}.pem --key=${ENV_SSL_ETCD_DIR}/${ENV_SSL_ETCD_CERT_PRIFIX}-key.pem endpoint health
done
