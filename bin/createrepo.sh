#!/bin/bash

ROOT=/home/admin/yum-rokid/Package/
BAK=/home/admin/bin/last.out

CUR=$(ls -1rt $ROOT)

echo "$(date) begin"
echo "$CUR" | diff $BAK - >&/dev/null
ret=$?

if [ $ret -eq 0 ]; then
    echo "DO NOTHING."
else
    echo "$CUR" >$BAK
    echo "DO IT......"

    createrepo yum-rokid
fi
echo "$(date) end"
