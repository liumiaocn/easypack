#!/bin/sh

JENKINS_HOST=localhost
JENKINS_PORT=32002
JENKINS_SERVICE_URL=http://${JENKINS_HOST}:${JENKINS_PORT}

JENKINS_USER=root
JENKINS_PASSWORD=liumiaocn
JENKINS_CONFIG_XML="Content-Type:application/xml"

JENKINS_CRUMB=`curl -u ${JENKINS_USER}:${JENKINS_PASSWORD} "${JENKINS_SERVICE_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)" 2>/dev/null`
if [ _"" = _"${JENKINS_CRUMB}" ]; then
  echo "NG: Failed to get Jenkins crumb info. "
  echo "    [USER = ${JENKINS_USER}] [Password = ${JENKINS_PASSWORD}] "
  echo "    Jenkins Url: ${JENKINS_SERVICE_URL}"
  echo "    if user & password & url right, please check CSRF setting"
  exit 1
else
  echo "[JENKINS Crumb]: ${JENKINS_CRUMB}"
fi

usage() {
  echo "Usage: $0 ACTION DEMO-PATTERN"
  echo "       ACTION: JOBCREATE|JOBEXEC|JOBDELETE|JOBCHECK|JOBENABLE|JOBDISABLE|JOBCOPY|LOGCHECK"
  echo "   eg: $0 "
}

ACTION=$1
DEMO_PATTERN=$2
ARG_OPTIONS=$3

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

if [ _"JOBCREATE" = _"${ACTION}" ]; then
  JENKINS_DEMO_XML_CONFIG="demo/pipeline/${DEMO_PATTERN}/config.xml" 
  if [ ! -f ${JENKINS_DEMO_XML_CONFIG} ]; then
    echo "[NG: config file does not exist: ${JENKINS_DEMO_XML_CONFIG} ]"
    exit 1
  fi
  echo "JOB Creation Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} -H "${JENKINS_CONFIG_XML}"  --data-binary  "@${JENKINS_DEMO_XML_CONFIG}" ${JENKINS_SERVICE_URL}/createItem?name=${ARG_OPTIONS} 
  echo "JOB Creation Ends   ..."
elif [ _"JOBEXEC" = _"${ACTION}" ]; then
  echo "JOB [${DEMO_PATTERN}] Build Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} ${JENKINS_SERVICE_URL}/job/${DEMO_PATTERN}/build
  echo "JOB [${DEMO_PATTERN}] Build Ends   ..."
elif [ _"JOBENABLE" = _"${ACTION}" ]; then
  echo "JOB [${DEMO_PATTERN}] Enable Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} ${JENKINS_SERVICE_URL}/job/${DEMO_PATTERN}/enable
  echo "JOB [${DEMO_PATTERN}] Enable Ends   ..."
elif [ _"JOBDISABLE" = _"${ACTION}" ]; then
  echo "JOB [${DEMO_PATTERN}] Disable Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} ${JENKINS_SERVICE_URL}/job/${DEMO_PATTERN}/disable
  echo "JOB [${DEMO_PATTERN}] Disable Ends   ..."
elif [ _"JOBCOPY" = _"${ACTION}" ]; then
  echo "JOB [${DEMO_PATTERN}] COPY to [${ARG_OPTIONS}] Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} "${JENKINS_SERVICE_URL}/createItem?name=${ARG_OPTIONS}&mode=copy&from=${DEMO_PATTERN}"
  echo "JOB [${DEMO_PATTERN}] COPY to [${ARG_OPTIONS}] Ends   ..."
  echo
elif [ _"JOBDELETE" = _"${ACTION}" ]; then
  echo "JOB [${DEMO_PATTERN}] Delete Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} ${JENKINS_SERVICE_URL}/job/${DEMO_PATTERN}/doDelete
  echo "JOB [${DEMO_PATTERN}] Delete Ends   ..."
elif [ _"JOBCHECK" = _"${ACTION}" ]; then
  echo "JOB [${DEMO_PATTERN}] API Check Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} ${JENKINS_SERVICE_URL}/job/${DEMO_PATTERN}/api/xml 2>/dev/null|xmllint --format -
  echo "JOB [${DEMO_PATTERN}] API Check Ends   ..."
elif [ _"LOGCHECK" = _"${ACTION}" ]; then
  if [ _"" = _"${ARG_OPTIONS}" ]; then
    JENKINS_LOG_SEQ=1
  else
    JENKINS_LOG_SEQ=${ARG_OPTIONS}
  fi
  echo "JOB [${DEMO_PATTERN}] LOG Check Begins ..."
  curl -X POST -u ${JENKINS_USER}:${JENKINS_PASSWORD} -H ${JENKINS_CRUMB} ${JENKINS_SERVICE_URL}/job/${DEMO_PATTERN}/${JENKINS_LOG_SEQ}/consoleText
  echo "JOB [${DEMO_PATTERN}] LOG Check Ends   ..."
fi
