#!/bin/bash

#
# 统计匹配pattern行的占比
# 除#开头行
#

if [ $# -ne 2 ]; then
	echo "Usage: $0 pattern file"
	exit
fi
pattern=$1
file=$2

all=$(cat $file | grep -v '^#' | wc -l)
hit=$(grep "$pattern" $file | grep -v '^#' | wc -l)
pre=$(echo "scale=2; $hit * 100 / $all" | bc)

echo -e "all\thit\tpre"
echo "------------------------------"
echo -e "$all\t$hit\t$pre%"

