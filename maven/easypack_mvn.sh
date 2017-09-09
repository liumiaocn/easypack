#!/bin/sh
###############################################################################
#
#VARS INIT
#
###############################################################################
JAVA_HOME=/usr/local/java
MVN_HOME=/usr/local/maven
DIR_DOWNLOAD=/tmp/download.$$
DIR_NEW_MVN=apache-maven-3.5.0
DIR_NEW_JDK=jdk1.8.0_144

JDK_TAR_GZ=jdk-8u144-linux-x64.tar.gz
JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/${JDK_TAR_GZ}"
MAVEN_TAR_GZ=apache-maven-3.5.0-bin.tar.gz
MAVEN_URL="http://www-us.apache.org/dist/maven/maven-3/3.5.0/binaries/${MAVEN_TAR_GZ}"
PROFILES=/etc/profile


###############################################################################
#
#DOWNLOAD JDK & MAVEN
#
###############################################################################
mkdir -p ${DIR_DOWNLOAD}
cd $DIR_DOWNLOAD
date
echo "## Download begins : JDK : ${JDK_TAR_GZ}"
wget --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JDK_URL} >/dev/null 2>&1
echo "## Download ends   : JDK : ${JDK_TAR_GZ}"
echo

date
echo "## Download begins : MAVEN: ${MAVEN_TAR_GZ}"
wget ${MAVEN_URL} >/dev/null 2>&1
echo "## Download ends   : MAVEN: ${MAVEN_TAR_GZ}"
echo

echo "## Check download"
ls -l ${JDK_TAR_GZ} ${MAVEN_TAR_GZ}

###############################################################################
#
#INSTALL JDK & MAVEN
#
###############################################################################
#create directories
mkdir -p ${JAVA_HOME} ${MVN_HOME}

date
echo "## Install begins : JDK : {JAVA_HOME}"
cd ${JAVA_HOME}
gunzip -c ${DIR_DOWNLOAD}/${JDK_TAR_GZ} | tar xvf -
echo "## Install ends   : JDK : {JAVA_HOME}"
echo

date
echo "## Install begins : MAVEN : {JAVA_HOME}"
cd ${MVN_HOME}
gunzip -c ${DIR_DOWNLOAD}/${MAVEN_TAR_GZ} | tar xvf -
echo "## Install ends   : MAVEN : {MVN_HOME}"

###############################################################################
#
#ENVIRONMENT VARS
#
###############################################################################
echo "## Env setting : JDK : JAVA_HOME + PATH"
echo "" >>${PROFILES}
echo "#JDK Setting" >>${PROFILES}
echo "export JAVA_HOME=${JAVA_HOME}/${DIR_NEW_JDK}" >>${PROFILES}
echo "export PATH=\${JAVA_HOME}/bin:\$PATH" >>${PROFILES}
export JAVA_HOME=${JAVA_HOME}/${DIR_NEW_JDK}
export export PATH=${JAVA_HOME}/bin:$PATH

echo "## Env setting : M2_HOME :  + PATH"
echo "" >>${PROFILES}
echo "#Maven Setting" >>${PROFILES}
echo "export M2_HOME=${MVN_HOME}/${DIR_NEW_MVN}" >>${PROFILES}
echo "export PATH=\${M2_HOME}/bin:\$PATH" >>${PROFILES}
export M2_HOME=${MVN_HOME}/${DIR_NEW_MVN}
export PATH=${M2_HOME}/bin:$PATH

###############################################################################
#
#CONFIRM VERSION
#
###############################################################################
echo "## Check Java version"
java -version
echo

echo "## Check Maven version"
mvn --version
echo

###############################################################################
#
#REMOVE DOWNLOAD FILES
#
###############################################################################
echo "## Delete Download files"
rm -rf ${DIR_DOWNLOAD}
