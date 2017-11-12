#!/bin/sh

usage(){
  echo "Usage: $0 [node-xxx.tar.gz]"
  echo "       node-xx.tar.gz: specified file will be used. Default will download directly"
  echo
}

INSTALL_FLAG="NET"
FILE_SPECIFIED=$1

if [ $# -eq 1 ]; then
  if [ ! -f ${FILE_SPECIFIED} ]; then
    echo "File ${FILE_SPECIFIED} does not exist"
    usage
    exit 1
  else
    INSTALL_FLAG="LOCAL"
  fi
fi

FILE_VERSION=9.1.0
FILE_TAR_GZ=node-v${FILE_VERSION}-linux-x64
DOWNLOAD_URL="https://nodejs.org/dist/v${FILE_VERSION}/${FILE_TAR_GZ}.tar.gz"

DIR_INSTALL=/usr/local/npm

date
echo "##Install Step 1: download binary file ..."
date
if [ _"LOCAL" = _"$INSTALL_FLAG" ]; then
  echo "  Install by using local tar.gz file specified, downloading is skipped..."
else
  cd /tmp
  wget ${DOWNLOAD_URL}
fi

date
ls ${FILE_TAR_GZ}.tar.gz
echo

echo "##Install Step 2: tar xvpf to unzip file ..."
date
mkdir -p /usr/local/npm
cd /usr/local/npm
tar xvpf /tmp/${FILE_TAR_GZ}.tar.gz
mv node* node
pwd
ls
date
echo


echo "##Install Step 3: create link file"
date
ln -s /usr/local/npm/node/bin/npm /usr/local/bin/npm
ln -s /usr/local/npm/node/bin/node /usr/local/bin/node

echo


echo "VERSION CONFORM:"
npm -v
node -v
