#!/bin/bash
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 1:65535 -j REDIRECT --to-ports 8000
gcc bonk.c -o bonk
nc -tlv -n -e ./bonk -p 8000
