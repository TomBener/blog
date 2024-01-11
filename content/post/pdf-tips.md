---
title: 调整页码、转移批注、切割页面：这些命令行工具帮你玩转 PDF
date: 2023-12-28
categories:
    - PDF
    - Command Line
    - Keyboard Maestro
---

{{< admonition type=tip title="📑 导语" >}}
无需 Adobe Acrobat 或付费 PDF 软件，也能玩转复杂 PDF 操作
{{< /admonition >}}

如今，无论是商业文件，电子书籍，还是学术论文，大多以 PDF（**P**ortable **D**ocument **F**ormat，便携式文档格式）文件格式存储和分发。由于 PDF 具有跨平台、跨设备、且不易修改的特点，能够保持文件呈现的一致性，因此在互联网上得到了广泛的应用。借助扫描技术，PDF 甚至让前数字时代的书籍或文章「重见天日」，为信息传播发挥了重要作用，因此，PDF 被称为 [世界上最重要的文件格式](https://www.vice.com/en/article/pam43n/why-the-pdf-is-secretly-the-worlds-most-important-file-format)。可以说，在 2023 年使用电子设备，就不可避免地要与 PDF 文件打交道。

尽管 PDF 的使用相当广泛，各类 PDF 软件也层出不穷，但是 PDF 的很多特点和功能仍然不为人知，日常学习工作中遇到 PDF 相关的问题还是会让不少同学犯难。举个例子，我的一位爱书朋友热衷于将喜爱的纸质书扫描成 PDF 电子书，前段时间他遇到一个棘手的问题：扫描得到的 PDF 文件中，每一页包含书籍的两页，他想将其分割成单独的两页，在付费的 [Adobe Acrobat Pro](https://adobe.com/acrobat.html) 中折腾了半天，他也没有搞明白究竟应该该如何实现。能找到的其他方法也不是没有，但全都需要付费，且价格还不便宜，因此他没有尝试。最终，在我的推荐下，没有花费一分钱，他使用开源的 MuPDF 轻松实现了这个需求[^sjl]。

[^sjl]: 尽管过程中遇到的最大问题是如何安装 MuPDF。

可见，发明 PDF 格式的 Adobe 公司推出的 Acrobat 也并非万能的，在实现某些 PDF 功能时并非总是最优选项。除此之外，Adobe Acrobat 的许多高级功能都需要付费使用，并且界面不够美观，个人不是很喜欢。有鉴于此，本文接下来将分享一些我日常用到的 PDF 处理技巧，这些技巧都是我在日常学习工作中遇到的，可能相对比较小众，但每一种方法都提供了免费的实现方式，让你无需 Adobe Acrobat 或其他付费 PDF 软件，也能轻松应对工作中处理 PDF 的问题。

本文分享的技巧主要使用命令行工具来实现，下面的表格列出了这些工具的主要信息，包括名称、语言、支持平台、许可方式、主要功能等。

| 名称 | 语言 | 支持平台 | 版本 | 界面 | 许可方式 | 主要功能 | 安装方式 (macOS) | 备注 |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| [pdftk-java](https://gitlab.com/pdftk-java/pdftk) | Java | Linux, macOS, Windows | 3.3.3 | 命令行 | GNU-2.0 | 导出 PDF 元数据，合并、拆分、修复 PDF 等 | `brew install pdftk-java` | 本文使用的为 Java 移植版，[PDFtk Server](https://www.pdflabs.com/tools/pdftk-server/) 原版已有超过 10 年未更新，停留在 2.02 版本，部分功能与 pdftk-java 有所不同。 |
| [Skim](https://skim-app.sourceforge.io/) | Objective-C | macOS | 1.6.21 | 图形化应用 | BSD | 阅读和批注 PDF，默认将 PDF 标注存储为 Skim notes | `brew install --cask skim` | 本文使用的是 Skim 附带的两个命令行工具 [SkimNotes](https://sourceforge.net/p/skim-app/wiki/SkimNotes_Tool/) 2.9.3 和 [SkimPDF](https://sourceforge.net/p/skim-app/wiki/SkimPDF_Tool/) 1.3.4。 |
| [MuPDF](https://mupdf.com/) | C | Linux, macOS, Windows, Android, iOS | 1.23.0 | Library | AGPL-3.0 | 轻量级 PDF、XPS 和电子书查看器 | `brew install mupdf` | MuPDF 包括软件库、命令行工具和适用于各种平台的阅读器，本文只用到了它的命令行工具 `mutool`。 |
| [pdfjam](https://github.com/rrthomas/pdfjam) | Shell | Linux, macOS,  通过 [Cygwin](http://www.cygwin.com/) 支持 Windows | 3.10 | 命令行 | GPL-2.0 | 主要涉及 PDF 页面的处理 | 安装 [TeX Live](https://www.latex-project.org/get/) 发行版或下载 [release](https://github.com/rrthomas/pdfjam/releases/tag/v3.10) 后安装 | pdfjam 为 LaTeX 包 [pdfpages](http://www.ctan.org/tex-archive/macros/latex/contrib/pdfpages) 提供了在命令行中的使用接口，依赖于 LaTeX 引擎和包。 |
| [pypdf](https://github.com/py-pdf/pypdf) | Python | Linux, macOS, Windows | 3.16.2 | Library | BSD | 通过 Python 对 PDF 进行分割、合并、裁剪和转换、提取文本等 | `pip install pypdf` | 2022 年 12 月以前，`pypdf` 的名称为 `PyPDF2`。 |

为了让不熟悉命令行的朋友也能上手使用，我也提供了 macOS 平台上的自动化实现方案，包括 [Keyboard Maestro](http://www.keyboardmaestro.com/)、[Automator](https://support.apple.com/guide/automator/welcome/mac)（自动操作）和 [Shortcuts](https://support.apple.com/guide/shortcuts-mac/apdf22b0444c/mac)（快捷指令），你可以点击 [这个链接](https://p15.p3.n0.cdn.getcloudapp.com/items/4guWAPdz/5eb749fa-80b4-49ab-a88d-c480e18c393f.zip) 下载文中提到的所有 Keyboard Maestro macros、Automator workflows 和 Shortcuts。后两个软件都是 macOS 自带的，完全免费，只有 Keyboard Maestro 是付费软件。作为 Mac 用户，我非常喜欢 Keyboard Maestro，也推荐你使用它。如果你还没有购买 [Keyboard Maestro](https://www.keyboardmaestro.com/main/store)，可以使用少数派读者专属优惠码 `SSPAI` 享受八折优惠，只需 28.8 美元即可入手 [Keyboard Maestro 11](https://sspai.com/post/83932)。关于学习如何系统使用 Keyboard Maestro，欢迎阅读由我撰写的少数派栏目《[生产力超频：Keyboard Maestro 拯救效率](https://sspai.com/series/350)》。

## 调整 PDF 页码标签

一般情况下，我们所说的 PDF 页码指的是物理页码，即 PDF 中从第 1 页开始递增的页码，每个 PDF 文档都有物理页码，这种页码被称作 page numbers，大多数情况下，page numbers 都使用阿拉伯数字计数。除此之外，在 PDF 特别是较长的 PDF 书籍中，还有另一种被称作 [page folios](https://www.devontechnologies.com/blog/20220208-pdf-page-numbering) 的页码，它是指 PDF 页面中页眉或页脚处的序列标记，可能是英文字母、罗马数字或阿拉伯数字，在 Adobe Acrobat 中也叫作 page labels。我们常说的某本书的第几页指的是 page folios，而不是 page numbers。例如下图中的 PDF 一共有 256 页，当前位于 page numbers 的第 19 页，page folios 的第 10 页。

{{< imgcap title="PDF Expert 右下角显示的 PDF 页码" src="https://static.retompi.com/231532eb-5e0b-4ec3-9158-0bb6e50601d5.png" >}}

在上图所示的 PDF 中，page numbers 和 page folios 不一致。当我们在 PDF 阅读软件中页码跳转框中输入阿拉伯数字 10 之后，会跳转到 page numbers 的第 10 页，而不是 page folios 的第 10 页（即这本书的第 10 页）。造成这种情况的原因是 PDF 书籍中的封面、版权、前言、目录等部分的 page numbers 通常使用的是英文字母或罗马数字，正文部分才是阿拉伯数字。为了方便阅读，我们通常需要将 page folios 和 page numbers 设置为相同的值。

在 Adobe Acrobat 中，我们可以选中需要调整的页面缩略图，然后右键点击「Page Labels…」，在弹出的对话框中设置需要调整的页面范围，然后调整 page labels，可以选择使用阿拉伯数字、英文字母、罗马数字或自定义标记，以及为其添加前缀，最后点击「OK」即可，如下图所示。

{{< imgcap title="在 Adobe Acrobat 中调整 PDF 页码" src="https://static.retompi.com/b1be6c92-3988-448b-b7bc-8fc9fb50da5b.png" >}}

尽管在 Adobe Acrobat 中调整 page labels 非常直观，但是这种方法需要付费，而且操作比较繁琐，需要多次点击，不够方便。下面介绍另一种调整 PDF 页码的方法——使用命令行工具 PDFtk。这种方法无需付费，并且非常符合 [Unix 哲学](https://en.wikipedia.org/wiki/Unix_philosophy)「一切皆文件」的原则。需要注意的是，由于原版 PDFtk[^aiq] 不支持调整 PDF 页码标签的功能，因此下文使用的都是 `pdftk-java`。

[^aiq]: 安装命令为 `brew tap zph/cervezas && brew install pdftk`。

使用下面的命令，就可以将名为 `input.pdf` 的元数据 [导出](https://www.pdflabs.com/docs/pdftk-man-page/#dest-op-dump-data-utf8) 为一个纯文本文件 `metadata.text`：

```shell
pdftk input.pdf dump_data_utf8 output metadata.text
```

使用文本编辑器打开生成的 `metadata.text`，可以看到 `input.pdf` 的各种元数据，其中就包括页码标签信息，如下所示：

```text
PageLabelBegin
PageLabelNewIndex: 1
PageLabelStart: 1
PageLabelPrefix: Cover
PageLabelNumStyle: NoNumber
PageLabelBegin
PageLabelNewIndex: 2
PageLabelStart: 1
PageLabelPrefix: Page
PageLabelNumStyle: UppercaseLetters
PageLabelBegin
PageLabelNewIndex: 3
PageLabelStart: 1
PageLabelNumStyle: UppercaseLetters
PageLabelBegin
PageLabelNewIndex: 6
PageLabelStart: 1
PageLabelNumStyle: LowercaseLetters
PageLabelBegin
PageLabelNewIndex: 9
PageLabelStart: 1
PageLabelNumStyle: UppercaseRomanNumerals
PageLabelBegin
PageLabelNewIndex: 12
PageLabelStart: 1
PageLabelNumStyle: LowercaseRomanNumerals
PageLabelBegin
PageLabelNewIndex: 17
PageLabelStart: 1
PageLabelNumStyle: DecimalArabicNumerals
```

容易发现，每个 PDF 页码标签的元数据由 4 或 5 行组成：

- `PageLabelBegin`：开始一个页码标签
- `PageLabelNewIndex`：页码标签开始的索引，对应 PDF 的 page numbers
- `PageLabelStart`：页码标签开始的页码
- `PageLabelPrefix`：页码标签的前缀（可选）
- `PageLabelNumStyle`：页码标签的类型，包括 `NoNumber`（无页码）、`DecimalArabicNumerals`（阿拉伯数字）、`UppercaseLetters`（大写英文字母）、`LowercaseLetters`（小写英文字母）、`UppercaseRomanNumerals`（大写罗马数字）和 `LowercaseRomanNumerals`（小写罗马数字）。

上面的示例对应的 PDF 页码标签元数据可以解读为：

- 第 1 页的 page label 为自定义文本 `Cover`
- 第 2 页的 page label 为带有前缀 `Page` 的大写英文字母 `Page A`
- 第 3 页的 page label 为大写英文字母 `A`，依次递增
- 第 6 页的 page label 为小写英文字母 `a`，依次递增
- 第 9 页的 page label 为大写罗马数字 `I`，依次递增
- 第 12 页的 page label 为小写罗马数字 `i`，依次递增
- 第 17 页的 page label 为阿拉伯数字 `17`，依次递增直至最后一页

需要注意的是，不是每一个 PDF 都具有这些全部类型，有些 PDF 的元数据可能没有任何关于页码标签的内容，这种情况下，PDF 阅读器会使用阿拉伯数字 1 开始标记。

为了修改 PDF 的页码标签，我们需要先将 PDF 的页码标签元数据导出为文本文件，然后修改其中的页码标签信息，最后将修改后的元数据导入 PDF 文件，生成一个新的 PDF 文件。比如我们将上述示例中倒数第 3 行的 `17` 修改为 `20`，就可以将 PDF 的 page labels 修改为从阿拉伯数字 20 开始，而不是之前的 17，如下图所示。

{{< imgcap title="修改元数据后得到 PDF，从第 20 页开始使用阿拉伯数字作为页码标签" src="https://static.retompi.com/49c758f8-871d-4d71-86e6-6737b51425bf.png" >}}

经过上面的分析，修改 PDF 页码标签的步骤就很清晰了：

1. 使用 `pdftk` 导出 PDF 的元数据为文本文件
2. 根据 PDF 页面信息，使用文本编辑器打开元数据文件，修改页码标签信息
3. 使用 `pdftk` 将修改后的元数据导入 PDF，生成页码标签修改后的 PDF

尽管上述步骤非常简单明了，但每次都需要修改文件名称，对于不熟悉命令行的朋友来说，可能还是有点难以上手。因此，我制作了一个 Keyboard Maestro macro 来实现这一功能，如下图所示。

{{< imgcap title="调整 PDF 页码标签的 Keyboard Maestro macro" src="https://static.retompi.com/30b06a1c-7d24-42ed-80e3-884859df8389.png" >}}

这个 macro 首先获取访达（Finder）中选中文件及其所在路径，然后保存为 Keyboard Maestro 中的变量 `selected_pdf`。之后是一个条件判断，用于判断选中的文件是否是 PDF，如果不是，则弹出通知「No PDF was selected.」，然后取消执行 macro。如果选中的文件是 PDF 的话，则弹出一个提示框，让用户输入页码标签的起始页，这里包括了 3 种类型，也就是 3 个变量：

- `FirstPage`：第一页，通常为 `Cover`，默认值设置为 1
- `LowercaseRomanNumerals`：小写罗马数字页码标签的起始页
- `DecimalArabicNumerals`：阿拉伯数字页码标签的起始页

如果上述 3 个值留空的话，则表示不包括该类页码标签。接下来，Keyboard Maestro 将用户输入的值作为变量传递给下面的 Shell 脚本：

```shell
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

cd "$KMVAR_pdf_path"

# Dump PDF metadata
pdftk "$KMVAR_selected_pdf" dump_data_utf8 output metadata.text

# Path to the metadata file dumped by pdftk
METADATA_FILE="metadata.text"

# Remove existing page label information if present
sed -i '' '/PageLabelBegin/,$d' "$METADATA_FILE"

# Function to append page label information
append_page_label(){
    cat <<EOF >> "$METADATA_FILE"
PageLabelBegin
PageLabelNewIndex: $1
PageLabelStart: $2
$3
$4
EOF
}

# Append new page label information if variables are not empty
[ -n "$KMVAR_FirstPage" ] && append_page_label "$KMVAR_FirstPage" "1" "PageLabelPrefix: Cover" "PageLabelNumStyle: NoNumber"
[ -n "$KMVAR_LowercaseRomanNumerals" ] && append_page_label "$KMVAR_LowercaseRomanNumerals" "1" "PageLabelNumStyle: LowercaseRomanNumerals"
[ -n "$KMVAR_DecimalArabicNumerals" ] && append_page_label "$KMVAR_DecimalArabicNumerals" "1" "PageLabelNumStyle: DecimalArabicNumerals"

# Update PDF metadata
pdftk "$KMVAR_selected_pdf" update_info_utf8 metadata.text output adjusted-page-labels.pdf

# Remove `metadata.text`
rm metadata.text
```

这段代码主要分为 6 个部分：

- 使用 `export` 命令将 `pdftk` 命令所在的路径添加到 `PATH` 环境变量中，这样就可以直接使用 `pdftk` 命令，而不需要输入完整的路径。`/opt/homebrew/bin` 和 `/usr/local/bin` 分别是 Homebrew 在 Apple Silicon Mac 上和 Intel Mac 上的默认安装路径。
- 使用 `cd` 命令切换到选中 PDF 文件所在的路径。
- 使用 `pdftk` 命令导出 PDF 的元数据为文本文件 `metadata.text`。
- 使用 `sed` 命令删除 `metadata.text` 中已有的页码标签信息，然后使用 `cat` 命令将用户输入的页码标签信息追加到 `metadata.text` 中
- 使用 `pdftk` 命令将修改后的元数据导入 PDF，生成页码标签修改后的 PDF。
- 使用 `rm` 命令删除 `metadata.text`。

激活这个 macro 之后，在访达中选中需要修改页码标签的 PDF 文件，然后按下快捷键 `⌃ + ⌥ + L` 或点击菜单栏的 Keyboard Maestro Engine 图标，在弹出的窗口中输入不同类型的页码标签的起始页，就可以得到页码标签修改后的 PDF 文件，使用效果见下图。

{{< imgcap title="调整 PDF 页码标签的 Keyboard Maestro macro 使用效果" src="https://static.retompi.com/2735b7c5-8b3d-4574-8d91-1806391e0d0b.gif" >}}

在上图的示例中，默认将第 1 页的 page label 设置为 `Cover`，小写罗马数字的起始页为 2，阿拉伯数字的起始页为 5，生成的 PDF 的页码标签如下图所示。

{{< imgcap title="调整 PDF 页码标签后得到的 PDF" src="https://static.retompi.com/e7ea1f2e-c9f1-44fc-bba7-ded025a48755.png" >}}

需要注意的是，上述 macro 只包括了自定义的 Cover、小写罗马数字和阿拉伯数字这 3 种类型的页码标签，如果你需要调整其他类型的页码标签，可以参考上面的示例，自行修改 Shell 脚本中的代码。需要注意的是，`KMVAR_` 是 Keyboard Maestro 中 Shell 脚本使用变量所必需的前缀，不可省略。

## 转移 PDF 批注

{{< admonition title="🔖 Note" >}}
本文为少数派会员文章，以上是其中部分内容，欢迎加入少数派会员 [阅读全文](https://sspai.com/prime/story/cli-utils-for-pdf-manipulations)。
{{< /admonition >}}


<!-- 转移 PDF 批注是一个非常小众但很实用的需求。举个例子，假设你在阅读一个 PDF 文件的过程对它做了一些不可逆转的修改，比如删掉某些字符无法撤销，或者因为某些操作导致 PDF 体积变得非常大，而你在阅读过程中已经在这个 PDF 中做了一些批注。尽管你可以通过从其他途径获得这个 PDF 的原始副本来代替修改过的 PDF，但这个操作会导致已有的批注一并丢失。因此，你想要用新的 PDF 替代已经修改过的 PDF，并将已有的批注转移到新的 PDF 中。

再举个例子，如今很多学术期刊上的论文都采用在线出版（FirstView or Latest articles）的方式，即在论文编入某一期或卷之前首先发布在期刊的网站上，这样可以让研究成果尽快被读者阅读到，但此时的论文还没有被编入期刊的某一期（issue）或卷（volume）中，也就是还没有正式出版，在线出版和正式出版的时间往往相隔很长时间，有时甚至超过一年。绝大多数情况下，在线出版和正式出版论文唯一的区别是页码，例如在下图所示的例子中，左侧是在线出版的 PDF，页眉处的页码是 2，而在右侧正式出版的 PDF 中，页眉处的页码是 854。在引用这篇论文时，我们应该使用正式出版的论文，也就是右侧页码为 854 的论文，因此需要用右侧的论文替代左侧的论文。如果你已经在「在线出版」的论文 PDF 中做了一些批注，为了避免重复做一遍批注，你希望将批注转移到正式出版的论文中。

{{< imgcap title="在线出版和正式出版的论文的 PDF 文件页码不同" src="https://static.retompi.com/4c6c2238-3847-4298-8ed1-5103434b142a.png" >}}

如果你使用的 PDF 阅读软件将批注保存为一个单独的文件或保存在专有数据库中，比如 [Zotero 6](https://sspai.com/post/72163) 内置的 PDF 阅读器，那么完全可以实现无痛切换。但是我不习惯这种方式，因为我同时使用多个 PDF 软件，我希望无论在哪个 PDF 软件中打开，批注都保存在 PDF 文件内部，也就是 embedded annotations。

Adobe Acrobat 可以实现转移嵌入 PDF 内部的批注的功能，使用方式如下图所示。首先打开有批注的 PDF，点击右侧的「Comment」图标，然后点击右上角的更多选项图标，点击「Export All To Data File…」，然后在弹出的窗口中选择导出文件的存储位置和格式，有两种格式可选，一种是 FDF（Forms Data Format），另一种是 XFDF（XML Forms Data Format），这两种格式都可以导出 PDF 批注。

{{< imgcap title="在 Adobe Acrobat 中导出批注" src="https://static.retompi.com/d948d734-201d-4a4e-bc29-4404e61dcdf7.png" >}}

导出批注之后，再用 Adobe Acrobat 打开新的 PDF，点击右侧的「Comment」图标，然后点击右上角的更多选项图标，点击「Import Data File…」，然后在弹出的窗口中选择刚刚导出的批注文件，就可以将批注转移到新的 PDF 中。

{{< imgcap title="在 Adobe Acrobat 中导入批注" src="https://static.retompi.com/ddda067f-b17f-4eda-b03d-52c0e8e8aef9.png" >}}

说实话，我不喜欢使用 Adobe Acrobat 这种笨重且需要多次点击的软件，仅仅为了转移 PDF 批注，就需要两次打开 Adobe Acrobat，对我来说实在是难以忍受。因此，我曾多次尝试使用更加自动化的方法来代替在 Adobe Acrobat 中的操作。

一开始，我尝试通过 AppleScript 调用 Adobe Acrobat 来实现这个功能，但在网络上搜索之后，并没有找到足够靠谱的教程，于是放弃了这种方案。之后我想试试命令行工具，但在互联网上搜索一番之后，也没有找到现成的工具。搁置了许久之后，最近我又想起了这件事，于是想在 ChatGPT 的帮助下，借助 Python 来实现这个功能。在 ChatGPT 的指导下，我尝试使用了 [pypdf](https://github.com/py-pdf/pypdf)、[PyMuPDF](https://github.com/pymupdf/PyMuPDF)、[borb](https://github.com/jorisschellekens/borb)、[python-poppler](https://github.com/cbrunet/python-poppler) 等多个 PDF 相关的 Python 包，然而遗憾的是，尽管对话内容甚至都超过了 GPT-4 的 token 上限，我依然没有成功实现。

正所谓「山穷水尽疑无路，柳暗花明又一村」，就在经历多次尝试未果快要放弃之时，我想到了 Mac 上安装的 [Skim](https://skim-app.sourceforge.io/)——一个开源的 PDF 软件，体积小巧但功能强大。尽管我近来很少使用 Skim，但对它将 PDF 批注单独存储为 `.skim` 文件的特点印象深刻。事实上，我使用 Python 的思路就是为了模拟 Adobe Acrobat 的操作，即先将 PDF 批注导出为 FDF 或 XFDF 文件，然后再将其嵌入到另一个 PDF 中。既然 Skim 可以把批注单独保存为一个文件，我何必执着于导出为 FDF 或 XFDF，为什么不直接利用 Skim notes 呢？

经过一番研究，借助 Skim，我成功实现了「转移 PDF 批注」的功能，代码如下：

```shell
# Transfer annotations from one PDF to another via Skim

# 1. Convert `old.pdf` with embedded annotations to `output-skim.pdf` with Skim notes
skimpdf unembed old.pdf output-skim.pdf

# 2. Get Skim notes from `output-skim.pdf` as `output-skim.skim`
skimnotes get output-skim.pdf

# Tests whether `output-skim.pdf` has Skim notes (optional):
# skimnotes test output-skim.pdf

# 3. Write Skim notes to `new.pdf`
skimnotes set new.pdf output-skim.skim

# 4. Embed Skim notes to a new PDF file as embed annotations
skimpdf embed new.pdf

# 5. Remove temporary files
rm output-skim.*
```

这几行代码的作用如下：

1. 将 `old.pdf` 中的批注转换为 Skim notes，得到 `output-skim.pdf`。
2. 将 `output-skim.pdf` 中的 Skim notes 导出为 `.skim` 文件，得到 `output-skim.skim`。
3. 将 `output-skim.skim` 中的 Skim notes 导入到 `new.pdf` 中，得到带有批注的 `new.pdf`。
4. 将 `new.pdf` 的 Skim notes 嵌入为 embedded annotations，得到 `new.pdf`。
5. 删除临时文件 `output-skim.pdf` 和 `output-skim.skim`。

上面这几行 Shell 脚本用到了 Skim 提供的两个命令行工具 SkimNotes 和 SkimPDF。通过 Homebrew 命令安装 Skim 之后，这两个命令行工具会安装到 `/Applications/Skim.app/Contents/SharedSupport/` 目录下，Homebrew 会自动为它们创建软链接（symbolic link），添加到 `PATH` 环境变量中，可以直接在终端中使用。如果你不是使用 Homebrew 安装的 Skim，可以使用下面这行命令将 `skimnotes` 和 `skimpdf` 链接到 `/usr/local/bin` 中（按下回车后需要输入密码）：

```shell
sudo ln -s /Applications/Skim.app/Contents/SharedSupport/{skimnotes,skimpdf} /usr/local/bin/
```

为了弄清楚 Skim notes 是一种什么样的格式，也为了稳妥起见，我们可以用下面这行命令将 `.skim` 文件转换为 `.xml` 文件：

```shell
plutil -convert xml1 -o output-skim.xml output-skim.skim
```

使用 VS Code 打开转换得到的 `output-skim.xml` 文件，如下图所示。

{{< imgcap title="将 Skim notes 转换得到的 XML 文件" src="https://static.retompi.com/62e72530-07c6-4ea3-8be5-a93c166024ec.png" >}}

从这个 XML 文件可以看出，Skim notes 中的信息非常丰富，完全不输 FDF 和 XFDF 文件，包含了批注的颜色、位置、页码、类型、作者、创建时间、修改时间等信息。因此通过 Skim notes，我们可以实现和 Adobe Acrobat 一样的功能，将 PDF 批注转移到另一个 PDF 中。

为了让不熟悉命令行的朋友也能使用这个功能，我制作了两个 Keyboard Maestro macros 来实现「转移 PDF 批注」的功能，如下图所示。

{{< imgcap title="转移 PDF 批注的 Keyboard Maestro macros" src="https://static.retompi.com/2e00d03a-6223-4e14-97fc-7c0dfc76b133.jpeg" >}}

之所以是两个 macros，是因为我们需要在访达中先后选择两个 PDF 文件。左侧的「Step I」用于选择包含批注的 PDF，右侧的「Step II」用于选择需要转移批注的 PDF，这两个 macros 唯一的区别是用到的 Shell 脚本不同。

「Step I」中 Shell 脚本的作用是将 PDF 中的嵌入式批注转换为 Skim notes：

```shell
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

cd "$KMVAR_pdf_path"

# 1. Convert annotations embedded in the original PDF to output-skim.pdf with Skim notes
skimpdf unembed "$KMVAR_pdf_file" output-skim.pdf

# 2. Get Skim notes from `output-skim.pdf` as `output-skim.skim`
skimnotes get output-skim.pdf

# Tests whether `output-skim.pdf` has Skim notes (optional):
# skimnotes test output-skim.pdf
```

「Step II」中 Shell 脚本的作用是将 Skim notes 作为 embedded annotations 嵌入到新的 PDF 中，并删除临时文件：

```shell
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

cd "$KMVAR_pdf_path"

# 3. Write Skim notes to the new PDF
skimnotes set "$KMVAR_pdf_file" output-skim.skim

# 4. Embed Skim notes to a new PDF
skimpdf embed "$KMVAR_pdf_file"

# 5. Remove temporary files
rm output-skim.*
```

这两个 macros 的使用方式见下图。首先，在访达中选中包含批注的 PDF，然后按下快捷键 `⌃ + ⌥ + ⇧ + I`，就会得到 `output-skim.pdf` 和 `output-skim.skim` 两个文件；接下来，在访达中选中需要转移批注的 PDF，然后按下快捷键 `⌃ + ⌥ + ⇧ + H`，得到带有批注的新的 PDF。

{{< imgcap title="使用 Keyboard Maestro macros 转移 PDF 批注的使用效果" src="https://static.retompi.com/0b2cf512-ed2d-41dd-9b34-4cf6c6a4d9fc.gif" >}}

需要注意的是，通过 Skim 转移 PDF 批注可能会导致某些扫描版 PDF 的文字图层消失，比如通过 DEVONthink OCR 得到的 PDF 都存在这个问题，这大概是由于 Skim 使用 [Apple PDFKit](https://developer.apple.com/documentation/pdfkit) 框架来修改 PDF，而这一框架存在不少 [bug](https://discourse.devontechnologies.com/t/ocr-layer-disappearing/51806)。因此，请谨慎使用此方法转移扫描版 PDF 中的批注。

{{< imgcap title="转移批注后的 PDF 显示编码软件为 PDFKit" src="https://static.retompi.com/279d6f23-290a-404b-ace4-a93d832a6ef1.jpeg" >}}

## 移除 PDF 批注

除了转移 PDF 批注外，有时我们也有移除 PDF 中的批注的需求。比如，我们需要将自己阅读过的 PDF 分享给其他人，但是不希望分享自己在其中做的批注，因此想要将其全部移除。

PDF Expert 可以实现移除 PDF 批注的功能。首先，我们打开需要移除批注的 PDF，打开左侧的 Annotations 窗口（快捷键 `⌘ + ⌥ + 3`），然后全选所有批注（快捷键 `⌘ + A`），点击右键，选择「Remove」，或者在键盘上点击删除键，就可以将所有批注删除。使用方式如下图所示。

{{< imgcap title="在 PDF Expert 中移除 PDF 批注" src="https://static.retompi.com/1e1eba0c-f982-4f22-a8a2-ff30c89c49e5.png" >}}

不过，对于页码和批注非常多的 PDF 来说，PDF Expert 不会一次性全部加载所有的批注，而需要向下滚动才能加载，这样就需要多次点击，变得非常麻烦。在我的日常使用中，超过 500 页的 PDF 大多存在这个问题，因此我希望能够一键移除 PDF 中的所有批注，避免多次点击。此外，PDF Expert 是一个付费软件，如果你不想为了移除批注而购买 PDF Expert，那么可以使用下面这个 Keyboard Maestro macro 来实现这个功能。

{{< imgcap title="移除 PDF 批注的 Keyboard Maestro macro" src="https://static.retompi.com/ca672bd4-a6a9-4bec-8e78-29b7f96e5aad.png" >}}

上图的 macro 中，核心部分是执行下面这行 Shell 脚本：

```shell
pdftk "$KMVAR_pdf_file" output - uncompress | LC_ALL=C sed '/^\/Annots/d' | pdftk - output "$KMVAR_pdf_path"/pdf-without-annotations.pdf compress
```

这行命令的思路是先使用 `pdftk` 命令将 PDF 解压缩，然后使用 `sed` 命令删除批注信息，最后使用 `pdftk` 命令将修改后的 PDF 压缩，得到一个不包含批注的 PDF，保存为 `pdf-without-annotations.pdf`。需要注意的是，`sed` 命令之前的 `LC_ALL=C` 是为了解决 `sed` 命令在 macOS 上的 [locale](https://stackoverflow.com/a/23584470/4970632) 问题，其他操作系统可能不需要添加这个参数。当然，你也可以直接在命令行中执行下面的命令将 PDF 批注移除：

```shell
pdftk input.pdf output - uncompress | LC_ALL=C sed '/^\/Annots/d' | pdftk - output output.pdf compress
```

借助 Keyboard Maestro，我们只需在访达中选中 PDF，然后按下快捷键 `⌃ + ⌥ + ⇧ + R` 或点击菜单栏中的 Keyboard Maestro Engine 图标，就可以得到一个不包含批注的 PDF 文件。使用效果见下图。

{{< imgcap title="使用 Keyboard Maestro 移除 PDF 批注的使用效果" src="https://static.retompi.com/ef222955-d1d7-4078-a875-8157f76a0ccd.gif" >}}

## 分割 PDF 页面

分割 PDF 是指将双栏或多栏 PDF 的每一栏单独成页。在处理一些扫描版 PDF 书籍时，为了方便在电子屏幕上阅读或打印成纸质版，同时也为了保持纸质书籍的 page folios 和 PDF 的 page labels 一致，我们需要将 PDF 书籍的每一页分割为两页，并按照书籍的页码顺序排列。

{{< imgcap title="扫描得到的 PDF 书籍中，PDF 的每一页有书籍的两页" src="https://static.retompi.com/77c37d79-7843-43ce-b5dd-f30fa961fbd0.png" >}}

如本文开头所述，我使用 MuPDF 来实现分割 PDF 页面的功能。执行下面这行命令，就可以将双栏 PDF 转换为单栏 PDF：

```shell
mutool poster -x 2 input.pdf output.pdf
```

其中，`mutool poster` [命令](https://www.mupdf.com/docs/manual-mutool-poster.html) 读入 `input.pdf` 准备将其分割，`-x 2` 表示将 PDF 的每一页从垂直方向的正中间分割为两部分，`-y` 表示从水平方向上分割，紧接着后面的数字 `n` 表示分割成 `n` 部分，对于双页扫描的 PDF 来说，`n` 设置为 2，最终输出为 `output.pdf`。

将上面这行命令稍加修改，写成下面这样：

```shell
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

cd "$KMVAR_pdf_path"

mutool poster -x 2 "$KMVAR_pdf_file" output-$(date +%Y-%m-%d_%H-%M-%S).pdf
```

然后将其添加到 Keyboard Maestro 中，制作如下图所示的一个 macro，就可以通过 Keyboard Maestro 快捷地分割 PDF 页面。

{{< imgcap title="分割 PDF 页面的 Keyboard Maestro macro" src="https://static.retompi.com/62575e3a-1ede-4b60-92ba-3c4755ad8061.png" >}}

除了在 Keyboard Maestro 执行 `mutool` 之外，我们也可以在其他 macOS 自动化应用中执行这行命令。比如，在 Automator 中，我们将 workflow 接受的文件更改为「PDF files」，并且只在访达中起作用，也可以设置图标和颜色。接下来选择「Run Shell Script」action，将「Pass input」设置为 `arguments`，执行一段 Shell 脚本，制作一个如下图所示的 Automator Quick Action。

{{< imgcap title="分割 PDF 页面的 Automator Quick Action" src="https://static.retompi.com/3dbeec71-14b0-4e03-a005-15f4b38dd004.png" >}}

这个 Automator  quick action 执行的 Shell 脚本如下：

```shell
FILE="$@"
DIR=$(dirname "${FILE}")

export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

mutool poster -x 2 "${FILE}" "${DIR}/output-$(date +%Y-%m-%d_%H-%M-%S).pdf"
```

其中，`FILE="$@"` 表示接受 Automator workflow 传递过来的文件，`DIR=$(dirname "${FILE}")` 表示获取文件所在的路径，`mutool poster -x 2 "${FILE}" "${DIR}/output-$(date +%Y-%m-%d_%H-%M-%S).pdf"` 表示执行 `mutool` 命令，将 PDF 分割为单栏 PDF，并将输出的文件保存在原文件所在的路径中，文件名为 `output-$(date +%Y-%m-%d_%H-%M-%S).pdf`，其中 `$(date +%Y-%m-%d_%H-%M-%S)` 表示当前时间戳，以避免文件名重复。

类似地，我们也可以在 Shortcuts 中执行这行命令，制作如下图所示的一个 Shortcut。

{{< imgcap title="分割 PDF 页面的 Shortcut" src="https://static.retompi.com/63ab41c2-a32f-4e65-bc2d-c6588e118a9a.png" >}}

这个 Shortcut 只接受 PDF 作为输入，如果没有输入则停止。主体部分是执行一段 Shell 脚本处理选中的 PDF，使用的代码和上面的 Automator workflow 完全相同。如上图所示，为了在访达和菜单栏点击使用这个 Shortcut，需要勾选右侧的「Use as Quick Action」及下方的「Finder」和「Services Menu」。你可以点击 [这里](https://www.icloud.com/shortcuts/19deef9c50574eb7afd862f1a0bb798c) 安装这个 Shortcut，使用效果见下图。

{{< imgcap title="在访达中使用 Shortcut 分割 PDF 的使用效果" src="https://static.retompi.com/c0986c52-9ba9-4baf-b4d7-1bcc679cb899.gif" >}}

需要注意的是，首次执行这个 Shortcut 会弹出如下图所示的隐私弹窗，请求执行 Shell 脚本，点击允许即可。

{{< imgcap title="首次运行 Shortcut 请求执行 Shell 脚本的隐私弹窗" src="https://static.retompi.com/e768bd81-b969-4f11-8adc-b9ad6a6672b0.png" >}}

## 统一 PDF 页面尺寸

很多情况下，PDF 页面尺寸不一致，特别是对于扫描版 PDF 来说，这种情况非常普遍。为了方便阅读和打印，我们需要将 PDF 页面尺寸统一。在此前的 [文章](https://sspai.com/prime/story/cli-utils-for-ordinary-tasks) 中，我曾分享过的 LaTeX 包 pdfjam 可以轻松完成这一操作。值得注意的是，pdfjam 包含在 TeX 发行版中，如果你在 macOS 上已安装了 [MacTeX](https://www.tug.org/mactex/)[^iza]，就不需要再安装，这也是 pdfjam 文档中所推荐的安装方式。当然，如果你不想安装硕大无朋的 MacTeX，也可以根据 pdfjam 的 [文档](https://github.com/rrthomas/pdfjam#-installation) 单独安装它。

[^iza]: 可以使用 `brew install --cask mactex` 或 `brew install --cask mactex-no-gui` 安装 MacTeX，后者不包括其中的 GUI 应用。

下面这行命令中，pdfjam 将 `input.pdf` 的页面尺寸统一为 A4（210 x 297 mm），输出为 `a4paper.pdf`，其中 `--quiet` 用于抑制 pdfjam 的输出：

```shell
pdfjam input.pdf --a4paper --outfile a4paper.pdf --quiet
```

值得注意的是，A4 只是一种常见的页面尺寸，但并不表示 pdfjam 只能将页面统一为 A4。实际上，pdfjam 支持的页面尺寸基于 LaTeX 包 geometry，类型非常丰富，你可以查看 [geometry 文档](https://ctan.org/pkg/geometry) 了解更多信息。

尽管使用 pdfjam 统一 PDF 页面尺寸非常方便，但是它统一页面尺寸的机制是在 PDF 页面的四周填充白色边框，使其尺寸达到指定的大小。在下图的例子中，左侧的 `input.pdf` 是待处理的 PDF，右侧的 `a4paper.pdf` 是通过 pdfjam 统一页面尺寸后的 PDF。可以看到，与左侧 PDF 相比，右侧 PDF 页面四周边框变得很宽，导致 PDF 文字内容变得相对更小。

{{< imgcap title="使用 pdfjam 统一 PDF 页面尺寸的效果" src="https://static.retompi.com/4a315059-7b5e-40f7-afa2-f163fcda0b15.png" >}}

为了解决上述问题，我使用 Python 编写了一个脚本，实现按比例计算 PDF 的页面尺寸的功能，将所有页面统一为第一页的尺寸，代码如下：

```python
from pypdf import PdfReader, PdfWriter, PageObject
import os

def unify_page_sizes(input_pdf_path, output_pdf_path):
    input_pdf_path = os.path.expanduser(input_pdf_path)
    output_pdf_path = os.path.expanduser(output_pdf_path)
    
    pdf_reader = PdfReader(input_pdf_path)
    pdf_writer = PdfWriter()

    first_page = pdf_reader.pages[0]
    unified_width, unified_height = float(first_page.mediabox.upper_right[0]), float(first_page.mediabox.upper_right[1])

    for page_num in range(len(pdf_reader.pages)):
        page = pdf_reader.pages[page_num]
        src_width, src_height = float(page.mediabox.upper_right[0]), float(page.mediabox.upper_right[1])
        x_scale = unified_width / src_width
        y_scale = unified_height / src_height

        # Create a new blank page with the unified dimensions
        new_page = PageObject.create_blank_page(width=unified_width, height=unified_height)

        # Create a transformation matrix for scaling
        transformation_matrix = [x_scale, 0, 0, y_scale, 0, 0]

        # Merge the original page into the new page with the transformation matrix
        new_page.merge_transformed_page(page, transformation_matrix)

        # Add the new page to the PdfWriter object
        pdf_writer.add_page(new_page)

    # Save the new PDF
    with open(output_pdf_path, 'wb') as out_pdf_file:
        pdf_writer.write(out_pdf_file)

# Usage
input_pdf_path = os.environ.get('KMVAR_pdf_file')
output_pdf_path = os.path.join(os.environ.get('KMVAR_pdf_path', '.'), 'unified_page_size.pdf')
unify_page_sizes(input_pdf_path, output_pdf_path)
```

这段代码用到了 Python 包 `pypdf`，它的思路是首先获取 PDF 的第一页的尺寸，然后遍历 PDF 的每一页，计算每一页的尺寸与第一页的尺寸的比例，然后按照这个比例对每一页进行缩放，最后将缩放后的页面保存为新的 PDF，命名为 `unified_page_size.pdf`。 

为了使用方便，我们可以将这段代码保存为一个 `.py` 文件，然后通过下图所示的 Keyboard Maestro macro 来执行它。

{{< imgcap title="通过 Python 统一 PDF 页面尺寸的 Keyboard Maestro macro" src="https://static.retompi.com/801fe9e0-5109-47f2-b958-acb3ac9d4117.png" >}}

这个 macro 的核心是执行这行命令：

```shell
python ~/Documents/unify-pdf-pages/unify-pdf-pages.py
```

需要注意的是，你需要修改这行命令中 `python` 在你的 Mac 上的路径和 `.py` 文件的名称和路径，否则无法正常执行。使用这个 macro 统一 PDF 页面尺寸的最终效果见下图。可以看到，与 pdfjam 相比，通过 Python 统一页面尺寸得到的 PDF 没有很宽的边框，效果相对更好。

{{< imgcap title="通过 Keyboard Maestro 执行 Python 脚本统一 PDF 页面尺寸的效果" src="https://static.retompi.com/2da319ba-a075-463f-8d0d-b588b6190e1d.png" >}}

## 合并 PDF 页面

与将多个 PDF 文件合并为一个 PDF 文件不同，「合并 PDF 页面」是指将同一个 PDF 文件的多个页面合并为一个页面。比如有时为了节约纸张，可以在打印时将两页 PDF 放置到一张纸上。尽管打印时大多有「多页打印」的设置，比如在 macOS 上，我们可以在打印设置窗口中选择「每张纸的页数」，但这个选项只能在有限的 2、4、6、9 等选项中选择，也无法实现自定义的排列方式。例如在下图中，每张纸中两页 PDF 的默认排列方式是水平排列，不能实现垂直排列。

{{< imgcap title="打印时选择每张纸 2 页 PDF 的效果" src="https://static.retompi.com/9fa42355-d530-4349-a984-1adb8182e3a1.png" >}}

为了实现更加个性化的合并 PDF 页面的需求，我们可以使用命令行工具 pdfjam。比如使用下面这行命令，就可以将 `input.pdf` 中每两页合并为一页，输出为 `output.pdf`：

```shell
pdfjam input.pdf --nup 2x1 --landscape --outfile output.pdf --quiet
```

其中 `--nup 2x1` 表示将 2 页 PDF 水平并排放置到 1 页中，`2` 表示列数，`1` 表示行数，`--landscape` 表示将页面横向排列，`--quiet` 表示抑制 pdfjam 的输出。

将这行命令稍加修改，写成下面这样：

```shell
export PATH="$PATH:/Library/TeX/texbin"

cd "$KMVAR_pdf_path"

pdfjam "$KMVAR_selected_pdf" --nup "$KMVAR_ColumnNum"x"$KMVAR_RowNum" --landscape --outfile combined-sheets.pdf --quiet
```

然后将其添加到 Keyboard Maestro 中，制作如下图所示的一个 macro，就可以通过 Keyboard Maestro 快捷地合并 PDF 页面。

{{< imgcap title="合并 PDF 页面的 Keyboard Maestro macro" src="https://static.retompi.com/1ddfe26e-e82b-42f2-a409-08a0e8f90969.png" >}}

激活这个 macro，会首先弹出一个输入框，提示用户输入合并后的 PDF 中每一页的列数和行数，完成输入后，就会得到合并后的 PDF，保存到当前目录中，使用效果如下图所示。

{{< imgcap title="借助 Keyboard Maestro 合并 PDF 页面的效果" src="https://static.retompi.com/0fa6e509-877b-47a6-aac6-fe434662c1b6.gif" >}}

## 转移 PDF 书签

PDF 书签（[bookmark](https://helpx.adobe.com/hk_en/acrobat/using/page-thumbnails-bookmarks-pdfs.html)）是指导航窗格的书签面板中的超链接文本，对应着不同的页码，有时也叫作「目录」或「大纲」，这是一种非常容易丢失的信息，比如使用 [DEVONthink](https://www.devontechnologies.com/apps/devonthink) OCR PDF 或批注 PDF，都有可能导致 PDF 书签丢失，在本文上述的例子中，分割 PDF 页面、统一 PDF 页面尺寸等操作也都会导致 PDF 书签丢失。因此，如果你需要对 PDF 进行这些操作，最好先将 PDF 书签导出，待处理完毕后，再将其导入到新的 PDF 中，实现 PDF 书签的转移。

转移 PDF 书签用到的工具是 PDFtk。使用下面这行命令，就可以将 `input.pdf` 的元数据导出，得到 `metadata.text`，如果该 PDF 包含书签，则书签信息也会导出到 `metadata.text` 中：

```shell
pdftk input.pdf dump_data_utf8 output metadata.text
```

使用 VS Code 打开 `metadata.text`，可以看到如下图所示的内容。

{{< imgcap title="导出 PDF 元数据后中的书签信息" src="https://static.retompi.com/0594a687-d1c6-4bf4-8b75-21cc70b46abd.png" >}}

从上图可以看到，每个书签条目由 4 行组成：

- `BookmarkBegin`：开始一个书签条目
- `BookmarkTitle`：书签标题
- `BookmarkLevel`：书签层级，用阿拉伯数字 1、2、3 等表示
- `BookmarkPageNumber`：书签的页码，从第 1 页开始计算

为了实现 PDF 书签的转移，我们可以将 `metadata.text` 中的书签信息复制到新的 PDF 的元数据中，然后使用下面这行命令，将更新后的 `metadata.text` [导入](https://www.pdflabs.com/docs/pdftk-man-page/#dest-op-update-info-utf8) 到新的 PDF 中。这样，新的 PDF 就包含了原有 PDF 的书签信息：

```shell
pdftk input.pdf update_info_utf8 metadata.text output output.pdf
```

为了便捷地实现 PDF 书签的转移，我制作了两个 Keyboard Maestro macros，无需手动复制粘贴，就可以实现 PDF 书签的转移，如下图所示。

{{< imgcap title="转移 PDF 书签的 Keyboard Maestro macros" src="https://static.retompi.com/76947f1c-e071-41ee-b965-9aac60fec587.jpeg" >}}

在上图左侧的 macro 中，核心部分是执行这两行命令：

```shell
cd "$KMVAR_pdf_path"

pdftk "$KMVAR_pdf_file" dump_data_utf8 | grep "Bookmark"
```

它的作用是将原有的 PDF 的元数据导出，然后使用 `grep` 命令筛选出包含 `Bookmark` 字符的行，也就是书签信息，保存为 Keyboard Maestro 中的变量 `extracted_pdf_bookmark`，供右侧的 macro 使用。最后播放一个音效「Glass」，起到提示的作用。

在上图右侧的 macro 中，执行的是这几行 Shell 命令：

```shell
cd "$KMVAR_pdf_path"

pdftk "$KMVAR_pdf_file" dump_data_utf8 output metadata.text

echo "$KMVAR_extracted_pdf_bookmark" | sed -i '' '/NumberOfPages/ r /dev/stdin' metadata.text

pdftk "$KMVAR_pdf_file" update_info_utf8 metadata.text output output-$(date +%Y-%m-%d_%H-%M-%S).pdf

rm metadata.text
```

这几行命令的作用是将新得到的 PDF 的元数据导出，得到 `metadata.text`，然后将 Keyboard Maestro 中的变量 `extracted_pdf_bookmark` 中的书签信息插入到 `metadata.text` 中，最后将更新后的 `metadata.text` 导入到新的 PDF 中，得到带有书签的新的 PDF，最后删除临时文件 `metadata.text`。这两个 macros 的使用方式与上面介绍的「转移 PDF 批注」的 macros 类似，此处不再赘述。

## 嵌入文件到 PDF 中

PDF 文件支持嵌入文件，这恐怕是一个很少有人知道的功能。利用这个功能，PDF 可以像压缩包一样，包含多个文件。嵌入文件到 PDF 中的好处是可以将多个文件合并到一起，方便分享和存储。比如，你可以将一篇论文的原始数据、代码、图片、HTML 和 DOCX 格式的论文等一系列附件嵌入到 PDF 格式的论文中，这样，你就只需发送一个 PDF 文件给其他人，而其他人在该 PDF 中点击对应的链接，就可以打开相应的附件，这在某些不支持发送和打开压缩包的场景下非常有用。

[Adobe Acrobat](https://helpx.adobe.com/acrobat/using/links-attachments-pdfs.html#add_an_attachment) 可以为 PDF 添加附件，但是毕竟要付费，不符合本文分享免费工具的原则。尽管在之前的 [文章](https://sspai.com/post/64842) 中，我曾分享过如何使用 LaTeX 将文件嵌入到 PDF 中的方法，但对于不熟悉 LaTeX 的朋友来说，这个方法可能有些复杂。

下面，我们使用 PDFtk 来实现将文件 [嵌入](https://www.pdflabs.com/docs/pdftk-man-page/#dest-op-attach) 到 PDF 中的功能。执行下面这行命令，可以将 `attach.png` 嵌入到 `input.pdf` 中，得到带有附件的 `output.pdf`：

```shell
pdftk input.pdf attach_files attach.png output output.pdf
```

如下图所示，使用 PDF Expert 打开生成的 `output.pdf`，可以看到左侧的导航窗格中多了一个附件图标，点击之后即可在默认的应用程序中打开。

{{< imgcap title="在 PDF Expert 中打开嵌入附件的 PDF" src="https://static.retompi.com/aac7fc37-558d-4d47-a70f-ff7d3dd6c4c9.png" >}}

如果你想要将附件嵌入到 PDF 的某一页中，可以加上 `to_page` 参数，例如下面这行命令将 `attach.png` 嵌入到 `input.pdf` 的第一页中：

```shell
pdftk input.pdf attach_files attach.png to_page 1 output output.pdf
```

同样使用 PDF Expert 打开生成的 `output.pdf`，可以看到该 PDF 的第一页中有一个类似回形针的附件图标，点击之后即可打开嵌入的 `attach.png`，如下图所示。

{{< imgcap title="在 PDF Expert 中打开嵌入附件到第一页的 PDF" src="https://static.retompi.com/2cba4437-0e07-4dfb-8a45-7e9ff927897b.png" >}}

将上述代码稍加修改，我们可以制作下图所示的两个 Keyboard Maestro macros，用于将文件嵌入到 PDF 中。

{{< imgcap title="将文件嵌入到 PDF 中的 Keyboard Maestro macros" src="https://static.retompi.com/fc0027f8-2e2a-4c8d-9c60-6636b28553e2.jpeg" >}}

上图左侧的 macro 非常简单，只是为了将要嵌入的文件保存为 Keyboard Maestro 中的变量 `attached_file`，供右侧的 macro 使用。右侧的 macro 中，核心部分是执行下面这两行命令：

```shell
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

pdftk "$KMVAR_pdf_file" attach_files "$KMVAR_attached_file" output "$KMVAR_pdf_path"/pdf-with-attachment.pdf
```

这段代码的作用是将上图左侧 macro 中的 `attached_file` 嵌入到右侧 macro 选中的 `pdf_file` 中，得到 `pdf-with-attachment.pdf`。使用时，你需要首先在访达中选中要嵌入的文件，然后执行左侧的 macro，将文件保存为变量 `attached_file`，接下来在访达中选中要添加附件的 PDF，然后执行右侧的 macro，就可以得到嵌入了附件的 PDF 文件 `pdf-with-attachment.pdf`。使用效果见下图。

{{< imgcap title="通过 Keyboard Maestro 将文件嵌入到 PDF 中的使用效果" src="https://static.retompi.com/19c5f89b-94c0-425c-bc05-b617b70424b7.gif" >}}

除了将文件嵌入到 PDF 中，PDFtk 也支持将 PDF 中的附件导出。如果一个 PDF 包含嵌入的附件，你可以使用下面这行命令将附件 [导出](https://www.pdflabs.com/docs/pdftk-man-page/#dest-op-unpack) 到当前目录中：

```shell
pdftk input.pdf unpack_files
```

值得注意的是，除了 PDFtk 以外，其他一些命令行工具也可以实现将文件嵌入到 PDF 或从 PDF 中导出附件的功能，比如 `pdfattach` 和 `pdfdetach`，它们都是 [Poppler](https://poppler.freedesktop.org/) 的一部分，可以通过 `brew install poppler` 安装，如果你感兴趣，可以使用 `pdfattach --help` 和 `pdfdetach --help` 查看它们的使用方法。

## 绕过 PDF 权限密码

PDF 有 [两种密码](https://helpx.adobe.com/acrobat/using/securing-pdfs-passwords.html) 保护方式，一种是打开密码（document open password），也被称为用户密码（user password），另一种是权限密码（permissions password）。前者是指打开 PDF 时需要输入的密码，后者是指对 PDF 进行编辑、打印、OCR 等操作时需要输入的密码。

{{< imgcap title="在预览中打开有权限密码的 PDF" src="https://static.retompi.com/7eb81677-9802-43a3-a2f0-49ec964efcd1.png" >}}

尽管权限密码可以起到保护 PDF 内容的作用，但既然用户能够阅读，为什么不可以对它进行批注呢？好在有不少方法可以绕过 PDF 权限密码，下面介绍几种我用过的方法。需要注意的是，这些方法都只能绕过权限密码，而不能绕过打开密码。此外，PDF 权限密码在很大程度上依赖于 PDF 软件，比如同一份有权限密码的 PDF，在 Preview（预览）中无法批注，但在 PDF Expert 中可以批注，这可能是因为 PDF Expert 使用了自己开发的 PDF 框架，而不是使用 macOS 自带的 PDFKit 框架。受此启发，我们可以通过在 PDF Expert 中新建一个空白 PDF，然后将有权限密码的 PDF 拖拽到空白 PDF 中，再删除这个 PDF 第一页的空白页，就可以得到一个没有权限密码的 PDF，使用方法见下图。

{{< imgcap title="使用 PDF Expert 中绕过 PDF 权限密码" src="https://static.retompi.com/be406737-04fa-491b-a39f-319cc2ae39ef.gif" >}}

除了 PDF Expert 外，你也可以使用系统自带的免费方案——Automator，制作一个如下图所示 quick action。

{{< imgcap title="使用 Automator 绕过 PDF 权限密码" src="https://static.retompi.com/3a5ebc74-d476-4ce2-8ef1-afdd2c6264f8.png" >}}

这个 Automator workflow 的作用是使用「Split PDF」这个 action，将访达中选中的 PDF 拆分为单页 PDF，保存到桌面上，命名为 `split-pdf-output-page*.pdf`，其中 `*` 表示页码。然后执行下面这段 Shell 脚本，使用 PDFtk 将这些单页 PDF 合并为一个 PDF，当然合并 PDF 有很多方案，你也可以选择其他方式。Shell 脚本的最后一步是删除所有单页 PDF，得到一个没有权限密码的 PDF 文件 `pdf-without-password.pdf`：

```shell
cd desktop

export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

pdftk split-pdf-output-page*.pdf cat output pdf-without-password.pdf

rm split-pdf-output-page*.pdf
```

除了以上两种方法，最后再介绍一种绕过 PDF 权限密码到「开箱即用」的方法，也就是在访达中执行 [quick actions](https://support.apple.com/guide/mac-help/mchl97ff9142/mac)（快速操作），通过创建 PDF 的方式，将有权限密码的 PDF 转换为没有权限密码的 PDF。

{{< imgcap title="在访达中通过「创建 PDF」的动作绕过 PDF 权限密码" src="https://static.retompi.com/774a4eb6-95a0-46b5-9c30-186d64465cd1.png" >}}

值得注意的是，上图所示的「Create PDF」是 [macOS 自带](https://support.apple.com/guide/mac-help/mchl21ac2368/14.0/mac/14.0) 的一个 action，你只需要确保「Settings -> Privacy & Security -> Extensions -> Finder -> Create PDF」处于开启状态即可。

{{< imgcap title="在系统设置中开启「Create PDF」" src="https://static.retompi.com/4944e000-5572-47f5-ae53-2c994b6b21f7.png" >}}

你可能注意到了，上图中创建 PDF 的快捷操作不仅适用于 PDF，对图片同样有效。因此，你可以创建一张图片或一个单页 PDF，然后同时选中有权限密码的 PDF 和这张图片或单页 PDF，右键点击，选择「Quick Actions -> Create PDF」，最后将生成的 PDF 中的辅助图片或 PDF 删除，就可以得到一个没有权限密码的 PDF。

容易发现，无论是 PDF Expert、Automator 还是「创建 PDF」的快捷操作，都是通过创建新的 PDF 来绕过 PDF 权限密码的。因此，理论上，只要能够基于有密码的 PDF 创建新的 PDF，就可以用来绕过 PDF 权限密码，比如「打印 PDF」在某些情况下也是可行的。

## 小结

本文介绍了我在日常使用中遇到的一些 PDF 自动化需求，包括处理 PDF 页码、批注、页面、书签、附件、密码等方面，这些需求可能不是太常见，但是在遇到这些需求时，你可以使用本文介绍的方法来解决。如果你有其他处理 PDF 的需求，也可以在评论区留言，我会在时间和能力允许的情况下，尽量帮助你解决。

文中提供的方法基本上都是通过命令行实现的，尽管它们全都是完全免费的，但对于不少朋友来说，可能对使用命令行具有畏惧心理，不知道如何上手，这也是我在帮助那位爱书朋友解决分割扫描 PDF 书籍意识到的问题。正因如此，我将文中用到这些命令行工具的操作全部封装成了 Keyboard Maestro macro、Automator workflow 或 Shortcuts，以便所有人都能「开箱即用」。

对于本文处理 PDF 的技巧，所有 Keyboard Maestro macro 的制作思路大致都是相同的。首先获取访达中选中的 PDF 文件的路径，用到的 action 是「For Each Path in Finder Selection」，这一步的目的是为了获取选中文件的路径，以便将其传递给命令行工具。为了将生成的 PDF 文件保存在当前路径下，还需要获取选中文件所在的路径，用到的 action 是「Get File Attribute」中的「parent path」。接下来通过「If Then Else」action 判断选中的文件是否是 PDF，如果不是 PDF，则弹出一个通知，并取消执行当前 macro；如果选中的文件是 PDF，则通过「Execute a Shell Script」action 执行 Shell 脚本。这一步有两个需要注意的地方，一是关于 Keyboard Maestro 中的环境变量，在本文中，我们使用的是 `export` 命令将用到的命令行工具的路径添加到环境变量中。关于 Keyboard Maestro 中另外两种的环境变量的设置方式，可以参考我的 [这篇文章](https://sspai.com/post/82976)。第二个需要注意的问题是 Keyboard Maestro 中的变量，与直接在命令行中执行命令不同，从 Keyboard Maestro 中获取的变量需要添加 `$KMVAR_` 作为前缀，其后紧跟着变量名，如果变量名中有空格，则需要将空格替换为下划线 `_`。例如在本文中，为了获取选中的 PDF 文件的路径，需要在 Shell 脚本中写作 `"$KMVAR_pdf_file"` 的形式，其中 `pdf_file` 是变量的名称。此外，对于需要用户输入的变量，我们使用 Keyboard Maestro 的「Prompt for User Input」action 将其传递给 Shell 脚本。

最后，通过本文制作的 Keyboard Maestro macros、Automator workflow 和 Shortcuts，相信你可以大致看出这三个 Mac 自动化工具的异同。Automator 和 Shortcuts 和 Keyboard Maestro 有很多相似之处，比如对于执行 Shell 脚本处理 PDF 来说，三者都能获取访达中选中的 PDF，避免了在命令行中执行 Shell 脚本需要修改文件名称的繁琐。然而，作为 Apple 第一方应用的 Automator 和 Shortcuts，在不少方面还是比不上 Keyboard Maestro，比如它们无法像 Keyboard Maestro 一样在不同 macro 之间使用同一个变量，也不支持自定义用户输入窗口。正如其开发者 [Peter N Lewis](https://mastodon.social/@peternlewis/111543907372944570) 所说的那样：

> I don’t like to trumpet my own app, but seriously, I have never seen a thread more in need of a Keyboard Maestro recommendation than this one. Fewer bugs, clearer control over actions and the best [forum](https://forum.keyboardmaestro.com/) on the Internet. Every time I try to use Shortcuts for anything on my phone I just end up curled in a ball whimpering.
>
> ---
> 
> 我不太喜欢过分吹嘘我的应用，但不得不说，真没有哪个讨论比这个帖子更适合推荐 Keyboard Maestro 了。它不仅问题少，操作也更为直观，还有着网上最棒的用户社区。每次我在手机上试图使用快捷指令做些什么，到头来总是无奈地感到沮丧。 -->
