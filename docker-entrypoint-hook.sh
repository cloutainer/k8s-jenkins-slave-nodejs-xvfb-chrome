#!/bin/bash

set -e

#
# VERSION OUTPUT
#
VERSION_NODE=$(node -v)
echo "DOCKER-ENTRYPOINT-HOOK >> node version          : "$VERSION_NODE
VERSION_YARN=$(yarn -v)
echo "DOCKER-ENTRYPOINT-HOOK >> yarn version          : "$VERSION_YARN
VERSION_NPM=$(npm -v)
echo "DOCKER-ENTRYPOINT-HOOK >> npm version           : "$VERSION_NPM
VERSION_CHROME=$(google-chrome --version)
echo "DOCKER-ENTRYPOINT-HOOK >> google-chrome version : "$VERSION_CHROME


#
# XVFB
#
echo "DOCKER-ENTRYPOINT-HOOK >> starting Xvfb"
Xvfb :99 -ac -screen 0 1280x1024x16 -nolisten tcp &
xvfb=$!
export DISPLAY=:99

#
# DBUS
#
echo "DOCKER-ENTRYPOINT-HOOK >> starting dbus"
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
