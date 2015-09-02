#!/bin/bash

[ $# -eq 0 ] && echo "Usage: $0 rpm..." && exit 0

scp $@ admin@repo-1:~/yum-rokid/Package/
# ssh admin@repo-1 createrepo yum-rokid

sudo yum clean all && yum makecache

