---
title: "Emacs中的个人信息管理 — 日记/笔记/博客"
date: 2024-03-27
lastmod: 2024-03-27
tags:
  - Emacs
  - series
  - Org
series:
  - Emacs 中的个人信息管理
draft: false
aliases:
  - /post/pim-in-emacs-gtd-daily-note-blog
---

本文是 [本系列](/series/emacs-中的个人信息管理/) 的第三篇， 分享在Emacs中进行日记记录，笔记管理和博客文章的管理

<!--more-->


## TL;DR {#tl-dr}

1.  日记和笔记使用 `Org-Roam` 进行管理
2.  博客使用 `Hugo` + `Ox-Hugo` 进行管理
3.  详细的配置可以看[这里](https://github.com/running-grass/grass-emacs?tab=readme-ov-file#org-roam)(我的Emacs配置仓库)


## 基础工作流 {#基础工作流}

之所以把这三件事情放到一起进行分享，是因为这三件事情可以形成一个较为完整的工作流。

每天除任务以外的琐碎的想法记录都会收集到日记里面，主要存放一些灵感、想法、回忆、趣事等，偏主观的内容而一些客观的知识性内容，或者某一主体性的内容，会作为一篇笔记进行保存。例如会议纪要、年度总结、数据库相关知识点汇总等博客则是在笔记的基础上，进行汇总、整理，进行系统性的输出。


## 日记 {#日记}

在 `Emacs` 下，用 `Org Mode` 写日记是最适合不过的了，可以使用自定义捕获模板写日记，有也可以使用具有增强功能的插件。目前有两个热门的包可以使用，org-jourmals 和 org-roam。这两个包都不错，如果想用一个轻量化的插件，就选择 org-jourmals。而如果要使用 org-roam 的话，则可以直接使用 org-roam 中的内置日记功能。

此处分享一下 org-roam 中日记相关的配置。

```emacs-lisp
(leaf org-roam
  :straight t
  :after org
  :custom
  (org-roam-directory . "~/org/roam/")
  ;; Dailies
  ("C-c n j" . org-roam-dailies-capture-today)
  :config
  (org-roam-db-autosync-mode)
  )
```

其实是没有什么可配置的，它开箱即用，只要配置一个键绑定即可。


## 笔记 {#笔记}

最近几年开始流行的双链笔记，现在但凡提到笔记，就先考虑有没有双链，几乎快成了笔记类应用的标配了。在 Emacs 中有两个热门的双链笔记的插件， org-brain 和 org-roam， 两个项目都已经不太活跃了，不过 org-roam 近期还是有更新的。我目前使用的 org-roam，因为它的理念和我熟悉的双链特性更接近。且它的生态也更好一些。

以下是完整的 org-roam 配置

```emacs-lisp
(leaf org-roam
  :straight t
  :require org-roam org-roam-protocol
  :after org
  :custom
  (org-roam-directory . "~/org/roam/")
  `(org-roam-node-display-template . ,(concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  :bind
  ("C-c n l" . org-roam-buffer-toggle)
  ("C-c n f" . org-roam-node-find)
  ("C-c n g" . org-roam-graph)
  ("C-c n i" . org-roam-node-insert)
  ("C-c n C" . org-roam-capture)
  ;; Dailies
  ("C-c n j" . org-roam-dailies-capture-today)

  :config
  (org-roam-db-autosync-mode)
  )
```


## 博客 {#博客}

在 Emacs 上的博客插件是很多的，有原生导出静态网站的，也有和其它静态生成工具集成的。例如我使用的 `hugo` ，在 Emacs 上对应的集成插件为 `ox-hugo` 。 本文便是通过这个组合进行维护和发布的。

我的配置如下：

```emacs-lisp
(leaf ox-hugo
  :straight t
  :after ox
  :require t
  :leaf-defer nil
  :ensure-system-package hugo
  :custom
  (org-hugo-section . "post")
  (org-hugo-auto-set-lastmod	. t)
  :init
  (add-to-list 'org-capture-templates
               '("h"
                 "Hugo draft"
                 entry
                 (file+olp "~/org/blog/draft.org" "Draft")
                 (function org-hugo-new-subtree-post-capture-template)))

  )
```


### 小技巧 {#小技巧}


#### 如何设置列表的摘要 {#如何设置列表的摘要}

以本文为例

```org
本文是 [[/series/emacs-中的个人信息管理/][本系列]] 的第三篇， 分享在Emacs中进行日记记录，笔记管理和博客文章的管理

#+hugo: more
```

其中 `#+hugo: more` 前面的内容会在列表页面显示为摘要。同时也会作为 `SEO` 中的 `description`


#### 如何设置文章系列 {#如何设置文章系列}

同样还是以本文为例

```org
*** TODO Emacs中的个人信息管理 — 日记/笔记/博客 :Org:
:PROPERTIES:
:EXPORT_FILE_NAME: pim-in-emacs-gtd-daily-note-blog
:EXPORT_HUGO_CUSTOM_FRONT_MATTER: :series [ "Emacs 中的个人信息管理" ]
:END:
```

其中 `:EXPORT_HUGO_CUSTOM_FRONT_MATTER: :series [ "Emacs 中的个人信息管理" ]` 就是设定当前文章的系列名称，可以是多个。如果需要在博客中显示出来，那么还需要在 `hugo.toml` 中配置

```toml
[taxonomies]
series = 'series'
tag = 'tags'

[[menu.main]]
identifier = 'series'
name = '系列'
url = '/series/'
weight = 10
```

如有需要，还可以定制指定的系列详情页。


## 后续 {#后续}

以后可能会有 财务记账、anki集成或者浏览器书签管理等内容。
