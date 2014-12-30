#!/bin/bash
#
# Reloads Diladele Web Safety and Squid Proxy, usually called by the Web UI
#
# returns:
#        0 - on success
#       !0 - on various errors
#

echo "reloading Diladele Web Safety..."
kill -HUP $(pidof qlproxyd)
res=$?
if [ $res -ne 0 ]; then
    echo "cannot reload, error $res"
    exit 1
fi


echo "reloading Squid proxy..."
kill -HUP $(pidof squid3)
res=$?
if [ $res -ne 0 ]; then
    echo "cannot reload, error $res"
    exit 1
fi

# dump success
echo "reload successful!"
exit 0