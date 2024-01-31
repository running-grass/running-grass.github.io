+++
title = "linux下文件编码的转换"
date = 2016-03-30T00:00:00+08:00
lastmod = 2024-01-31T11:23:29+08:00
draft = false
weight = 2002
+++

昨天用TP发现在某个文件中输出中文会在浏览器显示乱码<br />
经过测试发现是文件编码为gb2312 ，而不是utp-8 类型，所有找了几段资料来修复这个问题


## 首先查看文件的编码 {#首先查看文件的编码}

enca (如果你的系统中没有安装这个命令，可以用sudo yum install -y enca 安装 )<br />
查看文件编码

```text
enca filenamefilename
```

使用 enca \* 命令可以方便查看所有文件的编码，方便找到问题文件<br />
需要说明一点的是，enca对某些GBK编码的文件识别的不是很好，识别时会出现：Unrecognized encoding


## 文件编码转换 {#文件编码转换}


### 2.1 enconv 转换文件编码，比如要将一个GBK编码的文件转换成UTF-8编码，操作如下 {#2-dot-1-enconv-转换文件编码-比如要将一个gbk编码的文件转换成utf-8编码-操作如下}

```text
enconv -L zh_CN -x UTF-8 filename
```

这个命令好像我不太会用，反正是不起作用，总是执行不成功，我用下面的iconv命令成功的进行了编码的转换


### 2.2 iconv 转换，iconv的命令格式如下： {#2-dot-2-iconv-转换-iconv的命令格式如下}

```text
iconv -f encoding -t encoding inputfile\
```

比如将一个UTF-8 编码的文件转换成GBK编码

```text
iconv -f UTF-8 -t GBK file1 -o file2
```
