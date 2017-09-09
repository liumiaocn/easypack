#!/bin/sh

usage(){
  echo "Usage: $0 [clamav-xxx.tar.gz]"
  echo "       clamav-xx.tar.gz: specified file will be used. Default will download directly"
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

FILE_VERSION=0.99.2
FILE_TAR_GZ=clamav-${FILE_VERSION}
DOWNLOAD_URL="http://www.clamav.net/downloads/production/${FILE_TAR_GZ}.tar.gz"

DIR_INSTALL=/usr/local/clamav

date
echo "##Install Step 1: Install gcc openssl openssl-devel"
echo "##                Create Directory for compile-install"
yum install gcc -y
date
echo "  gcc install completed"
yum install openssl openssl-devel -y
date
echo "  openssl openssl-devel install completed"
mkdir -p ${DIR_INSTALL}
date
echo "  install directory creating completed"
echo

echo "##Install Step 2: download source file ..."
date
if [ _"LOCAL" = _"$INSTALL_FLAG" ]; then
  echo "  Install by using local tar.gz file specified, downloading is skipped..."
else
  wget ${DOWNLOAD_URL}
fi
date
ls ${FILE_TAR_GZ}.tar.gz
echo

echo "##Install Step 3: tar xvpf to unzip file ..."
date
tar xvpf ${FILE_TAR_GZ}.tar.gz
cd ${FILE_TAR_GZ}
pwd
ls
date
echo


echo "##Install Step 4: install by source file"
date
./configure --prefix=${DIR_INSTALL}
make
make install
date
echo "Install completed."
ls ${DIR_INSTALL}
echo

echo "##Setting Step 1: add user & group"
groupadd clamav
useradd -g clamav clamav
echo "  user & group added"
date
echo

echo "##Setting Step 2: create directories and set permissions"
cd ${DIR_INSTALL}
mkdir -p logs database worktmp
chown clamav:clamav database
touch ${DIR_INSTALL}/logs/freshclam.log
chown clamav:clamav ${DIR_INSTALL}/logs/freshclam.log
pwd
ls
date

echo "##Setting Step 3: setting freshclam.conf for update viruse database"
cd ${DIR_INSTALL}/etc
cp freshclam.conf.sample freshclam.conf
sed -i s@Example@#Example@g freshclam.conf
sed -i s@'#DatabaseDirectory /var/lib/clamav'@'DatabaseDirectory /usr/local/clamav/database/'@g freshclam.conf
sed -i s@'#UpdateLogFile /var/log/freshclam.log'@'UpdateLogFile /usr/local/clamav/logs/freshclam.log'@g freshclam.conf
sed -i s@'#PidFile /var/run/freshclam.pid'@'PidFile /usr/local/clamav/worktmp/freshclam.pid'@g freshclam.conf
date
echo "setting completed..."
echo

echo "Now Begin to init database version, it may take a little while, please wait with patience..."
date
${DIR_INSTALL}/bin/freshclam
date
echo "Update complete..."
echo

echo "VERSION CONFORM:"
${DIR_INSTALL}/bin/clamscan --version
echo
