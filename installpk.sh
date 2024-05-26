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

# install pyfluidsynth
pip install pyfluidsynth

# install opam
apt install opam -y

# install pyml
opam install pyml

# load opam env in current terminal
eval $(opam env --switch=default)

# initialize opam environment every time terminal opens
echo "eval \$(opam env --switch=default)" >> ~/.bashrc

# generate the interpreter
make

# done!
echo "PressKey successfully (hopefully) installed!"

