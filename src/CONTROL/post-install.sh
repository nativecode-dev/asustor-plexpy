#!/bin/bash

PACKAGE=/usr/local/AppCentral/{{name}}

GROUP=administrators
USER=admin

case "${APKG_PKG_STATUS}" in
    install)
        mkdir -p $PACKAGE/data
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
        cd $PACKAGE
        chown -R ${USER}:${GROUP} $PACKAGE/data
        chown -R ${USER}:${GROUP} $PACKAGE/lib
        ;;
esac
