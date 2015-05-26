#!/bin/bash

# get wan ip
# from ip138, true rate 99%
# 1111.ip138.com/ic.asp

if [ $# -eq 1 ]; then
	if [ $1 = "ip" ]; then
		curl -s 1111.ip138.com/ic.asp | iconv -c -f GB2312 -t UTF-8 | grep '\[.*\]' | sed 's/^.*\[//g' | sed 's/\].*$//g'
	else
		echo "Usage: wanip		//default, show detailed ip info, including location" 
		echo "       wanip -h	//print this usage" 
		echo "       wanip ip	//Only show wlan ip"
	fi
else
	curl -s 1111.ip138.com/ic.asp | iconv -f GB2312 -t UTF-8 | grep '\[.*\]' | sed 's/^.*<center>//g' | sed 's/<.center>.*$//g' 
fi
