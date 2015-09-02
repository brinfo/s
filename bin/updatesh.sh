#!/bin/bash

scp $* m1:~/bin/;
scp $* admin@m1:~/bin/;
scp $* m2:~/bin/;
scp $* admin@m2:~/bin/;

