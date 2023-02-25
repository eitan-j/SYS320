#!/bin/bash

# This script creates an IPTables ruleset and a Windows firewall rule powershell script based on an Apache log file


# Apache log example
# 81.19.44.12 - - [30/Sep/2018:06:26:56 -0500] "GET / HTTP/1.1" 200 225 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0"

# Arguments using the position, they start at $1
APACHE_LOG="$1"

# Check if file exists
if [[ ! -f ${APACHE_LOG} ]]
 then
    echo "Please specify the path to a log file."
    exit 1
fi

# Looking for web scanners.

for badIP in $( \
grep -Ei 'test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t' "${APACHE_LOG}" | awk '{print $1}' | sort -u )
do
    echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${badIP}\" dir=in action=block remoteip=${badIP}" >> blocklist.ps1
    echo "iptables -A INPUT -s ${badIP} -j DROP" >> blocklist.iptables
done


# sed -e 's/\[//g' -e 's/"//g' "${APACHE_LOG}" | \
# grep -Ei 'test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t' | \
# awk ' BEGIN { format = "%-15s %-20s %-6s %-6s %-5s %s\n"
#     printf format, "IP", "Date", "Method", "Status", "Size", "URI"
#     printf format, "--", "----", "------", "------", "----", "---"}
#
#
# { printf format, $1, $4, $6, $9, $10, $7 }'

