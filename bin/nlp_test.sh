#!/bin/bash

nlp="nc localhost 8313"
nlp="nc m2 8313"

. ~/bin/function.sh

function nlptest()
{
    local txt=$(echo "$1" | cut -d \| -f1)
    local dom=$(echo "$1" | cut -d \| -f2)
    local qry=$(echo "$1" | cut -d \| -f3)
    local t0=$(date +%s%3N)

    if [ "$1" = "$txt" ]; then
        dom=""
        qry=""
    fi
    echo -en "'$txt'\t'$dom'\t'$qry' -> "
    local t1=$(date +%s%3N)
    local costs=$(($t1 - $t0))
    local out=""
    if [ -n "$qry" ]; then
        out=$(echo '{"queryDomain":"'$dom'","querySent":"'$txt'", "querySession" : "[{\"domain\":\"$qry\",\"posStart\":2,\"posEnd\":9,\"confidence\":0.634921,\"action\":\"asksong\",\"slots\":{}}]"}' | $nlp | json_pp)
    else
        out=$(echo '{"queryDomain":"'$dom'","querySent":"'$txt'"}' | $nlp | json_pp)
    fi
    echo -e "$costs\n$out"
}

if [ $# -eq 1 ]; then
    if [ -f "$1" ]; then
        file="$1"
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

