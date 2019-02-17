#!/bin/sh

. ./install.cfg

# set cfssl tools in search path
chmod 755 ${ENV_HOME_CFSSL}/*
if [ $? -ne 0 ]; then
  echo "prepare downloaded cfssl tools in ${ENV_HOME_CFSSL} in advance"
  exit
fi

export PATH=${ENV_HOME_CFSSL}:$PATH

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
EOF


# append etcd hosts list
echo ${ENV_ETC_HOSTS} |awk -F" " '{
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

cd $ODIR
