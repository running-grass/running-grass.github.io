+++
title = "函数式编程之旅(二)——初窥门径"
date = 2020-07-21T11:08:00+08:00
lastmod = 2024-01-31T11:23:30+08:00
draft = false
weight = 2003
+++

一等公民是基石，纯函数是核心，柯里化是手段，函数组合是目的

<!--more-->

&gt; 本系列只做抛砖引玉


## 一等公民 {#一等公民}

一等公民是函数式编程世界中的基础法则，是构建整个世界的基石。那什么是\__一等公民__呢，一本国外教材中给的解释如下：
&gt; In general, a value in a programming language is said to have ﬁrst-class status if it can be passed as a parameter, returned from a subroutine, or assigned into a variable.

函数如果作为一等公民，可以做以下三件事：

-   函数的参数可以是一个函数
-   函数的返回值可以为另一个函数
-   函数可以赋值给一个变量

举例如下：

```javascript
function fn() {
    // do someing
}
var g = fn;
```

定义一个函数fn，然后把fn赋值给g


## 纯函数 {#纯函数}

纯函数有以下两个特点：

-   无副作用
-   引用透明
-   有返回值

我们先看第一点\`无副作用\`，那什么是\*\*副作用\*\*呢？


## 无副作用 {#无副作用}

下面给出一些反面案例


### 直接修改数据结构 {#直接修改数据结构}

```javascript
function f(obj) {
    obj.name = "f";
    return obj;
}
```


### 修改外部变量或全局变量的值 {#修改外部变量或全局变量的值}

```javascript
var outter = {name: "outter"};
function f(obj) {
    outter.name = obj.name;
    return obj;
}
```


### 抛出异常或以错误终止 {#抛出异常或以错误终止}

```javascript
function f(obj) {
    throw new Error("error")
}
```


### 进行IO操作 {#进行io操作}

包含文件IO和网络IO等

```javascript
function f(obj) {
    return fetch('https://xxx.com/post/1');
}
```

****以上的函数均不是纯函数。****


## 引用透明 {#引用透明}

给定相同的输入，函数总是返回相同的输出。

```javascript
function addOne(x) {
    return x + 1;
}
addOne(7);
```

对于\`addOne(7)\`，无论调用多少次，都会返回同一个数值\`8\`。因此所有出现\`addOne(7)\`的地方都可以使用数字\`8\`替换掉，而不会引发任何问题，这就是\*\*引用透明\*\*.
\### 有返回值如果一个函数既没有副作用，也没有返回值，那么相当于这个函数什么也没有做。所以我们认为纯函数是必须要有返回值的。


## 数据不可变 {#数据不可变}

如果有人用过\`Immutable.js\`的话，肯定会数据不可变这个特性多有了解了。数据不可变对应着\`纯函数\`无副作用特性中的不能直接修改数据结构，数据不可变和纯函数是相辅相成的概念。数据不可变要求函数不可以改变传入的参数，而是要返回一个全新的对象，这样对新对象进行修改，是不会破坏原对象的数据的。


## 高阶函数 {#高阶函数}

这个概念是一等公民的应用，把函数作为参数或者返回值进行传递，就是一个高阶函数。举三个例子：

```javascript
function applyOne(f, x) {
    return f(x);
}

function addX(x) {
    return y => x + y;
}

function wrapAdd(f) {
    return x => f(x + 1)
}
```

以上三个函数都是属于高阶函数。


## 偏函数 {#偏函数}

也叫做\`偏应用函数\`，\`部分应用函数\`.
&gt; 对于一个具有n(n &gt;= 1)个参数的多参函数f，如果先传入m(m &lt;= n)个参数，此时不会真正执行函数f，而是会返回一个新的函数f'，调用f'时只需要传入n-m个参数，便可以真正的执行函数f.

描述起来有点绕，我们来看个例子：

```javascript
function add(x, y, z) {
    return x + y + z;
}

let f1 = add.bind(null, 1, 2, 3)
f1() // => 6

let f2 = add.bind(null, 1, 2)
f3(3) // => 6

let f3 = add.bind(null, 1)
f3(2, 3) // => 6
```

上面的\`f1\`,\`f2\`,\`f3\`都是偏函数


## 柯里化 {#柯里化}

柯里化的概念和偏函数的概念是交织在一起的，上面一节我们把\`add\`函数编程偏函数\`f1\`的过程如果再通用一些，就是柯里化。

```javascript
function addCurried(x) {
    return function(y) {
        return function(z) {
            return x + y + z;
        }
    }
}
addCurried(1)(2)(3) // => 6
```

上面我们便构建了一个柯里化版本的\`add\`函数。那么这样做的好处是什么呢？


### 固定参数使参数复用 {#固定参数使参数复用}

```javascript
addThree = addCurried(1)(2);
addThree(3) // => 6
addThree(5) // => 8
addThree(10) // => 13
addThree(96) // => 99
```

\`addThree\`便是固定了前两个参数1和2。


### 延迟执行 {#延迟执行}

上面的例子中，\`addCurried(1)(2)\`之后并没有真正的执行加法运算，而是把前两个参数保存起来，等到传入最后一个参数的时候才会真正执行运算。
\## 函数组合说了这么多特性，很多人会觉得这就是没事找事儿啊，可以的制作出那么多概念来。其实呢，上面的这些特性都是为了函数组合而服务的。函数式编程的理念告诉我们每个函数只做一件单一的小事情，通过函数名就能知道这个函数的功能，那么碰到稍微复杂一点的逻辑怎么办呢？这时候就需要把单一的小函数使用各种不同的组合结构来组合在一起。
&gt; 以下的变量\`R\`为[Ramda](<https://ramda.cn/docs/>)的全局变量，

```javascript
let arr = [1, 2, 3, 4, 5];

let doSoming = R.pipe(
    R.filter(x => x <= 3),  // [1, 2, 3]
    R.map(x => x * 2),      // [2, 4, 6]
    R.reduce(R.add, 0));    // 12

doSoming() // 12
```

这个例子中，我们使用了pipe(管道)把三个函数按照顺序首尾相连。
&gt; filter的输入为arr，输出为[1, 2, 3]
map的输入为filter的输出[1, 2, 3]， map的输出为[2, 4, 6]
reduce的输入为map的输出，reduce的输出为12

这只是一种最简单的组合方式，还可以加入一些分支判断等。


## 无参风格 {#无参风格}

也叫做\`Pointfree\`,提倡的是尽量的去组合已有的函数，而不是写各种匿名函数把以后函数再封装。

```javascript
arr.map(x => f(x)) // no-pointfree

arr.map(f)         // pointfree

pipe(                        // no-pointfree
    x => add1(x),
    x => mult4(x),
    x => toString(x)
)(4)

pipe(add1, mult4, toString) // pointfree
```

&gt; 以上是本人对函数式编编中的特点与概念的一些粗浅理解，如有错误及不足之处，请批评指正。
