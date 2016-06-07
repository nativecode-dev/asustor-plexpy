#!/bin/sh

DATADIR=/share/{{name}}
PACKAGE=/usr/local/AppCentral/{{name}}
PIDFILE=$PACKAGE/.pidfile
cd $PACKAGE

package_kill() {
    kill -KILL $(cat $PIDFILE)
}

package_terminate() {
    kill -TERM $(cat $PIDFILE)
}

package_start() {
    python lib/PlexPy.py --daemon --datadir $DATADIR --nolaunch --pidfile $PIDFILE
}

package_stop() {
    i=0
    REPEATS=3
    package_terminate
    while [ -f $PIDFILE ]
    do
        sleep 2
        let "i+=1"
    done
}

case $1 in
    start)
        echo "Located package directory $PACKAGE."
        echo "Using data directory $PACKAGE/data."
        echo "Launching daemon..."
        package_start
        echo "Done."
        exit 0
        ;;

    stop)
        package_stop
        exit 1
        ;;

    reload)
        package_stop
        package_start
        ;;

    *)
        echo "usage: $0 {start|stop|reload}"
        ;;
esac

exit 0
