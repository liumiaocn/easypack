#!/bin/sh

. ./install.cfg
. ./common-util.sh

# set cfssl tools in search path
chmod 755 ${ENV_HOME_CFSSL}/*
if [ $? -ne 0 ]; then
  echo "prepare downloaded cfssl tools in ${ENV_HOME_CFSSL} in advance"
  exit
fi

export PATH=${ENV_HOME_CFSSL}:$PATH

# copy kubectl for preparement
cp ${ENV_HOME_BINARY}/kubernetes/kubectl ${ENV_KUBE_DIR_BIN}

# create dir for certs when not existing
mkdir -p ${ENV_SSL_CA_DIR} ${ENV_SSL_K8S_DIR} ${ENV_SSL_ETCD_DIR}

# create ca-config file for etc and k8s profiles
cat <<EOF >${ENV_SSL_CA_DIR}/${ENV_SSL_CA_CONFIG}
{
  "signing": {
    "default": {
      "expiry": "${ENV_SSL_DEFAULT_EXPIRY}"
    },
    "profiles": {
      "${ENV_SSL_PROFILE_ETCD}": {
         "expiry": "${ENV_SSL_PROFILE_ETCD_EXPIRY}",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      },
      "${ENV_SSL_PROFILE_K8S}": {
         "expiry": "${ENV_SSL_PROFILE_K8S_EXPIRY}",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF

# create csr files of ca
cat <<EOF >${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CSR}
{
    "CN": "${ENV_SSL_CN}",
    "key": {
        "algo": "${ENV_SSL_KEY_ALGO}",
        "size": ${ENV_SSL_KEY_SIZE}
    },
    "names": [
        {
            "C": "${ENV_SSL_NAMES_C}",
            "L": "${ENV_SSL_NAMES_L}",
            "ST": "${ENV_SSL_NAMES_ST}",
            "O": "${ENV_SSL_NAMES_O}",
            "OU": "${ENV_SSL_NAMES_OU}"
        }
    ]
}
EOF

# create csr files of etcd
cat <<EOF >${ENV_SSL_ETCD_DIR}/${ENV_SSL_FILE_ETCD_CSR}
{
    "CN": "${ENV_SSL_ETCD_CSR_CN}",
    "hosts": [
    "127.0.0.1",
EOF


# append etcd hosts list
echo ${ENV_ETCD_HOSTS} |awk -F" " '{
    for(cnt=1; cnt<NF; cnt++){
        printf("    \"%s\",\n",$cnt);
    }
    printf("    \"%s\"\n", $NF);
}' >>${ENV_SSL_ETCD_DIR}/${ENV_SSL_FILE_ETCD_CSR}

# append csr files of etcd
cat <<EOF >>${ENV_SSL_ETCD_DIR}/${ENV_SSL_FILE_ETCD_CSR}
    ],
    "key": {
        "algo": "${ENV_SSL_KEY_ALGO}",
        "size": ${ENV_SSL_KEY_SIZE}
    },
    "names": [
        {
            "C": "${ENV_SSL_NAMES_C}",
            "L": "${ENV_SSL_NAMES_L}",
            "ST": "${ENV_SSL_NAMES_ST}"
        }
    ]
}
EOF

ODIR=`pwd`
cd ${ENV_SSL_CA_DIR}

cfssl gencert -initca ${ENV_SSL_FILE_CA_CSR} | cfssljson -bare ca -

# confirm ca pem: ca-key.pem  ca.pem
ls ${ENV_SSL_CA_DIR}/*.pem
echo

cd ${ENV_SSL_ETCD_DIR}
cfssl gencert -ca=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} -ca-key=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY} -config=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CONFIG} -profile=${ENV_SSL_PROFILE_ETCD} ${ENV_SSL_FILE_ETCD_CSR} | cfssljson -bare ${ENV_SSL_ETCD_CERT_PRIFIX}

# confirm cert pem: cert-etcd-key.pem  cert-etcd.pem
ls ${ENV_SSL_ETCD_DIR}/*.pem

# Deploy the master node.
mkdir -p ${ENV_SSL_K8S_DIR}
cat >${ENV_SSL_K8S_DIR}/${ENV_SSL_FILE_K8S_CSR} <<EOF
{
    "CN": "${ENV_SSL_K8S_CSR_CN}",
    "hosts": [
      "${ENV_SSL_CSR_HOSTS_SRV}",
      "127.0.0.1",
      "${ENV_CURRENT_HOSTIP}",
      "${ENV_K8S_CLUSTER_SERVICE_IP}",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "${ENV_SSL_KEY_ALGO}",
        "size": ${ENV_SSL_KEY_SIZE}
    },
    "names": [
        {
            "C": "${ENV_SSL_NAMES_C}",
            "L": "${ENV_SSL_NAMES_L}",
            "ST": "${ENV_SSL_NAMES_ST}",
            "O": "${ENV_SSL_NAMES_O}",
            "OU": "${ENV_SSL_NAMES_OU}"
        }
    ]
}
EOF

cd ${ENV_SSL_K8S_DIR}
cfssl gencert -ca=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM}  -ca-key=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY} -config=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CONFIG} -profile=${ENV_SSL_PROFILE_K8S} ${ENV_SSL_FILE_K8S_CSR} | cfssljson -bare ${ENV_SSL_K8S_CERT_PRIFIX}

echo "## cert for kube-apiserver"
# confirm cert pem: cert-k8s.pem cert-k8s-key.pem
ls ${ENV_SSL_K8S_DIR}/${ENV_SSL_K8S_CERT_PRIFIX}*.pem

cat >${ENV_SSL_K8S_DIR}/${ENV_SSL_FILE_K8SCM_CSR} <<EOF
{
    "CN": "${ENV_SSL_K8SCM_CSR_CN}",
    "hosts": [
      "127.0.0.1",
      "${ENV_CURRENT_HOSTIP}"
    ],
    "key": {
        "algo": "${ENV_SSL_KEY_ALGO}",
        "size": ${ENV_SSL_KEY_SIZE}
    },
    "names": [
        {
            "C": "${ENV_SSL_NAMES_C}",
            "L": "${ENV_SSL_NAMES_L}",
            "ST": "${ENV_SSL_NAMES_ST}",
            "O": "${ENV_SSL_NAMES_O_K8SCM}",
            "OU": "${ENV_SSL_NAMES_OU}"
        }
    ]
}
EOF

cfssl gencert -ca=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM}  -ca-key=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY} -config=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CONFIG} -profile=${ENV_SSL_PROFILE_K8S} ${ENV_SSL_FILE_K8SCM_CSR} | cfssljson -bare ${ENV_SSL_K8SCM_CERT_PRIFIX}

echo "## cert for kube-controller-manager"
# confirm cert pem: cert-k8scm.pem cert-k8scm-key.pem
ls ${ENV_SSL_K8S_DIR}/${ENV_SSL_K8SCM_CERT_PRIFIX}*.pem

cat >${ENV_SSL_K8S_DIR}/${ENV_SSL_FILE_K8SCH_CSR} <<EOF
{
    "CN": "${ENV_SSL_K8SCH_CSR_CN}",
    "hosts": [
      "127.0.0.1",
      "${ENV_CURRENT_HOSTIP}"
    ],
    "key": {
        "algo": "${ENV_SSL_KEY_ALGO}",
        "size": ${ENV_SSL_KEY_SIZE}
    },
    "names": [
        {
            "C": "${ENV_SSL_NAMES_C}",
            "L": "${ENV_SSL_NAMES_L}",
            "ST": "${ENV_SSL_NAMES_ST}",
            "O": "${ENV_SSL_NAMES_O_K8SCH}",
            "OU": "${ENV_SSL_NAMES_OU}"
        }
    ]
}
EOF

cfssl gencert -ca=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM}  -ca-key=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY} -config=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CONFIG} -profile=${ENV_SSL_PROFILE_K8S} ${ENV_SSL_FILE_K8SCH_CSR} | cfssljson -bare ${ENV_SSL_K8SCH_CERT_PRIFIX}

echo "## cert for kube-scheduler"
# confirm cert pem: cert-k8sch.pem cert-k8sch-key.pem
ls ${ENV_SSL_K8S_DIR}/${ENV_SSL_K8SCH_CERT_PRIFIX}*.pem

echo
echo "## create kubeconfig for kube-controller-manager"
create_kubedonfig  ${ENV_KUBECONFIG_KUBE_CONTROLLER_MANAGER}  ${ENV_KUBECONFIG_CLIENT_KUBE_CONTROLLER_MANAGER} ${ENV_SSL_K8SCM_CERT_PRIFIX}

echo "## create kubeconfig for kube-scheduler"
create_kubedonfig  ${ENV_KUBECONFIG_KUBE_SCHEDULER}  ${ENV_KUBECONFIG_CLIENT_KUBE_SCHEDULER} ${ENV_SSL_K8SCH_CERT_PRIFIX}

cd $ODIR
