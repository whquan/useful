#!/bin/bash

port=6080

if [ $# -ne 0 ]; then
	port=$1
fi
echo $(lanip):$port
python -m SimpleHTTPServer $port 2>/dev/null
