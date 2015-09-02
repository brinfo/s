#!/bin/bash

#
# parse nlp collect logs to db
# Tue Sep  1 20:34:01 CST 2015
#
MYSQL="mysql -uroot -proot -h ws9 speechcms"
MARK=/home/admin/bin/mark
LOGS=/home/admin/logs/collect.log

echo "$(date) start..."

lastd=
lastn=0
mark=$(cat $MARK 2>/dev/null)
if [ -n "$mark" ]; then
    lastd=$(echo "$mark" | cut -d -f1)
    lastn=$(echo "$mark" | cut -d -f2)
fi
today=$(date +"%Y%m%d")
filen=$(wc -l $LOGS | cut -d' ' -f1)

echo "$today$filen" >$MARK

logs=
if [ "$today" != "$lastd" ]; then
    lastn=0
    logs=$(cat $LOGS)
elif [ "$lastn" -lt "$filen" ]; then
    logs=$(sed -n $lastn',$p' $LOGS)
fi

echo "$logs" | grep  | sed 's:::g' | cut -d -f4,6 --output-delimiter= | sort | uniq -c | sort -r |
    while read count b; do
        echo "$count -> $b"
        asr=$(echo "$b" | cut -d -f1)
        context=$(echo "$b" | cut -d -f2)
        echo "$count -> $b -> $asr -> $context"
        #continue
        n=$(echo "set names utf8; select n from nlp_collect where name='$asr' and context='$context';" | $MYSQL | tail -1)
        echo "= $n"
        if [ -z "$n" ]; then
            echo "set names utf8;insert into nlp_collect(n, name, context, date_created, last_updated) value('$count', '$asr', '$context', now(), now());" | $MYSQL
        else
            n=$((n + count))
            echo "set names utf8; update nlp_collect set n='$n' where name='$asr' and context='$context';" | $MYSQL
        fi
    done

echo "$(date) end  ..."
