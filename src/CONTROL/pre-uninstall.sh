PACKAGE=/usr/local/AppCentral/{{name}}

if [ -d $PACKAGE/lib ]; then
    rm -rf $PACKAGE/lib
fi
