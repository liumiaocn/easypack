#! /bin/bash -e

: "${JENKINS_HOME:="/var/jenkins_home"}"
touch "${COPY_REFERENCE_FILE_LOG}" || { echo "Can not write to ${COPY_REFERENCE_FILE_LOG}. Wrong volume permissions?"; exit 1; }
echo "--- Copying files at $(date)" >> "$COPY_REFERENCE_FILE_LOG"
find /usr/share/jenkins/ref/ -type f -exec bash -c '. /usr/local/bin/jenkins-support; for arg; do copy_reference_file "$arg"; done' _ {} +

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [ _"$JENKINS_MODE" == _"master" ]; then
  exec java "$JAVA_OPTS" -jar /usr/share/jenkins/jenkins.war "${JENKINS_OPTS}" "$@"
elif [ _"$JENKINS_MODE" == _"slave" ]; then
  exec java "$JAVA_OPTS" -jar /usr/share/jenkins/slave.jar "${JENKINS_OPTS}" "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"
