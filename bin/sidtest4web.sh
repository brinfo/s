#!/bin/bash

mysql="mysql -uroot -proot -hm1 speechcms"
wavdir="$HOME/asr_recorder/"
wavdir="."

export PATH=$HOME/bin:/usr/local/bin/:$PATH

users=""

echo 'select u.name from sid s, sid_user u where s.user_id = u.id group by u.id having count(*) >= 3 order by s.date_created desc;' | $mysql | sed 1d |
(
while read user wavs; do 
    if [ -z "$users" ]; then
        users="$user"
    else
        users="$users $user"
    fi
done
userstr=$(echo $users | sed 's: :;:g; s:$:;:')

for wav in $*; do
    name=$(basename $wav .wav)
    dd if=$wavdir/$wav of=$name.pcm  skip=44 bs=1
    opu2pcm $name.pcm $name.opu >/dev/null 2>&1
    if [ -f "$name.opu" ]; then
	echo "$wav"
        sidtest.sh "$userstr" "$name.opu" | tail -1
    else
	echo "no $name.opu found!"
    fi
done
)

