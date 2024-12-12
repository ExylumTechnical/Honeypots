#!/bin/bash
# Will not trigger until someone fully connects to the service that is running

BADIPS=""
LOGFILE="/var/log/honeyportlogs.txt"
PORT=8000
while ( $true ); do
	IP=$( nc -tvl -p $PORT 2>&1 1> /dev/null | grep "connect" | cut -d " " -f 6 | cut -d "[" -f 2 | cut -d "]" -f 1 )
	iptables -A INPUT -p tcp -s $IP -j DROP
	echo $IP was blocked and logged
# Log all the things, because the more places it is the less likely it is to be missed
	# Dump the ip address to a local log file
	echo "$( date ) - $IP" > $LOGFILE
	# Add a log rule to IP tables
	iptables -A INPUT -p tcp -s $IP -j LOG
	# And finally log it to the system Log
	logger "HoneyPort Activity: $( date ) - $IP"
done;
