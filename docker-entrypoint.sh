#!/bin/bash

set -e

#
# DISPLAY DOCKER CMD CALL
#
#myInvocation="$(printf %q "$BASH_SOURCE")$((($#)) && printf ' %q' "$@")"
#echo $myInvocation

#
# UMASK
#
umask u+rxw,g+rwx,o-rwx

#
# USER
#
echo "DOCKER-ENTRYPOINT >> running as user"
whoami

#
# XVFB
#
echo "DOCKER-ENTRYPOINT >> starting Xvfb"
Xvfb :99 -ac -screen 0 1280x1024x16 -nolisten tcp &
xvfb=$!
export DISPLAY=:99

#
# DBUS
#
echo "DOCKER-ENTRYPOINT >> starting dbus"
eval `dbus-launch --sh-syntax --config-file=/tmp/dbus-system.conf`

#
# PULSEAUDIO
#
# FIXME: "Daemon startup failed"
#pulseaudio --daemonize

#
# CHROME
#
export CHROME_BIN="/usr/bin/google-chrome"



# ---------------------------------------------------------------------------------------
# FROM HERE ON DOWN JENKINS SLAVE JNLP
# ---------------------------------------------------------------------------------------

echo "DOCKER-ENTRYPOINT >> config: JENKINS_NAME:     $JENKINS_NAME"
echo "DOCKER-ENTRYPOINT >> config: JENKINS_SECRET:   $JENKINS_SECRET"
echo "DOCKER-ENTRYPOINT >> config: JENKINS_URL:      $JENKINS_URL"
echo "DOCKER-ENTRYPOINT >> config: JENKINS_JNLP_URL: $JENKINS_JNLP_URL"

### FIXME: Since older Jenkins slave.jar versions have "-url" and newer ones have "-jnlpUrl"
###        We will download V3 releases from GitHub instead!
###        Since slave.jar has no version parameter to check the version we cannot handle the versions differently :(

#echo "DOCKER-ENTRYPOINT >> downloading jenkins-slave.jar from Jenkins"
#echo "DOCKER-ENTRYPOINT >> ${JENKINS_URL}/jnlpJars/slave.jar"
#curl -I ${JENKINS_URL}/jnlpJars/slave.jar

#curl -sSLo /tmp/jenkins-slave.jar ${JENKINS_URL}/jnlpJars/slave.jar
#remoting-3.10 is bundled with jenkins 2.71
curl -sSLo /tmp/jenkins-slave.jar  https://repo.jenkins-ci.org/releases/org/jenkins-ci/main/remoting/3.10/remoting-3.10.jar

###echo "DOCKER-ENTRYPOINT >> checking integrity of slave.jar"
###jar -tvf /tmp/jenkins-slave.jar

echo "DOCKER-ENTRYPOINT >> establishing JNLP connection with Jenkins via JNLP URL"

exec java $JAVA_OPTS -cp /tmp/jenkins-slave.jar \
            hudson.remoting.jnlp.Main -headless \
            -url $JENKINS_URL $JENKINS_SECRET $JENKINS_NAME


### Produces 403 Forbidden => exec java -jar /tmp/jenkins-slave.jar -jnlpUrl $JENKINS_JNLP_URL
