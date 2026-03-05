---
title: "最近写Purescript项目的一些感悟"
date: 2021-08-31
lastmod: 2024-02-01
tags:
  - PureScript
  - Haskell
  - 函数式编程
draft: false
aliases:
  - /post/some-insights-on-using-purescript-recently
---

这篇文章是我使用PureScript(下文简称Purs)这几个月的一些碎碎念，纯主观看法且带有偏见，非教程，轻喷。

<!--more-->


## 学习资料不多 {#学习资料不多}

-   资料说不上少，但也算不上多。读过的四个比较系统点的文档
    -   首先是官方文档仓库的 [语法参考](https://github.com/purescript/documentation/blob/master/language/README.md)
    -   然后是一本电子书 [Puresctipt By Example](https://book.purescript.org/)
    -   然后是 [PureScript: Jordan's Reference](https://jordanmartinez.github.io/purescript-jordans-reference-site/)
    -   最后是类库的API文档 [Pursuit](https://pursuit.purescript.org/)
-   其中最实用的感觉还是 Jordan's 的Reference，还有一个项目 cookbook，不过上面就全是各种示例了


## 安装过程有点不太友好 {#安装过程有点不太友好}

-   使用npm装好purescript的编译器， 再安装包管理工具Spago，由于我是用的nix-shell，外部shell安装了一个版本的purescript，nix-shell内安装了另外一个版本的purescript，导致spago使用的时候 一直报版本不对应，自己折腾好一会才发现问题。
-   在国内使用spago偶尔会出现网络问题，科学上网也不行，只能多install几次，才能成功。


## 和Haskell很像的语法 {#和haskell很像的语法}

-   在语法上很舒适，函数调用可以不使用小括号是我喜欢Haskell最粗暴的原因
-   基于空格的层级控制也让代码更加干净整洁


## 强大的特性 {#强大的特性}

-   代数数据类型，一直在用，但是一直不太了解其本质是啥，我也解释不清楚 T \_{ T}
-   函子/单子/TypeClass 这些函数式中强大的武器，我目前也没体会到TypeClass比OO中的Interface强大在哪里，不过呢，看起来就高级一些呢
-   和Js生态的集成，通过FFI，可以导入JS生态中的Npm库，并且给予其恰当的类型，Purs中的Record对应js中的Object，但是目前还不适应Record的深层修改，我知道Lens用来处理这方面很优雅，还未来得及学习。
-   通过Effect类型隔离所有的副作用。但是还是有很多途径把副作用从Effect释放出来，犹如打开潘多拉魔盒。例如使用一些unsafe的函数，或者自己写的一个FFI函数，函数实现中带有副作用，但是却未在类型中声明。这个就只能靠自觉了
-   Function Sting Sting Boolean这种不太直观的方式了。
-   多用newTypp，少用data.通过derive newtype来派生包装器内部类型的实例还是很方便的呢
-   还有一些类型空间编程的特性，仅耳闻，未实战。


## 前端web工程 {#前端web工程}

-   把Purs用在web项目中，可以有两种形式。
-   第一种是在一个JS为主的项目中，按需引用.purs文件。借助webpack等工具自动build。这种方式比较适合在生产代码中小规模试用purs。
-   第二种是只在webpack的入口js文件中引入Main.purs，后续的事情就交给Main.purs来创建应用了。这样的话，大多数都是purs代码，存在一小部分FFI代码。
-   我目前在项目中会有 以下 几种情况会写js代码。
    -   针对npm库写一些binding
    -   一些用purs不知道怎么写或者特别费事的代码，会临时写段js代码顶上。


## Web前端框架 {#web前端框架}

-   目前比较流行的有两个 ，一个react的binding，一个纯Purs方案，halogen。还有几个更小众的purs前端框架，没去细了解过。
-   而我选用的Halogen， 目前发现halogen没有开箱即用的组件库。有个formless和selector，看了看没看懂，就暂时先不用了。
-   值得一提的是halogen有一个React-hook的类似实现——purescript-halogen-hooks，它和react-hooks还是有一些区别的。目前没看太懂。还有一个新写的 halogen-store，是一个类似redux的数据仓库的解决方案，它的实现是封装了一下ReaderT，用起来没啥大问题。


## 设计模式 {#设计模式}

-   设计模式这块，不像OO里面那么成熟和繁多，或者说typeclass本身就是一些设计模式的实现——比OO的还要优雅。例如monad、foldable，newtype等。 由于purescript实在小众，好在有Haskell的研究成果可以看看，在知乎上一一个系列的Haskell设计模式的译文。还未来得及学习，先放个链接。
    -   [haskell中的设计模式：序](https://zhuanlan.zhihu.com/p/358493281)
-   还有一些关于Haskell代码架构方面的博文。
    -   [The ReaderT Design Pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern/)
    -   [Three Layer Haskell Cake](https://www.parsonsmatt.org/2018/03/22/three_layer_haskell_cake.html)
    -   [CAPABILITY: THE READERT PATTERN WITHOUT THE BOILERPLATE](https://www.tweag.io/blog/2018-10-04-capability/)
-   但是我都没有读太懂，勉勉强强能用来干活而已。
-   我目前的代码是根据purescript-halogen-realworld中的demo，把应用分为三层。
    -   全局状态层(状态层)，在应用(页面)被渲染之前被初始化，存放着一个Store. 包括全局配置、数据库连接、日志级别等。可以定义一个Reducer，通过定义不同的Action来完成对Store数据的更新。
    -   副作用接口层(副作用层)，把应用需要使用的各种副作用从页面中剥离出来由这一层统一管理，在页面组件的代码中不直接调用有副作用的代码。包括数据库增删改查、记录日志、路由导航、随机数、当前时间等。可以通过getStore来取到Store数据
    -   页面组件层(视图层)，包括各种页面、组件、html片段、工具函数，这一层只写纯函数。涉及到副作用的就会调用上一层的接口。需要读取应用配置的，可以通过connect函数把Store和组件连接起来。在组件初始化的时候读取全局状态。
-   然后再新建一个自己的AppM，它是一个实现了副作用层所有接口的Monad，并且它连接了状态层。所以可以从状态层取出数据库连接，进行增删改查
-   最后在Main.purs中读取应用配置，建立数据库连接，初始化状态层，使用runAppM把AppM和状态层注入到页面层的根组件(在我项目中为路由组件)。如果需要写测试用例，可以单独实现一个AppM，替换所有的副作用为mock数据。
-   作为一个前端，我从这个模型中收益良多。之前一直没有体会到vuex中actions的必要性。这个模型刚好可以和一个Vue(React同理)项目做类比。vuex中的stateh和getters相当于是状态层的状态数据。mutation相当于状态层的reducer。而vuex中的actions相当于是副作用层。如果这样的话，具体的vue组件所有的网络请求和其它的副作用，都应该通过actions来完成。页面级组件负责和副作用接口打交道，纯UI组件不应该和副作用接口层有任何直接交互。


## 其它问题 {#其它问题}

-   编译缓存处理不好，出现莫名其妙的问题在webpack下，更改了组件上的Monad约束，编译不会报错，但是在浏览器运行时会有一个运行时错误。=Uncaught TypeError: component.initialState is not a function=  这时必须手动触发一次Main.purs的编译才行，如果还不行，那就在把根组件也手动触发一次编译。
-   编译出来的js可读性太差，在调试阶段，针对一个运行时报错，很难定位到真实错误


## purs 和相关类似代码的比较 {#purs-和相关类似代码的比较}

-   purs vs typescript

    对于ts用的真不多，无疑ts的生态和入手难度肯定是占据上风。但是其依旧保留着js上面的一些问题。作为ts的超集，并没有带来编程思维上质的变化。很多时候，我们学习一门语言，主要学习的是其背后的编程思想。而ts除了强类型之外，并没有在编程思想上带来更多。
-   purs vs elm

    作为一门便于入门的类Haskell语法的前端语言。语言特性没有purs那么强大，优点就是简单易学。但是相应的局限性会很大。很多Haskell中的设计模式就不容易实现。无法借鉴Haskell社区中宝贵的财富
-   purs vs idris

    另外一个类似Haskell语法的通用型语言，语言特性比Haskell还要强大一些，但是生态太弱了。而且最新的Idris2和Idris1不兼容。尝鲜的话比purs强太多，可编译的后端也比purs多，但是和js的交互和生态上就比不上purs。
-   purs vs rescript
    1.  rescript生成的代码可读性更好，没有太多的闭包。理论上性能会比purs好。
    2.  rescript是对标typescript的，而purs是haskell编程范式在js上的复现。
    3.  rescript没有对副作用进行很好的隔离
    4.  rescript没看到有类型类/类型空间编程等高级特性
    5.  bucklescript更偏向js的语法，和js的互操作性可能会比purs还要好一些。
    6.  入门简单一些


## 结尾 {#结尾}

想絮叨的差不多就这么多了，以后有别的再补充吧。
