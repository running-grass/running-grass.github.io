---
title: "在Hyprland桌面下，Chromium系浏览器无法使用Fcitx输入法"
date: 2024-03-08
lastmod: 2024-03-08
tags:
  - 疑难杂症
  - Chromium
  - Fcitx
  - Wayland
  - Hyprland
draft: false
aliases:
  - /post/in-hyprland-chromium-not-use-fcitx
---

## TL;DR {#tl-dr}

使用以下参数打开

```sh
chromium -enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime
```


## 背景 {#背景}

操作系统为 `NixOS` ，桌面为 `Hyprland` ，显示协议为 `Wayland` ，输入法是 `Fcitx` 配制的小鹤双拼。浏览器是 `Brave` （Chromium内核）。之前我的浏览器是可以使用 Fcitx 输入法的，但是前端时候不知道动了什么配置，突然就不能使用输入法了，但我又懒得一个个的回滚系统去看。所以干脆一不做二不休，重新查一下原因吧。


## 原因 {#原因}

经过排查，发现 `Firefox` 中可以使用 Fcitx, 首先排除了是 Fcitx 的配置问题。那问题就是出现在 Chromium 上。 经过搜索发现了 [在Wayland上使用Fcitx的注意实现](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland) 这一wiki。在里面详细的记录着出现问题的原因。一句话就是软件本身对于输入法的支持有bug。


## 方案 {#方案}


### 第一种方案 {#第一种方案}

使用 `chromium -enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4` 来启动浏览器，这个的问题是输入框位置有时候会在错误的位置上


### 第二种方案 {#第二种方案}

使用 `chromium -enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime` 来启动浏览器，这样会使用 `text-input-v1`, 效果比上面一个要稳定


## 结论 {#结论}

`Wayland` 任重道远，现在用在生产环境下的坑还是挺多的，需要有极强的折腾精神才能坚持的用下去
