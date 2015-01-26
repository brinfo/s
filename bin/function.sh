#!/bin/bash

function toeng()
{
    local file=${1:-}

    sed -e 'y/ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ/abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ/' -e 'y/－“—，。＇＂‘’”；＃【】｛｝《》（）、？！＠━…/-"-,.'"'"'"'"'""'"'"\;\#[]{}  (),?!@-./' $file
}
