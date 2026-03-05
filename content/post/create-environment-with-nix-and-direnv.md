---
title: "使用Nix+direnv快速构建不同软件版本的开发环境"
date: 2021-07-07
lastmod: 2024-02-01
tags:
  - 开发环境
  - Nix
  - direnv
  - docker
  - virtualenv
  - nodejs
  - python
draft: false
aliases:
  - /post/create-environment-with-nix-and-direnv
---

我们在开发项目是总是会遇到一些软件版本的问题，例如项目A需要node版本为8-10，而项目B需要版本大于12，常用的方案有这么几种。

-   在开发不同的项目的时候，手工切换不同的版本 (因为我遇到的不多，所以一直这么干)
-   使用虚拟机或者Docker
-   使用类似python中的virtualenv，根据不同的目录切换不同的虚拟运行时环境

本文的方案属于第三种。不需要太多的背景知识。

<!--more-->


## 安装Nix {#安装nix}

nix是一个函数式的包管理器，想像成apt-get或者homevrew这种的，或者npm。

在命令行执行 `curl -L https://nixos.org/nix/install | sh` 就可以自动安装nix

如果被墙，也可以使用清华镜像站的 `sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install)`


### 更换镜像(可选) {#更换镜像--可选}

目前已知的有清华镜像站  <https://mirrors.tuna.tsinghua.edu.cn/help/nix/>

可以通过在 `~/.config/nix/nix.conf` 文件中写入以下内容，获得安装加速

```text
substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
```

并且执行以下命令获得源码下载加速

```base
nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --update
```


## 安装direnv {#安装direnv}

既然已经安装好了nix，那么就直接用nix来安装direnv吧。

```base
nix-env -iA nixpkgs.direnv
```


## 配置项目 {#配置项目}

先在项目根目录新建一个文件 `shell.nix` ，内容示例如下

```nil
with import <nixpkgs> {};
mkShell {
  buildInputs = [
    nodejs-10_x
    yarn
    idris2
  ];
}
```

在这里，我声明了我的这个项目依赖这三个软件，nodejs，yarn，idris2，并且指定了nodejs的大版本。

(可选) 此时可以手动的执行 `nix-shell` 命令安装依赖，并且进入到nix-shell中。不过这样就不能使用自己心爱的shell了

可以到 `https://search.nixos.org/packages` 页面搜索自己依赖的软件包。

在项目根目录新建一个文件 `.envrc` , 内容如下：

```nil
use_nix
```

对，就这么一行就够了。

然后执行 `direnv allow .` ，注意有个点喔。执行 `eval "$(direnv hook zsh)"` 可以让自己的shell在进入该目录的时候，自动检测并安装依赖，且自动切换软件的依赖目录。 由于我用的是 `zsh` 所以我这里写的是zsh， 其它的shell可以到 `https://direnv.net/docs/hook.html` 查看命令。

对了，别忘记把上面这条命令加入到你的 bashrc/zshrc 中啊。

在终端试试 `cd ..` ， 然后在 `cd` 到项目目录 试试。看看命令行有没有自动的加载虚拟运行时环境啊。


## 和docker的对比 {#和docker的对比}

我比较懒，也就不写123了，对于开发环境，大多数情况用nix+direnv就足够了，毕竟软件版本隔离是最大众的需求嘛。

而且还这么简单。😄


## 参考链接 {#参考链接}

-   <https://search.nixos.org/packages>
-   <https://direnv.net/>
-   <https://myme.no/posts/2020-01-26-nixos-for-development.html#virtual-environments-using-nix-shell>
-   <https://nixos.wiki/wiki/Development_environment_with_nix-shell#Using_Direnv>
