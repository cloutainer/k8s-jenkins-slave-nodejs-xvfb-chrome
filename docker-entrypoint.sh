#!/bin/bash

set -ve

#
# DISPLAY DOCKER CMD CALL
#
myInvocation="$(printf %q "$BASH_SOURCE")$((($#)) && printf ' %q' "$@")"
echo $myInvocation

#
# UMASK
#
umask u+rxw,g+rwx,o-rwx

#
# XVFB
#
Xvfb :99 -ac -screen 0 1280x1024x16 -nolisten tcp &
xvfb=$!
export DISPLAY=:99

#
# DBUS
#
eval `dbus-launch --sh-syntax --config-file=/tmp/dbus-system.conf`

#
# PULSEAUDIO
#
# pulseaudio --daemonize

#
# CHROME
#
export CHROME_BIN="/usr/bin/google-chrome"



# ---------------------------------------------------------------------------------------
# FROM HERE ON DOWN JENKINS SLAVE JNLP
# ---------------------------------------------------------------------------------------

echo "DOCKER-ENTRYPOINT >> downloading jenkins-slave.jar from Jenkins"
curl -sSLo /home/jenkins/.bin/jenkins-slave.jar ${JENKINS_URL}/jnlpJars/slave.jar


echo "DOCKER-ENTRYPOINT >> establishing JNLP connection with Jenkins"
exec java $JAVA_OPTS -cp /home/jenkins/.bin/jenkins-slave.jar \
            hudson.remoting.jnlp.Main -headless \
            $JENKINS_JNLP_URL $JENKINS_SECRET $JENKINS_NAME

