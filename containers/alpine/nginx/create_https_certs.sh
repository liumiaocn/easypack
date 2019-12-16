#!/bin/sh

FILE_CA_KEY=ca.key
FILE_CA_CERT=ca.crt
RSA_KEY_LENGTH=2048
CA_EXPIRY_DAYS=3650
SERVER_EXPIRY_DAYS=365
FILE_SERVER_KEY=server.key
FILE_SERVER_CERT=server.crt
FILE_SERVER_CSR=server.csr
FILE_V3_EXT=v3_extfile.conf
NAME_DN_C=CN
NAME_DN_ST=LiaoNing
NAME_DN_L=DaLian
NAME_DN_O=devops
NAME_DN_OU=unicorn
NAME_DN_CN=${ENV_NAME_DN_CN:-www.devops.com}

echo "## Prepare for DN and v3 extension setting files"
cat > ${FILE_V3_EXT} <<EOF
[ req ]
default_bits = ${RSA_KEY_LENGTH}
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = ${NAME_DN_C}
ST = ${NAME_DN_ST}
L = ${NAME_DN_L}
O = ${NAME_DN_O}
OU = ${NAME_DN_OU}
CN = ${NAME_DN_CN}

[ req_ext ]
subjectAltName = @alt_names

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names

[ alt_names ]
DNS.1 = ${NAME_DN_CN}
EOF

echo "## Create CA private key with name : $FILE_CA_KEY"
openssl genrsa -out ${FILE_CA_KEY} ${RSA_KEY_LENGTH}

echo "## Create CA certificate with name : $FILE_CA_CERT"
openssl req -x509 -new -nodes -key ${FILE_CA_KEY} -days ${CA_EXPIRY_DAYS} -out ${FILE_CA_CERT} -config ${FILE_V3_EXT}

echo "## Create server private key with name : $FILE_SERVER_KEY"
openssl genrsa -out $FILE_SERVER_KEY $RSA_KEY_LENGTH

echo "## Create server CSR file with name    : $FILE_SERVER_CSR"
openssl req -new -key ${FILE_SERVER_KEY} -out ${FILE_SERVER_CSR} -config ${FILE_V3_EXT}

echo "## Create server certificate with name : $FILE_SERVER_CERT" 
openssl x509 -req -in ${FILE_SERVER_CSR} -CA ${FILE_CA_CERT} -CAkey ${FILE_CA_KEY} -CAcreateserial \
             -out ${FILE_SERVER_CERT} -days ${SERVER_EXPIRY_DAYS} -extensions v3_ext -extfile ${FILE_V3_EXT}
