#!/bin/sh

. ./install.cfg
. ./common-util.sh

echo "## please make sure you can get the following images"
grep image etc/plugins/dashboard/kubernetes-dashboard.yaml
echo "## getting the above image ready in advance is preferred, please press any key when ready"
read

echo "## create dashboard service"
kubectl delete -f etc/plugins/dashboard/kubernetes-dashboard.yaml >/dev/null 2>&1
kubectl create -f etc/plugins/dashboard/kubernetes-dashboard.yaml

# create and display dashboard token
create_dashboard_token
sleep 2

display_dashboard_token
sleep 2

echo "## display pods information"
sleep 2 
kubectl get pods -n kube-system

echo "## display service information"
kubectl get service -n kube-system
