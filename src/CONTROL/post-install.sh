#!/bin/bash

DATADIR=/share/{{name}}
PACKAGE=/usr/local/AppCentral/{{name}}

git clone {{{plexpy.url}}} $PACKAGE/lib | tee $PACKAGE/git.log
cd $PACKAGE/lib
git checkout v{{version}}
git branch -D master
git checkout -b master
