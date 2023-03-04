---
title: 个人用户如何使用 ChatGPT API
date: 2023-03-04
categories:
    - ChatGPT
---

{{< admonition title="🔖 Note" >}}
本文首发于 [少数派](https://sspai.com/post/78631)
{{< /admonition >}}

<h2>目录</h2>

- [图形化应用](#图形化应用)
  - [OpenAI Playground](#openai-playground)
  - [ChatGPT API 网页版](#chatgpt-api-网页版)
  - [OpenCat](#opencat)
- [命令行工具](#命令行工具)
  - [Python 脚本](#python-脚本)
  - [Python 命令行工具](#python-命令行工具)
  - [Curl](#curl)
- [Keyboard Maestro](#keyboard-maestro)
  - [方式一](#方式一)
  - [方式二](#方式二)
  - [方式三](#方式三)
- [其他使用方式](#其他使用方式)
  - [PopClip](#popclip)
  - [Bob](#bob)
  - [快捷指令](#快捷指令)
- [小结](#小结)

---
<br>

此前我介绍了 [在命令行中使用 ChatGPT](/post/use-chatgpt-cli) 的方法，但当时使用的开源项目 [waylaidwanderer/node-chatgpt-api](https://github.com/waylaidwanderer/node-chatgpt-api) 没有使用官方 API，经常出现失效的情况。尽管该项目已更新了好几个版本，但是想要使用它，完全取决于是否有可用的「[小道 API](https://github.com/waylaidwanderer/node-chatgpt-api#updates)」，可以说是相当艰难。

好消息是 OpenAI 在 2023 年 3 月 1 日发布了基于 `gpt-3.5-turbo` 模型的官方 [ChatGPT API](https://openai.com/blog/introducing-chatgpt-and-whisper-apis)，这个模型与 [ChatGPT 网页版](https://chat.openai.com/chat) 完全相同，但优势非常明显，一是响应速度快得多，几乎不会出现意外断开连接的情况，二是 API 对用户登录网络的限制非常少，这对于中国大陆网友非常友好，能够极大地拓展应用场景。

ChatGPT API 的价格为每 1000 个 tokens 0.002 美元，根据 [OpenAI 的介绍](https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them)，1 个 token 约等于 4 个英语字母，或者 0.75 个单词，换句话说，1 个英语单词约等于 1.33 tokens（1 个汉字约等于 2.33 个 tokens）。新注册的 OpenAI 账号会自动获得 18 美元的余额，拥有 900 万个 tokens 的请求量，你可以在注册或登录 OpenAI 账号之后，在 [这里](https://platform.openai.com/account/api-keys) 生成自己的 API key。

毫无疑问，企业用户将会是 ChatGPT API 的主要客户，可以预见，一大批基于 ChatGPT API 的应用将会迅速出现，未来处处是 ChatGPT 的应用场景 [正在到来](https://www.bensbites.co/p/wave-chatgpt-apps)。

{{< imgcap title="ChatGPT API 发布一天后出现的部分 AI 应用" src="https://p15.p3.n0.cdn.getcloudapp.com/items/llu7vPlg/ba5630dd-05ab-458e-90e8-e18444e188c6.png" >}}

那么对于个人用户来说，除了使用这些第三方应用封装的 ChatGPT 应用外，应该如何使用 ChatGPT API 来提高自己的学习和工作效率呢？本文就来分享一些个人使用 ChatGPT API 的方法，主要是在 macOS 平台上。由于关于 ChatGPT 的消息变化太快，无法保证内容的实效性，如果出现已变更或更新的情况，请前往原始链接查看相关信息。

## 图形化应用

### OpenAI Playground

OpenAI 提供了一个 [Playground](https://platform.openai.com/playground?mode=chat)，可以通过可视化的方式学习如何使用 `gpt-3.5-turbo` 的接口，也就是 ChatGPT API，有 Complete、Chat、Insert 和 Edit 四种模式，可以通过鼠标拖动调节各个参数，非常直观方便。不过有点遗憾的是，使用这个页面需要登录，并且要求账户中有余额。

{{< imgcap title="OpenAI Playground" src="https://p15.p3.n0.cdn.getcloudapp.com/items/qGuqyPgP/ebe39605-c42b-4ec9-b5f2-5061d7cf7a32.png" >}}

### ChatGPT API 网页版

除了 OpenAI 官方的示例，有网友利用自己的 ChatGPT API 制作了专属的网页版，可以像 ChatGPT 预览版一样，直接在浏览器中使用，比如 [这个](https://freegpt.one/)。与 ChatGPT 的官方页面相比，它的优势是完全免费、无需登录、速度超快、打开即用。

{{< imgcap title="基于 ChatGPT API 的网页应用" src="https://p15.p3.n0.cdn.getcloudapp.com/items/wbuDrjPY/8f79484a-35b7-498a-a6a1-364d7470d802.png" >}}

### OpenCat

如果你不想与其他人共享同一个 ChatGPT 应用，可以使用 [Baye](https://twitter.com/waylybaye) 开发的 [OpenCat](https://apps.apple.com/us/app/opencat/id6445999201)，制作一个专属于自己的 ChatGPT。下载 OpenCat 之后，首次打开会要求你填写你自己 API key，之后就可以直接打开使用了，这种方式可以获得极快的响应速度，同时还能避免点击恼人的「验证你是人类」。

{{< imgcap title="在 OpenCat 中通过 API key 使用 ChatGPT" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Kou9yxL0/12f7b954-c219-4517-9eda-89e80dff4d11.png" >}}

## 命令行工具

### Python 脚本

OpenAI 官方提供了一个 Python 库 [openai](https://github.com/openai/openai-python)，可以使用 `pip` 安装：

```shell
pip install openai
```

需要注意的是，使用 ChatGPT API 需要 `openai 0.27.0` 或更新版本，如果你的系统中安装了旧版本，需要通过下面的命令查看版本信息和更新，否则无法使用 ChatGPT API。

```shell
# Show openai info, including version
pip show openai

# upgrade openai package
pip install --upgrade openai
```

接下来就可以根据 [官方示例](https://platform.openai.com/docs/api-reference/chat/create)，写一个简单的调用 ChatGPT API 的 Python 脚本：

```python
import openai
# Get OpenAI API key at https://platform.openai.com/account/api-keys
openai.api_key = "YOUR_API_KEY"

completion = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    messages=[{"role": "user", "content": "Hello ChatGPT!"}]
)

print(completion.choices[0].message.content)
```

将其保存在一个文本文件中，命名为 `chat.py`，并将第 2 行的 `YOUR_API_KEY` 替换为你的 API key，然后在终端中执行 `python chat.py`，就会向 ChatGPT 发送一条消息 `Hello ChatGPT!`，稍等一下就会返回它的回答，比如这是它回答我的内容：

```text
Hello! How may I assist you today?
```

除了这种预先填写问题的方式，也可以使用 `input()` 的方式让用户输入问题，然后再返回 ChatGPT 的回答内容：

```python
import openai
openai.api_key = "YOUR_API_KEY"

user_input = input("Input Your Question: ")

completion = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    messages=[{"role": "user", "content": user_input}],
    # max_tokens=100
)

print(completion.choices[0].message.content)
```

在终端中执行 `python chat.py` 之后，会弹出一个提示输入语句 `Input Your Question:`，你需要按照提示输入问题，然后同样稍等片刻，便会返回 ChatGPT 的回复。

### Python 命令行工具

Python 库 `openai` 也提供了一个命令行工具，可以直接使用，而无需通过执行 Python 脚本来调用 ChatGPT API：

```shell
openai api chat_completions.create -m gpt-3.5-turbo -g user "Hello ChatGPT!"
```

这行代码中，通过 `$(pbpaste)` 将剪切板内容转换为命令行的标准输入，而最前面的 `pbpaste` 是为了一并把问题粘贴回来。`openai` 是调用 Python 库的命令行工具，`api chat_completions.create` 是指创建一个 ChatGPT 对话，`-m gpt-3.5-turbo` 是指使用 `gpt-3.5-turbo` 模型，`-g user` 是指提问者角色为 `user`。

需要注意的是，上面这行命令没有提供 API key，这是因为我将它保存在了 `.zshrc` 中，方便全局调用。你可以在 `.bashrc` 或 `.zshrc` 中添加一行命令：

```shell
export OPENAI_API_KEY='YOUR_API_KEY'
```

然后就可以全局调用。如果没有将 API key 保存在环境变量中，则需要修改上面的命令为：

```shell
pbpaste && openai -k YOUR_API_KEY api chat_completions.create -m gpt-3.5-turbo -g user "$(pbpaste)"
```

### Curl

[Curl](https://curl.se/) 是一个通过指定 URL 语法传输数据的命令行工具，它的普及性可以用「基础设施」来形容，在互联网应用中几乎无处不在，OpenAI 自然也提供了通过 Curl 来调用 ChatGPT API 的方式：

```shell
curl https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
  "model": "gpt-3.5-turbo",
  "messages": [{"role": "user", "content": "List five alternative words of happiness"}]
}'
```

这几行命令返回的结果是 JSON 格式，这对于需要使用结构化信息的场景很有用。如果你希望 Curl 只返回 ChatGPT 的回答信息，可以使用命令行工具 [jq](https://github.com/stedolan/jq) 从 JSON 中把它提取出来：

```shell
curl https://api.openai.com/v1/chat/completions \
  -s \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
  "model": "gpt-3.5-turbo",
  "messages": [{"role": "user", "content": "List five alternative words of happiness"}]
}' | jq -r '.choices[0].message.content'
```

这是上面这几行命令的返回结果：

```text
1. Joy
2. Bliss
3. Delight
4. Elation
5. Contentment
```

## Keyboard Maestro

前文介绍了在命令行中使用 ChatGPT API 的三种方式，它们的共同点是都需要打开终端再执行，略显麻烦。为了使用方便，我们可以将其改写一下，放在 macOS 上的自动化应用中来快速执行，比如 [Alfred](https://www.alfredapp.com/)、[LaunchBar](https://www.obdev.at/launchbar)、[Keyboard Maestro](https://www.keyboardmaestro.com/)。为此，我们需要将前面的代码略微修改一下，下面以 Keyboard Maestro 为例进行说明。

### 方式一

第一种执行 Python 脚步的方式需要将「从用户输入」改为「从 stdin 输入」，这是为了将拷贝的文字作为标准输入，以便放在 Keyboard Maestro 中执行：

```python
import sys
import openai
openai.api_key = "YOUR_API_KEY"

standard_input = sys.stdin.readline().rstrip()

completion = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    messages=[{"role": "user", "content": standard_input}]
)

print(completion.choices[0].message.content)
```

将这几行代码保存在 `chat.py` 中，保存在任意位置。然后制作一个下图中的 Keyboard Maestro 宏来运行这段 Python 代码，其中 `pbpaste` 是 macOS 自带的命令行工具，用来粘贴剪切板中的内容，你需要将下面的 `~/Library/CloudStorage/Dropbox/code/chat.py` 替换为你的系统中 Python 脚本的保存路径。另外，还要确保 Python 的安装路径在 Keyboard Maestro 的 [环境变量](https://wiki.keyboardmaestro.com/action/Execute_a_Shell_Script#Path_in_Shell_Scripts) 中，否则需要指明 Python 的绝对路径。

{{< imgcap title="在 Keyboard Maestro 中运行 Python 脚本使用 ChatGPT" src="https://p15.p3.n0.cdn.getcloudapp.com/items/7KuzdEl2/e7a3c6a8-e367-4554-b473-27a0b7af71ae.png" >}}

### 方式二

由于 `openai` 提供了命令行工具，我们可以直接在 Keyboard Maestro 中执行 Shell 脚本，这种方式不依赖外部文件，因此更加推荐：

```shell
pbpaste && openai api chat_completions.create -m gpt-3.5-turbo -g user $(pbpaste)
```

{{< imgcap title="在 Keyboard Maestro 中执行 Shell 脚本使用 ChatGPT API 的命令行工具" src="https://p15.p3.n0.cdn.getcloudapp.com/items/NQuWz7L9/8c796a72-97c3-4a22-9ae5-41a9bfed93cb.png" >}}

当选中一段文字后，按下快捷键 `⇧ + ⌃ + C` 两次，便可以向 ChatGPT 提问，然后同时返回问题和答案。

{{< imgcap title="在 macOS 上通过快捷键使用 ChatGPT" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Blub0xnJ/794b2dbc-2e67-43ab-b03e-68723e2b736d.gif" >}}

### 方式三

这种方式同样是在 Keyboard Maestro 中执行 Shell 脚本，不过使用的不是 Python，而是 Curl。下面的命令用 jq 将返回的 JSON 格式中提取出了 ChatGPT 回答的纯文字信息，如果你只需要得到 JSON 格式，可以将其移除。

```shell
curl https://api.openai.com/v1/chat/completions \
  -s \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
  "model": "gpt-3.5-turbo",
  "messages": [{"role": "user", "content": "'"$(pbpaste)"'"}]
}' | jq -r '.choices[0].message.content'
```

{{< imgcap title="在 Keyboard Maestro 中执行 Curl 命令使用 ChatGPT" src="https://p15.p3.n0.cdn.getcloudapp.com/items/OAuoO06g/34827d79-f6dc-4117-94ba-da715fc4373b.png" >}}

以上三种通过 Keyboard Maestro 使用 ChatGPT 的方式，最为推荐的是第二种，你可以根据需要选择合适自己的任意一种方式。除了以上使用 ChatGPT 的基本方式，即鼠标选中文字向 ChatGPT 提问，你还可以利用 Keyboard Maestro 的 [Conflict Palette](https://wiki.keyboardmaestro.com/manual/Palettes#Conflict_Palette)，制作在特定应用场景下使用的宏，比如对文字进行翻译、润色、总结、解释等，可以参考 [吴秉儒](https://twitter.com/WuPingJu/status/1631646790079635457) 的推文。

## 其他使用方式

### PopClip

PopClip 是一款通过简单的鼠标点击或手势，快速地完成剪贴板操作、文本处理、搜索等任务的工具，它会在选中文本时自动弹出一个小工具栏，提供一系列可选操作，如复制、粘贴、搜索、翻译、分享等，除此之外，它还支持许多第三方插件。

几天前，PopClip 开发者 [Nick Moore](https://forum.popclip.app/t/new-extension-chatgpt/1434) 制作了一个 [ChatGPT 插件](https://pilotmoon.com/popclip/extensions/page/ChatGPT)，可以选中文字，然后点击 ChatGPT 图标，在下方粘贴它的回复内容，按住 Shift 键则可以将回复内容拷贝到剪切板中。

{{< imgcap title="通过 PopClip 使用 ChatGPT" src="https://p15.p3.n0.cdn.getcloudapp.com/items/P8u2pn7L/15ace5a6-a96c-4220-8edf-bb4c86ab8520.gif" >}}

除此之外，也有网友制作了校对和润色选中文字的 PopClip 插件，比如 [ChatGPT Grammar Check Extension](https://hiraku.dev/2023/03/7425/)、[ChatGPT Proofreader Extension](https://reorx.com/makers-daily/003-chatgpt-proofreader-extension-popclip/)。

### Bob

[Bob](https://bobtranslate.com) 是一款 macOS 平台的翻译和 OCR 软件，同样支持插件。除了通过快捷键使用外，也可以通过 [PopClip 调用 Bob](https://bobtranslate.com/guide/integration/popclip.html)。

网友 yetone 制作了两个 Bob 插件，一个是基于 ChatGPT 的 [文本翻译](https://github.com/yetone/bob-plugin-openai-translator) 插件，可以全面替代 [DeepL](https://www.deepl.com/translator)，另一个是对句子进行 [润色和语法修改](https://github.com/yetone/bob-plugin-openai-polisher) 的插件，可以全面替代 [Grammarly](https://www.grammarly.com/)（心疼 DeepL 和 Grammarly 两秒钟 😂）。

{{< imgcap title="通过 Bob 插件使用 ChatGPT 润色文字" src="https://p15.p3.n0.cdn.getcloudapp.com/items/GGu7vOyW/1f563682-fba7-4daf-8587-bda2a863a22e.gif" >}}

### 快捷指令

苹果的快捷指令（Shortcuts）同样也可以用来调用 ChatGPT API，使用非常方便。比如 [吴秉儒](https://pinchlime.com/blog/chatgpt-api-shortcut/) 制作了一个简单的 Shortcuts，用 [快捷指令](https://www.icloud.com/shortcuts/a9ba455466774e4299c1077659fda7b3) 来使用 ChatGPT。

{{< imgcap title="使用 ChatGPT 的快捷指令" src="https://p15.p3.n0.cdn.getcloudapp.com/items/7Kuzd7wA/2e960384-bd7f-48b2-b008-e80c86e6156e.png" >}}

除此之外，还有网友制作了一个通过 Siri 和 ChatGPT 对话的 [快捷指令](https://github.com/Yue-Yang/ChatGPT-Siri)，非常有趣，让原本的语音智障助手摇身一变成为人工智能助手 🤣

## 小结

模型更好，价格更低的 ChatGPT API 一经推出，便迅速引爆网络，沉寂已久的 Twitter 似乎也因此恢复了往日的热闹，时间线上的推文几乎都在讨论，有不少网友已经做出了很好玩的应用。本文基于我这两天上网冲浪的见闻，分享了一些个人用户使用 ChatGPT API 的方法，希望可以让你尝尝鲜，快速体验一番 ChatGPT 在日常学习和工作中应用的魅力。

如果说去年 12 月初的 ChatGPT 预览版开启了一扇小门，展现了它在自然语言处理方面的巨大潜力，让人们可以到门口一睹人工智能时代的惊艳，那么 ChatGPT API 的问世，则更像把这扇门移到了普通人的跟前，让我们无需走到门前就可以轻松地使用它。面对正在悄然改变我们生活方式的 ChatGPT，让我们共同期待并积极拥抱一个全新时代的到来吧！
