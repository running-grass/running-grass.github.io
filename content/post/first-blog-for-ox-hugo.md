+++
title = "使用ox-hugo写博客"
date = 2020-10-22T15:10:00+08:00
lastmod = 2024-02-01T16:31:27+08:00
draft = false
+++

&gt; 本文是使用ox-hugo发表的第一篇文章


## 阅读前提 {#阅读前提}

-   知道Emacs和Org是什么
-   知道hugo或其它SSG[^fn:1]程序


## 为什么要使用ox-hugo {#为什么要使用ox-hugo}

1.  可以使用强大的Emacs
2.  可以使用Org格式，同时利用其TODO和文学编程的功能
3.  可以和基于Org的GTD系统相结合
4.  可以使用Org-capture来快速的记录博客灵感


## 安装ox-hugo {#安装ox-hugo}

```emacs-lisp
;; 我是使用use-packge,其它方式见文档
(use-package ox-hugo
  :after ox)
```


## 配置ox-hugo {#配置ox-hugo}

我的hugo目录为 ~/workspace/blog/
博客文章的目录为 ~/workspace/blog/content/post/
博客文章的Org目录为 ~/workspace/blog/content-org/

```emacs-lisp
(use-package ox-hugo
  :after ox
  :config

  (setq
   ;; 设置在文件导出到content下的哪个目录，我的这个是 content/post
   org-hugo-section "post"
   ;; 设置文章的最后修改时间为导出时间
   org-hugo-auto-set-lastmod	t
   )
  ;; 设置在org文件保存的时候自动导出到org-hugo-section下
  (org-hugo-auto-export-mode)
  )
```

想要实现自动导出还需要在hugo根目录下新建一个文件

```emacs-lisp
;; .dir-locals.el
(("content-org/"
  . ((org-mode . ((eval . (org-hugo-auto-export-mode)))))))
```

在Org文件最前面设置

```org
#+HUGO_BASE_DIR: ~/workspace/blog/
#+TODO: TODO DONE
```

HUGO_BASE_DIR这个属性是每个Org文件必须设置的，指定hugo的根目录，配合org-hugo-section之后导出路径为 ~/workspace/blog/content/post/
TODO这个属性为选填的，为了覆盖全局设置。
&gt; 任务状态为TODO时，导出后为草稿，任务状态切换至DONE时，导出后为正式文章.

&gt; 在从TODO切换到DONE时，会在Org标题下生成CLOSED: `[2020-10-22 四 16:10]`, 如果未指定发布时间的话，则自动采用该CLOSED时间


## 开始写文章 {#开始写文章}

-   在org文件中新建一个文件，例如我的是~/workspace/blog/content-org/post.org

-   在文件头部添加必要的属性#+HUGO_BASE_DIR: ~/workspace/blog/

-   在文件中新增一个标题为文章标题，例如“使用ox-hugo写博客”， 增加一个TODO关键字
-   并且增加一个属性， 指定生成的文件名称
    ```org
    :PROPERTIES:
    :EXPORT_FILE_NAME: first-blog-for-ox-hugo
    :END:
    ```
-   开始写正文，例如你正在看到的文字
-   把TODO状态切换至DONE
-   保存Org,如果开启了Hugo server的话，是可以在浏览器上面实时查看改动的。


## 参考链接 {#参考链接}

-   [ox-hugo官网](<https://ox-hugo.scripter.co/>)
-   [ox-hugo配置](<https://cloud.tencent.com/developer/article/1530404>)
-   [使用 Emacs + ox-hugo 来写博客](<http://blog.jiayuanzhang.com/post/blog-with-ox-hugo/>)

[^fn:1]: 静态网站生成工具
