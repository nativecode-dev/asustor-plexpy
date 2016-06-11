#!/bin/bash

DATADIR=/share/{{name}}
PACKAGE=/usr/local/AppCentral/{{name}}

if [ ! -d $DATADIR ]; then
    mkdir -p $DATADIR
fi

if [ ! -d $PACKAGE/lib]; then
    git clone {{{plexpy.url}}} $PACKAGE/lib
fi

cd $PACKAGE/lib
git checkout {{plexpy.tag}}
git branch -D master
git checkout -b master
