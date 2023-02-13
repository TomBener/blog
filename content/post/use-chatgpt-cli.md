---
title: 一日一技｜在命令行中使用 ChatGPT
date: 2023-02-12T18:01:41+08:00
categories:
    - ChatGPT
---

{{< admonition type=warning title="⚠️ 注意" >}}
由于 OpenAI 可能会关闭或改变 API，本文介绍的方法随时可能失效。
{{< /admonition >}}

<br>

自从人工智能聊天机器人 ChatGPT (Chat Generative Pre-trained Transformer) 在去年 11 月 30 日推出以来，它的表现让人们大呼惊艳，不少人纷纷表示下一个全新时代——「人工智能时代」即将到来，由此带来了 ChatGPT 在互联网上的持续火爆。

简体中文互联网作为一个特殊的存在，在 ChatGPT 推出近两个月后，也就是最近一两周，它才在这里引起了人们的广泛讨论。然而，由于 [OpenAI](https://openai.com/) 并未对中国用户开放注册，且对网络条件要求相当苛刻 [^EB6]，绝大多数中文互联网用户实际上无法直接使用 ChatGPT。另一方面，ChatGPT 的活跃用户数已经 [超过一亿](https://www.reuters.com/technology/chatgpt-sets-record-fastest-growing-user-base-analyst-note-2023-02-01/)，经常出现负载过高而无法登录或使用的情况，不少用户对此心有抱怨，因此 OpenAI 顺势推出了 [ChatGPT Plus](https://openai.com/blog/chatgpt-plus/)——每月 20 美元，可以增加高峰时期的可用性，获得更快的响应速度，以及优先使用新功能。

[^EB6]: 你可以使用这个 [Shell 脚本](https://github.com/missuo/OpenAI-Checker) 测试一下自己的 IP 能否访问 OpenAI。

遗憾的是，本文介绍的在命令行中使用 ChatGPT 的方法，并不能解决以上两个问题——你仍然需要拥有一个 OpenAI 账号，并且可以正常登录 ChatGPT 网页版，可能仍然还是会遇到拥堵的情况。不过，在命令行中使用 ChatGPT，本身不就是一件足够有趣的事情吗？

## 先决条件

本文使用的是 GitHub 上的一个开源项目 [waylaidwanderer/node-chatgpt-api](https://github.com/waylaidwanderer/node-chatgpt-api)，需要具备以下这几个先决条件：

- [Node.js](https://nodejs.org/) >= 16.0.0
- [npm](https://www.npmjs.com/)
- [Docker](https://www.docker.com/)（可选）
- 成功登录 [ChatGPT 网页版](https://chat.openai.com)

## 安装与配置

使用以下命令在本地安装该项目：

```shell
npm i @waylaidwanderer/chatgpt-api
```

或者使用以下命令全局安装该项目：

```shell
npm i -g @waylaidwanderer/chatgpt-api
```

如果你是像我一样的尝鲜用户，推荐使用直接下载源代码的方式：

```shell
git clone https://github.com/waylaidwanderer/node-chatgpt-api
```

然后进入下载的文件夹 `node-chatgpt-api` 中，执行下面这行命令，安装所需依赖：

```shell
npm install
```

接下来将根目录下的 `settings.example.js` 重命名 `settings.js`，其中的内容为：

```javascript
module.exports = {
    // Your OpenAI API key (for `ChatGPTClient`)
    openaiApiKey: process.env.OPENAI_API_KEY || 'accessToken',
    chatGptClient: {
        // (Optional) Support for a reverse proxy for the completions endpoint (private API server).
        // Warning: This will expose your `openaiApiKey` to a third-party. Consider the risks before using this.
        // reverseProxyUrl: 'https://chatgpt.pawan.krd/api/completions',
        // (Optional) Parameters as described in https://platform.openai.com/docs/api-reference/completions
        modelOptions: {
            // You can override the model name and any other parameters here.
            // model: 'text-chat-davinci-002-20221122',
        },
        // (Optional) Set custom instructions instead of "You are ChatGPT...".
        // promptPrefix: 'You are Bob, a cowboy in Western times...',
        // (Optional) Set a custom name for the user
        // userLabel: 'User',
        // (Optional) Set a custom name for ChatGPT
        // chatGptLabel: 'ChatGPT',
        // (Optional) Set to true to enable `console.debug()` logging
        debug: false,
    },
    // Options for the Keyv cache, see https://www.npmjs.com/package/keyv.
    // This is used for storing conversations, and supports additional drivers (conversations are stored in memory by default).
    // Does not apply when using `BingAIClient`.
    cacheOptions: {},
    // Options for the Bing client
    bingAiClient: {
        // The "_U" cookie value from bing.com
        userToken: '',
        // (Optional) Set to true to enable `console.debug()` logging
        debug: false,
    },
    // Options for the API server
    apiOptions: {
        port: process.env.API_PORT || 3000,
        host: process.env.API_HOST || 'localhost',
        // (Optional) Set to true to enable `console.debug()` logging
        debug: false,
        // (Optional) Set to "bing" to use `BingAIClient` instead of `ChatGPTClient`.
        // clientToUse: 'bing',
    },
    // Options for the CLI app
    cliOptions: {
        // (Optional) Set to "bing" to use `BingAIClient` instead of `ChatGPTClient`.
        // clientToUse: 'bing',
    },
    // If set, `ChatGPTClient` will use `keyv-file` to store conversations to this JSON file instead of in memory.
    // However, `cacheOptions.store` will override this if set
    storageFilePath: process.env.STORAGE_FILE_PATH || './cache.json',
};
```

由于现在无法直接使用 OpenAI 的 API，这个项目（[1.15.1](https://github.com/waylaidwanderer/node-chatgpt-api/commit/06117e6321de6bb3d177ae8c8a7d97097a4ecd98)）目前使用反向代理的方式来调用 OpenAI API。在浏览器中成功登录 ChatGPT 网页版之后，你需要访问 <https://chat.openai.com/api/auth/session> 获取登录 session 的 `accessToken` [^477]，然后用复制得到的一长串字符替换上面代码第 3 行中的 `accessToken`。最后，将第 7 行取消注释，也就是将这一行最前面的 `//` 删除。

[^477]: 需要注意的是，这会将你的 API key 暴露给第三方服务器，如果你介意的话，可以使用 `text-davinci-003` 模型，但需要付费，效果也比不上 `text-chat-davinci-002` 模型。

## 使用 ChatGPT

做好以上安装和配置，就可以在命令行中正常使用 ChatGPT 了。首先进入项目文件夹，例如我放在 `Downloads` 中，那么就可以直接通过下面这行命令进入：

```shell
cd Downloads/node-chatgpt-api
```

然后执行以下命令启动：

```shell
npm run cli
```

如果一切顺利，会出现下图所示的界面：

![](https://p15.p3.n0.cdn.getcloudapp.com/items/E0uRkml5/28e31929-9857-4252-911a-e8f0805feb14.png)

然后你就可以开始愉快地和 ChatGPT 在命令行中聊天了，它的回复内容会自动复制到剪切板中，还可以使用 `!` 调出 6 个快捷命令。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/yAuAOnox/f147d69f-9f72-4029-b5d3-c8d1b07084c6.png)

![](https://p15.p3.n0.cdn.getcloudapp.com/items/4gu4oRzo/488d2920-b3f1-441b-bbc0-b23e46050b7a.png)
