#!/bin/bash

mysql="mysql -uroot -proot -hm1 speechcms"
wavdir='/home/admin/asr_recorder/'

users="yj jn yt wj zl"
usern=$(echo $users | tr ' ' $'\n' | wc -l)
userstr=$(echo $users | sed 's: :;:g; s:$:;:')
tmp=.tmp

echo 'select u.name, group_concat(s.name) from sid s, sid_user u where s.user_id = u.id group by u.id having count(*) >= 3 order by s.date_created desc;' | $mysql | sed 1d |
while read user wavs; do 
    echo "($user) -> ($wavs)"
    wavs=$(echo "$wavs" | cut -d, -f1-3 --output-delimiter=' ')
    echo "($user) -> ($wavs)"
    for wav in $wavs; do
        name=$(basename $wav .wav)
        dd if=$wavdir/$wav of=$name.pcm  skip=44 bs=1
        opu2pcm $name.pcm $name.opu
    done
    opus=$(echo "$wavs" | sed 's:wav:opu:g')
    echo "($user) -> ($opus)"
    sidtrain.sh $user $opus
done

exit

if true; then
#if false; then
for wav in *wav; do
    name=$(basename $wav .wav)
    dd if=$wav of=$name.pcm  skip=44 bs=1
    opu2pcm $name.pcm $name.opu
done

for user in $users; do
    sidtrain.sh $user ${user}1.opu ${user}2.opu ${user}3.opu | sed -n '{p;n;n;n;p;}' | sed 'N;s:\n: => :g'
done
fi

if [ -f $tmp ]; then
    rm $tmp
fi
for opu in *opu; do
    sidtest.sh $userstr $opu | sed -n '{p;n;n;n;p;}' | cut -c5- | sed 'N;s:\n: => :g' | tee -a $tmp
done

pos=$((16 + usern * 3))
#echo  "$pos $((pos + 1)) $((pos + 13)) $((pos + 15))"
total=0
hit=0
cat $tmp | cut -c$pos-$((pos + 1)),$((pos + 13))-$((pos + 15)) --output-delimiter=' ' |
(
    while read a b; do
        total=$((total + 1))
        if [ $a = $b ]; then
            hit=$((hit + 1))
        fi
    done
    per=$(echo "scale=2; $hit / $total * 100" | bc)
    echo "RESULT: HIT / TOTAL = $hit / $total = $per%"
)

