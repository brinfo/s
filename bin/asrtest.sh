#!/bin/bash

# 16:40:56.643637 IP 127.0.0.1.33831 > 127.0.0.1.65101: Flags [P.], seq 1:58, ack 1, win 342, options [nop,nop,TS val 150381536 ecr 150381536], length 57
# 	0x0000:  4500 006d e4f6 4000 4006 5792 7f00 0001  E..m..@.@.W.....
# 	0x0010:  7f00 0001 8427 fe4d 3162 4715 2924 f8b6  .....'.M1bG.)$..
# 	0x0020:  8018 0156 fe61 0000 0101 080a 08f6 a3e0  ...V.a..........
# 	0x0030:  08f6 a3e0 0000 0035 7232 6465 6d6f 5f32  .......5r2demo_2
# 	0x0040:  3734 3931 3166 3839 3639 6634 6633 6662  74911f8969f4f3fb
# 	0x0050:  3839 3239 3837 3665 3638 3335 6266 337c  8929876e6835bf3|
# 	0x0060:  317c 6f70 757c 752f 7c30 7c30 00         1|opu|u/|0|0.
# 16:40:56.643650 IP 127.0.0.1.65101 > 127.0.0.1.33831: Flags [.], ack 58, win 342, options [nop,nop,TS val 150381536 ecr 150381536], length 0

# admin@svr1:~/srtest$ ll test*
# -rw-rw-r-- 1 admin admin  26859 Oct 30 16:03 test.opu
# -rw-rw-r-- 1 admin admin 171800 Oct 30 16:48 test.pcm
# -rwxrwxr-x 1 admin admin   1048 Oct 30 17:05 test.sh*

# admin@svr1:~/srtest$ printf "%x\n" 26859
# 68eb

# "01234567890|1|opu|u/|0|0\x00" 25 = 0x19
# du -b test.pcm | cut -d$'\t' -f1
# printf '%08x\n' 11123512 | sed 's:[a-f0-9][a-f0-9]:\\x&:g;'

sox=
if [ -f /usr/local/bin/sox ]; then
    sox=/usr/local/bin/sox
elif [ -f /usr/bin/sox ]; then
    sox=/usr/bin/sox
fi
if [ -z "$sox" ]; then
    return
fi

function pcm2asr()
{
    local tmp=$$.tmp
    local bs=10240
    local file=$1
    local var=$2
    local ret=

    if [ $# -le 1 ]; then
        echo "usage: $0 file"
        return
    fi

    ext=$(echo $file | grep -o '[^.]*$')
    if [ "$ext" = "opu" ]; then
        opu2pcm $file $tmp
        file=$tmp
        ext=pcm
    fi
    if [ $ext = "wav" ]; then
        ext=pcm
        $sox $file -r 16000 $$.wav
        file=$$.wav
    fi
    printf "$file: $ext\n" 1>&2
    ret=$( (
    echo -ne '\x00\x00\x00\x1901234567890|1|'$ext'|u/|0|0\x00'

    size=$(du -b $file | cut -d$'\t' -f1)
    hex=$(printf '%08x\n' $bs | sed 's:[a-f0-9][a-f0-9]:\\x&:g;')
    skip=0
    for ((ii = 0; ii < size / bs; ++ ii)); do
        skip=$((ii * bs))
        echo -ne "$hex"
        dd if=$file skip=$skip bs=1 count=$bs 2>/dev/null
        printf "send to asr:% 2dth % 6d % 6d ...\n" ${ii} $skip $bs 1>&2
        sleep 1
    done
    if [ $skip -eq 0 ]; then
        last=$size
    else
        skip=$((skip + bs))
        #echo "$skip $size"
        if [ $skip -lt $size ]; then
            last=$((size - skip))
        fi
    fi
    hex=$(printf '%08x\n' $last | sed 's:[a-f0-9][a-f0-9]:\\x&:g;')
    echo -ne "$hex"
    dd if=$file skip=$skip bs=1 count=$last 2>/dev/null

    echo -ne '\x00\x00\x00\x00';
    sleep 2;
    ) | nc m2 65101 | cut -d\| -f1 | cut -c5-)

    if [ -e $tmp ]; then
        rm $tmp
    fi
    if [ -e $$.wav ]; then
        rm $$.wav
    fi

    # 设返回值
    if [[ "$var" ]]; then
        eval $var="'$ret'"
    else
        echo "$ret"
    fi
}

for file in $*; do
    pcm2asr $file asret
    echo -e "$file\t$asret"
done

