#!/bin/bash

if [ $# -ne 4 ]; then
    echo "Usage: $0 r g b n"
    exit
fi
R=$1
G=$2
B=$3
NUM=$4

RGB=$(printf '\%04o\%04o\%04o' $R $G $B)
for ((i = 0; i < NUM; ++ i)); do
    echo -ne "${RGB}"
done

