#!/bin/bash

asrhome="/home/admin/SRServer/SRServerCn/"

pid=$(pidof SRServer)
cd $asrhome
echo "kill ($pid)"
kill $pid
kill $pid
sleep 2
nohup ./startup.sh >>nohup.out 2>&1 &
tail nohup.out
