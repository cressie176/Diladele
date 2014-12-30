#!/bin/bash
#
# Restarts Diladele Web Safety and Squid Proxy, usually called by the Web UI
#
# returns:
#       0 - on success
#      !0 - on various errors
#

# restart qlproxy
echo "restarting Diladele Web Safety..."
supervisorctl restart qlproxy squid3
res=$?
if [ $res -ne 0 ]; then
    echo "cannot restart, error $res"
    exit 1
fi

# dump success
echo "restart successful!"
exit 0
