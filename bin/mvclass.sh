#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 oldclass newclass file"
    exit
fi
oldclass=$1
newclass=$2
file=$3

oldclass0=$(echo $oldclass | tr a-z A-Z)
newclass0=$(echo $newclass | tr a-z A-Z)
extfile=$(echo $file | grep -o '[^.]*$')

echo "sed -e 's:$oldclass:$newclass:g' -e 's:$oldclass0:$newclass0:g' $file | diff $file -"

sed -e "s:$oldclass:$newclass:g" -e "s:$oldclass0:$newclass0:g" $file | tee $newclass.$extfile | diff $file -

