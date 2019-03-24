#!/bin/sh

. ./install.cfg

# set cfssl tools in search path
chmod 755 ${ENV_HOME_CFSSL}/*
if [ $? -ne 0 ]; then
  echo "prepare downloaded cfssl tools in ${ENV_HOME_CFSSL} in advance"
  exit
fi

export PATH=${ENV_HOME_CFSSL}:$PATH

mkdir -p ${ENV_SSL_K8S_DIR}
cd  ${ENV_SSL_K8S_DIR}
if [ $? -ne 0 ]; then
  echo "failed to create dir :${ENV_SSL_K8S_DIR}"
  exit
fi

cat > ${ENV_SSL_PROXY_CSR} <<EOF
{
  "CN": "${ENV_SSL_PROXY_CSR_CN}",
  "hosts": [],
  "key": {
    "algo": "${ENV_SSL_KEY_ALGO}",
    "size": ${ENV_SSL_KEY_SIZE}
  },
  "names": [
    {
      "C": "${ENV_SSL_NAMES_C}",
      "ST": "${ENV_SSL_NAMES_L}",
      "L": "${ENV_SSL_NAMES_ST}",
      "O": "${ENV_SSL_NAMES_O}",
      "OU": "${ENV_SSL_NAMES_OU}"
    }
  ]
}
EOF

cfssl gencert -ca=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_PEM} \
  -ca-key=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_KEY} \
  -config=${ENV_SSL_CA_DIR}/${ENV_SSL_FILE_CA_CONFIG} \
  -profile=${ENV_SSL_PROFILE_K8S} ${ENV_SSL_PROXY_CSR} | cfssljson -bare ${ENV_SSL_PROXY_CERT_PRIFIX}

ls ${ENV_SSL_K8S_DIR}/${ENV_SSL_PROXY_CERT_PRIFIX}*pem
