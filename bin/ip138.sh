#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage:"
	echo "      $0 www.example.com"	
	echo "      $0 www.example.com ip"	
	exit 1
fi
dom=$1
res=a
if [ $# -eq 2 ] && [ $2 = "ip" ]; then
	curl -s http://www.ip138.com/ips138.asp\?ip\=$dom | grep "$dom" | sed 's/^.*>> //g' | sed 's/<.*$//g'
else
	curl -s http://www.ip138.com/ips138.asp\?ip\=$dom | iconv -f GB2312 -t UTF-8 | grep -A 3 "$dom" | grep '<td' | sed "s/.*$dom/$dom/g" | sed 's/<.font>.*$//g' | sed 's/^.*本/本/g' | sed 's/<\/li><li>/\n/g' | sed 's/<.*>//g'
fi
exit 0
