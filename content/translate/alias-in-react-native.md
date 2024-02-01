+++
title = "React Native中的别名"
date = 2024-02-01T16:30:00+08:00
lastmod = 2024-02-01T16:30:26+08:00
draft = false
aliases = ["/post/08/18/2017-08-18-alias-in-react-native/"]
+++

有时候，你会在你的项目有多个文件和文件夹。我们需要从任意随机文件中获得一个文件的引用。如果我们这样的相对路径的话，看起来是这个样子的:

```javascript
import themes from '../../config/themes';
```

通过符号\`../\`让我们很难去思考，在更复杂的项目中，这将是一个噩梦。

<!--more-->

在这篇文章中，我们将找到关于这种场景的可能的解决方案和替代方案。

假定项目有以下文件夹结构。

```example
 Your App Root Directory
|-- app
     |-- component
     |    |-- login
     |    |   |-- login.js
     +-- resources
     |    |-- icon
     |    |    |-- userupload.png
     |-- index.ios.js
     |-- index.android.js
```

我们有两种可能的解决方案用来在上面的文件夹结构中指出每个节点。


## Use @providesModule {#use-providesmodule}

一个次级的解决方案，可以工作，但不是\*\*安全\*\*的，在你的文件中使用\`@providesmodule\`。这是用较少的代码，但是因为它是基于Facebook自己内部使用的情况下，可以根据其内部突发奇想改变。所以可能不稳定。你可以阅读更多关于它在这里：<https://github.com/facebook/fbjs>

要使用它，您需要将此注释包含在文件的顶部：

```javascript
/**
 * @providesModule login
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';

export default class login extends Component{
    render(){
        return(
            <View>
                <Text> this is login page
                </Text>
            </View>
        );
    }
}
```

然后你可以像上面一样导入它：

```javascript
import themes from 'login';
```


## 使用\`babel-plugin-module-alias\` {#使用-babel-plugin-module-alias}

一个\`babel\`插件用来在Babel编译过程中以不同的目录重写(map, alias, resolve)

使用方法：

Install babel cli

```text
npm install --g babel-cli
```

Install  babel-plugin-module-alias.

```text
npm install --save babel babel-plugin-module-alias
```

在根目录创建一个文件\`.babelrc\`或者在项目的\`package.json\`中增加\`babel:\`的键，然后添加以下代码

```json
"babel":{
  "plugins": [[
    "module-alias", [
      { "src": "./app", "expose": "app" },
      { "src": "./app/resources/icon", "expose": "icon" }
      ]
   ]]
 }
```

最后清除缓存并重新启动节点服务器。

```bash
npm start -- --reset-cache
```

完整的源代码可以从[这里](<https://github.com/tigerraj32/ReactNative/branches/all>)下载
