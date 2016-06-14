#!/bin/bash

DATADIR=/share/{{name}}
PACKAGE=/usr/local/AppCentral/{{name}}

GROUP=administrators
USER=admin

if [ ! -d $PACKAGE/lib]; then
    git clone {{{plexpy.url}}} $PACKAGE/lib
fi

cd $PACKAGE/lib
git checkout v{{version}}
git branch -D master
git checkout -b master

# Set ownership to admin/administrators, per the docs.
# http://developer.asustor.com
chown $USER:$GROUP $PACKAGE/lib -R
