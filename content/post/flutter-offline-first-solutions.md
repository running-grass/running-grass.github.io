---
title: "调研在Flutter中支持离线优先的数据库"
date: 2021-12-02
lastmod: 2024-02-02
draft: false
aliases:
  - /post/flutter-offline-first-solutions
---

本文调研了10余种客户端数据库方案。用于在 `Flutter` 中支持离线优先的数据库。

<!--more-->


## 背景 {#背景}

之前用rxdb做了一个简单的web应用。应用数据存在在浏览器端，可以通过在服务器上面couchdb服务来进行数据同步。最近想要把这个web应用从purescript架构重构为flutter架构。但是flutter是不支持rxdb的，所以需要找一个类似的解决方案，在 flutter 框架下支持android、macos。需要的特性有：

1.  支持android、macos，最好也支持ios，web，windows
2.  支持离线优先、无感切换，当无网络的时候使用存储在客户端的数据库，网络恢复时自动把数据同步到服务端。
3.  支持flutter的sdk
4.  最好可以不需要自己搭建服务器


## 方案 {#方案}


### Firestore {#firestore}

google自己的产品，是一个no-sql数据库
\### 优点

1.  不需要自己维护服务器
2.  可以配合firebase其它的服务，例如认证服务
3.  上面几个要求都能满足


#### 缺点 {#缺点}

1.  服务商绑定，上了google的船
2.  google服务在国内用不了


### Parse {#parse}

著名的firebase开源替代品，可惜暂时还不支持离线优先。如果不考虑离线的话，的确是一个很棒的bass(Backas a service)。


### Appwrite {#appwrite}

另外一个开源bass应用，看到在issue中有考虑离线优先，但是还未实现


### Space Cloud {#space-cloud}

另外一个bass，也是不支持离线优先


### Kuzzle {#kuzzle}

另外的bass，依旧不支持离线优先


### supabase {#supabase}

在考虑，还未支持


### SapphireDB {#sapphiredb}

支持离线优先，但是只支持js sdk


### sporran {#sporran}

flutter的一个库，但是只支持web平台


### Couchdb+Wilt {#couchdb-plus-wilt}

基于网络api的，不支持离线


### brickk offline first {#brickk-offline-first}

适合于查询 支持android和ios两个平台，仅支持查询缓存。


### Couchbase {#couchbase}

在flutter中有两个库可以提供支持，不是官方的支撑，还不太成熟需要一个同步网关，自建后端


### Realm {#realm}

realm目前在前端平台的支持很广，同时也可以使用Mongodb Realm
Sync作为同步服务器。不过可惜的是，flutter 还处于alpha版本（截止2021年）


## 结论 {#结论}

除去自己动手同步sqlite之外现成的方案只有Realm，couchbase，firestore三种了，firestore因为网络问题可以先不用，couchbase后期的维护不太可靠，只能把希望寄托于realm和mongodb了。先暂时使用realm做重构，试用一段时间再来写试用报告吧。
