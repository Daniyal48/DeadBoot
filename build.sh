#!/bin/bash

export PREFIX="$HOME/opt/cross"
export TARGET32=i686-elf
#export TARGET64=x86_64-elf
export PATH="$PREFIX/bin:$PATH"

make clean
make all
