#!/bin/bash

# Storyline: Create peer VPN configuration file


# What is peer's name
echo -n "What is the peer's name? "
read clientname

# Filename variable
peerfile="${clientname}-wg0.conf"

# Check if the peer file exists
if [[ -f "${peerfile}" ]]
then

    # Prompt if we need to overwrite the file
    echo "The file ${peerfile} exists."
    echo -n "Do you want to overwrite it? (y/N) "
    read to_overwrite

    if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == ""  || "${to_overwrite}" == "n"  ]] # TODO - this sucks
    then
        echo "Exit..."
        exit 0
    elif [[ "${to_overwrite}" == "y" || "${to_overwrite}" == "Y" ]]
    then
        echo "Creating the wireguard configuration file..."
    else
        echo "Invalid value"
        exit 1
    fi
fi

# Create a private key
privatekey="$(wg genkey)"

# Create a public key
clientpublickey="$(echo ${privatekey} | wg pubkey)"

# Generate a preshared key
preshared="$(wg genpsk)"

# 10.254.132.0/24,172.16.28.0/24 198.199.97.163:4282 publickey  8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0

# Endpoint
endpoint="$(head -1 wg0.conf | awk ' { print $3 } ')"

# Server Public Key
serverpublickey="$(head -1 wg0.conf | awk ' { print $4 } ')"

# DNS servers
dns="$(head -1 wg0.conf | awk ' { print $5 } ')"

# MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"

# KeepAlive
keepalive="$(head -1 wg0.conf | awk ' { print $7 } ')"

# ListenPort
listenport="$(shuf -n1 -i 40000-50000)"

# Default routes for VPN
routes="$(head -1 wg0.conf | awk ' { print $8 } ')"

# Create the client configuration file

echo "[Interface]
Address = 10.254.132.100/24
DNS = ${dns}
ListenPort = ${listenport}
MTU = ${mtu}
PrivateKey = ${privatekey}

[Peer]
AllowedIPs = ${routes}
PersistentKeepalive = ${keepalive}
PresharedKey = ${preshared}
PublicKey = ${clientpublickey}
Endpoint = ${endpoint}
" > "${peerfile}"

# Add our peer configuration to the server config
echo "

# ${clientname} begin
[Peer]
PublicKey = ${clientpublickey}
PresharedKey = ${preshared}
AllowedIPs = 10.254.132.100/32
# ${clientname} end
" | tee -a wg0.conf
