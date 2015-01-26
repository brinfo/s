#!/bin/bash

. ~/bin/function.sh

file=${1:-}

toeng $file | xmllint --format -

