#!/bin/sh

. ./install.cfg

create_kubedonfig(){
  KUBECONFIG_NAME="$1"
  KUBECONFIG_USER="$2"
  KUBECONFIG_CERT_PREFIX="$3"
  
  # Create cluster kubeconfig file. 
  kubectl config set-cluster ${ENV_KUBECONFIG_CLUSTER} \
    --certificate-authority=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
    --embed-certs=${ENV_KUBECONFIG_EMBED_CERTS} \
    --server=${ENV_KUBE_MASTER_HTTPS} \
    --kubeconfig=${KUBECONFIG_NAME}
  
  kubectl config set-credentials ${KUBECONFIG_USER} \
    --client-certificate=${ENV_SSL_K8S_DIR}/${KUBECONFIG_CERT_PREFIX}.pem \
    --client-key=${ENV_SSL_K8S_DIR}/${KUBECONFIG_CERT_PREFIX}-key.pem \
    --embed-certs=${ENV_KUBECONFIG_EMBED_CERTS} \
    --kubeconfig=${KUBECONFIG_NAME}
  
  kubectl config set-context ${KUBECONFIG_USER} \
    --cluster=${ENV_KUBECONFIG_CLUSTER} \
    --user=${KUBECONFIG_USER} \
    --kubeconfig=${KUBECONFIG_NAME}
  
  kubectl config use-context ${KUBECONFIG_USER} --kubeconfig=${KUBECONFIG_NAME}
}
