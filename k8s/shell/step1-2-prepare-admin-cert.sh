#!/bin/sh

. ./install.cfg
. ./common-util.sh

# set cfssl tools in search path
chmod 755 ${ENV_HOME_CFSSL}/*
if [ $? -ne 0 ]; then
  echo "prepare downloaded cfssl tools in ${ENV_HOME_CFSSL} in advance"
  exit
fi

export PATH=${ENV_HOME_CFSSL}:$PATH

# create dir for certs when not existing
mkdir -p ${ENV_SSL_CA_DIR} ${ENV_SSL_ETCD_DIR}

# create csr files of admin
cat <<EOF >${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_ADMIN_CSR}
{
    "CN": "${ENV_SSL_ADMIN_CN}",
    "hosts": [],
    "key": {
        "algo": "${ENV_SSL_KEY_ALGO}",
        "size": ${ENV_SSL_KEY_SIZE}
    },
    "names": [
        {
            "C": "${ENV_SSL_NAMES_C}",
            "L": "${ENV_SSL_NAMES_L}",
            "ST": "${ENV_SSL_NAMES_ST}",
            "O": "${ENV_SSL_NAMES_O_MASTER}",
            "OU": "${ENV_SSL_NAMES_OU}"
        }
    ]
}
EOF

ODIR=`pwd`
cd ${ENV_SSL_CA_DIR}

cfssl gencert -ca=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} -ca-key=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY} -config=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CONFIG} -profile=${ENV_SSL_PROFILE_K8S} ${ENV_SSL_FILE_ADMIN_CSR} | cfssljson -bare ${ENV_SSL_ADMIN_CERT_PRIFIX}

# confirm cert pem: kubeadmin-key.pem  kubeadmin.pem
ls ${ENV_SSL_CA_DIR}/${ENV_SSL_ADMIN_CERT_PRIFIX}*.pem

#echo "openssl pkcs12 -export -out ${ENV_SSL_ADMIN_CERT_PRIFIX}.pfx -inkey ${ENV_SSL_ADMIN_CERT_PRIFIX}-key.pem -in ${ENV_SSL_ADMIN_CERT_PRIFIX}.pem -certfile ${ENV_SSL_FILE_CA_PEM}"
openssl pkcs12 -export -out ${ENV_SSL_ADMIN_CERT_PRIFIX}.pfx -inkey ${ENV_SSL_ADMIN_CERT_PRIFIX}-key.pem -in ${ENV_SSL_ADMIN_CERT_PRIFIX}.pem -certfile ${ENV_SSL_FILE_CA_PEM} -password pass:${ENV_MAC_CLIENT_PRF_PASSWORD}

# Create kubectl kubeconfig file. 
kubectl config set-cluster ${ENV_KUBECONFIG_CLUSTER} \
  --certificate-authority=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
  --embed-certs=${ENV_KUBECONFIG_EMBED_CERTS} \
  --server=${ENV_KUBE_MASTER_HTTPS} \
  --kubeconfig=${ENV_KUBECONFIG_KUBECTL}

kubectl config set-credentials ${ENV_KUBECONFIG_CLIENT_KUBECTL} \
  --client-certificate=${ENV_SSL_CA_DIR}/${ENV_SSL_ADMIN_CERT_PRIFIX}.pem \
  --client-key=${ENV_SSL_CA_DIR}/${ENV_SSL_ADMIN_CERT_PRIFIX}-key.pem \
  --embed-certs=${ENV_KUBECONFIG_EMBED_CERTS} \
  --kubeconfig=${ENV_KUBECONFIG_KUBECTL}

kubectl config set-context ${ENV_KUBECONFIG_CLUSTER} \
  --cluster=${ENV_KUBECONFIG_CLUSTER} \
  --user=${ENV_KUBECONFIG_CLIENT_KUBECTL} \
  --kubeconfig=${ENV_KUBECONFIG_KUBECTL}

kubectl config use-context ${ENV_KUBECONFIG_CLUSTER} --kubeconfig=${ENV_KUBECONFIG_KUBECTL}

echo "## copy ${ENV_KUBECONFIG_KUBECTL} to ~/.kube/config"
cp ${ENV_SSL_CA_DIR}/${ENV_KUBECONFIG_KUBECTL} ~/.kube/config
