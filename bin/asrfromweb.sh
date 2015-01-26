#!/bin/bash

MYSQL="mysql -uroot -proot -hm1 speechcms"
OUTFILE="/home/admin/ASR/Rokid/prelm/asr.txt.web"
TMP=$$.tmp

echo "select count,name from asr_dialog order by date_created desc;" | $MYSQL | sed 1d |
	while read n txt; do
		for ((i = 0; i < n; ++ i)); do
			echo $i $txt
		done
	done >$TMP
diff $TMP $OUTFILE >/dev/null
ret=$?
if [ $ret -ne 0 ]; then
	mv $TMP $OUTFILE
fi

exit $ret

