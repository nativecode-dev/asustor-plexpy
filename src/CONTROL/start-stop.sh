#!/bin/sh

NAME=PlexPy
PACKAGE=plexpy

if [ -z "${APKG_PKG_DIR}" ]; then
	PKG_DIR=/usr/local/AppCentral/${PACKAGE}
else
	PKG_DIR=$APKG_PKG_DIR
fi

. ${PKG_DIR}/CONTROL/env.sh

PIDFILE=/var/run/${PACKAGE}.pid
CHUID=${USER}:${GROUP}

start_daemon() {
	echo "Starting ${NAME}..."

	# Set umask to create files with world r/w
	umask 0

	env TERM="linux" \
		start-stop-daemon -S \
			--pidfile $PIDFILE \
			--chuid $CHUID \
			--user $USER \
			--exec dtach -- -n $SOCKET -e "^T" env HOME=$BASE PlexPy.py

	# Get the pid of the newest process matching plexpy
	pgrep -n PlexPy.py > $PIDFILE
}

stop_daemon_with_signal() {
	start-stop-daemon -K --quiet --user $USER --pidfile $PIDFILE --signal "$1"
}

stop_daemon() {
	echo "Stopping ${NAME}..."
	stop_daemon_with_signal 2
}

daemon_status() {
	start-stop-daemon -K --quiet --test --user $USER --pidfile $PIDFILE
}

exit 0
