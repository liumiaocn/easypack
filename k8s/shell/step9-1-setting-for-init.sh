#!/bin/sh

. ./install.cfg
. ./common-util.sh

csr_auto_approve
echo "## sleep ${ENV_CSR_AUTO_APPROVE_INTERVAL}s for auto csr approve"
sleep $ENV_CSR_AUTO_APPROVE_INTERVAL
csr_auto_approve

echo "## kubectl version"
kubectl version
echo

echo "## kubectl cluster-info"
kubectl cluster-info
echo

echo "## kubectl get node"
kubectl get nodes -o wide
echo

echo "## kubectl get cs"
kubectl get cs
echo
