#!/bin/bash

LOG=/home/admin/logs/debug.log 

if [ $# -ge 1 ]; then
    LOG=$LOG.$1
fi
echo $LOG

ssh admin@test-8 ls $LOG >&/dev/null
if [ $? -ne 0 ]; then
    echo "$LOG not found."
    exit
fi

ssh admin@test-8 cat $LOG | head -n 100 | grep '' | sed 's:||::g' | cut -d -f2,4- |
    (
     IFS=
     while read time asr request nlp cost; do
        echo "$time === $asr === $request === $nlp === $cost"
        echo "set names utf8; insert into speechcms.nlp_log(date_created, last_updated, name, request, result0, cost) values('$time', now(), '$asr', '$request', '$nlp', '$cost');" | mysql -uroot -proot -h speech-mysql.db.rokid.com
    done
    )

