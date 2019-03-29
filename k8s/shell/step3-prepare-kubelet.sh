#!/bin/sh

. ./install.cfg

# set cfssl tools in search path
chmod 755 ${ENV_HOME_CFSSL}/*
if [ $? -ne 0 ]; then
  echo "prepare downloaded cfssl tools in ${ENV_HOME_CFSSL} in advance"
  exit
fi

export PATH=${ENV_HOME_CFSSL}:$PATH

mkdir -p ${ENV_SSL_K8S_DIR}
cd  ${ENV_SSL_K8S_DIR}
if [ $? -ne 0 ]; then
  echo "failed to create dir :${ENV_SSL_K8S_DIR}"
  exit
fi

cat > ${ENV_SSL_PROXY_CSR} <<EOF
{
  "CN": "${ENV_SSL_PROXY_CSR_CN}",
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
  -profile=${ENV_SSL_PROFILE_K8S} ${ENV_SSL_PROXY_CSR} | cfssljson -bare ${ENV_SSL_PROXY_CERT_PRIFIX}

ls ${ENV_SSL_K8S_DIR}/${ENV_SSL_PROXY_CERT_PRIFIX}*pem

BOOTSTRAP_TOKEN=`awk -F "," '{print $1}' ${ENV_KUBE_DIR_ETC}/${ENV_KUBE_API_TOKEN}`

# set cluster for bootstrap-kubelet
kubectl config set-cluster ${ENV_KUBECONFIG_CLUSTER} \
  --certificate-authority=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
  --embed-certs=${ENV_KUBECONFIG_EMBED_CERTS} \
  --server=${ENV_KUBE_MASTER_HTTPS} \
  --kubeconfig=${ENV_KUBECONFIG_BOOTSTRAP}

# set client infor by using token for kubelet
kubectl config set-credentials ${ENV_KUBECONFIG_CLIENT_KUBELET} \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=${ENV_KUBECONFIG_BOOTSTRAP}

# connect client infor with cluster for kubelet
kubectl config set-context ${ENV_KUBECONFIG_CONTEXT_DEFAULT} \
  --cluster=${ENV_KUBECONFIG_CLUSTER} \
  --user=${ENV_KUBECONFIG_CLIENT_KUBELET} \
  --kubeconfig=${ENV_KUBECONFIG_BOOTSTRAP}

# set default context by using bootstrap.kubeconfig
kubectl config use-context ${ENV_KUBECONFIG_CONTEXT_DEFAULT} --kubeconfig=${ENV_KUBECONFIG_BOOTSTRAP}

# Create kube-proxy kubeconfig file. 
kubectl config set-cluster ${ENV_KUBECONFIG_CLUSTER} \
  --certificate-authority=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
  --embed-certs=${ENV_KUBECONFIG_EMBED_CERTS} \
  --server=${ENV_KUBE_MASTER_HTTPS} \
  --kubeconfig=${ENV_KUBECONFIG_KUBEPROXY}

kubectl config set-credentials ${ENV_KUBECONFIG_CLIENT_KUBEPROXY} \
  --client-certificate=${ENV_SSL_K8S_DIR}/${ENV_SSL_PROXY_CERT_PRIFIX}.pem \
  --client-key=${ENV_SSL_K8S_DIR}/${ENV_SSL_PROXY_CERT_PRIFIX}-key.pem \
  --embed-certs=${ENV_KUBECONFIG_EMBED_CERTS} \
  --kubeconfig=${ENV_KUBECONFIG_KUBEPROXY}

kubectl config set-context ${ENV_KUBECONFIG_CONTEXT_DEFAULT} \
  --cluster=${ENV_KUBECONFIG_CLUSTER} \
  --user=${ENV_KUBECONFIG_CLIENT_KUBEPROXY} \
  --kubeconfig=${ENV_KUBECONFIG_KUBEPROXY}

kubectl config use-context ${ENV_KUBECONFIG_CONTEXT_DEFAULT} --kubeconfig=kube-proxy.kubeconfig

kubectl get clusterrolebinding ${ENV_KUBECONFIG_CLIENT_KUBELET} >/dev/null 2>&1
if [ $? -eq 0 ]; then
  kubectl delete clusterrolebinding ${ENV_KUBECONFIG_CLIENT_KUBELET}
fi
# binding kubelet-bootstrap user to system cluster roles.
kubectl create clusterrolebinding ${ENV_KUBECONFIG_CLIENT_KUBELET} \
  --clusterrole=${ENV_KUBECONFIG_ROLE_BOOTSTRAPPER} \
  --user=${ENV_KUBECONFIG_CLIENT_KUBELET}
