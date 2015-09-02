#!/bin/bash

. ~/bin/function.sh

function nlptest()
{
    local txt=$(echo "$1" | cut -d \| -f1)
    local dom=$(echo "$1" | cut -d \| -f2)
    local qry=$(echo "$1" | cut -d \| -f3)
    local t0=$(date +%s%3N)

    echo dsftest nlp "$1" | sed 's:":\\\":g; s:{:\\\{:g; s:}:\\\}:g;' | ssh et.c@build-1  2>/dev/null
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

