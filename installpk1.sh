#!/bin/bash

# Check if user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update package lists
apt update

# install python3
apt install python3 -y

# install pip
apt install python3-pip -y

# install ocaml
apt install ocaml -y

# install opam
apt install opam -y

# install alsa
apt install alsa-base -y

# upgrade packages
apt upgrade