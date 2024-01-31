+++
title = "从Hexo迁移到Hugo"
date = 2020-11-01T22:54:00+08:00
lastmod = 2024-01-31T11:23:11+08:00
draft = false
weight = 1002
+++

记录一下自己从Hexo迁移到Hugo的过程，程序直接部署到GitHub Page。

<!--more-->


## 背景 {#背景}

写文章的地方一直在变，从刚接触网络时的qq空间，到后来的微信朋友圈写长文，再到后来的简书，后来又在微信公众号写了几篇，再之后自己使用hexo搭建博客，这次发现hugo的热度挺高，并且支持Emacs的org模式，本着折腾至死的精神，博客再次迁移，顺便把之前的东西都整理到一起


## 安装 {#安装}


### 安装命令行 {#安装命令行}

因为我用的是Mac，所以我可以直接用 `Homebrew` 命令进行安装

```bash
brew install hugo
```


### 创建新博客 {#创建新博客}

```bash
hugo new site quickstart
```


### 添加新主题 {#添加新主题}

\#+BEGIN_SRC bash
cd quickstart
git init
git submodule add <https://github.com/olOwOlo/hugo-theme-even.git> themes/even
\#+BEGIN_SRC


### 创建第一篇博文 {#创建第一篇博文}

```bash
hugo new posts/my-first-post.md
```

这时会自动生成一个文件my-first-post.md文件，里面会有一些默认的信息


### 启动服务 {#启动服务}

```bash
hugo server -D
```

使用参数 `-D` 可以使草稿也被渲染出来


### 编译静态网站 {#编译静态网站}

```bash
hugo -D
```


## 部署 {#部署}


### 自建服务器 {#自建服务器}

可以直接把public目录使用scp拷贝到自己的服务器上


### GitHub Page {#github-page}


#### 建立一个page仓库 {#建立一个page仓库}

在github上面创建一个&lt;username&gt;.github.io的公开仓库例如我的仓库名称是running-grass/running-grass.github.io


#### 添加子git子模块 {#添加子git子模块}

```bash
cd quickstart
rm -rf public
git submodule add -b master https://github.com/<USERNAME>/<USERNAME>.github.io.git public
```


#### 设置baseURL {#设置baseurl}

把config文件中的baseURL设置为&lt;username&gt;.github.io


#### 部署脚本 {#部署脚本}

在博客根目录下创建一个文件 `deploy.sh` ，并且使用 `chmod +x deploy.sh` 添加可执行权限，内容如下

```bash
#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
    msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
```


#### 设置Github Pages {#设置github-pages}

-   进入到 `Settings` 页面，向下滚动找到 `GitHub Pages` 设置
-   在 `Source` 中选择分支，目录选择 `/(root)` ，然后点击 `Save`
-   在 `Enforce HTTPS` 复选框选中，以后HTTPS肯定是必须的


#### 设置自定义域名 {#设置自定义域名}

-   随便找一个域名注册商(例如 `阿里云`)，注册一个自己喜欢的域名
-   在 `static/CNAME` 文件中增加刚买的域名，我这里是 `grass.show`
-   使用上面的部署脚本重新部署博客到 `GitHub`
-   `Ping` 一下自己的GitHub Page的ip，例如我会 `ping running-grass.github.io` ，然后记住ip
-   进入域名控制台，设置DNS解析，把根域名解析A记录到刚才的ip上面
-   十分钟过后，就可以访问自己的域名了，例如我这里是 `https://grass.show`


## 迁移 {#迁移}

因为我之前博客使用hexo来写的，文章采用的是Markdown，可以很方便的复制到这边来，基本上不需要改变什么

同时又把微信公众号的文章也一并迁移了过来，图片使用 `PicGo` 保存到github上面


## 使用ox-hugo {#使用ox-hugo}

参见[使用ox-hugo写博客](/post/first-blog-for-ox-hugo)
