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

csr_auto_approve(){
  CSR_PENDINGS=`kubectl get csr |grep -i pending |awk '{print $1}'`
  for pending in $CSR_PENDINGS
  do
    csr_id=`echo $pending |awk '{print $1}'`
    echo "## auto approve $csr_id"
    kubectl certificate approve $csr_id
  done
}

create_dashboard_token(){
  echo "## create service account for dashboard"
  kubectl get serviceaccount dashboard-admin -n kube-system >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    kubectl delete serviceaccount dashboard-admin -n kube-system
  fi
  kubectl create serviceaccount dashboard-admin -n kube-system

  echo "## create clusterrolebinding for dashboard"
  kubectl get clusterrolebinding dashboard-admin >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    kubectl delete clusterrolebinding dashboard-admin
  fi
  kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin
}

display_dashboard_token(){
  dashboard_secret=`kubectl get secrets -n kube-system | grep dashboard-admin | awk '{print $1}'`
  echo "## dashboard_secrete: $dashboard_secret"

  echo "## dashboard_token: "
  kubectl describe secret -n kube-system ${dashboard_secret} | grep -E '^token' | awk '{print $2}'
}
