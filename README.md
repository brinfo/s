这里放置一些常用的配置
以免每次新电脑时重新配置

步骤:

1. 参见 https://help.github.com/articles/generating-ssh-keys
2. git clone https://github.com/brinfo/s.git
3. cd configs; for file in $(/bin/ls -1d .* | sed '1,2d' | grep -v '^.git$'); do if [ -f ~/$file -o -h ~/$file ]; then mv ~/$file ~/$file.$(date +"%Y%m%d"); fi; ln -s $PWD/configs/$file ~/; done


* 注意以上命令会将$HOME目录下的已经存在的文件重命名.
