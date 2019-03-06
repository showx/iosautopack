#!/bin/bash
#合并模拟器与真机
#Author:show
#lipo -info 真机framework文件路径
#lipo -create 真机路径 模拟器路径 -output 真机路径

echo shell路径：$0;
echo 地址:$1;
echo 名称:$2;
echo 内容:$3;


#"happySDK.framework/happySDK"
path=$1
framename=$2
#path=$0
content=$3
#/Users/pengyongsheng/Library/Developer/Xcode/DerivedData/happySDK-gmugxwnehiiywsbzyoonndtqxzvj/Build/Products/
debug_sim=$path/Debug-iphonesimulator/$framename;
debug_phone=$path/Debug-iphoneos/$framename;
debug_sim_real=$debug_sim/$content;
debug_phone_real=$debug_phone/$content;

echo sim:$debug_sim_real;
echo phone:$debug_phone_real;

#sdk.framework是文件， 下面的bin文件不当文件，属于包内容
if [ -n "$1" ] && [ -n "$2" ];then
	echo "------------start";
	if [ -e $debug_sim ] && [ -e $debug_phone ];then
		lipo -create $debug_phone_real $debug_sim_real -output $debug_phone_real
		cp -rf $debug_phone /code/tmp/framework/$framename
	fi
else
	echo "请输入参数";
fi

echo finish;