#!/bin/bash

opensipsctl=/usr/sbin/opensipsctl

if [ $# -ne 1 ]; then
   echo "Usage: $0 dir"
   exit
fi
dir=$1

echo "\$dir = $dir"

echo "drop database opensips;" | mysql -uroot -proot

$opensipsctl add a  a
$opensipsctl add b  b
$opensipsctl add et et
$opensipsctl add jn01 jn
$opensipsctl add et01 et
