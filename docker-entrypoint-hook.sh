#!/bin/bash

set -e

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
