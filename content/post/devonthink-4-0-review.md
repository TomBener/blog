---
title: DEVONthink 4.0 评测：AI 加持的全新文件管理体验
date: 2025-07-12
categories:
  - DEVONthink
  - PDF
  - AI
  - 文件管理
---

{{< admonition title="🔖 Note" >}}
本文首发于 [少数派](https://sspai.com/post/100991)
{{< /admonition >}}

作为 macOS 上的老牌文件管理应用，[DEVONthink](https://www.devontechnologies.com) 一直保持着稳定的更新节奏，几乎每几个月就会发布一个新版本，带来一些 bug 修复和功能改进，而大版本更新一般则会每 3–4 年发布一次。[DEVONthink 3.0](https://www.devontechnologies.com/blog/devonthink-30) 发布于 2019 年 9 月，距今已有近 6 年时间。在这 6 年时间里，文件管理（或笔记管理）方式发生了翻天覆地的变化，无论是 [Roam Research](https://roamresearch.com)、[Obsidian](https://obsidian.md) 等双链笔记的出现，还是 [ChatGPT](https://chatgpt.com)、[DeepSeek](https://www.deepseek.com) 等生成式人工智能的兴起，都在深刻改变着人们的知识管理模式。

2025 年 4 月，DEVONthink 4.0 的第一个 [公开测试版本](https://www.devontechnologies.com/blog/20250403-devonthink-40-public-beta) 发布，经历了两个多月的测试，正式版 [DEVONthink 4.0 Copernicus](https://www.devontechnologies.com/blog/20250626-devonthink-40-copernicus) 已于 6 月底上线，截至本文发布时，最新版本为 4.0.2（以下使用 4.0 代指 DEVONthink 4 目前的所有版本）。作为一个大版本更新，DEVONthink 4.0 带来了许多令人兴奋的功能改进和体验升级，尤其是它在 AI 方面的自我突破——从过去简单的「智能分组」算法拓展到对接当下流行的生成式 AI 模型，为个人知识管理注入了全新的可能性。当然，除此之外，版本管理、文档编辑、搜索及自动化等方面也各有亮点。本篇文章将结合更新重点、功能亮点与实际用户反馈，深入评测 DEVONthink 4.0 的更新亮点。

根据官方文档，相比 3.x 版本，DEVONthink 4.0 的主要更新包括 [以下几个方面](https://www.devontechnologies.com/apps/devonthink/new)：

- **集成生成式 AI 模型**：支持 ChatGPT、Claude、Gemini 等主流大语言模型 API，也可通过 [Ollama](https://ollama.com) 或 [LM Studio](https://lmstudio.ai) 接入本地部署的 AI 模型，实现与文档的智能问答、总结归纳、自动标注甚至图像生成。
- **版本管理与审计安全存档**：提供文档历史版本自动保存功能，以及「审计安全」数据库，可防篡改并记录删除日志，满足重要或敏感的文件存档需求。
- **编辑与内容处理优化**：改进 Markdown 所见即所得编辑器，更好支持图片、链接，新增打字机模式等，更好地转换 Markdown, EPUB 和网页文档，增加编辑 PDF 书签的功能。
- **搜索与链接新功能**：无需 OCR 即可搜索扫描版 PDF 文档，引入类似脑图的 Graph 知识图谱，可视化文档之间的关联；支持跨文档段落链接、快速自动链接，以及上下文语义搜索等。
- **自动化工作流加强**：Smart Rule（智能规则）加入 AI 动作和条件，AppleScript 脚本接口升级，允许更灵活强大的批处理和插件扩展。
- **界面与协作改进**：界面图标更统一直观，支持分组管理智能组/规则，路径导航栏功能扩展，内置帮助系统重做并支持聊天交互辅助，Server 网页端全面重构增强团队协作能力。

从 DEVONthink 3.x 升级到 4.0 的过程相当简单，只需几步即可完成：

1. 登录你的 [DEVONthink 个人账户](https://www.devontechnologies.com/login)，选择适用于 DEVONthink 4 的许可证。
2. 从官网下载最新版的 [DEVONthink 4](https://www.devontechnologies.com/download/apps)，或使用 [Homebrew](https://brew.sh) 安装：`brew install --cask devonthink`。
3. 打开 DEVONthink 4 并输入你的许可证代码完成激活。

由于新旧版本的数据库格式兼容，你可以在 DEVONthink 4 中直接打开原有的数据库，甚至可以随时切换回版本 3。此外，升级时还有一些技术细节需要注意：

- 全局收件箱（`Inbox.dtBase2`）和同步数据文件夹（`Cloudy`）会被移动到 `~/Library/Application Support/DEVONthink` 目录，并在原位置创建替身。如果你需要同时保留两个版本，切勿删除 DEVONthink 4 的应用支持子文件夹。
- 个人配置，如阅读列表、自定义元数据、智能组、智能规则等，都会被尽可能保留。
- 旧版本的 Spotlight 缓存会被移除。
- DEVONthink 4 采用了新的脚本架构。多数 AppleScript 或 JavaScript 脚本仍可继续工作，但脚本需要做一些小的调整，例如需要将 `application name` 从 `DEVONthink 3` 改为 `DEVONthink`。

## AI 助手：从内置机器学习模型到大语言模型

首先必须指出，AI 无疑是 DEVONthink 4.0 最重要的升级，也是本次更新的最大亮点。事实上，DEVONthink 一直以来就内置了一些号称「人工智能」的功能，例如基于词频和相似度的「See Also & Classify」（查看类似项与自动归类）引擎，可以在本地分析文档内容之间的关联，这套本地机器学习算法一直是 DEVONthink 的 [核心卖点](https://www.devontechnologies.com/apps/devonthink/ai) 之一，也是其强大搜索和组织能力的基石。

众所周知，我们熟知的 AI 是 Artificial Intelligence 的首字母缩写，但苹果公司所谓的 AI 是 [Apple Intelligence](https://www.apple.com/apple-intelligence/) 的缩写，也许同样是出于对自身产品的执着，DEVONthink 所谓的 AI 既包括其一直以来内置的人工智能（built-in artificial intelligence），也包括其与时俱进地接入的大语言模型（large language models）。

### DEVONthink 内置 AI

DEVONthink 内置的 AI 可以让软件自动推荐相似资料、辅助标签归类，或通过智能分组快速汇集符合条件的条目。在 4.0 中，这些功能只是被重新组织和优化了，并没有本质上的变化。例如在下图中，点击 `Tools -> Inspectors -> See Also`，可以看到下方出现了 Groups 和 Documents 两栏：前者用热力分值列出最相关的归档文件夹，可双击、拖放或点击 `Move to ⌃C` 按钮快速移动；后者展示可能关联的文件，悬停可看完整路径，选中即可在预览区查看。顶部搜索框支持实时过滤，下方还可以切换 Based on content、Based on tags 或 Current database only 等选项进行筛选。

![DEVONthink 内置 AI 驱动的 See Also 功能](https://cdn.retompi.com/6f7e47d9-269a-489d-8fbf-3d3f03fa6923.png)

除了 See Also 以外，DEVONthink 4.0 内置的 AI 还提供了一个 Graph 功能，可以可视化文档之间的关联。如果你用过 [Connected Papers](https://www.connectedpapers.com/)，一定会对 DEVONthink 的 Graph 功能很熟悉，它们都以网络图的方式可视化一篇文档与其他条目的多重关联。选中文档后，屏幕右侧会出现一个以红色圆点为中心的节点图，外围黄色节点通过五类连线（Item Link、WikiLink、Mentions、Tags、See Also）展示链接强度。点击节点即可高亮直接连接（蓝线）、再次双击跳至该条目并生成新的子图；底部 Show Connections 选项则允许按关系类型开关过滤，也可以右键之后点击 `Export…` 将 graph 导出为 PDF。简而言之，这就是把在线的 Connected Papers 式的灵感地图带到本地知识库，但并不局限于学术 PDF，也支持 Markdown、Docx、纯文本笔记、网页、图片等其他格式，如果你的 DEVONthink 数据库中收集了大量文件，那么这个功能对于主题研究和视野拓展会非常有帮助。

![Graph 功能](https://cdn.retompi.com/dac39c2a-1ef1-4c39-afc9-bee269846d3d.png)

### 大语言模型加持的 AI 助手

如果说 DEVONthink 的内置 AI 助手是对已有功能的重新组织和优化，那么大语言模型加持的 AI 助手则是 4.0 新增的全新功能。过去几年，ChatGPT 引领的人工智能浪潮让大语言模型的能力产生了质变，不少生产力工具纷纷接入 OpenAI、Gemini 等大语言模型的服务。早在 2023 年上半年 OpenAI 刚推出 [GPT‑3.5 Turbo API](https://openai.com/index/introducing-chatgpt-and-whisper-apis) 之时，我就在 DEVONthink 官方论坛上提议将 [ChatGPT API 整合进 DEVONthink](https://discourse.devontechnologies.com/t/a-proposal-for-the-integration-of-devonthink-and-chatgpt-api/74907)，让 GPT 读取数据库中的文件并进行问答。然而当时 DEVONthink 开发团队对此相当保守，甚至表现出对大语言模型的不屑，并且 [明确表示](https://discourse.devontechnologies.com/t/a-proposal-for-the-integration-of-devonthink-and-chatgpt-api/74907/5)「与 ChatGPT 的直接集成在当下几乎不可能」，不禁让人感叹德国企业的保守和固执。然而谁能想到，两年后 DEVONthink 就「真香」地在 4.0 中把这一功能集成了，并且将其作为新版本的最大更新亮点进行介绍，不禁令人莞尔。

要在 DEVONthink 中调用大语言模型，我们需要在 `Setting… -> AI -> Chat` 中进行设置，目前支持的模型包括：

- ChatGPT
- Claude
- Gemini
- Mistral AI
- Perplexity

如果对于数据隐私有顾虑，你也可以选择 GPT4All、LM Studio 或 Ollama 等引擎使用本地模型。下面以 Google Gemini 为例，说明设置步骤。首先，我们需要在 [Google AI Studio](https://aistudio.google.com/apikey) 生成一个 API Key，然后将其填入 DEVONthink 的 AI 设置中，接下来选择模型，其他选项保持默认或按需进行调整，即可启用 Gemini 模型。值得一提的是，Google 免费用户可以使用 Gemini 2.5 Flash 和 Gemini 2.5 Pro 等高级模型，尽管有 [速率限制](https://ai.google.dev/gemini-api/docs/rate-limits#current-rate-limits)。目前 DEVONthink 无法自定义 Base URL，因此还不支持第三方 API 转发服务。

![DEVONthink 中 AI 相关设置](https://cdn.retompi.com/fea04c0c-4af4-4a2b-a119-1c4f2cac9c87.png)

设置完成之后，我们在 DEVONthink 中选中一个或多个文档，点击右侧的 `Chat` 图标，即可调用大语言模型和当前文档进行对话。就像在 ChatGPT 或 DeepSeek 的对话界面一样，你可以输入问题，让 AI 总结文档，或针对某些细节进行提问或讨论。如果你之前使用过 Zotero 插件 [Zotero GPT](https://github.com/MuiseDestiny/zotero-gpt) 或 [PapersGPT For Zotero](https://github.com/papersgpt/papersgpt-for-zotero)，那么 DEVONthink 的 AI 助手对你来说应该不会太陌生，只不过 DEVONthink 的 AI 助手在功能上更加全面，并且由于是 macOS 原生应用，体验更加流畅。

![调用大语言模型和文档对话](https://cdn.retompi.com/ff95811a-d85e-4cee-83ed-cbd9ad06cca3.png)

从上图可以看到，DEVONthink 的窗口右上方有两个 `Chat` 图标。点击下方较小的 `Chat` 图标，会打开对话框，而点击上方较大的 `Chat` 图标，会出现一个浮动窗口，二者的功能类似，但前者更方便在文档中随时调用。在 AI 返回结果后，可以点击上方的 4 个图标进行以下操作：

- `Clear`：清除聊天框内容
- `Resend Last Message`：重新发送上一条消息
- `Copy`：复制结果
- `Save…`：保存当前聊天记录，支持 Markdown、纯文本、富文本、HTML、JSON 等格式

功能上，DEVONthink 4 的 AI 助手几乎是一个全能型选手，围绕「理解和加工文档」提供了多种能力，比如摘要与提炼、文本润色与改写等。例如，你可以选中一段文本，点击文档右上方的 `Transform Text via Chat` 图标，即可让 AI 对选中的文本进行润色或改写，支持 Friendly、Professional、Concise 和 Rewrite 四种风格，与 Apple Intelligence 的写作助手类似。

![使用 AI 润色或改写文本](https://cdn.retompi.com/3060ca3d-3a32-47cf-be20-55f7813440cc.gif)

DEVONthink 4.0 的 AI 集成并非简单地塞进一个大语言模型的套壳界面，而是深度结合了 DEVONthink 软件自身的特点，提供了多样化的「知识助手」能力，这使得我们在阅读论文、整理笔记、写作输出的整个流程中，都可以随时调动 AI 来处理各种任务。例如，DEVONthink 的一大特色是支持高级搜索运算符（search operators），但这些运算符数量众多，规则复杂，大多数用户很难记住这些语法。不过借助 AI，我们可以直接把自然语言转换为高级搜索运算符。例如在下图中，我在聊天框中输入「搜索数据库中关于 generative AI 和 social science 研究的相关文档，要求关键词之间不超过 10 个字符」。可以看到，AI 将自然语言转换为高级搜索语法 `"generative AI" NEAR/10 "social science research"`，并自动执行搜索操作将其输入到上方的搜索框中，找到了 3 篇文档。

![AI 将自然语言转换为高级搜索运算符](https://cdn.retompi.com/e7992f7f-f1d3-48c5-9518-f5503ea64d8f.png)

DEVONthink AI 不仅能搜索本地数据库，还支持联网搜索，例如直接查询 PubMed 医学文献或 Wikipedia 等，相当于把 DEVONthink 与互联网知识连接起来了。而对于总结文档这一高频需求，DEVONthink AI 还提供了一个单独的 `Summarization` 设置。如下图所示，你可以在其中选择模型，以及总结的风格，包括 `Text`、`Bullet List`、`Key Points`、`Table` 和 `Custom` 这 5 种，除此之外，也可以在最下方的 `Custom Prompt` 中输入自定义的提示词，让 AI 根据你的特定需求进行总结。

![AI 总结文档的设置](https://cdn.retompi.com/935a3b1a-c86e-45fd-b3c5-0057f2f32eb6.png)

设置完成后，在 DEVONthink 选中要总结的文档，点击 `Edit -> Summarize via Chat…`，文档右侧会出现一个浮动窗口，稍等片刻便会出现 AI 的总结结果。

![使用 AI 总结选中的文档](https://cdn.retompi.com/2ef9002f-0b50-40b0-a920-dff8b0406669.gif)

如果你想要将总结结果保存下来，方便后续使用，可以点击 `Tools -> Summarize Documents via Chat…`，选择对应的格式，比如 Markdown、富文本、注释或评论等，如下图所示。

![保存 AI 总结的结果](https://cdn.retompi.com/63b2aabd-43a7-4121-a623-f60487ea43bb.png)

除了文本处理以外，DEVONthink 中的 AI 还支持生成图像，例如使用 OpenAI DALL-E、Google Imagen、Stable Diffusion 等模型生成图片，你可以基于已有资料内容，提示 AI 绘制一张相符的插图，然后插入笔记中。例如给一份旅行日记生成一张地图插画，或让 AI 根据会议记录绘制一张概念流程图。

![AI 生成图像的设置](https://cdn.retompi.com/71cff320-aa05-4be4-baf0-be51fe26684d.png)

DEVONthink 4 在 AI 下的「Transcription」面板里整合了一站式文本转录功能：针对图片转文本，可以在 Apple Vision 的「Fast」与「Accurate」两档 OCR 之间切换，或调用对话模型中配置的大语言模型完成识别；音频/视频转文本则提供本地 Apple Speech、远程 Apple Speech 以及 GPT-4o 三种引擎，并且可勾选「Add timestamps」将时间戳自动写入结果，最下方还能手动选择目标语言，整套流程简单直观，为多媒体资料的处理与利用提供了便利。

![AI 文本转录的设置](https://cdn.retompi.com/7cac0bf0-8360-41dc-9911-2ea2e61c82fb.png)

值得一提的是，为了降低新用户上手 DEVONthink 的门槛，DEVONthink 4 的内置帮助系统也做了升级。现在帮助文档本身也支持 AI 聊天模式，你可以点击 `Help -> DEVONthink Help` 打开本地帮助手册界面，在右侧的聊天框中向 Google Gemini 1.5 Flash 8B 询问相关问题，这相当于把说明书变成了互动式客服，有助于 DEVONthink 新手快速找到答案。对于中文用户来说，如果你不想阅读大段的英文说明书，使用中文提问还能顺便将手册翻译成中文。对于 DEVONthink 这样一个功能繁杂的软件来说，这是一个相当实用的设计。

![DEVONthink 帮助文档的 AI 聊天模式](https://cdn.retompi.com/c3331deb-c2b7-44ac-8484-ebb8e3eb0258.png)

### AI 自动化

对很多进阶用户来说，DEVONthink 真正的魅力并不是那些琳琅满目的按钮，而在于它丰富而强大的自动化能力。4.0 版本把这份能力再次向前推进——不仅优化了传统的 Smart Rules 与 AppleScript，更把生成式 AI 深度嵌入其中，让「让电脑替你干活」这件事变得更加简单。

DEVONthink 4.0 新增了两个 AI 驱动的动作：`Chat – Query` 与 `Chat – Continue if`。`Chat – Query` 负责提问，你只需写一句提示词（Prompt），它就能单独或结合选中文档把问题丢给你在 `Settings… -> AI -> Chat` 里选定的大模型，并把回答保存在 `Query Response` 占位符中，供后续动作调用。`Chat – Continue if` 负责决策，它同样发送一个提示词，但只期待模型回答 `yes` 或 `no`。若为 `yes`，规则继续向下执行；否则就此打住。例如，下图的 Smart Rule 通过 `Chat - Continue if` 判断当天添加的 PDF 的内容是否是关于大语言模型的，如果是的话，就移动到数据库中名为 `LLMs` 的文件夹中，否则就不执行任何操作。

![使用 AI 判断是否移动 PDF 到指定文件夹的 Smart Rule](https://cdn.retompi.com/7e163b02-ba9e-4865-938c-5cb2df735a63.png)

除了 Smart Rules 中 AI 相关的动作外，DEVONthink 4.0 还支持使用 AppleScript 调用 AI。如果你是脚本玩家，那么这个功能将极具可玩性，可以玩出很多花样。例如，我们可以创建一个 AppleScript，通过调用 AI 将选中的文本翻译成中文。

```applescript
-- Translate selected text to Chinese
-- Created by Tom Ben
-- Copyright (c) 2025. All rights reserved.

property pTitle : "Translate to Chinese"
property pLanguage : "Chinese"
property pRole : "You are a helpful assistant that translates text to Chinese. Return only the translated Chinese text but nothing else." -- The assistant's role

tell application id "DNtp"
	try
		set theText to selected text of think window 1
		if theText is missing value or theText is "" then error "No text selected."
		set theLanguage to pLanguage
		set theQuery to "Please translate the following text to " & theLanguage & "."
		tell think window 1 to display chat dialog prompt theQuery role pRole name pTitle
	on error errMsg number errNum
		if errNum ≠ -128 then display alert errMsg
	end try
end tell
```

打开 macOS 自带的脚本编辑器（Script Editor），将上面的 AppleScript 粘贴进去，保存为 `Translate to Chinese.scpt`，放在 `~/Library/Application Scripts/com.devon-technologies.think/Menu` 目录下，然后就可以在 DEVONthink 中使用，如下图所示。

![使用 AppleScript 调用 AI 将 DEVONthink 中选中的文本翻译成中文](https://cdn.retompi.com/39363089-75aa-4d44-9be2-bac3a7889bad.gif)

## 文档版本管理与安全存档

在文件管理中，一个经常被提及的需求是文档的历史版本保存和内容防篡改。以往 DEVONthink 在这方面提供的支持相对有限，用户更多需要借助 macOS 自带的版本控制或手动备份。DEVONthink 4.0 针对这种场景推出了全新的版本管理（Versioning）和审计存档（Archiving）功能，方便我们追溯修改、保护重要资料的完整性。

### 自动版本控制

DEVONthink 4.0 能够在我们编辑文档时自动创建历史版本。支持的文档类型包括纯文本、Markdown、RTF、PDF 等常见类型。你可以点击 `File -> Database Properties…`（快捷键 `⌘ + ⌥ + P`），在弹出的窗口中勾选 `Enable Versioning` 选项，开启版本控制，如下图所示。

![开启数据库版本控制功能](https://cdn.retompi.com/51784b5a-8507-4615-a88e-f22a335f0298.png)

当开启版本控制后，每当文件发生变更保存时，旧版内容会被留存一份。用户可以根据需要设置最多保留多少个版本、占用空间上限，以及多长时间后自动清理旧版本。

实际使用下来，这个功能类似于 Google Docs 的版本历史或 Dropbox 的版本恢复，让用户对编辑操作更有底气，特别是对于批注 DEVONthink 中的 PDF 来说，因为 DEVONthink 使用 [Apple PDFKit](https://developer.apple.com/documentation/pdfkit) 框架，一旦对其中的 PDF 进行批注，原来的文件属性就会被更改，PDF 页码标签会被全部重置为阿拉伯数字并且从 1 开始计数，交叉引用链接也可能会失效，甚至还可能导致某些 OCR 过的 PDF 的 [文字图层消失](https://discourse.devontechnologies.com/t/pdf-annotating-tools-grayed-out/70155)。因此，版本控制功能的引入，对于在 DEVONthink 中批注 PDF 来说非常重要且实用。

![文档自动版本控制功能](https://cdn.retompi.com/d3abff5a-09f2-42ba-a877-8814c1fde9a2.png)

### 审计安全存档

面向更专业严肃的归档需求，DEVONthink 4.0 引入了 Audit-Proof Database（审计安全数据库），专为「一旦入库就绝不能改动」的资料设计，主要服务于财税、法律等需符合法规的长期归档场景。导入后，文件立刻被系统锁定为只读；若试图通过外部应用编辑，DEVONthink 会弹窗警告并拒绝保存，从根源上杜绝篡改。

审计安全数据库为每条目记录文件名、内容哈希和值班时间戳，即使你之后重命名、甚至删除该文件，最初的痕迹仍会保存在不可编辑的内部日志，并可随时导出审计报告。这意味着任何改动——哪怕是删除——都留有记录，足以满足严苛的合规要求。为保护完整性，OCR、加盖印章、脚本自动化等会改写内容的功能统统被禁用。审计安全数据库支持 DEVONthink 的同步机制，但只能以同样的「审计模式」在另一台 Mac 打开。库文件本身被封装进加密磁盘映像，扩展名为 `.dtArchive`，一旦忘记创建时设定的密钥将无法解锁。需要注意的是，审计安全数据库与 DEVONthink 3.x 完全不兼容。

如此「硬核」的保险箱并非日常文件管理所必需，对大多数用户来说，普通版本控制已绰绰有余。但如果你必须证明「自入库以来，文件从未被改动」，它几乎是零配置、即开即用的最佳方案。要创建审计安全数据库，你可以点击 `File -> New -> Audit-Proof Database…`，在弹出的窗口中设置数据库名称、保存位置、密码等参数，然后点击「Create」按钮即可。

![数据库名称右侧有一个盾牌图标，表明这是一个审计安全数据库，其中的文件无法被更改](https://cdn.retompi.com/65aa0760-5b88-4d3d-a4f8-47e6dad0c2f7.png)

## 内容编辑与组织优化

DEVONthink 不仅是个资料仓库，也是很多人日常阅读、写作的工作台。4.0 针对内容编辑和组织方式也做出了一系列改进，让我们与文档打交道的体验更加流畅。

- **Markdown 编辑器升级**：DEVONthink 内置的 Markdown 编辑器在 4.0 中变得更好用。现在它支持所见即所得（WYSIWYG）模式下直接插入和显示图片、链接，文本行距排版也更美观，滚动预览更加顺畅。此外，新增的打字机模式（Typewriter Mode）可以让当前输入行始终保持在窗口中央——对于长篇写作时聚焦当前段落非常有帮助。
- **多格式内容转换**：如果你经常在不同格式之间迁移内容，DEVONthink 4 提供了更好的支持。Markdown、富文本、HTML 乃至 EPUB 等格式的文档，现在可以通过改进的转换引擎，保存或导出为 PDF、DOCX 等其他格式。
- **文档导航**：打开长篇文档或书籍资料，DEVONthink 4 支持目录视图，无论是 PDF、RTF 还是 Markdown 文件，只要有标题结构，现在都可以在侧边栏看到自动生成的大纲目录。对于 PDF 等支持书签的格式，现在可以直接在这个目录视图里编辑书签。
- **文档链接**：DEVONthink 很早就已支持 Wiki 链接（类似 [[Page]] 这样的链接），4.0 进一步扩展了跨文档引用的能力：现在可以直接获取某文档中特定段落的链接，然后在另一个笔记中引用，点击即可定位到原文相应位置。如果你使用过 Obsidian，应该会对这个功能非常熟悉，它相当于一个稍显粗糙的块引用，但并非双向链接，而是一种单向链接，引用关系只会在被引用的文档的 Inspectors 中的 `Document -> Mentions` 中显示。另一个小巧但实用的功能是快速链接，在编辑文本时，只要输入 `>>` 后紧跟想链接的文档名称首字母，DEVONthink 就会弹出匹配项供你选择并插入。

![在 DEVONthink 中使用文档链接功能](https://cdn.retompi.com/24f35b52-b0e8-4386-8828-ae33e422f524.gif)

## 界面细节调整

在用户界面方面，DEVONthink 4.0 也做了一些优化。首先直观的一点是图标和视觉风格的更新。开发团队重绘了大量图标，使之更加简洁现代，与最新的 macOS 视觉风格保持一致。各个 Inspectors 面板经过重新设计，布局更合理。此外，侧边栏的路径导航栏（Path Bar）变得可以交互，下级目录或快速返回上级资料库更方便。对于习惯鼠标拖拽的用户来说，现在很多弹出面板都支持脱离主窗口悬浮——例如标签面板、搜索过滤器，可以拖出来当作独立小窗使用，让你在不同空间自由摆放需要的工具。除此之外，DEVONthink 4 的稳健性和可靠性依旧无可挑剔。自从两个多月前开始使用 DEVONthink 4.0 以来，我没有遇到任何崩溃或数据丢失情况，各项功能也都运行正常。

![DEVONthink 3 界面](https://cdn.retompi.com/efc3908b-8b87-413b-b28e-4da76ef61b01.png)

![DEVONthink 4 界面](https://cdn.retompi.com/02d89471-b15a-4162-a165-ebce8b082151.png)

长期以来，一直有用户反映 DEVONthink 界面元素繁杂、新手不知所措的问题。4.0 虽然在整体 UI 布局上变化不大，但在帮助引导方面下了功夫。如前所述，重新整合的帮助文档支持直接聊天提问，不再需要翻阅厚厚的手册来学习功能了，只需用自然语言提问就可以。不过话说回来，DEVONthink 本身就是一款功能高度专业化的软件，注定有一定学习曲线。这次更新并未对「简化界面」做太多文章，结果还是难免让首次接触者感到门槛高。Mac Power Users 论坛上就有类似的 [声音](https://talk.macpowerusers.com/t/devonthink-4-0-public-beta/40338/45)：一位用户形容自己每次打开 DEVONthink 仿佛坐进飞机驾驶舱，各种按钮和选项让人眼花缭乱，哪怕有人告诉他「很多控制不用管」，但那些林立的仪表盘依然让人难以专注。对于这类用户，DEVONthink 或许需要在初始引导和精简模式上多做考虑，否则再强大的功能也很难发挥价值，希望未来的更新能看到开发团队在这方面的改进。

## 「灵活订阅」还是「一次买断」？

除了功能上的变化，DEVONthink 4.0 还有一个引发热议的重大调整：软件授权模式。官方在发布公告中特别提到，出于能够「更快地提供新版本而不必攒大招」的考虑，他们将改为所谓「[更灵活现代的授权模式](https://www.devontechnologies.com/apps/devonthink/upgrade#oneyearupdates)」。具体来说，新版采用维护订阅模式：**购买许可证后包含一年的免费更新**，一年期满后用户可以选择付费延长更新服务，但如果不续费也不影响继续使用当前版本的软件。简单理解，就是未来 DEVONthink 将没有传统意义上的大版本升级收费，而改为按服务期收费，但软件本身并不会在服务到期时锁定。

根据官方公布的价格，DEVONthink 4.0 的定价体系如下：

- **新购许可证**

购买许可证后包含一年免费更新和两个可用席位（可用于两台 Mac）。

| 版本                  | 价格     | 额外每台 Mac 席位 |
| ------------------- | ------ | ----------- |
| DEVONthink Standard | 99 美元  | 49 美元       |
| DEVONthink Pro      | 199 美元 | 99 美元       |
| DEVONthink Server   | 499 美元 | 99 美元       |

- **从 DEVONthink 3 升级**

对于已拥有 DEVONthink 3 许可证的用户，可以付费升级到 4.0，升级价格如下：

| 从                     | 到        | 价格     |
| --------------------- | -------- | ------ |
| DEVONthink Standard 3 | Standard | 49 美元  |
| DEVONthink Pro 3      | Pro      | 99 美元  |
| DEVONthink Server 3   | Server   | 149 美元 |

- **续订更新服务**

一年免费更新期过后，用户可以选择续订以继续获取新版本。

| 版本                  | 一年续订费用 |
| ------------------- | ------ |
| DEVONthink Standard | 49 美元  |
| DEVONthink Pro      | 99 美元  |
| DEVONthink Server   | 149 美元 |

如果在更新服务到期前续订，还可以享受折扣以及两或三年的优惠选项，价格如下：

| 版本                  | 一年续订费用 | 两年续订费用 | 三年续订费用 |
| ------------------- | ------ | ------ | ------ |
| DEVONthink Standard | 44 美元  | 79 美元  | 104 美元 |
| DEVONthink Pro      | 89 美元  | 159 美元 | 209 美元 |
| DEVONthink Server   | 134 美元 | 239 美元 | 314 美元 |

如果你是学生或教育工作者，还可以享受更高的折扣，具体价格可在 DEVONthink 官网个人账户中查看。

事实上，DEVONthink 4.0 新推出的维护订阅模式并不新鲜，在一些专业工具（如 TablePlus、ForkLift、Sketch、Tower、Kaleidoscope 等）上已实行多年。这种模式的优点是确保软件开发商有持续收入来迭代改进产品，同时用户不被强制订阅，可自主决定何时续费获取新功能。然而，对于习惯了「一次购买，长期使用」的老用户来说，这依然是个不小的观念转变。有用户在论坛上算了 [一笔账](https://discourse.devontechnologies.com/t/dt4-more-flexible-and-modern-license-model/82624)：他 2019 年花费约 40 欧元升级到 DEVONthink 3，用了 5 年才迎来下一次付费，而按新模式如果未来 5 年每年都续费，可能总花费要达到之前的 6 倍之多。即便可以不续费，但谁又愿意错过安全补丁呢？针对这样的疑虑，DEVONthink 官方 [强调](https://discourse.devontechnologies.com/t/dt4-more-flexible-and-modern-license-model/82624/7)：「我们这不是订阅制」，因为就算不续费，你手上的软件依然可以用，只是后续无法更新而已。他们把此举比作服务合约，服务期满软件不会停，只是没有新功能，就像买断软件配上了可选的年度维护计划。而对于关键的 bug 修复，官方也表示即使用户不续费，若出现严重问题也会酌情提供修复，尽量保障基本可用性。

实际用户反馈方面，可谓毁誉参半。有部分资深用户表示理解，认为 DEVONthink 定价本就不低，但物有所值，而且支持厂商健康运营也是对软件未来的一种投资。一位个人用户就 [分享](https://discourse.devontechnologies.com/t/dt4-more-flexible-and-modern-license-model/82624/6) 说，尽管他主要是私人用途，AI 新功能可能用不上，但 DEVONthink 多年来可靠强大的表现和优质支持让他觉得这次付费升级是值得的。相反，也有不少用户直言难以接受，觉得所谓「灵活授权」只是换汤不换药的订阅制，担心以后每年都得掏一笔钱才能安心用下去。特别是同时使用多款生产力工具的人，面对各家纷纷转向订阅或年费模式，难免产生不满情绪，如果每个都续费，相比之前的支出肯定会增长不少，累计起来的总开销不容小觑。

对此，我的看法是，DEVONthink 4 的授权模式改变确实需要时间让用户消化。站在厂商角度，这可能是维持持续开发的现实选择；站在用户角度，理性评估自己对更新的需求就显得很重要。如果你对 DEVONthink 新版本的新功能并不感冒，完全可以一次购买后用好几年不升级，等有足够吸引你的更新功能时再付费续上。这和传统的大版本付费其实本质相似，只是周期由厂商主导变成用户自主选择而已。值得庆幸的是，DEVONthink 并没有像某些竞品那样把核心功能也放到云端收费墙后面，软件还是完完全全在本地运行、数据自主人掌控的。未来我们大概会看到 DEVONthink 更频繁地推出功能更新，而不是憋到几年才发大版本，我们也许能够更快用上那些呼声很高的改进。对于忠实用户来说，每年支持一下喜爱的工具，也算是良性循环，而对于偶尔用用的人，新模式下其实影响不大，因为你无须强制续费。

总之，新授权模式的推出标志着 DEVONthink 商业策略的一次重要转型。目前来看争议在所难免，但具体影响如何还有待时间检验。至少在我个人看来，DEVONthink 作为我数年来文件管理的核心，其价值早已超出当初购买时的金额，这次掏腰包升级也在情理之中。当然，每个人情况不同，读者们也可根据自身需求权衡取舍。

## 结语

从功能层面来说，DEVONthink 4.0 展现出了这款「数字图书馆」与时俱进的一面。生成式 AI 的融入，为个人知识管理带来了颇具想象力的用法：我们可以更轻松地洞察海量信息中的规律，用聊天的方式和资料对话，也可以把繁琐的整理工作交给 AI，大幅提高效率。同时，版本管理、AI 自动化等功能则针对专业用户的痛点给出了诚意的解决方案，巩固了 DEVONthink 在文献管理、研究工作流中的领先地位。

然而，软件的双刃性也在此凸显。一方面，DEVONthink 4.0 变得更强大更全面了；但另一方面，它的学习成本和使用复杂度依然存在，这可能依旧令一部分人望而却步。对此，也许开发团队认为 DEVONthink 本就不是面向所有人的大众应用，它服务的是那些愿意投入时间定制自己知识系统的重度知识工作者。就像有人 [调侃道](https://talk.macpowerusers.com/t/devonthink-4-0-public-beta/40338/42)：「如果你觉得它复杂，那可能真不适合你」，话虽直白，却道出了 DEVONthink 的定位。毕竟，强大和易用往往难以兼得，在功能丰富度上碾压竞品的 DEVONthink，在易用性上做出些妥协也可以理解。

退一步说，随着 AI 助手的引入，也许未来 DEVONthink 可以尝试把复杂操作智能化，从另一个层面降低门槛。例如，根据用户习惯自动推荐规则、动态优化界面布局，或者通过对话指导新手完成设置等。如果这些愿景能实现，那么 DEVONthink 将不仅仅是被动的工具，而更像一个主动的知识管家。

最后，我们还是要回到产品本身。对于老用户而言，DEVONthink 4.0 提供的升级理由是充分的——无论是「真香」的 AI 体验，还是诸多细节改进，都让日常的文件管理体验更上一层楼。而对于新用户来说，如果你正寻找一款能「收纳一切、检索一切、连接一切」的文件管理利器，那么 DEVONthink 4 依然是市面上屈指可数的最佳选择。或许一开始你会被它的庞杂惊到，但一旦投入时间理清其逻辑，相信你会体会到那种掌控全局的快感。

总的来说，DEVONthink 4.0 是一次继往开来的重大升级，它没有辜负用户的期待，也为将来的进一步更新埋下了伏笔。我们也期待 DEVONthink 在新的授权模式下，能更快速、更稳定地迭代，为广大知识工作者打造理想中的信息乐园。至于这款软件能否凭借 AI 的东风突破小众圈层，被更多普通用户接受，就让时间和市场去检验吧。
