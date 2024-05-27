#!/bin/bash

# Check if user is not root
if [ "$(id -u)" -eq "0" ]; then
    echo "This script must not be run as root" 1>&2
    exit 1
fi

# install pyfluidsynth
pip install pyfluidsynth

# install keyboard listener
pip install pynput

# initialize opam
opam init

# install pyml
opam install pyml

# install ocamlfind
opam install ocamlfind

# load opam env in current terminal
eval $(opam env --switch=default)

# initialize opam environment every time terminal opens
echo "eval \$(opam env --switch=default)" >> ~/.bashrc

# generate the interpreter & clean repository
make
make clean

# done!
echo "PressKey successfully (hopefully) installed!"

