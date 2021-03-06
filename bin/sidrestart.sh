#!/bin/bash

sidhome="/home/admin/SidServer/SpidTest2"
sidhome="/home/admin/SidServer/RunSid"

pid=$(pidof ZSidServer)
cd $sidhome
pwd
echo "kill ($pid)"
if [ -n "$pid" ]; then
    kill "$pid"
fi
sleep 1
pid=$(pidof ZSidServer)
echo "pid = ($pid)"
nohup ./run.sh >>nohup.out 2>&1 &

tail -n 20 nohup.out

