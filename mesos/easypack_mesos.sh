#!/bin/sh

###############################################################################
#
#Variable Init
#
###############################################################################
TMP_LOG_FILE=/tmp/tmp_log_file.$$.log
FILE_ETC_HOSTS=/etc/hosts
SOFT_RPM_MESOS="http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm"
SOFT_PKG_MESOS=mesos
SOFT_PKG_ZOOKEEPER=mesosphere-zookeeper
SOFT_PKG_MARATHON=marathon

CONFIG_ZK_FILE=/etc/zookeeper/conf/zoo.cfg
CONFIG_ZK=/var/lib/zookeeper/myid
CONFIG_MESOS_ZK=/etc/mesos/zk
CONFIG_MESOS_QUORUM=/etc/mesos-master/quorum
CONFIG_NUM_QUORUM=2
CONFIG_MESOS_MASTER_IP=/etc/mesos-master/ip
CONFIG_MESOS_MASTER_HOSTNAME=/etc/mesos-master/hostname
CONFIG_MESOS_SLAVE_IP=/etc/mesos-slave/ip
CONFIG_MESOS_SLAVE_HOSTNAME=/etc/mesos-slave/hostname
DIR_MESOS_CONF=/etc/marathon/conf

CONFIG_MESOS_SLAVE_FILE_CONTAINER=/etc/mesos-slave/containerizers
CONFIG_MESOS_SLAVE_CONTAINER="docker,mesos"
CONFIG_MESOS_SLAVE_FILE_REG_TMO=/etc/mesos-slave/executor_registration_timeout
CONFIG_MESOS_SLAVE_REG_TMO=5mins

MESOS_MASTER1_IP="192.168.146.32"
MESOS_MASTER2_IP="192.168.146.33"
MESOS_MASTER3_IP="192.168.146.34"
MESOS_MASTER1_HOSTNAME="host32"
MESOS_MASTER2_HOSTNAME="host33"
MESOS_MASTER3_HOSTNAME="host34"

MESOS_SLAVE1_IP="192.168.146.42"
MESOS_SLAVE2_IP="192.168.146.43"
MESOS_SLAVE3_IP="192.168.146.44"
MESOS_SLAVE1_HOSTNAME="host42"
MESOS_SLAVE2_HOSTNAME="host43"
MESOS_SLAVE3_HOSTNAME="host44"

PORT_ZK_MASTER=2888
PORT_ZK_VOTE=3888
PORT_ZK_MESOS=2181
###############################################################################
#
#Function Def
#
###############################################################################
usage(){
  echo "Usage: $0 ACTION TYPE NODE"
  echo "       ACTION: INSTALL|INIT|UNINSTALL|STATUS|START|STOP|RESTART"
  echo "       TYPE  : MASTER|SLAVE"
  echo "       NODE  : 1|2|3|ALL"
}

append_mesos_master_hosts(){
  echo "# Mesos Master" >> ${FILE_ETC_HOSTS}
  echo "${MESOS_MASTER1_IP} ${MESOS_MASTER1_HOSTNAME}" >> ${FILE_ETC_HOSTS}
  echo "${MESOS_MASTER2_IP} ${MESOS_MASTER2_HOSTNAME}" >> ${FILE_ETC_HOSTS}
  echo "${MESOS_MASTER3_IP} ${MESOS_MASTER3_HOSTNAME}" >> ${FILE_ETC_HOSTS}
  echo "" >>${FILE_ETC_HOSTS}

  echo "# Mesos Slave" >> ${FILE_ETC_HOSTS}
  echo "${MESOS_SLAVE1_IP} ${MESOS_SLAVE1_HOSTNAME}" >> ${FILE_ETC_HOSTS}
  echo "${MESOS_SLAVE2_IP} ${MESOS_SLAVE2_HOSTNAME}" >> ${FILE_ETC_HOSTS}
  echo "${MESOS_SLAVE3_IP} ${MESOS_SLAVE3_HOSTNAME}" >> ${FILE_ETC_HOSTS}
  echo "" >>${FILE_ETC_HOSTS}
}

mgnt_master(){
  ACTION=$1

  if [ _"$ACTION" = _"INSTALL" ]; then
    systemctl stop firewalld && systemctl disable firewalld
    iptables -F
    echo "##Install: deltarpm"
    yum -y install deltarpm
    echo "##       : mesos"
    rpm -Uvh ${SOFT_RPM_MESOS}
    yum install -y ${SOFT_PKG_MESOS}
    echo "##       : marathon"
    yum install -y ${SOFT_PKG_MARATHON}
    echo "##       : zookeeper"
    yum install -y ${SOFT_PKG_ZOOKEEPER}
  elif [ _"$ACTION" = _"CONFIG" ]; then
    #Config: Zookeeper
    echo "server.1=${MESOS_MASTER1_IP}:${PORT_ZK_MASTER}:${PORT_ZK_VOTE}" >> ${CONFIG_ZK_FILE}
    echo "server.2=${MESOS_MASTER2_IP}:${PORT_ZK_MASTER}:${PORT_ZK_VOTE}" >> ${CONFIG_ZK_FILE}
    echo "server.3=${MESOS_MASTER3_IP}:${PORT_ZK_MASTER}:${PORT_ZK_VOTE}" >> ${CONFIG_ZK_FILE}

    #Config: Zookeeper for mesos
    echo "zk://${MESOS_MASTER1_IP}:${PORT_ZK_MESOS},${MESOS_MASTER2_IP}:${PORT_ZK_MESOS},${MESOS_MASTER3_IP}:${PORT_ZK_MESOS}/mesos" > ${CONFIG_MESOS_ZK}

    #Config: Setting quorum
    echo "${CONFIG_NUM_QUORUM}" > ${CONFIG_MESOS_QUORUM}

    #define a unique ID number
    echo "${NODE}" > ${CONFIG_ZK}
    #Configure the Hostname and IP Address
    echo "${MESOS_MASTER_IP}" > ${CONFIG_MESOS_MASTER_IP}
    echo "${MESOS_MASTER_HOSTNAME}" > ${CONFIG_MESOS_MASTER_HOSTNAME}

    #All Master nodes
    #Configure Marathon on the Master Servers
    mkdir -p ${DIR_MESOS_CONF}
    cp ${CONFIG_MESOS_MASTER_HOSTNAME} ${DIR_MESOS_CONF}
    cp ${CONFIG_MESOS_ZK} ${DIR_MESOS_CONF}/master
    echo "zk://${MESOS_MASTER1_IP}:${PORT_ZK_MESOS},${MESOS_MASTER2_IP}:${PORT_ZK_MESOS},${MESOS_MASTER3_IP}:${PORT_ZK_MESOS}/marathon" > ${DIR_MESOS_CONF}/zk
  elif [ _"$ACTION" = _"INIT" ]; then
    systemctl stop mesos-slave
    systemctl disable mesos-slave
    systemctl restart zookeeper
    systemctl restart marathon
    systemctl restart mesos-master
  fi
}

mgnt_slave(){
  ACTION=$1

  if [ _"$ACTION" = _"INSTALL" ]; then
    systemctl stop firewalld && systemctl disable firewalld
    iptables -F  
    rpm -Uvh ${SOFT_RPM_MESOS}
    yum -y install mesos
    echo "zk://${MESOS_MASTER1_IP}:${PORT_ZK_MESOS},${MESOS_MASTER2_IP}:${PORT_ZK_MESOS},${MESOS_MASTER3_IP}:${PORT_ZK_MESOS}/mesos" > /etc/mesos/zk
  elif [ _"$ACTION" = _"CONFIG" ]; then
    #config mesos slave
    echo "${CONFIG_MESOS_SLAVE_CONTAINER}" > ${CONFIG_MESOS_SLAVE_FILE_CONTAINER}
    echo "${CONFIG_MESOS_SLAVE_REG_TMO}" > ${CONFIG_MESOS_SLAVE_REG_TMO}
    echo "${MESOS_SLAVE_IP}" > ${CONFIG_MESOS_SLAVE_IP}
    echo "${MESOS_SLAVE_HOSTNAME}" > ${CONFIG_MESOS_SLAVE_HOSTNAME}
  elif [ _"$ACTION" = _"INIT" ]; then
    systemctl stop mesos-master
    systemctl disable mesos-master
    systemctl enable mesos-slave
    systemctl restart mesos-slave
  fi
}

mgnt_service(){
  ACTION=$1
  TYPE=$2

  if [ _"$TYPE" = _"MASTER" ]; then
    systemctl ${ACTION} zookeeper
    systemctl ${ACTION} marathon
    systemctl ${ACTION} mesos-master
  elif [ _"$TYPE" = _"SLAVE" ]; then
    systemctl ${ACTION} mesos-slave
  fi
}

get_ip_or_hostname(){
  ACTION=$1
  TYPE=$2
  if [ _"$ACTION" = _"IP" ]; then
    if [ _"$TYPE" = _"MASTER" ]; then
      NODE_NUM=${NODE}
      eval echo "\${MESOS_MASTER${NODE}_IP}"
    elif [ _"$TYPE" = _"SLAVE" ]; then
      NODE_NUM=$NODE
      eval echo "\${MESOS_SLAVE${NODE}_IP}"
    fi
  elif [ _"$ACTION" = _"HOSTNAME" ]; then
    if [ _"$TYPE" = _"MASTER" ]; then
      NODE_NUM=$1
      eval echo "\${MESOS_MASTER${NODE}_HOSTNAME}"
    elif [ _"$TYPE" = _"SLAVE" ]; then
      NODE_NUM=$NODE
      eval echo "\${MESOS_SLAVE${NODE}_HOSTNAME}"
    fi
  fi
}

uninstall(){
  # Uninstall
  systemctl stop zookeeper
  systemctl stop marathon
  systemctl stop mesos-master
  systemctl stop mesos-slave

  yum erase -y mesos
  yum erase -y marathon
  yum erase -y mesosphere-zookeeper
  yum erase -y chronos

  rm -rf /var/lib/mesos
  rm -rf /var/log/mesos
  rm -rf /usr/lib/mesos
  rm -rf /usr/share/doc/mesos
  rm -rf /usr/share/doc/mesosphere-el-repo-7
  rm -rf /usr/share/mesos
  rm -rf /usr/etc/mesos
  rm -rf /usr/include/mesos
  rm -rf /usr/libexec/mesos
  rm -rf /etc/mesos
  rm -rf /etc/mesos-master
  rm -rf /etc/mesos-slave
  rm -rf /etc/zookeeper
  rm -rf /etc/default/mesos
  rm -rf /etc/default/mesos-master
  rm -rf /etc/default/mesos-slave
  rm -rf /usr/bin/mesos*
  rm -rf /usr/lib/systemd/system/mesos-master.service
  rm -rf /usr/lib/systemd/system/mesos-slave.service
  rm -rf /usr/sbin/mesos-*
  rm -rf /opt/mesosphere
  rm -rf /etc/marathon
  rm -rf /usr/bin/marathon
  rm -rf /usr/lib/systemd/system/marathon.service
  rm -rf /var/lib/zookeeper
  rm -rf /etc/systemd/system/multi-user.target.wants/chronos.service
  rm -rf /etc/systemd/system/multi-user.target.wants/marathon.service
  rm -rf /etc/systemd/system/multi-user.target.wants/mesos-master.service
  rm -rf /etc/systemd/system/multi-user.target.wants/zookeeper.service
  rm -rf /etc/systemd/system/multi-user.target.wants/mesos-slave.service
}


###############################################################################
#
#Param Check
#
###############################################################################
if [ $# -ne 3 ]; then
  usage
  exit 1
fi

#ACTION: INSTALL|UNINSTALL|STATUS|START|STOP|RESTART
ACTION=$1
#TYPE  : MASTER|SLAVE
TYPE=$2
#NODE  : 1|2|3
NODE=$3

MESOS_MASTER_IP=`get_ip_or_hostname IP MASTER`
MESOS_MASTER_HOSTNAME=`get_ip_or_hostname IP MASTER`
MESOS_SLAVE_IP=`get_ip_or_hostname IP SLAVE`
MESOS_SLAVE_HOSTNAME=`get_ip_or_hostname IP SLAVE`

date |tee ${TMP_LOG_FILE}
if [ _"$ACTION" = _"INSTALL" ]; then
  echo "## Intall Log file : $TMP_LOG_FILE"
  if [ _"$TYPE" = _"MASTER" ]; then
    echo -n "## Install for Master Node:            :"
    mgnt_master INSTALL >> ${TMP_LOG_FILE} 2>&1
    echo "OK"

    echo -n "## Config for Master Node: /etc/hosts  :"
    append_mesos_master_hosts >> ${TMP_LOG_FILE} 2>&1
    echo "OK"

    echo -n "## Config   for Master Node:           :"
    mgnt_master CONFIG >> ${TMP_LOG_FILE} 2>&1
    echo "OK"

  elif [ _"$TYPE" = _"SLAVE" ]; then
    echo -n "## Install for Slave   Node:             "
    mgnt_slave INSTALL >> ${TMP_LOG_FILE} 2>&1
    echo "OK"

    echo -n "## Config   for Slave   Node:            "
    mgnt_slave CONFIG  >> ${TMP_LOG_FILE} 2>&1
    echo "OK"
  fi
elif [ _"$ACTION" = _"INIT" ]; then
  echo "## Intall Log file : $TMP_LOG_FILE"
  if [ _"$TYPE" = _"MASTER" ]; then
    echo -n "## Init     for Master Node:           :"
    mgnt_master INIT   >> ${TMP_LOG_FILE} 2>&1
    echo "OK"

  elif [ _"$TYPE" = _"SLAVE" ]; then
    echo -n "## Init     for Slave   Node:            "
    mgnt_slave INIT    >> ${TMP_LOG_FILE} 2>&1
    echo "OK"
  fi
elif [ _"$ACTION" = _"UNINSTALL" ]; then
  uninstall
elif [ _"$ACTION" = _"STATUS" ]; then
  mgnt_service status ${TYPE}
elif [ _"$ACTION" = _"START" ]; then
  mgnt_service start ${TYPE}
elif [ _"$ACTION" = _"STOP" ]; then
  mgnt_service stop ${TYPE}
elif [ _"$ACTION" = _"RESTART" ]; then
  mgnt_service restart ${TYPE}
else
  usage
  eixt 1
fi
