#!/bin/bash

# 训练发送字符串格式：
# 0|0|user1|opu|r2
# 第一个字段“0”表示训练，
# 第二个字段“0”表示第0句话，同时删除历史声纹信息。
# 如果约定训练一个人的声纹要三句话，即第二个字段为2时，开始训练模型。
# 第三个字段“user1”表示声纹ID，全局唯一
# 第四个字段“opu”表示语音编码
# 第五个字段“r2”表示语音内容
# 
# 训练成功返回字符串格式：0|其他信息
# 训练失败返回字符串格式：1|失败信息

function opu2sid()
{
    local user=$1
    local n=$2
    local file=$3

    if [ $# -lt 3 ]; then
        echo "usage: $0 user num file"
        return
    fi

    ext=$(echo $file | grep -o '[^.]*$')
    if [ $ext != "opu" ]; then
        echo "no $ext file."
        return
    fi

    echo "train $user's ${n}th file: $file"
    (
    # head part
    head="0|$n|$user|$ext|123"
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
    echo "Usage: $0 user opu..."
    exit
fi
user=$1
shift
n=1
for file in $*; do
    opu2sid $user $n $file
    n=$((n + 1))
done

