#!/bin/sh
#ipa对比工具
#Author:show

# echo "开始执行";

# echo $1;

#解压数据
class-dump -H $1 -o /tmp/$1

echo "执行结束";