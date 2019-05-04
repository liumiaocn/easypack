#!/bin/sh

PROJECT_NAME="jeecg-boot"
PROJECT_URL="https://gitee.com/dangzhenghui/${PROJECT_NAME}"
DOCKER_BOOT_DIR="/data/jeecg-boot"
LOG_BOOT_BUILD="jeecg-boot.springboot.log"
LOG_ANGULAR_BUILD="jeecg-boot.angular.log"
DOCKER_IMAGE=liumiaocn/maven:3.6.1
DOCKER_LOCAL_M2_DIR=~/.m2
DOCKER_M2_DIR=/root/.m2

usage(){
  echo
  echo "Usage: $0 ACTION TYPE"
  echo "          ACTION: download|build|deploy|all"
  echo "          TYPE:   boot|angular|all|bootit(build)|angularit(build)"
  echo
}

err_handle(){
	if [ $? -ne 0 ]; then
	   echo "$*"
	   exit 1
	 fi
}

ACTION=$1
TYPE=$2

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

if [ _"$ACTION" = _"download" ]; then
  which git
  err_handle "please make sure git installed"

  if [ _"$TYPE" = _"boot" -o _"$TYPE" = _"angular" -o _"$TYPE" = _"all" ]; then
    echo "## git clone $PROJECT_URL"
    git clone $PROJECT_URL
    err_handle "git clone failed"
  fi

elif [ _"$ACTION" = _"build" ]; then
  
  if [ _"$TYPE" = _"boot" -o _"$TYPE" = _"all" ]; then
    echo "## please use $0 download all first"
    echo "## begin build jeecg-boot by using : mvn package"
    echo "   please check build log file : $LOG_BOOT_BUILD"
    docker run --rm -v ${DOCKER_LOCAL_M2_DIR}:${DOCKER_M2_DIR} -v `pwd`/${PROJECT_NAME}:${DOCKER_BOOT_DIR} ${DOCKER_IMAGE} mvn clean package -f ${DOCKER_BOOT_DIR}/pom.xml >$LOG_BOOT_BUILD
    echo "   build log"
    ls $LOG_BOOT_BUILD
    echo "   build target"
    ls ${PROJECT_NAME}/start/target
    echo
  fi
  if [ _"$TYPE" = _"bootit" -o _"$TYPE" = _"all" ]; then
    echo "## please use $0 download all first"
    echo "## enter jeecg-boot docker env : "
    docker run -it --rm -v ${DOCKER_LOCAL_M2_DIR}:${DOCKER_M2_DIR} -v `pwd`/${PROJECT_NAME}:${DOCKER_BOOT_DIR} -w${DOCKER_BOOT_DIR} ${DOCKER_IMAGE} sh
  fi

  if [ _"$TYPE" = _"angular" -o _"$TYPE" = _"all" ]; then
    echo "## please use $0 download all first"
    echo "## begin build angular by using : npm install"
    docker run --rm -v `pwd`/${PROJECT_NAME}:${DOCKER_BOOT_DIR}  -w ${DOCKER_BOOT_DIR}/ant-design-jeecg-angular liumiaocn/angular:7.3.8 npm install >$LOG_ANGULAR_BUILD 2>&1 &
    echo "## begin build angular by using : ng build"
    docker run --rm -v `pwd`/${PROJECT_NAME}:${DOCKER_BOOT_DIR}  -w ${DOCKER_BOOT_DIR}/ant-design-jeecg-angular liumiaocn/angular:7.3.8 ng build >> $LOG_ANGULAR_BUILD 2>&1 &
    echo "   please check build log file : $LOG_ANGULAR_BUILD"
    echo
  fi

  if [ _"$TYPE" = _"angularit" -o _"$TYPE" = _"all" ]; then
    echo "## please use $0 download all first"
    echo "## enter jeecg angular docker env: "
    docker run -it --rm -v `pwd`/${PROJECT_NAME}:${DOCKER_BOOT_DIR}  -w ${DOCKER_BOOT_DIR}/ant-design-jeecg-angular liumiaocn/angular:7.3.8 sh 
  fi

elif [ _"$ACTION" = _"deploy" ]; then
  :
elif [ _"$ACTION" = _"all" ]; then
  sh $0 download all
  sh $0 build    all
  sh $0 deploy   all
  
else
  usage
  exit 1
fi
