#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset




# Regex to extract the networks

if [[ -f "tmp/emerging-drop.suricata.rules" ]]
then

    # Prompt if we need to redownload the file
    echo "The rules file already exists."
    echo -n "Do you want to redownload it? (y/N) "
    read to_redownload

    if [[ "to_redownload" == "y" || "to_redownload" == "Y" ]]
    then
        wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O tmp/emerging-drop.suricata.rules
    fi
else
    mkdir tmp
    wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O tmp/emerging-drop.suricata.rules
fi


egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt


# Create a firewall ruleset
for eachIP in $(cat badIPs.txt)
do

#     echo  "block in from ${eachIP} to any" | tee -a pf.conf # for mac

    echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables

done
