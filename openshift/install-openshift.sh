#!/bin/sh

DOCKER_DAEMON_JSON=/etc/docker/daemon.json
OC_URL="https://github.com/openshift/origin/releases/download/v3.9.0/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz"
OC_FILENAME_TARGZ=`basename ${OC_URL}`

date
echo "## Step 1:  OS version confirm: "
uname -a
cat /etc/redhat-release
echo

echo "## Install docker "
yum -y install docker
echo

date
echo "## Step 2: Set net.ipv4.ip_forward"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
systemctl restart network
grep net.ipv4.ip_forward /etc/sysctl.conf
echo "sysctl net.ipv4.ip_forward"
sysctl net.ipv4.ip_forward
echo

date
echo "## Step 3: Set registry & Restart docker"
if [ -f "${DOCKER_DAEMON_JSON}" ]; then
  cp ${DOCKER_DAEMON_JSON} ${DOCKER_DAEMON_JSON}.org
fi

cat >${DOCKER_DAEMON_JSON} <<EOF
{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}
EOF
cat ${DOCKER_DAEMON_JSON}
echo

echo "## systemctl daemon-reload"
systemctl daemon-reload
echo
echo "## systemctl restart docker"
systemctl restart docker

echo "## confirm docker version"
docker version
echo

date
echo "## Step 4: Set for firewall"
firewall-cmd --permanent --new-zone dockerc
firewall-cmd --permanent --zone dockerc --add-source 172.17.0.0/16
firewall-cmd --permanent --zone dockerc --add-port 8443/tcp
firewall-cmd --permanent --zone dockerc --add-port 53/udp
firewall-cmd --permanent --zone dockerc --add-port 8053/udp
firewall-cmd --reload
echo

date
echo "## Step 5: get and setting oc: "
yum install -y wget
wget  ${OC_URL}
tar xvpf ${OC_FILENAME_TARGZ}
DIRNAME=`echo ${OC_FILENAME_TARGZ} |sed s/.tar.gz//g`
mv ${DIRNAME}/oc /usr/local/bin
chmod 755 /usr/local/bin/oc
which oc
oc version
echo

date
echo "## Step 6: start up oc cluster"
oc cluster up --host-data-dir="/opt"

date
docker images

date
echo "## Step 7: oc login -u developer"
oc login -u developer
echo "## Finished."
