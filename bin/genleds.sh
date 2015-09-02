#!/bin/bash

echo -ne "LED"
echo -ne "\x01"
echo -ne "\xff\x0f\x00\x00"
echo -ne "\x3c"
echo -ne "\x00\x01\x00\x00"
for ((i = 0; i < 256; ++ i)); do
    ./genled.sh $i $i $i 12
done

