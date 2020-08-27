#!/usr/bin/env bash

if [ $# -lt 2 ] || [ $# -gt 3 ]
then
    echo -e "Usage: portscan <ip/range> <interface> [filename]"
    exit 1
fi

# Colors
RST="\e[0m"
RED="\e[31m"
GRN="\e[32m"
YLW="\e[33m"
BLU="\e[34m"

ip=$1
iface=$2

echo -e "$BLU[+] Running masscan on all TCP and UDP ports on interface $YLW$iface$RST"
echo -e "$BLU[+] Target: $ip$RST"

sudo masscan -p1-65535,U:1-65535 --rate=1000 --adapter $iface $ip | tee all-ports.txt

tcp=$(cat all-ports.txt | grep -iF 'tcp' | cut -d' ' -f4 | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
udp=$(cat all-ports.txt | grep -iF 'udp' | cut -d' ' -f4 | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')

echo ""

if [ -z $tcp ]
then
    echo -e "$RED[!] No TCP ports found$RST"
else
    echo -e "$GRN[*] Found the following TCP ports: $tcp$RST"
fi

if [ -z $udp ]
then
    echo -e "$RED[!] No UDP ports found$RST"
else
    echo -e "$GRN[*] Found the following UDP ports: $udp$RST"
fi

if [ -z $tcp ] && [ -z $udp ] 
then
    echo -e "$RED[!] No ports to scan. Bye!$RST"
    exit 1
fi

# Create directory to store the nmap results
mkdir nmap

# Set the filename. Default is "nmap"
if [ $# -eq 2 ]
then
    filename="nmap"
else
    filename=$3
fi

if [ ! -z $tcp ]
then
    echo -e "$BLU[+] Scanning found TCP ports with NMAP$RST"
    sudo nmap -Pn -sV -sC -p$tcp $ip -oA nmap/$filename-tcp
fi

if [ ! -z $udp ]
then
    echo -e "$BLU[+] Scanning found UDP ports with NMAP$RST"
    sudo nmap -Pn -sV -sC -sU -p$udp $ip -oA nmap/$filename-udp
fi
