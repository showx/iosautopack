#-*- coding: utf-8 -*-
#!/usr/bin/python
#ios代码混淆
#Author show
###################################
#指定字匹配
#指定文件后缀匹配
#单词获取php代码文件再自己精选一些出来
#替换的单词作为字典
#使用集合排除函数名唯一
#正则注释的去除，这个未必有必要吧？
#生成唯一字符串的函数
#替换相关域名和方法
#根据文件名更改替换相关方法
#rename之后其实也要改一下项目的名renameFileInXcodeProj
#图片文件的更改
#针对文件夹加前缀
#针对文件加前缀
#这里嵌入批量压力图片的脚本，使用convert
#去除空格与注释

import struct
import os
from os.path import join, getsize
path_prefix = "php"
file_prefix = "show"
sdk_path = "/code/tmp/ios"
framework_path = "/sdk_demo_show/Laughing"
clear_space = true

#逐行替换所有内容
def replacefilecontent(file,find_str,replace_str):
	line_data = ""
	newfile = file  #newfile = file+".bak";
	num = 0
	with open(file, "r") as f:
		for line in f:
			line = line.replace(find_str,replace_str)
			line_data += line
			num = num+1 #计算出行数
		
	print newfile
	with open(newfile,"w") as f:
		f.write(line_data)
		
# 替换所有内容
def replacefilecontentAll(file,find_str,replace_str):
	with open(file,"r") as fileObj:
		all_text = fileObj.read()
		fileObj.close()
	all_text = all_text.replace(find_str,replace_str)
	with open(file,"w") as fileObj:
		fileObj.write(all_text)
		fileObj.close()
		
#更新所有文件
def renameInAllFile(old_text, new_text):
	global sdk_path
	for parent, folders, files in os.walk(sdk_path):
		for file in files:
			full_path = os.path.join(parent, file)
			replacefilecontentAll(full_path, old_text, new_text)

#重命名文件名
def replacefilename(file,find_str,replace_str):
	new_file = file.replace(find_str,replace_str)
	os.rename(file,new_file)
	
#获取文件后缀
def file_extension(path): 
	return os.path.splitext(path)[1] 

#运行替换
def replace_run(tmpname,find_str,replace_str):
	replacefilecontent(tmpname,find_str,replace_str)
	replacefilename(tmpname, find_str, replace_str)
	
#替换字典里的关键词
def dict_run():
	global sdk_path
	dict_1d = dict()
	dict_1d['1'] = {'find': '_C9S','replace':'_'}
	dict_1d['2'] = {'find': 'B8G_','replace':''}
	dict_1d['3'] = {'find': '_A8P','replace':''}
	dict_1d['4'] = {'find': '_A04','replace':''}
	dict_1d['5'] = {'find': '_A08','replace':''}
	dict_1d['7'] = {'find': '_A19','replace':''}
	dict_1d['7'] = {'find': '_A18','replace':''}
	dict_1d['7'] = {'find': '_A17','replace':''}
	dict_1d['8'] = {'find': '_A05','replace':''}
	dict_1d['9'] = {'find': '_X88','replace':''}
	dict_1d['10'] = {'find': '_A16','replace':''}
	dict_1d['11'] = {'find': '_A01','replace':''}
	dict_1d['12'] = {'find': '_A06','replace':''}
	dict_1d['13'] = {'find': '_A02','replace':''}
	dict_1d['14'] = {'find': '_A09','replace':''}
	dict_1d['15'] = {'find': '_A03','replace':''}
	dict_1d['16'] = {'find': '_A10','replace':''}

	for key1 in dict_1d:
		find_str = dict_1d[key1]['find']
		replace_str = dict_1d[key1]['replace']
		print '查找:',find_str,'替换:',replace_str
		arr = [];
		for fpathe,dirs,fs in os.walk(sdk_path):
			for f in fs:
				files = os.path.join(fpathe,f)
				basename = os.path.basename(files)
				if basename == '.DS_Store' :
					pass
				else:
					arr.append(files);
		for tmpname in arr:
			print tmpname
			ext = file_extension(tmpname);
			#只允许.m和.h文件替换
			if ext!='.m' and ext!='.h':
				continue
			replacefilecontent(tmpname,find_str,replace_str)
			replacefilename(tmpname, find_str, replace_str)
			
#增加前缀,暂时不全改
def prefix_run():
	global sdk_path,file_prefix,path_prefix,framework_path
	framework_path = sdk_path+framework_path
	print framework_path
	for root, dirs, files in os.walk(sdk_path):
#		print root,dirs
		tmp = root.find(framework_path)
		#找到框架里的文件才进行替换
		if(tmp==0):
#			print root,files
#			print files;
			for tmpfile in files:
				ext = file_extension(tmpfile);
				if ext!='.m' and ext!='.h':
					continue
				filehis = tmpfile.find(file_prefix)
				if(filehis==0):
					print '存在前缀,不进行处理',tmpfile;
					continue;
				else:
					pass
#					print 'nohis';
					
				print tmpfile;
				new_tmpfile = file_prefix+tmpfile
				full_path = os.path.join(root, tmpfile)
				new_full_path = os.path.join(root, new_tmpfile)
				base_tmpfile = os.path.splitext(tmpfile)[0];
				base_new_tmpfile = os.path.splitext(new_tmpfile)[0];
				
				print "\t [exec file : %s -> %s] " %(tmpfile, new_tmpfile) 
				print "\t [base file : %s -> %s] " %(base_tmpfile, base_new_tmpfile) 
				print "\t path : %s -> %s" %(full_path, new_full_path) 
				os.rename(full_path, new_full_path)
				renameInAllFile(base_tmpfile,base_new_tmpfile);
	
def main():
#	dict_run()
#	prefix_run()
	
	
if __name__ == '__main__':
	print '开始运行脚本'
	main()			
		
		
