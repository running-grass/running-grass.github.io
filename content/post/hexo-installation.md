---
title: "Hexo的介绍及安装使用"
date: 2020-07-10
lastmod: 2024-02-01
draft: false
aliases:
  - /post/hexo-installation
---

## 什么是Hexo {#什么是hexo}

Hexo 是一个快速、简洁且高效的博客框架。Hexo 使用 Markdown（或其他渲染引擎）解析文章，在几秒内，即可利用靓丽的主题生成静态网页

<!--more-->


## Hexo的特点 {#hexo的特点}

-   基于Node.js

&gt; 不需要额外配置其它的运行时环境

-   极速生成

&gt; 生成静态文件的速读极快，可以在几秒钟内完成

-   支持Markdown

&gt; 可以专心的码字，而不用关心样式问题

-   一键部署

&gt; 支持多种部署方式，且可以同时部署到多个地方

-   插件丰富

&gt; 截止到目前有\*\*349\*\*个插件，同时还支持\`Octopress\`的大部分插件

-   主题模板多

&gt; 截止到目前有\*\*313\*\*个精美的主题，可以直接使用


## 安装 {#安装}


### 安装Hexo命令行工具 {#安装hexo命令行工具}

```bash
npm install hexo-cli -g
```


### 初始化博客项目 {#初始化博客项目}

```bash
hexo init blog
```


### 安装依赖 {#安装依赖}

```bash
cd blog
npm install
```


### 启动服务器 {#启动服务器}

```bash
cd blog
hexo server
```

此时可以打开\`<http://localhost:4000/%60%E9%A2%84%E8%A7%88%E5%8D%9A%E5%AE%A2>


## 更换主题 {#更换主题}


### 安装\`NexT\`主题 {#安装-next-主题}

```bash
cd blog
git clone https://github.com/next-theme/hexo-theme-next themes/next
```


### 修改配置文件 {#修改配置文件}

-   打开\`blog/_config.yml\`文件
-   找到\`theme: landscape\`配置项
-   修改为\`theme: next\`
-   重启服务器生效


## 编辑文章 {#编辑文章}


### 新建博文 {#新建博文}

```bash
cd blog
hexo new "hello-hexo"
```


### 编辑内容 {#编辑内容}

-   打开\`blog/source/_posts/hello-hexo.md\`
-   在最后一行后面输入文章内容
-   保存后，刷新网页查看效果


## 完善网站配置 {#完善网站配置}

打开\`blog/_config.yml\`，完善网站的基本信息，参考如下

```yaml
# Site
title: 奔跑的小草
subtitle: 一只野生程序猿，爱越野，爱滑雪
description: 分享一些技术上的文章
keywords: IPFS,Hexo,Vue
author: 刘世华
language: zh-CN
timezone: Asia/Shanghai
```

重启服务器后生效
