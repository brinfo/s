#!/bin/bash -x

. ~/bin/function.sh

function ttstest()
{
    local str=$1
    local file=$2

    echo "ssh et.c@build-1 dsftest tts '$str' opu 2>/dev/null >$file.opu"
    ssh et.c@build-1 dsftest tts "$str" opu 2>/dev/null >$file.opu
    #echo dsftest tts "$1" | sed 's:":\\\":g; s:{:\\\{:g; s:}:\\\}:g;' | ssh et.c@build-1  2>/dev/null >$file.opu
    if [ -f $file.opu ]; then
        opu2pcm $file.opu $file.wav
        if [ -f $file.wav ]; then
            exit 0
        fi
    fi
}

if [ $# -ne 2 ]; then
    echo "Usage: $(basename $0) text     outfile"
    echo "       $(basename $0) textfile outfile"
    exit 1
else
    file=$2
    if [ -f "$1" ]; then
        file="$1"
        str=$(cat $file)
        ttstest "$str" $file
    else
        ttstest "$1" $file
    fi
fi

exit 1

