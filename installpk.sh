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




# Install libsfml-dev
apt install libsfml-dev -y

# Install librapidxml-dev
apt install librapidxml-dev -y

# Install clang++-16
if ! command -v clang++-16 &>/dev/null; then
    # If clang++-16 doesn't exist, proceed with installation
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    ./llvm.sh 16
    rm llvm.sh
else
    echo "clang++-16 is already installed."
fi

# Install make
apt install make -y

# Run make in current directory
make

# Execute the resulting binary
./Bomberman_Plat.x