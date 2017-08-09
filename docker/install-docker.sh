#!/bin/sh

SYSTEMDDIR=/usr/lib/systemd/system
SERVICEFILE=docker.service
DOCKERDIR=/usr/bin
DOCKERBIN=docker
SERVICENAME=docker
FILETARGZ=docker-1.13.1.tgz

if [ ! -f ${FILETARGZ} ]; then
  echo "Docker binary tgz files does not exist, please check it"
  echo "wget https://get.docker.com/builds/Linux/x86_64/docker-1.13.1.tgz"
  exit 1
fi

echo "##unzip : tar xvpf ${FILETARGZ}"
tar xvpf ${FILETARGZ}
echo

echo "##binary : ${DOCKERBIN} copy to ${DOCKERDIR}"
cp -p ${DOCKERBIN}/* ${DOCKERDIR} >/dev/null 2>&1
which ${DOCKERBIN}

echo "##systemd service: ${SERVICEFILE}"
echo "##docker.service: create docker systemd file"
cat >${SYSTEMDDIR}/${SERVICEFILE} <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket

[Service]
Type=notify
EnvironmentFile=-/run/flannel/docker
WorkingDirectory=/usr/local/bin
ExecStart=/usr/bin/dockerd \
                -H tcp://0.0.0.0:4243 \
                -H unix:///var/run/docker.sock \
                --selinux-enabled=false \
                --log-opt max-size=1g

ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo ""

systemctl daemon-reload
echo "##Service status: ${SERVICENAME}"
systemctl status ${SERVICENAME}
echo "##Service restart: ${SERVICENAME}"
systemctl restart ${SERVICENAME}
echo "##Service status: ${SERVICENAME}"
systemctl status ${SERVICENAME}

echo "##Service enabled: ${SERVICENAME}"
systemctl enable ${SERVICENAME}
