---
title: "Emacs中的个人信息管理 — GTD收集"
date: 2024-03-04
lastmod: 2024-03-04
tags:
  - Emacs
  - series
  - GTD
  - Org
series:
  - Emacs 中的个人信息管理
draft: false
aliases:
  - /post/pim-in-emacs-gtd-inbox
---

本文是 [本系列](/series/emacs-中的个人信息管理/) 的第一篇。

本篇分享我在 `Emacs` 中使用 `Org` 进行 `GTD` 信息收集的一些方案及配置。

<!--more-->


## TL;DR {#tl-dr}

在 `Emacs` 中有收集信息有以下几种方式：

1.  内部收集
    1.  `Org-capture` / `Org-roam-capture` 收集日常想法
2.  外部收集
    1.  浏览器剪藏可以通过 Org-protocol
    2.  快速启动 可以通过 Org-protocol 收集任务和想法
    3.  手机端日历事件收集 davx+org-caldav
    4.  手机端任务收集 davx+jtx board
    5.  手机端笔记收集 syncthing/wevdav+orgzly


## 个人信息管理 {#个人信息管理}

个人信息管理是指个人对自己的信息进行收集、整理、存储和利用的过程。它涵盖了个人生活和工作中的各种信息，包括但不限于笔记、任务、日程安排、项目计划、联系人、文档和资料等。有效的个人信息管理可以帮助人们提高工作效率、降低信息过载，更好地组织生活和工作，以及更好地实现个人和职业目标。


## GTD {#gtd}

GTD，全称Getting Things Done，是由David Allen提出的一种个人任务管理方法。它强调将任务和想法从大脑中转移到外部系统中，以减轻压力并提高生产力。
GTD的核心理念包括收集、处理、组织、回顾和执行，通过这些步骤帮助个人有效地管理任务、项目和目标，从而更好地应对日常生活和工作中的复杂情境。


## Emacs和Org {#emacs和org}

Emacs 是一款自由开源的文本编辑器，具有高度可定制性和可扩展性。它被广泛用于编程、文本编辑、以及各种工作流程中。

Orgmode 是 Emacs 的一个内置工具，用于组织大纲、笔记、任务列表、日程安排和其他文本管理任务。它具有强大的大纲视图、标签、TODO列表、时间跟踪等功能，可帮助用户高效地管理信息和项目。
Orgmode 还支持导出到其他格式，如 HTML、LaTeX 等，使其成为一种强大的写作和出版工具。


## 内部收集 {#内部收集}

内部收集使用Org的捕获模板来支撑。可以在Emacs的使用过程中，通过快捷键打开任务的捕获窗口，在完成之后，再回到之前的工作流。不担心心流的中断。

```emacs-lisp
(setq org-capture-templates . '(
                                ("t" "Todo" entry (file+headline  "~/org/gtd/gtd.org" "Inbox For GTD") "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:RELATED: %a\n:END:")
                                ))
```

其中按照参数顺序分别为：

-   `"t"` 为该捕获模板的快捷键
-   `Todo` 为该捕获模板的描述
-   `entry` 为该捕获模板的类型， `entry` 为最常用的，代表的是一个 `标题行` ，除此之外还有 `item`  (普通列表项)
    、 `checkitem` (普通列表中的复选框项)、 `table-line` (表格行) 以及 `plain` (普通文本)
-   `(file+headline  "~/org/gtd/gtd.org" "Inbox For GTD")` 为保存是写入的目标，其中
    -   `file+headline` 为目标类型，这个类型为指定的文件中的某个标题行，另外一个常用的为 `file` 。还有其它多种，不一一列举
-   `"* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:RELATED: %a\n:END:"` 为具体的模板内容， 其中：
    -   `*` 为占位符，在实际插入目标的时候，会按照具体的层级填充星号
    -   `%a` 为众多模板变量之一，代表着执行捕获命令时的引用链接


## 外部收集 {#外部收集}


### PC端 {#pc端}


#### Org-protocol {#org-protocol}

Org-protocol 为 `Emacs` Server 模式下的一个特性功能，可以通过 Emacs client 传递一个字符串到 Emacs Server。在 Emacs Server 中可以注册多个处理器，根据传入的路径不同，调用不同的处理函数。 默认有几个处理函数，见 `org-protocol-protocol-alist-default`

首先启动 Emacs server，不同的操作系统有不同的方式。以 `NixOS` 为例：

```nix
services.emacs = {
  enable = true;
};
```

然后注册自定义协议处理器，详细的方式见 [这里](https://orgmode.org/worg/org-contrib/org-protocol.html#org31b122b)， 以 `NixOS` 为例：在 home-manager 中配置如下。

```nix
{
  xdg.desktopEntries = {
    org-protocol = {
      name = "org-protocol";
      noDisplay = true;
      exec = "emacsclient -- %u";
      terminal = false;
      comment = "Intercept calls from emacsclient to trigger custom actions";
      type = "Application";

      mimeType = [ "x-scheme-handler/org-protocol" ];
    };
  };
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/org-protocol" = "org-protocol.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/org-protocol" = "org-protocol.desktop";
    };
  };
}
```

在 Emacs 中配置一个单独的捕获模板：

```emacs-lisp
(setq org-capture-templates '(
                              ("t" "Todo" entry (file+headline  "~/org/gtd/gtd.org" "Inbox For GTD") "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:RELATED: %a\n:END:")
                              ("n" "摘抄" entry (file  "~/org/inbox/emacs.org") "* TODO 摘抄自 %a \n:PROPERTIES:\n:CREATED: %U\n:RELATED: %a\n:END:\n%i\n" :immediate-finish t)
                              ))
```

在浏览器中保存一个书签，名字为 `保存到Emacs` ，地址如下：

```javascript
javascript:location.href='org-protocol://capture?%27 +      new URLSearchParams({            template: %27n%27, url: window.location.href,            title: document.title, body: window.getSelection()});
```

大功告成。

在浏览器的网页中，选中一段文本，点击书签栏的这个书签，就可以把选中的文本保存的 Org 中。

类似的，也可以直接收藏整个网页。


### 手机端 {#手机端}

由于主要使用场景在PC上面，如果要在手机端进行收集信息的话，通常有两种方式,
第一种是把对应的文件同步到手机端，第二种是直接在手机端读写远程的文件。而第二种机制的支持软件不多，且极度依赖网络环境，故我使用的都是第一种机制。


#### 同步机制 {#同步机制}

<!--list-separator-->

-  caldav + DavX

    第一种同步机制是利用Caldav协议。这种方式需要一个可以访问的服务。我使用的是 radicale 服务，它可以提供 Carddav 和 Caldav 服务。

    以 `NixOS` 为例，搭建 Radicale 服务

    ```nix
    {
      services.radicale = {
        enable = true;
        settings = {
          server.hosts = [ "localhost:5232" ];
          auth = { type = "htpasswd"; };
        };
      };

      # 使用 apacheHttpd 来编辑 users 文件,设置用户名和密码
      environment.etc."radicale/users".source = ../../../files/radicale/users;

      # 配置 Nginx
      services.nginx = {
        enable = true;
        defaultListen = [{
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }];

        virtualHosts = {
          "radicale" = {
            serverName = "carddav.grass.show";
            locations."/".proxyPass = "http://localhost:5232";
            useACMEHost = "grass.show";
            forceSSL = true;
          };
        };
      };
    }
    ```

    `DAVx` 是一个安卓端上面的 Caldav/Carddav/Webdav 的同步软件。 可以集成到系统通讯录和系统日历。

<!--list-separator-->

-  Syncthing

    `Syncthing` 是一个 P2P 的同步工具，跨多个常用的端。由于是去中化的，不需要一个可以访问的IP。


#### 具体使用 {#具体使用}

<!--list-separator-->

-  Org-caldav

    首先把 PC 上面的任务和事件导出到 Caldav 上面。

    ```emacs-lisp
    (leaf org-caldav
        :straight t
        :custom
        ;; 双向同步
        (org-caldav-sync-direction . 'twoway)

        (org-caldav-exclude-tags . '("no_caldav"))
        (org-caldav-todo-percent-states  . '(
                                             (0 "TODO")
                                             (10 "NEXT")
                                             ))

        ;; ;; 如果上一次异常，不询问
        (org-caldav-resume-aborted . 'always)

        ;; 同步过程中自动删除条目，不再询问(我的本地org使用了git存储)
        ;; org-caldav-delete-org-entries 'always
        (org-caldav-delete-calendar-entries . 'always)

        ;; 不导出 VTODO
        (org-caldav-sync-todo . t)
        (org-icalendar-include-todo . '("TODO" "NEXT"))

        ;; 如果不是是todo节点，会作为一个event
        (org-icalendar-use-scheduled . '(todo-start))

        ;; 如果是todo节点，会作为一个event
        (org-icalendar-use-deadline . '(todo-due))

        ;; 不使用sexp
        (org-icalendar-include-sexps . nil)
        (org-icalendar-include-bbdb-anniversaries . nil)
        ;; 后台导出，不显示同步结果
        (org-caldav-show-sync-results . nil)
        ;; debug logs
        (org-caldav-debug-level . 2)
        :init
        ;; 多个日历
        (setq org-caldav-calendars (list (list
                                          :url (concat "https://grass:" (grass-emacs/get-bitwarden-password "carddav:grass") "@carddav.grass.show/grass")
                                          :calendar-id "xxxx-xxxxx" ; 个人日历
                                          :select-tags (list "personal" "work")
                                          :files '("~/org/gtd/gtd.org")
                                          :inbox "~/org/inbox/caldav-personal.org")
                                         (list
                                          :url (concat "https://family:" (grass-emacs/get-bitwarden-password "carddav:family") "@carddav.grass.show/family")
                                          :calendar-id "yyyyy-yyyyyy" ; 家庭日历
                                          :select-tags (list "family")
                                          :files '("~/org/gtd/gtd.org")
                                          :inbox "~/org/inbox/caldav-family.org")))
        :bind
        ("C-c t c" . org-caldav-sync)
        )
    ```

    在上面，我根据同步的tag，把任务分别导出到两个不同的日历中。一个是私人使用，这个会由我本人使用，用于在 PC 和 手机端同步日历和任务。而另外一个日历是供家庭共享使用。我和我爱人都通过手机端来查看/添加日历。而我则通过PC端的Emacs管理和维护日历。

<!--list-separator-->

-  系统日历

    在 `DAVx` 中配置 `Radicate` 上面的用户名和密码，即可以配置好 Caldav的同步，而同步来的事件（非任务）则会自动集成到系统日历中，而在系统日历中添加的事件的时候，可以选择保存到 caldav , 这样在下一次同步的时候，会把改日历事件同步到 Radicate 中，在使用 Org-caldav 和 Radicate 同步的时候，会把这条由手机端添加的日历事件写入到 `~/org/inbox/caldav-personal.org`  中。 只要不修改其 ID，可以自由移动该条目，不影响同步

<!--list-separator-->

-  Jtx Borad

    这是一个在安卓上面的管理 笔记/日历/任务 的开源软件。而我因为只是用于和caldav集成，所以我只使用了任务功能，其它的模块我都关闭了。在 `DAVx` 中可以打开和 `Jtx` 的集成开关。每次 `DAVx` 同步完成，会自动再同步到 `Jtx` ，这样就可以在 `Jtx` 对任务进行完成操作，或者新增。最终也会同步到 Org 文件中。

<!--list-separator-->

-  Orgzly

    这个一个手机端的 Org 文件编辑器，对于任意格式的Org信息，可以使用 Orgzly 来收集。

    首先在PC端配置好 Syncthing，把 Org 目录共享出去（我没有共享整个目录，只共享了一个 `~/org/syncthing` 子目录）。然后在手机端安装 Syncthing，匹配PC设备上的Syncthing， 然后配置 Org 存储路径。 进行同步

    使用 Orgzly 收集想法和笔记等内容。会同步到 PC 端。


## 后续 {#后续}

1.  考虑通过 `Org-protocol` ,在 `Rofi` （快速启动器） 中快速捕获想法
2.  既然把信息收集到 `Org` 中来了，那么接下来的就是如何整理，下一篇会详细说一下我的整理思路
