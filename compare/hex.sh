#!/bin/sh
#ipa对比工具
#Author:show

# echo "开始执行";

# echo $1;

# #解压数据

if [[  "$1" == "ipaunzip" ]];then 
	echo "解压文件";
	# 1.ipa 2.ipa
	mv 1.ipa 1.zip
	mv 2.ipa 2.zip
	unzip 1.zip >/dev/null
	rm -rf 1.zip
	echo "1.zip finish";
	unzip 2.zip >/dev/null
	rm -rf 2.zip
	echo "2.zip finish";
else
	echo "现有文件";
fi

function unzip()
{
	unzip $1;
}
function ipa_unzip()
{
	mv $1.ipa $1.zip
	unzip $1.zip >/dev/null
	rm -rf $1.zip
}

function compare_resource()
{
	# echo $FOLDER_B$1"/_CodeSignature/CodeResources" ./tmp/tmp$i;
	if [ $1 == $2 ];then
		return;
		# echo 'same';
	fi
	echo "----------------资源文件对比--------------";
	# echo "["$1"]" "["$2"]";
	start=$(date +%s);

	bcomp  "@$FOLDER_A/rule/hex-rule.txt" "$FOLDER_A/tmp/$1" "$FOLDER_A/tmp/$2" "$FOLDER_A/resource.txt";
	end=$(date +%s);
	time=$(( $end - $start ));
	# cat ./resource.txt;

	same_num=`cat resource.txt|grep '[0-9]\+ same' | sed 's/[^0-9]//g'`;
	left_num=`cat resource.txt|grep '[0-9]\+ left orphan' | sed 's/[^0-9]//g'`;
	right_num=`cat resource.txt|grep '[0-9]\+ right orphan' | sed 's/[^0-9]//g'`;
	difference_num=`cat resource.txt|grep '[0-9]\+ difference' | sed 's/[^0-9]//g'`;
	echo "compare time:"$time"same size:"$same_num;
	# echo "left_num:"$left_num;
	# echo "right_num:"$right_num;
	# echo "difference_num:"$difference_num;
	# echo "------------------------------"

	let `expr left_file=$same_num+$left_num+$difference_num`; 
	let `expr right_file=$same_num+$right_num+$difference_num`; 

	# if [ $left_num -gt $right_num ];then
		c=`echo "scale=4; ($same_num/$left_file)*100" | bc`
		echo "left【"$1"】【size:】"$left_file"【资源相似度："$c"%】";
	# else
		c=`echo "scale=4; ($same_num/$right_file)*100" | bc`
		echo "right【"$2"】【size:】"$right_file"【资源相似度："$c"%】";
	echo "------------end 资源文件对比--------------";
	# fi
}
function compare_code()
{
	if [ $1 == $2 ];then
		return;
	fi
	echo "----------------代码二进制对比--------------";
	start=$(date +%s)
	bcomp  "@$FOLDER_A/rule/hex-rule.txt" "$FOLDER_A/tmp2/$1" "$FOLDER_A/tmp2/$2" "$FOLDER_A/hex.txt";
	end=$(date +%s)
	time=$(( $end - $start ))
	# cat ./hex.txt;
	same_num=`cat hex.txt|grep '[0-9]\+ same' | sed 's/[^0-9]//g'`;
	left_num=`cat hex.txt|grep '[0-9]\+ left orphan' | sed 's/[^0-9]//g'`;
	right_num=`cat hex.txt|grep '[0-9]\+ right orphan' | sed 's/[^0-9]//g'`;
	difference_num=`cat hex.txt|grep '[0-9]\+ difference' | sed 's/[^0-9]//g'`;
	echo "compare time:"$time"same size:"$same_num;
	# echo "left_num:"$left_num;
	# echo "right_num:"$right_num;
	# echo "difference_num:"$difference_num;
	# echo "------------------------------"

	let `expr left_file=$same_num+$left_num+$difference_num`; 
	let `expr right_file=$same_num+$right_num+$difference_num`; 

	# if [ $left_num -gt $right_num ];then
		c=`echo "scale=4; ($same_num/$left_file)*100" | bc`
		echo "left【"$1"】【size:】"$left_file"【代码相似度："$c"%】";
	# else
		c=`echo "scale=4; ($same_num/$right_file)*100" | bc`
		echo "right【"$2"】【size:】"$right_file"【代码相似度："$c"%】";
	# fi
	echo "------------end 代码二进制对比--------------";
}
function test()
{
	echo $FOLDER_B;
}
FOLDER_A=/code/y/iosautopack/compare/;
FOLDER_B=$FOLDER_A"/Payload/";
echo "根目录:"$FOLDER_A;
echo "对比目录:"$FOLDER_B;
echo "--------------------------";

declare -a appname
#初始化appname 0为指定1对多的文件
file_a=$FOLDER_B"/YiQuanLieRen.app";
file_a_prefix=${file_a%.*};
file_prefix=${file_a_prefix#${FOLDER_B}/*}  
tmp_path=$file_a_prefix".app";
appname[0]=$tmp_path;

i=1;
for file_a in ${FOLDER_B}/*; do 
	echo "【生成资源文件】"$file_a;
    file_a_prefix=${file_a%.*};
    file_prefix=${file_a_prefix#${FOLDER_B}/*}  
    #处理并复制相关文件
    tmp_path=$file_a_prefix".app";
    appname[$i]=$tmp_path;

    cp -rf $tmp_path"/_CodeSignature/CodeResources" ./tmp/$file_prefix;

    #gnu-sed
    #brew install gnu-sed --with-default-names 

	/usr/local/opt/gnu-sed/bin/sed -i '1,6d' ./tmp/$file_prefix
	/usr/local/opt/gnu-sed/bin/sed -i ':a;N;$!ba;s/<data>\n//g' ./tmp/$file_prefix
	/usr/local/opt/gnu-sed/bin/sed -i ':a;N;$!ba;s/<\/data>\n//g' ./tmp/$file_prefix
	/usr/local/opt/gnu-sed/bin/sed -i ':a;N;$!ba;s/<dict>\n//g' ./tmp/$file_prefix
	/usr/local/opt/gnu-sed/bin/sed -i ':a;N;$!ba;s/<\/dict>\n//g' ./tmp/$file_prefix

	/usr/local/opt/gnu-sed/bin/sed -i 's/<key>.*<\/key>$//' ./tmp/$file_prefix
	/usr/local/opt/gnu-sed/bin/sed -i 's/<real>.*<\/real>$//' ./tmp/$file_prefix


	/usr/local/opt/gnu-sed/bin/sed -i ':a;N;$!ba;s/<true\/>\n//g' ./tmp/$file_prefix
	/usr/local/opt/gnu-sed/bin/sed -i ':a;N;$!ba;s/<\/plist>//g' ./tmp/$file_prefix

	/usr/local/opt/gnu-sed/bin/sed -i ':a;N;$!ba;s/\n//g' ./tmp/$file_prefix

	/usr/local/opt/gnu-sed/bin/sed -i 's/			 			//g' ./tmp/$file_prefix
	/usr/local/opt/gnu-sed/bin/sed -i 's/		 		//g' ./tmp/$file_prefix
   
   /usr/local/opt/gnu-sed/bin/sed -i 's/			//g' ./tmp/$file_prefix
   /usr/local/opt/gnu-sed/bin/sed -i 's/	//g' ./tmp/$file_prefix


	# /usr/local/opt/gnu-sed/bin/sed -i 's/^$//g' ./tmp/$file_prefix

	cp -rf $tmp_path"/"$file_prefix ./tmp2/$file_prefix;

    # cp -rf $tmp_path"/"$file_prefix ./tmp$i"/bin";
    # cp -rf $tmp_path"/_CodeSignature/CodeResources" ./tmp$i;
	let i++;
done 
#双重for循环
for i in ${!appname[@]}
do
	#先不使用交叉对比
	for j in ${!appname[@]}
	do 
		echo ${appname[$i]}"------"${appname[$j]}
		# echo ${appname[$i]#${FOLDER_B}/*}"-------------"${appname[$j]#${FOLDER_B}/*}
		#${appname[$i]%%.*}
		#比对资源
		compare_resource  $(basename "${appname[$i]}" ".app")  $(basename "${appname[$j]}" ".app") 
		#对比代码
		# compare_code  $(basename "${appname[$i]}" ".app")  $(basename "${appname[$j]}" ".app") 
	done
    break;
done



echo "执行结束";





