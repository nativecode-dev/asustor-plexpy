#!/bin/sh

PACKAGE=/usr/local/AppCentral/{{name}}
cd $PACKAGE

kill_by_pid() {
    if [ -f $PACKAGE/data/.pidfile]; then
        kill $(cat $PACKAGE/data/.pidfile)
    fi
}

case $1 in
    start)
        echo "Located package directory $PACKAGE."
        echo "Using data directory $PACKAGE/data."
        echo "Launching daemon..."
        python lib/PlexPy.py --daemon --datadir $PACKAGE/data --nolaunch --pidfile $PACKAGE/data/.pidfile
        echo "Done."
        exit 0
        ;;

    stop)
        i=0
        REPEATS=3
        while [ $i -lt $REPEATS ]
        do
            kill_by_pid
            sleep 1
            if [ ! -f $PACKAGE/data/.pidfile]; then
                exit 0
            fi
            let "i+=1"
        done
        exit 1
        ;;

    reload)
        ;;

    *)
        echo "usage: $0 {start|stop|reload}"
        ;;
esac

exit 0
