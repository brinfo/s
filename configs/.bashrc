#!/bin/bash -x

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PS1='\u@\h:\w\$ '
export GRAILS_HOME=~/tools/ggts-bundle/grails-2.4.3/
export PATH=$PATH:~/bin:$GRAILS_HOME/bin

alias m0='ssh m0'
alias m1='ssh m1'
alias m2='ssh m2'
alias ls='ls --color'
alias  l='ls -l'
alias ll='ls -la'
alias grep='grep --color'
alias cdw='cd ~/work/dsfcpp/src'

#for tair
export TBLIB_ROOT=~/work/TBLIB/
export LD_LIBRARY_PATH=~/work/evproto/evproto/:~/tair_bin/lib:$TBLIB_ROOT/lib:/usr/local/lib
#for dsfcpp
export LD_LIBRARY_PATH=~/work/dsfcpp/src/:$LD_LIBRARY_PATH

#for java
export JAVA_HOME=`/usr/libexec/java_home`

ulimit -c unlimited
ulimit -n 4096

set -o vi

function doGrep()
{
        local cmd=${1:-}
        local opt=${2:-}
        local arg=${3}
        local dir=${4:-.}

        if [ $# -le 2 ]; then
                echo "usage: $cmd pattern [dir]"
                return
        fi
        shift 3
        if [ $# -gt 1 ]; then
                dir=$*
        fi
#       echo "\$# = $#: \$cmd='$cmd' \$opt='$opt', \$arg='$arg', \$dir='$dir'"
#       echo "\$# = $#: grep '$opt' '$arg' '$dir'"
#       echo "--------------------------------------------------"
        grep "$opt" "$arg" $dir
}

alias   G="doGrep G   -Rn    $*"
alias  Gi="doGrep Gi  -Rni   $*"
alias  Gw="doGrep Gw  -Rnw   $*"
alias Giw="doGrep Giw -Rniw  $*"
alias Gwi="doGrep Gwi -Rniw  $*"

alias   L="doGrep L   -Rnl   $*"
alias  Li="doGrep Li  -Rnli  $*"
alias  Lw="doGrep Lw  -Rnlw  $*"
alias Liw="doGrep Liw -Rnliw $*"
alias Lwi="doGrep Lwi -Rnlwi $*"

function doFind()
{
        local cmd=${1:-}
        local opt=${2:-}
        local arg=${3}
        local dir=${4:-.}

        if [ $# -lt 2 ]; then
                echo "usage: $cmd pattern [dir]"
                return
        fi
        shift 2
        if [ "$#" -gt 1 ]; then
                dir=$*
        fi
#       echo "\$# = $#: \$cmd='$cmd' \$opt='$opt', \$arg='$arg', \$dir='$dir'"
#       echo "\$# = $#: find '$dir' | grep '$opt' '$arg'"
#       echo "--------------------------------------------------"
        find $dir | grep "$opt" $arg
}
alias   F="doFind F       $*"
alias  Fi="doFind Fi  -i  $*"
alias  Fw="doFind Fw  -w  $*"
alias Fiw="doFind Fiw -iw $*"
alias Fwi="doFind Fwi -wi $*"

#
# for c/c++
#
function cl()
{
        local dir=${1:-.}
        find $dir -name '*.c'   \
                -o -name '*.cpp'        \
                -o -name '*.cxx'        \
                -o -name '*.cc'        \
                -o -name '*.h'        \
                -o -name '*.hpp' | sort
}
function cw()
{
        wc $(cl) | sort -n
}
function cg()
{
        doGrep cg -n "$1" $(cl) $2 $3 $4 $5 $6 $7 $8 $9
}
function cgi()
{
        doGrep cgi -in "$1" $(cl) $2 $3 $4 $5 $6 $7 $8 $9
}
function cgw()
{
        doGrep cgw -n "\<$1\>" $(cl) $2 $3 $4 $5 $6 $7 $8 $9
}
function cgwi()
{
        doGrep cgwi -in "\<$1\>" $(cl) $2 $3 $4 $5 $6 $7 $8 $9
}
function cgl()
{
        doGrep cg -l "$1" $(cl) $2 $3 $4 $5 $6 $7 $8 $9
}
function cgwl()
{
        doGrep cgwl -l "\<$1\>" $(cl) $2 $3 $4 $5 $6 $7 $8 $9
}
function cgwli()
{
        doGrep cgwli -li "\<$1\>" $(cl) $2 $3 $4 $5 $6 $7 $8 $9
}
alias cgiw=cgwi
alias cglw=cgwl
alias cgwil=cgwli
alias cglwi=cgwli
alias cgliw=cgwli
alias cgilw=cgwli
alias cgiwl=cgwli


#
# for java
#
function jl()
{
        find $1 -name '*.java'        \
                -o -name '*.xml' | sort
}

function jw()
{
        wc $(jl) | sort -n
}
function jg()
{
        doGrep jg -n "$1" $(jl) $2 $3 $4 $5 $6 $7 $8 $9
}
function jgw()
{
        doGrep jgw -n "\<$1\>" $(jl) $2 $3 $4 $5 $6 $7 $8 $9
}
function jgl()
{
        doGrep jgl -l "$1" $(jl) $2 $3 $4 $5 $6 $7 $8 $9
}
function jgwl()
{
        doGrep jgwl -l "\<$1\>" $(jl) $2 $3 $4 $5 $6 $7 $8 $9
}


function g2u()
{
    iconv -f gbk -t utf8 $*
}

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/et.c/.gvm/bin/gvm-init.sh" ]] && source "/Users/et.c/.gvm/bin/gvm-init.sh"
