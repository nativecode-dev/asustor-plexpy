#!/bin/sh

PACKAGE=/usr/local/AppCentral/{{name}}
. $PACKAGE/CONTROL/env.sh

case $1 in
    start)
        echo "Located package directory $PLEXPY_DIR."
        echo "Using data directory $PLEXPY_DATA."
        echo "Launching daemon..."
        python $PLEXPY_DIR/PlexPy.py --daemon --datadir $PLEXPY_DATA --nolaunch --pidfile
        echo "Done."
        exit 0
        ;;

    stop)
        ;;

    reload)
        ;;

    *)
        echo "usage: $0 {start|stop|reload}"
        ;;
esac

exit 0
