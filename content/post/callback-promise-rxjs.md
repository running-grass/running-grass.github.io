+++
title = "异步——从Callback到Promise再到Rxjs"
date = 2017-08-31T00:00:00+08:00
lastmod = 2024-02-01T16:31:20+08:00
draft = false
aliases = ["/post/08/31/2017-08-31-callback-promise-rxjs/"]
+++

异步编程从以前的晦涩难懂，到现在的简单明了，从以前的功能单一，到现在的功能强大。

<!--more-->


## Callback {#callback}

在远古时代，人们为了实现异步编程，通常采用callback的形式，定义好一个回调函数，在需要异步请求的地方，注册回调函数，等异常请求返回后，把数据传入回调函数，对异步请求的结果进行处理。

如下所示:

```javascript
const callback = () => {
    console.log('I am a callback');
}

console.log('Hello');
setTimeout(callback, 1000);
console.log('world);
```

这样的方式初看起来简单明了，但是它经不起复杂度的考验，如果是多个异步的嵌套，就会立刻变得晦涩，继续上代码

```javascript
const log = console.log;
setTimeout(() => {
    log('我是第一层');
    setTimeout(() => {
        log('我是第二层');
        setTimeout(() => {
            log('我是第三层');
            setTimeout(() => {
                log('我是第四层');
            }, 1000)
        }, 1000)
    }, 1000)
}, 1000);
log('hello')
```

这样的代码不利于阅读，也不利于维护，接下来出现的是Promise，一个很重要的类型


## Promise {#promise}

Promise 是代表一个承诺，它可以承诺在一定的时间内，他会完成他的事件或者抛出错误。换句话说，它刚生成时，他的状态是不确定的，在一定时间后，他的状态肯定会确定下来，同时只有两种情况，一种是顺利完成，一种是出错异常。在编写代码过程中只需要监听这两个状态就可以对其结果进行处理，通过链式调用的方式可以使代码更加易读。下面是使用Promise的模拟耗时的异步操作

```javascript
const reqPromise = new Promise((resolve, reject) => {
    setTimeout(() => {
        console.log('Request完成');
        resolve({data: 1})
    },1000)
})

reqPromise.then(x => console.log(x));
```

是不是看起来更麻烦了呢？ 那么我们稍微增加一点复杂度看看。下面是Promise嵌套的情况:

```javascript
const getPromise = x => new Promise((resolve, reject) => {
    setTimeout(() => {
        console.log(x);
        resolve({data: 1})
    },1000)
});

getPromise('第一层').then(x => getPromise('第二层'))
    .then(x => getPromise('第三层'))
    .then(x => getPromise('第四层'))
    .then(x => getPromise('第五层'))
```

上面这段用Promise写的比直接使用Callback写的相比，是不是清晰了很多啊使用扁平的链式调用替代多层级的嵌套结构,对于代码维护起来也是清晰很多。

但是到此我们就满足了吗？

No，链式调用依然存在一些书写上的问题，上面的例子全都是异步代码，如果需要写同步代码的话，需要在Promise外面去写，异步代码是在Promise的resolve里面去写，这样丧失了代码的可读性。能不能把所有的代码都看成是同步的呢？ 这样代码风格不就统一了吗？

最新的es2017版本中有了async/swait的写法，它并不是一个新的功能，可以看做是Promise的语法糖。

我们把上面的Promise代码改一下如何：

```javascript
const getPromise = x => new Promise((resolve, reject) => {
    setTimeout(() => {
        console.log(x);
        resolve({data: 1})
    },1000)
});

const run = async () => {
    await getPromise('第一层').then(x => console.log('我是第一层的Resolve'))
    console.log('我是第一层之后的同步代码');
    await getPromise('第二层').then(x => console.log('我是第二层的Resolve'))
    console.log('我是第二层之后的同步代码');
    await getPromise('第三层').then(x => console.log('我是第三层的Resolve'))
    console.log('我是第三层之后的同步代码');
};

// 启动
run();
```

各位觉得这样的代码看起来如何呢？

我们从一开始Callback的那种一堆压缩成了Promise的一条线。然后又把这条线用async/await折叠成了四方的纸。有么有感觉到巨大的进步呢？

别着急，我们可以继续思考一下。能不能把同步和异步的代码全部当成异步来操作呢。这样是不是也可以去规范代码书写啊？

于是响应式编程应时而生。


## Rxjs {#rxjs}

Rxjs并不等于响应式编程，它只是RP(Reactive Programming)的一个类库实现，但是因为它在几乎所有主流语言上都有实现，所有rx算是rp中的中坚力量了吧。

在深入介绍rxjs之前，我们先用rxjs代码实现以上的那个例子.

```javascript
const { Observable: ob} = require('rxjs');

const getPromise = x => new Promise((resolve, reject) => {
    setTimeout(() => {
        console.log(x);
        resolve({data: 1})
    },1000)
});

ob.from(getPromise('第一层'))
    .map(x => console.log('我是第一层之后的异步代码'))
    .flatMap(x => getPromise('第二层'))
    .map(x => console.log('我是第二层之后的异步代码'))
    .flatMap(x => getPromise('第三层'))
    .map(x => console.log('我是第三层之后的异步代码'))
    .flatMap(x => getPromise('第四层'))
    .map(x => console.log('我是第四层之后的异步代码'))
    .flatMap(x => getPromise('第五层'))
    .map(x => console.log('我是第五层之后的异步代码'))
    .subscribe()
```
