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

echo "DOCKER-ENTRYPOINT >> downloading jenkins-slave.jar from Jenkins"
echo "DOCKER-ENTRYPOINT >> ${JENKINS_URL}/jnlpJars/slave.jar"
curl -I ${JENKINS_URL}/jnlpJars/slave.jar

curl -sSLo /tmp/jenkins-slave.jar ${JENKINS_URL}/jnlpJars/slave.jar

###echo "DOCKER-ENTRYPOINT >> checking integrity of slave.jar"
###jar -tvf /tmp/jenkins-slave.jar

echo "DOCKER-ENTRYPOINT >> establishing JNLP connection with Jenkins"
exec java $JAVA_OPTS -cp /tmp/jenkins-slave.jar \
            hudson.remoting.jnlp.Main -headless \
            -url $JENKINS_JNLP_URL $JENKINS_SECRET $JENKINS_NAME

