export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH=/usr/local/bin:$PATH:~/bin
export PS1='\u@\h:\w\$ '
export JAVA_HOME="/Library/java/JavaVirtualMachines/jdk1.7.0_60.jdk/Contents/Home"

alias ls='ls --color'
alias  l='ls -l'
alias ll='ls -la'
alias grep='grep --color'

alias m0='ssh m0'
alias m1='ssh m1'

set -o vi

function doGrepDir()
{
        local cmd=${1:-}
        local opt=${2:-}
        local arg=${3}
        local dir=${4:-.}

        if [ $# -le 2 ]; then
                echo "usage: $cmd pattern [dir]"
                return
        fi
        echo "grep '$opt' '$arg' '$dir'"
        grep "$opt" "$arg" "$dir"
}

function doGrepFiles()
{
        local cmd=${1:-}
        local opt=${2:-}
        local arg=${3}

        if [ $# -le 2 ]; then
                echo "usage: $cmd pattern file ..."
                return
        fi
        shift 3
        echo "grep '$opt' '$arg' '$*'"
        grep "$opt" "$arg" $*
}

function G()
{
        doGrepDir G -Rn $*
}

function Gi()
{
        doGrepDir Gi -Rni $*
}

function Gw()
{
        if [ $# -ge 1 ]; then
                pat="\<$1\>"
                shift
                doGrepDir Gw -Rn $pat $*
                return
        fi

        doGrepDir Gw
}

function L()
{
        doGrepDir L -Rnl $*
}

function F()
{
        local arg=${1:-}
        local dir=${2:-.}

        if [ $# -le 1 ]; then
                echo "usage: F pattern [dir]"
                return
        fi
        echo "find $dir | grep $arg"
        find $dir | grep "$arg"
}


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
                -o -name '*.hpp'
}
function cw()
{
        wc $(cl) | sort -n
}
function cg()
{
        doGrepFiles cg -n $* $(cl)
}
function cG()
{
        doGrepFiles cg -n "\<$*\>" $(cl)
}
function cgl()
{
        doGrepFiles cg -l $* $(cl)
}
function cGl()
{
        doGrepFiles cg -l "\<$*\>" $(cl)
}


#
# for java
#
function jl()
{
        find $1 -name '*.java'        \
                -o -name '*.xml'

}

function jw()
{
        wc $(jl) | sort -n
}
function jg()
{
        doGrepFiles jg -n $* $(jl)
}
function jG()
{
        doGrepFiles jg -n "\<$*\>" $(jl)
}
function jgl()
{
        doGrepFiles jg -l $* $(jl)
}
function jGl()
{
        doGrepFiles jg -l "\<$*\>" $(jl)
}


