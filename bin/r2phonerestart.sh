#!/bin/bash

r2phone="/home/et.c/work/dsfcpp/R2PhoneService/server"
rtpproxy="/home/et.c/work/rtpproxy/rtpproxy"

pid=$(pidof rtpproxy server)
echo "kill ($pid)"
if [ -n "$pid" ]; then
    kill $pid
fi

cd ~/bin/
nohup $r2phone 192.168.1.93 22222 tcp >r2phone.out 2>&1 &
nohup $rtpproxy -s udp:192.168.1.93:11111 -p rtpproxy.pid -d INFO -T 30 >rtpproxy.out 2>&1 &

tail -n 20 r2phone.out rtpproxy.out

