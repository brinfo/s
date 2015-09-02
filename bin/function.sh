#!/bin/bash

export PATH=$HOME/bin:/usr/local/bin:$PATH

MYSQL="mysql -uroot -proot -hm1 speechcms"

function toeng()
{
    local file=${1:-}

    sed -e 'y/ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ/abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ/' -e 'y/－“—，。＇＂‘’”；＃【】｛｝《》（）、？！＠━…/-"-,.'"'"'"'"'""'"'"\;\#[]{}  (),?!@-./' $file
}
