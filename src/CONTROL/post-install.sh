#!/bin/bash

DATADIR=/share/{{name}}
PACKAGE=/usr/local/AppCentral/{{name}}

case "${APKG_PKG_STATUS}" in
    install)
        mkdir -p $DATADIR
        git clone {{{plexpy.url}}} $PACKAGE/lib
        cd $PACKAGE/lib
        git checkout {{plexpy.tag}}
        git branch -D master
        git checkout -b master
        ;;

    upgrade)
        cd $PACKAGE/lib
        git pull origin master
        ;;

    *)
        ;;
esac
