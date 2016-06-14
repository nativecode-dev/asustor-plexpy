#!/bin/bash

DATADIR=/share/{{name}}
PACKAGE=/usr/local/AppCentral/{{name}}

if [ ! -d $PACKAGE/lib ]; then
    git clone {{{plexpy.url}}} $PACKAGE/lib
fi

cd $PACKAGE/lib
git checkout v{{version}}
git branch -D master
git checkout -b master

# Set ownership to admin/administrators, per the docs.
# http://developer.asustor.com
chown admin:administrators $PACKAGE/lib -R
