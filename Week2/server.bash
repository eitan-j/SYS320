#!/bin/bash

# Storyline: Script to create a wireguard server

# Create a private key
privatekey="$(wg genkey)"

# Create a public key
publickey="$(echo ${privatekey} | wg pubkey)"

# Set the addresses
address="10.254.132.0/24,172.16.28.0/24"

# Set the listen port
listenport="4282"

# Create the format for the client configuration options
peerinfo="# ${address} 198.199.97.163:4282 ${publickey}  8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"


echo "${peerinfo}
[Interface]
Address = ${address}
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${listenport}
PrivateKey = ${privatekey}
" > wg0.conf
