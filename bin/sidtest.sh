#!/bin/bash

# 测试发送字符串格式
# 1|0|user1;user2;user3|opu|123
# 第一个字段“1”表示训练，
# 第二个字段“0”保留字段，未使用
# 第三个字段“user1;user2;user3”目标声纹范围
# 第四个字段“opu”表示语音编码
# 第五个字段“123”
# 
# 测试返回字符串格式
# 测试成功：0|user1 得分;|其他信息
# 测试失败：1|出错信息
# 
# 每次测试，都会有得分，得分的门限预先设定

function opu2sid()
{
    local users=$1
    local n=$2
    local file=$3

    if [ $# -lt 3 ]; then
        echo "usage: $0 users num file"
        return
    fi

    ext=$(echo $file | grep -o '[^.]*$')
    if [ $ext != "opu" ]; then
        echo "no $ext file."
        return
    fi

    echo "test ${n}th file in $users: $file"
    (
    # head part
    head="1|0|$users|$ext|123"
    size=$(echo -n "$head" | wc -c)
    hex=$(printf '%08x\n' $size | sed 's:[a-f0-9][a-f0-9]:\\x&:g;')
    echo -ne "$hex$head"

    # opu part
    size=$(du -b $file | cut -d$'\t' -f1)
    hex=$(printf '%08x\n' $size | sed 's:[a-f0-9][a-f0-9]:\\x&:g;')
    echo -ne "$hex"
    cat $file

    # tail part
    echo -ne '\x00\x00\x00\x00';

    sleep 0.5;
    ) | nc m2 64101
}

if [ $# -le 1 ]; then
    echo "Usage: $0 users opu..."
    exit
fi
users=$1
shift
n=0
for file in $*; do
    opu2sid $users $n $file
    n=$((n + 1))
done

