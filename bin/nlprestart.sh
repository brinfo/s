#!/bin/bash

nlphome="/home/admin/NLPServer"

cd $nlphome
sudo kill $(ps axf | grep java | grep libzl | grep '^[ 0-9]*' -o)
sudo -u admin nohup ./zl.sh &
sleep 2
sudo -u admin tail -n 50 nohup.out

