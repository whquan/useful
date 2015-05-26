#!/bin/bash

# get current ip
# one Network Adapter

lineNumber=$(/etc/init.d/network status | grep -n 'Currently active devices:' | cut -d ':' -f 1 )

#echo -e "LAN:\c"
/etc/init.d/network status | sed -n "$(($lineNumber+1)) p" | cut -d ' ' -f 2 | xargs ifconfig | \
grep 'inet addr:' | sed 's/^.*addr://g' | cut -d ' ' -f 1
