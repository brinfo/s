#!/bin/bash

# 1.  run  : ./bin/asrlog.sh
# 2.  mount: sshfs -o allow_other m2:/home/admin/SRServer/SRServerCn/ asr_root
##3.  check: sudo -u www-data ls asr_root
# 4. umount: fusermount -u asr_root /or/ sudo umount asr_root

DIR="$HOME/data/asr_root/"
LOGS="logs/SRServer.log"
export PATH=/usr/local/bin:~/bin:$PATH

cd $DIR

if [ $# -ge 1 ]; then
    echo $1
fi
logs=
if [ -f "$LOGS.$1" ]; then
    logs="$LOGS.$1"
else
if [ -f "$LOGS$1" ]; then
    logs="$LOGS$1"
fi
fi
echo "$logs"
if [ ! -f "$logs" ]; then
    echo "NO file('$logs') found!"
    exit
fi
sed -n '1,$p' $logs | grep asrResult | cut -c7-30,50- | sed 's:	::; s:,[0-9][0-9][0-9] ::' |
    (
     IFS=
     while read time id txt; do
        echo "'$time' xxx '$id' xxx '$txt'"
        file=$(ls -1 $id* | sort | head -n 1)
        base=$(echo $file | sed 's:.[^.]*$::')
        ext=$(echo "$file" | grep '.[^.]*$' -o)
        echo "'$file' -> '$base' '$ext' '$base.wav'"
        if [ "$ext" = ".opu" ]; then
            if [ ! -f "$base.wav" ]; then
                echo opu2pcm $file $base.wav
                opu2pcm $file $base.wav
            fi
        fi
        if [ -f "$base.wav" ]; then
            echo "set names utf8; insert into speechcms.asr_log(date_created, last_updated, name, result0) values('$time', now(), '$base.wav', '$txt');" | mysql -uroot -proot -hspeech-mysql.db.rokid.com
            echo "set names utf8; insert into speechcms.asr_log(date_created, last_updated, name, result0) values('$time', now(), '$base.wav', '$txt');" #| mysql -uroot -proot -hspeech-mysql.db.rokid.com
        else
            echo "No $base.wav found"
        fi
    done
    )

