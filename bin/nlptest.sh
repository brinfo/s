#!/bin/bash

nlp="nc 192.168.1.68 8313"
nlp="nc localhost 8313"

function nlptest()
{
    local txt=$(echo "$1" | cut -d \| -f1)
    local dom=$(echo "$1" | cut -d \| -f2)
    local t0=$(date +%s)

    if [ "$1" = "$txt" ]; then
        dom=""
    fi
    echo -n '"'$txt'" "'$dom'" -> '
    local t1=$(date +%s)
    local cost=$(($t1 - $t0))
    local out=$(echo '{"queryDomain":"'$dom'","querySent":"'$txt'"}' | $nlp)
    echo "$out, cost ${cost}s"
}

if [ $# -eq 1 ]; then
    if [ -f $1 ]; then
        file=$1
        while read line; do
            if [ -n "$line" ]; then
                nlptest "$line"
            fi
        done <$file
    else
        nlptest "$1"
    fi
else
    for line in "$@"; do
        nlptest "$line"
    done
fi

