#!/bin/bash

nlphome="/home/admin/NLPServer"

pid=$(ps axf | grep java | grep libzl | grep '^[ 0-9]*' -o)
cd $nlphome
echo "kill ($pid)"
if [ -n "$pid" ]; then
    kill $(ps axf | grep java | grep libzl | grep '^[ 0-9]*' -o)
fi
nohup ./zl.sh >>nohup.out 2>&1 &
sleep 3
tail -n 20 nohup.out

