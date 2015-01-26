#!/bin/bash

declare -a a=('Debian' 'Red hat00' 'Red hat01' 'Suse')

echo $a
echo ${#a[@]}
echo ${#a}
echo ${a[@]}
echo ${a[2]}
echo ${#a[2]}
echo ${a[@]:1:3}
echo ${!a[@]}
echo ${!a[*]}
echo ${a[@],,R}
unset a[2]
echo ${!a[@]}
echo ${!a[*]}

