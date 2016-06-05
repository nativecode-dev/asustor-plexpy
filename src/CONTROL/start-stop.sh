#!/bin/sh

PACKAGE=/usr/local/AppCentral/{{name}}
. $PACKAGE/CONTROL/env.sh

case $1 in
    start)
        $PLEXPY_DIR/PlexPy.py --daemon --datadir $PLEXPY_DATA --nolaunch --pidfile
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
