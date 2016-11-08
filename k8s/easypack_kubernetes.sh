#!/bin/sh

INSTALL_LOG=/tmp/k8s_install.$$.log

usage(){
  echo "Usage: $0 MASTER|NODE [token] [MASTERIP]"
  echo "          token and IP are used with token created by kubeadm init in MASTER"
}

if [ $# -ne 1 -a $# -ne 3 ]; then
  usage
  exit 1
fi

TYPE=$1
TOKEN=$2
MASTERIP=$3

if [ _"$TYPE" = _"NODE" -a _"$TOKEN" = _"" ]; then
  usge
  exit
fi


echo `date` |tee -a $INSTALL_LOG
echo "##INSTALL LOG : $INSTALL_LOG " |tee -a $INSTALL_LOG
echo "##Step 1: Stop firewall ..." |tee -a $INSTALL_LOG
systemctl disable firewalld >>$INSTALL_LOG 2>&1
systemctl stop firewalld    >> $INSTALL_LOG 2>&1
iptables -F
echo |tee -a $INSTALL_LOG

#baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
date |tee -a $INSTALL_LOG
echo "##Step 2: set repository and install kubeadm etc..." |tee -a $INSTALL_LOG
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://files.rm-rf.ca/rpms/kubelet/
enabled=1
gpgcheck=0
EOF

setenforce 0
if [ _"$TYPE" = _"MASTER" ]; then
  echo "  install kubectl in Master..." |tee -a $INSTALL_LOG
  yum install -y kubectl kubernetes-cni >> $INSTALL_LOG 2>&1
fi
yum install -y docker kubelet kubeadm >> $INSTALL_LOG 2>&1
systemctl enable docker >> $INSTALL_LOG 2>&1
echo "#######Set docker proxy when needed. If ready, press any to continue..." |tee -a $INSTALL_LOG
read
systemctl restart docker >> $INSTALL_LOG 2>&1
systemctl enable kubelet & systemctl restart kubelet >> $INSTALL_LOG 2>&1

echo
date
echo "##Step 3: pull google containers..." |tee -a $INSTALL_LOG
PROXY="kube-proxy-amd64:v1.4.1"
DISCOVERY="kube-discovery-amd64:1.0"
SCHEDULER="kube-scheduler-amd64:v1.4.1"
CONTROLLER="kube-controller-manager-amd64:v1.4.1"
APISERVER="kube-apiserver-amd64:v1.4.1"
PAUSE="pause-amd64:3.0"
ETCD="etcd-amd64:2.2.5"
DNS="kubedns-amd64:1.7 "
DNSMASQ="kube-dnsmasq-amd64:1.3"
HEALTHZ="exechealthz-amd64:1.1"
DASHBOARD="kubernetes-dashboard-amd64:v1.4.1"

ALL_IMAGES="${PROXY} ${DISCOVERY} ${SCHEDULER} ${CONTROLLER} ${APISERVER} ${PAUSE} ${ETCD} ${DNS} ${DNSMASQ} ${HEALTHZ} ${DASHBOARD}"

CNT=0
echo "Now begin to pull images from liumiaocn" |tee -a $INSTALL_LOG
for image in ${ALL_IMAGES}
do
  CNT=`expr ${CNT} + 1`
  echo "No.${CNT} : ${image} pull begins ..." |tee -a $INSTALL_LOG
  docker pull liumiaocn/${image} >> $INSTALL_LOG 2>&1
  echo "No.${CNT} : ${image} pull ends   ..." |tee -a $INSTALL_LOG
  echo "No.${CNT} : ${image} rename      ..." |tee -a $INSTALL_LOG
  docker tag liumiaocn/${image}  gcr.io/google_containers/${image} >> $INSTALL_LOG 2>&1
  echo "No.${CNT} : ${image} untag       ..." |tee -a $INSTALL_LOG
  docker rmi  liumiaocn/${image} >> $INSTALL_LOG 2>&1
  echo "" |tee -a $INSTALL_LOG
done

echo "All images have been pulled to local as following" |tee -a $INSTALL_LOG
docker images |egrep 'kube|pause' |tee -a $INSTALL_LOG
echo |tee -a $INSTALL_LOG
date |tee -a $INSTALL_LOG

date |tee -a $INSTALL_LOG
if [ _"$TYPE" = _"MASTER" ]; then
  echo "##Step 4: kubeadm init" |tee -a $INSTALL_LOG
  rm -rf /etc/kubernetes/manifests/
  rm -rf /etc/kubernetes/kubelet.conf /etc/kubernetes/admin.conf
  kubeadm init |tee -a $INSTALL_LOG

  date |tee -a $INSTALL_LOG
  echo "##Step 5: taint nodes..." |tee -a $INSTALL_LOG
  kubectl taint nodes --all dedicated- |tee -a $INSTALL_LOG
  kubectl get nodes |tee -a $INSTALL_LOG

  date |tee -a $INSTALL_LOG
  echo "##Step 6: confirm version..." |tee -a $INSTALL_LOG
  kubectl version |tee -a $INSTALL_LOG
  kubeadm version |tee -a $INSTALL_LOG

  date |tee -a $INSTALL_LOG
  echo "##Step 7: set weave-kube ..." |tee -a $INSTALL_LOG
  kubectl apply -f https://git.io/weave-kube |tee -a $INSTALL_LOG
  kubectl get pods |tee -a $INSTALL_LOG
else
  rm -rf /etc/kubernetes/manifests/
  rm -rf /etc/kubernetes/kubelet.conf /etc/kubernetes/admin.conf
  echo "##Step 4: kubeadm join" |tee -a $INSTALL_LOG
  kubeadm join --token ${TOKEN} ${MASTERIP} |tee -a $INSTALL_LOG

  date |tee -a $INSTALL_LOG
  echo "##Step 5: confirm version..." |tee -a $INSTALL_LOG
  kubeadm version |tee -a $INSTALL_LOG
fi
