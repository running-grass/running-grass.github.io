---
title: "在FreeBSD系统上使用Docker"
date: 2020-11-09
lastmod: 2024-02-01
tags:
  - Docker
  - FreeBSD
draft: false
aliases:
  - /post/use-docker-on-freebsd
---

Docker利用了Linux内核的一些特性，而FreeBSD是不支持的，需要通过docker-machine创建虚拟机来曲线救国。

<!--more-->


## 安装VirtualBox {#安装virtualbox}

因为docker-machine需要使用到virtualbox，而我的FreeBSD作为服务器，是没有图形界面的，所以我这里安装的是 `nox11` 版本。

```bash
sudo pkg install virtualbox-ose-nox11
```

安装完成后，会有一些设置提示，也可以参考[virtualbox-ose-nox11的README](https://freebsd.pkgs.org/13/freebsd-amd64/virtualbox-ose-nox11-5.2.44_4.txz.html)

加载内核模块, 在 `/boot/loader.conf` 文件中增加一行

```text
vboxdrv_load="YES"
```

我日常使用非root用户操作，所以需要把我的用户加入到vboxusers用户组中

```bash
sudo pw groupmod vboxusers -m grass  # grass是我的用户名
```

为了使用桥接网络，需要在 `/etc/rc.conf` 中增加一行配置

```text
vboxnet_enable="YES"
```


## 安装docker-machine {#安装docker-machine}

```bash
sudo pkg install docker-machine
```


## 创建docker-machine {#创建docker-machine}

```bash
docker-machine create -d virtualbox default
```


## 安装docker {#安装docker}

```bash
sudo pkg install docker
```


## 连接到docker-machine {#连接到docker-machine}

```bash
eval (docker-machine env default)
```


## 启动第一个容器 {#启动第一个容器}

```bash
docker run hello-world
```
