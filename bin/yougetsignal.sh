#!/bin/bash

# By PowerSea 
# 2015/06/07
# 


# useful variables
proxy="192.168.6.196:8080"
yougetsignal="http://domains.yougetsignal.com/domains.php"
# ip search limit, fk

if [ $# -le 0 ];then
	echo "usage: $0 www.baidu.com"
	echo "       $0 1.2.3.4"
	exit 0
fi

# fetch domains from www.yougetsignal.com
# result is json format
rjson=$( curl -s -x $proxy $yougetsignal -F "remoteAddress=$1" )
#rjson=$(cat 1.json)

# fetch status
rstatus=$(echo $rjson | jq .status | sed 's/"//g')
if [ "$rstatus" != "Success" ]; then
	echo "failed to fetch domains"	
	exit 1
fi

# fetch domain count
declare -i rcount
rcount=$(echo $rjson | jq .domainCount | sed 's/"//g')
if [ $rcount -le 0 ]; then
	echo "0 domains"	
	exit 2
fi

# fetch domain list
declare -a rdomains 
rdomains=($(echo $rjson | jq '. | .domainArray[][0]' | sed 's/"//g'))

# fetch ip
rip=$(echo $rjson | jq .remoteIpAddress | sed 's/"//g')

# duplicate removal AND output
echo 
s=0
for ((i=0; i<$rcount; i=i+1)) 
do
	tip=$(host ${rdomains[$i]} | grep "$rip" )
	if [ "$tip" != "" ];then
		echo ${rdomains[$i]}
		s=$(($s+1))
	fi
done

echo 
echo "$1 >> $rip,    $s domains."

