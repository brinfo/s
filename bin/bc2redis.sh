#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 in bc.xml bc.redis"
    exit
fi
in=$1
xml=$2
redis=$3
delm='|'

>$xml
echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<package name="app.basicconversation" final="true" T="1">' >>$xml

>$redis
echo "[" >>$redis
cat $in | sed '/^$/d' | (
    n=0
    intent0=
    while read line; do
        m=$((n % 3))
        if [ 0 -eq $m ]; then
            intent=$(echo "$line" | cut -d\| -f1)
            slot=$(echo "$line" | cut -d\| -f2)
            echo "1 \$intent=($intent),\$slot = ($slot)"
            if [ "$intent0" != "$intent" ]; then
                if [ -n "$intent0" ]; then
                    echo "</patternlist>" >>$xml
                    echo "" >>$xml
                fi
                echo '<patternlist intent="'$intent'">' >>$xml
            fi
            intent0=$intent
        elif [ 1 -eq $m ]; then
                echo "$line" | sed 's:'$delm':</value>\n\t</pattern>\n\t<pattern>\n\t\t<output name="value">'$slot'</output>\n\t\t<value>:g; s:^:\t<pattern>\n\t\t<output name="value">'$slot'</output>\n\t\t<value>:; s:$:</value>\n\t</pattern>\n:' >>$xml
        elif [ 2 -eq $m ]; then

            echo -en "{\"key\":\"basicconversation:$intent:$slot\", \"value\":" >>$redis
            echo -n "$line" | sed 's:'$delm':", ":g; s:^:[":; s:$:"]:' >>$redis
            echo "}," >>$redis
        fi
        n=$((n + 1))
    done
    )
echo "</patternlist>" >>$xml
echo "</package>" >>$xml

sed -i '$s:,$::' $redis
echo "]" >>$redis

