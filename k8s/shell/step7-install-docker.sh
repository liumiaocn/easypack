#!/bin/sh

. ./install.cfg

echo -e "\n##  docker service"
systemctl stop docker 2>/dev/null

mkdir -p ${ENV_DOCKER_DIR_BIN} ${ENV_DOCKER_DIR_ETC} 
chmod 755 ${ENV_HOME_DOCKER}/*
cp -p ${ENV_HOME_DOCKER}/* ${ENV_DOCKER_DIR_BIN}
if [ $? -ne 0 ]; then
  echo "please check docker binary files existed in ${ENV_HOME_DOCKER}/ or not"
  exit 
fi

# create docker configuration file
cat >${ENV_DOCKER_DIR_ETC}/${ENV_DOCKER_ETC} <<EOF
DOCKER_OPTS="--registry-mirror=${ENV_DOCKER_REGISTRY_MIRROR} \\
-H tcp://0.0.0.0:4243 \\
-H unix:///var/run/docker.sock \\
--selinux-enabled=false \\
--log-opt max-size=${ENV_DOCKER_OPT_LOG_MAX_SIZE}"
EOF

# Create the docker service.
cat >${ENV_DOCKER_SERVICE} <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
EnvironmentFile=-${ENV_DOCKER_FLANNEL_CONF}
EnvironmentFile=-${ENV_DOCKER_DIR_ETC}/${ENV_DOCKER_ETC}
ExecStart=${ENV_DOCKER_DIR_BIN}/dockerd \$DOCKER_NETWORK_OPTIONS \$DOCKER_OPTS
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n##  daemon reload service "
systemctl daemon-reload
echo -e "\n##  start docker service "
systemctl start docker
echo -e "\n##  enable docker service " 
systemctl enable docker
echo -e "\n##  check  docker status"
systemctl status docker |egrep '\.service|Active:|\-\-'

echo
echo -e "##  check docker version"
docker version

echo
echo -e "##  load pause imgage for kubelet"
cd data
gunzip pause-amd64-3.1.tar.gz
docker load -i pause-amd64-3.1.tar
gzip pause-amd64-3.1.tar

echo "## load all other images needed"
docker load -i ${ENV_IMAGE_ALL_LOAD_DIR}/${ENV_IMAGE_ALL_LOAD_FILES} 2>/dev/null
