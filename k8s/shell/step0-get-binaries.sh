#!/bin/sh

TYPE_OS=linux
TYPE_ARCH=amd64
VER_CFSSL=R1.2
#VER_KUBERNETES=v1.13.4
VER_KUBERNETES=v1.15.0
VER_ETCD=v3.3.13
VER_DOCKER=18.09.7
VER_CNI=v0.7.4
VER_FLANNEL=v0.11.0
VER_CORDNS=1.2.6
DIR_DOWNLOAD=/tmp
CORDNS_IMAGE=k8s.gcr.io/coredns:${VER_CORDNS}


mkdir -p ${DIR_DOWNLOAD}
cd ${DIR_DOWNLOAD}

echo "## clear previous download binaries"
rm -rf ${DIR_DOWNLOAD}/binaries

echo "## create binaries download dir"
mkdir -p binaries
cd binaries

echo "## download cfssl"
date

mkdir -p cfssl
cd cfssl
echo "## get cfssl_${TYPE_OS}-${TYPE_ARCH} with name cfssl"
curl -Lo cfssl https://pkg.cfssl.org/${VER_CFSSL}/cfssl_linux-amd64 >/dev/null 2>&1
echo "## get cfssljson_${TYPE_OS}-${TYPE_ARCH} with name cfssljson"
curl -Lo cfssljson https://pkg.cfssl.org/${VER_CFSSL}/cfssljson_linux-amd64 >/dev/null 2>&1
echo "## get cfssl-certinfo_${TYPE_OS}-${TYPE_ARCH} with name cfssljson"
curl -Lo cfssl-certinfo https://pkg.cfssl.org/${VER_CFSSL}/cfssl-certinfo_linux-amd64 >/dev/null 2>&1
cd ..
ls cfssl
echo

echo "## download kubernetes"
mkdir -p kubernetes
cd kubernetes
echo "curl -Lo kubernetes.tar.gz https://dl.k8s.io/${VER_KUBERNETES}/kubernetes-server-${TYPE_OS}-${TYPE_ARCH}.tar.gz"
curl -Lo kubernetes.tar.gz https://dl.k8s.io/${VER_KUBERNETES}/kubernetes-server-${TYPE_OS}-${TYPE_ARCH}.tar.gz >/dev/null 2>&1
tar zxf kubernetes.tar.gz
mv kubernetes/server/bin/kube-apiserver .
mv kubernetes/server/bin/kube-controller-manager .
mv kubernetes/server/bin/kubectl .
mv kubernetes/server/bin/kubelet .
mv kubernetes/server/bin/kube-proxy .
mv kubernetes/server/bin/kube-scheduler .
mkdir -p plugin/coredns 
cd kubernetes
tar xf kubernetes-src.tar.gz
mv cluster/addons/dns/coredns/coredns.yaml.base ../plugin/coredns/coredns.yaml
cd ..
rm -rf kubernetes
rm kubernetes.tar.gz
cd ..
ls kubernetes
echo 

echo "## download etcd"
mkdir -p etcd
cd etcd
curl -Lo etcd-${VER_ETCD}-${TYPE_OS}-${TYPE_ARCH}.tar.gz https://github.com/coreos/etcd/releases/download/${VER_ETCD}/etcd-${VER_ETCD}-${TYPE_OS}-${TYPE_ARCH}.tar.gz >/dev/null 2>&1
tar zxf etcd-${VER_ETCD}-${TYPE_OS}-${TYPE_ARCH}.tar.gz
mv -f etcd-${VER_ETCD}-${TYPE_OS}-${TYPE_ARCH}/etcd* .
rm -rf etcd-${VER_ETCD}-${TYPE_OS}-${TYPE_ARCH}
rm etcd-${VER_ETCD}-${TYPE_OS}-${TYPE_ARCH}.tar.gz
cd ..

echo "## download docker"
mkdir -p docker
cd docker
curl -Lo docker-${VER_DOCKER}.tgz https://download.docker.com/${TYPE_OS}/static/stable/x86_64/docker-${VER_DOCKER}.tgz >/dev/null 2>&1
tar zxf docker-${VER_DOCKER}.tgz
mv docker tmpdocker
mv -f tmpdocker/* .
rm -rf tmpdocker
rm docker-${VER_DOCKER}.tgz
cd ..
ls docker
echo

echo "## download cni"
mkdir -p cni
cd cni
curl -Lo cni-plugins-${TYPE_ARCH}-${VER_CNI}.tgz https://github.com/containernetworking/plugins/releases/download/${VER_CNI}/cni-plugins-${TYPE_ARCH}-${VER_CNI}.tgz >/dev/null 2>&1
tar zxf cni-plugins-${TYPE_ARCH}-${VER_CNI}.tgz
rm cni-plugins-${TYPE_ARCH}-${VER_CNI}.tgz
cd ..
ls cni
date

echo "## download flannel"
mkdir -p flannel
cd flannel
curl -Lo flannel-${VER_FLANNEL}-${TYPE_OS}-${TYPE_ARCH}.tar.gz https://github.com/coreos/flannel/releases/download/${VER_FLANNEL}/flannel-${VER_FLANNEL}-${TYPE_OS}-${TYPE_ARCH}.tar.gz >/dev/null 2>&1
tar -zxvf flannel-${VER_FLANNEL}-${TYPE_OS}-${TYPE_ARCH}.tar.gz
rm flannel-${VER_FLANNEL}-${TYPE_OS}-${TYPE_ARCH}.tar.gz README.md
cd ..

echo "## download coredns image"
mkdir -p images/coredns
cd images/coredns
echo "   docker pull begin"
docker pull ${CORDNS_IMAGE}
echo "   docker save begin"
docker save ${CORDNS_IMAGE} >coredns.tar
ls coredns.tar

echo "## download completed"

which tree >/dev/null 2>&1
if [ $? -eq 0 ]; then
  tree "${DIR_DOWNLOAD}/binaries"
else
  find ${DIR_DOWNLOAD}/binaries -type f
fi
