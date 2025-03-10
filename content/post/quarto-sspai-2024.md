---
title: 从 Pandoc 到 Quarto：纯文本学术写作的实践与优化
date: 2025-03-06
categories:
    - Markdown
    - Quarto
    - Pandoc
---

{{< admonition title="🔖 Note" >}}
本文参与少数派 [2024 年度征文活动] 的入围文章，你可以在 [少数派] 上阅读本文。

  [2024 年度征文活动]: https://sspai.com/post/95877
  [少数派]: https://sspai.com/post/97056
{{< /admonition >}}

## 前言：工具对了，事半功倍

学术论文写作是一项繁琐而严谨的工作，但却是科研工作的核心环节。写好一篇学术论文，不仅需要有大量的文献阅读和扎实的实证研究，还需要有严谨的理论分析和精准的表达能力。除此之外，「用什么工具写」也是一个非常重要的问题，选择合适的写作工具，往往能起到事半功倍的效果。

几年前，我曾分享过基于 [Markdown 写作并使用 Pandoc 转换的纯文本学术写作流程](https://sspai.com/post/64842)，这篇文章是我在少数派发布的文章中点赞数量最多的一篇，时至今日仍能收到不少读者的反馈。，这也从侧面反映出，学术写作工具与流程的优化，是许多同学和研究者的共同需求。时光荏苒，四年过去了，技术在不断更新迭代，开源社区也在持续贡献着新的工具和方案。碰巧的是，在我发布那篇文章的同一个月，RStudio（现已更名为 Posit）团队发布了 [Quarto 的第一个版本](https://github.com/quarto-dev/quarto-cli/releases/tag/v0.1.13)——一个基于 Pandoc 的开源科学出版系统，进一步提升了学术写作的效率和体验。

对于熟悉我上一篇文章的读者来说，可能会有疑问：既然 Pandoc 已经足够强大且能满足学术写作需求，为什么还要重复造轮子，开发 [Quarto](https://quarto.org/) 呢？这是因为 Quarto 在 Pandoc 的基础上提供了更多针对科学出版的功能和更加友好的使用体验。例如，Quarto 支持直接在文章中直接运行 [Python](https://quarto.org/docs/computations/python.html)、[R](https://quarto.org/docs/computations/r.html)、[Julia](https://quarto.org/docs/computations/julia.html) 等代码[^llm]，额外支持交叉引用、参考文献预览、可视化编辑等，可以非常便捷地生成可重复稿件（reproducible manuscripts）。如果说 Pandoc 是文档转换的瑞士军刀，那么 Quarto 则是专注于学术写作的利器[^quarto]。

[^llm]: 这一功能来自于 Quarto 的前辈——RStudio 开发的另一款工具 [R Markdown](https://rmarkdown.rstudio.com/)。如今，在大语言模型的加持下，这种类似于文学式编程（[literate programming](https://en.wikipedia.org/wiki/Literate_programming)）的写作方式，能够让学术写作变得更加高效和自然。

[^quarto]: 值得一提的是，Quarto 命令行工具中包含 Pandoc，因此如果你已经安装了 Quarto，则不需要额外安装 Pandoc。目前 Quarto 正式版的最新版本是 [1.6.42](https://github.com/quarto-dev/quarto-cli/releases/tag/v1.6.42)，其中包括了 Pandoc 3.4。

尽管如此，Quarto 也并非完美无缺。由于它主要是为英语写作开发的工具，对于中文写作的支持并不十分完善，比如中西文混排下的引号、空格，学术写作的参考文献排序、本地化字符等，都需要进行额外的配置和处理。在过去的一年，我全面转向使用 Quarto 来撰写包括期刊论文、学位论文、会议报告在内的所有学术相关的文档。从最初的摸索到后来的得心应手，这一路积累了不少实践心得，特别是针对多种输出格式的改进和中文写作的优化。本文将结合我过往使用 Markdown + Pandoc 的经验，分享我使用 Quarto 进行学术写作的技巧，实现通过一份 Markdown 源文件输出完美的 Word、PDF、HTML 和 ePub 等格式。

为了更好地方便读者使用 Quarto 进行中文论文写作，我在 GitHub 上开源了 [quarto-cn-tools](https://github.com/TomBener/quarto-cn-tools) 项目，下文的内容也主要基于这个项目。

## 依然使用 Markdown 写作

Quarto 官方文档中提到，Quarto 文档（`.qmd` 文件）是 Markdown 和可执行代码块的结合，也就是可以直接执行代码的 Markdown 文件。尽管如此，Quarto 文档还是没有 Markdown 那样普遍，某些编辑器如 [Ulysses](https://ulysses.app) 无法在外部文件夹中读取 `.qmd` 文件。因此，为了尽可能在不同编辑器中保持兼容性，我依然选择使用 Markdown 写作。

为了充分利用 Quarto 的强大功能，在使用 Quarto 编译前，需要对 Markdown 文件进行一些预处理，同时将其转换为 Quarto 文档。之所以要这样做，是因为我主要使用 Ulysses 编辑 Markdown 文件[^ulysses]，而 Ulysses 会将行内链接转换为引用式链接，尽管可以选择关闭这一选项，但为了原始 Markdown 文档的 [可读性](https://sspai.com/post/77513)，我还是选择对 Markdown 进行预处理。此外，一般我会使用多个 Markdown 文件来组织论文，也就是将 `index.qmd` 作为主文件，`contents` 文件夹下存放各章节文件，减少各个部分相互干扰。但如果多个文件都有脚注的话，会出现重复的脚注编号，例如每个文件中都有 `[^1]`、`[^2]` 等[^footnote]，尽管 Pandoc 提供了 [--file-scope](https://pandoc.org/MANUAL.html#option--file-scope%5B) 参数来解决这个问题，但它在 Quarto 中 [并不适用](https://github.com/quarto-dev/quarto-cli/discussions/6333)。

[^ulysses]: 尽管 Markdown 编辑器层出不穷，但 Ulysses 依然是我最喜欢的 Markdown 编辑器，它的写作体验无出其右。

[^footnote]: Ulysses 会强制将脚注编号转换为阿拉伯数字，按照 Markdown 文件中的出现顺序从 `1` 递增。

{{< imgcap title="在 Ulysses 中读取外部 Markdown 文件夹中的多个文件，并开启「创建引用式链接」选项" src="https://cdn.retompi.com/580715d7-a740-4b88-9029-97c68fc7b4b0.png" >}}

为了最大限度地保持不同 Markdown 编辑器的兼容性，我编写了一个简单的 [Python 脚本](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/format-md.py) 来预处理 Markdown 文件：

- 随机化脚注编号，避免多个文件中出现重复的脚注编号造成冲突
- 将引用式链接转换为行内链接，同样是为了避免多个文件出现冲突
- 去除中文引号中的换行符，避免在后续处理引号时出现问题
- 将 Ulysses 中的数学公式块转换为 LaTeX 的通用格式

将文章中的各个章节拆分为多个 Markdown 文件是为了写作时更方便，但在转换为其他文件格式时，需要将其合并为一个单独的文件。为此，我们可以使用 Quarto 的 [includes](https://quarto.org/docs/authoring/includes.html) 功能将各个章节的内容包含进来，例如在 `index.qmd` 文件中加入下面这几行：

```markdown
{{</* include contents/1-introduction.qmd */>}}
{{</* include contents/2-literature-review.qmd */>}}
{{</* include contents/3-methods.qmd */>}}
{{</* include contents/4-results.qmd */>}}
{{</* include contents/5-conclusion.qmd */>}}
```

如此这般，我们就可以将各个章节的内容整合在一起，形成一篇完整的论文。而在设置文档属性时，我们只需要在项目的配置文件 `_quarto.yml` 中进行配置，而不必在每个 Markdown 文件中重复设置。这是 Quarto 在 Pandoc 基础上的一大改进，大大简化了复杂项目的配置管理。你可以参见下面的一个简单示例：

```yml
title: 用 Quarto 写作中文学术论文
subtitle: 一个简单的示例
author:
  name: Tom Ben
  email: email@example.edu
student-id: 1234567890
supervisor: 导师姓名
institute: 所在学校名称
major: 专业名称
date-format: "YYYY年M月D日"
number-sections: true
link-citations: true
toc: true
reference-section-title: 参考文献
bibliography: bibliography.bib
csl: _styles/gb-author-date.csl
execute:
  cache: true
  freeze: auto
  echo: true
  warning: false

format:
  docx:
    reference-doc: _styles/custom.docx
    template: _styles/custom.openxml
    filters:
      - remove-spaces
      - docx-quotes
    date: today

  html:
    template: _styles/html5.html
    date: 2025-03-06
    date-modified: today
    theme:
      light: [flatly, _styles/custom.scss]
      dark: [darkly, _styles/custom.scss]

  pdf:
    filters:
      - latex-quotes
    include-in-header:
      - _styles/custom.tex
    papersize: a4
    geometry: [margin=2.5cm]
    cite-method: biblatex
    biblio-style: gb7714-2015ay

  epub:
    epub-cover-image: figures/cover.png
    rights: © 2024--Present Tom Ben
    date: today

  revealjs:
    template: _styles/revealjs.html
    theme: _styles/metropolis.scss
    output-file: slides.html
    logo: figures/logo.svg
    citeproc: false
    toc-depth: 1
```

可以看到，我们可以在 `_quarto.yml` 中为每种输出格式单独设置不同的参数，满足不同的需求，而其他元数据则会作为默认参数应用到所有输出格式中。关于 `_quarto.yml` 的详细配置，你可以参考我在 GitHub 上分享的 [配置文件](https://github.com/TomBener/quarto-cn-tools/blob/main/_quarto.yml)，或者查看 [Quarto 文档](https://quarto.org/docs/projects/quarto-projects.html) 了解更多信息。

## 中文学术写作优化

正如前文所述，Pandoc 和 Quarto 在中文学术写作环境下都会遇到一些棘手的问题，例如中英混排的参考文献中的本地化字符替换、参考文献排序、中英文标点符号样式等。这些问题看似不起眼，但如果不加处理，会让论文的专业性和严谨性大打折扣，甚至影响论文的整体质量[^quality]。

[^quality]: 对于本科或硕士学位论文来说，评审老师关注的焦点往往是论文的格式，反而可能对论文的内容和研究质量关注较少，特别是在论文答辩环节。

此前，在使用 Pandoc 时，我也曾遇到过这些问题，但当时没有深入研究，只是通过一些变通的方法来解决。例如在生成 Word 文件之后，将其解压缩并使用正则表达式实现查找替换，但这种「简单粗暴」的方法有不少局限性，在不同格式下处理起来非常麻烦，面临着 Pandoc 或 Quarto 更新后失效的风险。

去年，在撰写博士学位论文开题报告的过程中，借助大语言模型，我尝试通过编写 [Pandoc filters](https://pandoc.org/filters.html) 来解决这些细节问题。在 Lua filter 和 Python filter 的帮助下，通过修改 Pandoc 的内部抽象语法树（AST），基本上解决了这些困扰多年的细节问题，为完全使用 Markdown 写作中文学术论文扫清了障碍。

### 中文参考文献字符本地化

国内期刊论文和学位论文广泛使用的《[信息与文献 参考文献著录规则 GB/T-7714-2015](https://web.archive.org/web/20241130221212/https://journal.ustc.edu.cn/uploadfile/yjsjy/20161108/GB%20T%207714-2015%E4%BF%A1%E6%81%AF%E4%B8%8E%E6%96%87%E7%8C%AE-%E5%8F%82%E8%80%83%E6%96%87%E7%8C%AE%E8%91%97%E5%BD%95%E8%A7%84%E5%88%99.pdf)》第 15 页 10.2.2 节规定：

> 正文中引用多著者文献时，对欧美著者只需标注第一个著者的姓，其后附「et al.」；对于中国著者应标注第一个著者的姓名，其后附「等」字。姓氏与「et al.」「等」之间留适当空隙。

遗憾的是，Pandoc 使用 CSL（[Citation Style Language](https://citationstyles.org/)）来格式化参考文献信息，但 CSL 不支持多语言的参考文献格式化，例如在 Pandoc 中将语言设置为默认的 `en-US` 时，所有文献的本地化字符都会被转换为英文，例如 `et al.`、`vol.`、`trans.` 等[^etal]。尽管 Zotero 中文社区提供了不少支持 [双语排版的 CSL](https://zotero-chinese.com/user-guide/faqs/word-addon#%E4%B8%AD%E8%8B%B1%E6%96%87%E6%B7%B7%E6%8E%92)，但这需要在 Zotero 中进行语言设置。更关键的是，这种双语排版不是 CSL 的标准语法，因此 [Pandoc 并不支持](https://github.com/zotero-chinese/styles/issues/177)，直接使用会有 `CiteprocParseError: Multiple layout elements present in citation` 错误。

[^etal]: 这些字符是 CSL 的语言环境预先定义的，你可以在 CSL 的 GitHub 仓库中找到对应的 [中文翻译](https://github.com/citation-style-language/locales/blob/master/locales-zh-CN.xml)，从中可以看到，`et al.`、`vol.`、`trans.` 对应的中文分别是 `等`、`卷`、`译`。

为了解决这个长期困扰我的问题，我编写了一个名为 `localize-cnbib.lua` 的 [Lua filter](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/localize-cnbib.lua)，用于实现替换中文正文引用和文末参考文献表中的本地化字符，包括：

- `et al.` 替换为 `等`
- `vol. X` 替换为 `第X卷`
- `trans.` 替换为 `译`
- `ed.` 或 `eds.` 替换为 `编`
- `ed.` 替换为 `编` 或 `X版`

当 Quarto 渲染文档时，这个 Lua filter 会在 Pandoc 生成引用之后介入，对文档的 AST 进行遍历，将满足条件的英文字符替换为对应的中文字符。值得一提的是，`localize-cnbib.lua` 同时支持 author-date 和 numeric 两种引用格式，并且在 [link-citations](https://pandoc.org/MANUAL.html#other-relevant-metadata-fields) 开启或关闭时都能正常工作。当然，上述替换只考虑了常见中文文献字符本地化的情况，如果有其他字符需要中文本地化，你可以自行修改 `localize-cnbib.lua` 文件，或者在 GitHub 上提交 issue。

需要注意，本项目中的 [gb-author-date.csl](https://github.com/TomBener/quarto-cn-tools/blob/main/_styles/gb-author-date.csl) 和 [gb-numeric.csl](https://github.com/TomBener/quarto-cn-tools/blob/main/_styles/gb-numeric.csl) 是我根据 [Zotero Styles](https://www.zotero.org/styles) 网站下载的 CSL 样式文件修改而来的。与原始样式文件相比，修改之后的样式文件更加符合 GB/T 7714-2015 的标准，而 `localize-cnbib.lua` 也是根据这两个样式文件的格式来编写的，因此它可能对其他 CSL 样式文件不起作用。另外，如果在 Quarto 中使用，无法在 YAML 文件中指定这个 Lua filter，只能在命令行中使用 `-L _extensions/localize-cnbib.lua`，这是因为 Quarto 目前 [不支持](https://github.com/quarto-dev/quarto-cli/issues/7888) 在 `citeproc` 之后执行 Lua filter。

{{< imgcap title="使用 `localize-cnbib.lua` 前后的对比，可以看到下图中中文参考文献的 `et al.` 被替换为 `等`" src="https://cdn.retompi.com/11797189-d676-4ef1-8994-8a069234eed8.png" >}}

### 中文参考文献按拼音排序

在著者-年份制的参考文献表中，中文文献一般需要按照拼音排序。基于 GB/T 7714-2015 的 BibLaTeX 样式包 [biblatex-gb7714-2015](https://github.com/hushidong/biblatex-gb7714-2015) 支持使用 `biber` 对中文文献按照排序，但 Pandoc 使用的 `citeproc` 不能区分中英文作者，无法实现对中文文献按拼音排序。对于 DOCX 输出来说，只能在 Word 中打开 Pandoc 或 Quarto 生成的文件，然后点击「排序」功能选择拼音排序，但对于 HTML 和 ePub 输出来说，则基本上束手无策。因此，中文参考文献的排序问题一直是一个令人十分头疼的问题。

由于 Lua 语言没有完善的汉语拼音库，我选择使用 Python 语言来编写 [Pandoc filter](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/sort-cnbib.py) `sort-cnbib.py`，即利用 [pypinyin](https://github.com/mozillazg/python-pinyin) 来获取中文文献著者的汉语拼音，然后通过 Pandoc 的 Python 接口库 [Panflute](https://github.com/sergiocorreia/panflute) 来修改 AST，实现中文参考文献按照拼音排序的目的。为了对多音字进行正确的排序，这个 filter 还对以下常见的多音字姓氏进行了特殊处理：

```python
def special_pinyin(text):
    # 多音字的姓氏拼音
    surname_map = {
        '葛': 'ge3',
        '阚': 'kan4',
        '区': 'ou1',
        '朴': 'piao2',
        '覃': 'qin2',
        '仇': 'qiu2',
        '任': 'ren2',
        '单': 'shan4',
        '解': 'xie4',
        '燕': 'yan1',
        '尉': 'yu4',
        '乐': 'yue4',
        '曾': 'zeng1',
        '查': 'zha1',
    }

    if contains_chinese(text):
        name = text.split(",")[0] if "," in text else text
        surname = name[0]

        # 获取完整姓名的拼音
        full_pinyin = pinyin(name, style=Style.TONE3)
        full_pinyin_text = "".join([i[0] for i in full_pinyin])

        # 如果姓氏在多音字列表中，替换拼音的首个发音
        if surname in surname_map:
            surname_py = surname_map[surname]
            # 根据姓氏的长度替换拼音
            surname_py_len = len(pinyin(surname, style=Style.TONE3)[0][0])
            full_pinyin_text = surname_py + full_pinyin_text[surname_py_len:]

        return full_pinyin_text
    else:
        return None
```

{{< imgcap title="使用 `sort-cnbib.py` 排序前后的对比，可以看到右图中中文参考文献的顺序被修改为按照著者的拼音排序" src="https://cdn.retompi.com/241339c0-6cf5-420d-9070-706af3146668.png" >}}

对于参考文献表中中文和英文文献哪个在前的问题，各个学校和期刊的要求不尽相同，有的要求中文在前，有的要求英文在前，`sort-cnbib.py` 默认英文在前，如果你需要将中文文献排在前面，可以将其中对应的代码修改为：

```python
def finalize(doc):
    doc.chinese_entries.sort(key=lambda x: special_pinyin(pf.stringify(x)))

    # 用排序后的条目替换 Div 中的内容
    for elem in doc.content:
        if isinstance(elem, pf.Div) and "references" in elem.classes:
            # 按拼音排序中文参考文献条目，并将其附加到非中文条目的末尾
            # 交换加号前后的顺序可以改变中文和非中文参考文献条目的顺序
            elem.content = doc.chinese_entries + doc.non_chinese_entries
            break
```

需要指出的是，这个按拼音排序的 filter 仅适用于著者-年份制（author-date style）的引用格式，如果是纯数字编号形式（numerical style），参考文献本身就是按引用先后排序或编号大小排序，自然不需要额外调整。

### 中文引号的处理

中西混排之难，当以引号为首。引号的处理，是最让人头疼的问题，「万恶之源」在于是简体中文和英文使用相同的引号，但却要求呈现出不同的效果。具体来说，简体中文使用的引号 `“`、`”`、`‘`、`’` 和英语中使用的蝌蚪引号是完全一样的，但由于中文字符较宽，所以在排版时需要让包裹中文的引号看上去更宽一些，而包裹英文的引号看上去更窄一些，特别是在 Microsoft Word 中。正是由于这个原因，不少网友会使用繁体中文的直角引号 `「`、`」`、`『`、`』` 来替代简体中文中的蝌蚪引号，然而中华人民共和国国家标准《[标点符号用法](https://web.archive.org/web/20250126142548/http://www.moe.gov.cn/ewebeditor/uploadfile/2015/01/13/20150113091548267.pdf)》规定简体中文的引号只有两组蝌蚪引号，因此在正式的学术论文中，一般不推荐使用直角引号。

在 [Pandoc 3.2.1](https://github.com/jgm/pandoc/releases/tag/3.2.1) 之前，我编写了一个 Lua filter 来处理 DOCX 输出中的中文引号，但它无法处理参考文献表中的引号。尽管有 AI 的帮助，但囿于自身代码水平的限制，我无法完全解决这个问题，只能向 Pandoc 的作者 John MacFarlane 教授提交了一个 [issue](https://github.com/jgm/pandoc/issues/9817)。幸运的是，他采纳了我的建议，在 Pandoc 3.2.1 中为 DOCX 文件中的 `w:r` 元素添加了 `eastAsia` 字体提示，也就是为中日韩（CJK）文字添加了字体提示，以确保在包含中文字符的 `w:r` 元素中，引号会被渲染为宽字符，在 Word 中更宽一些（只是看上去更宽，实际宽度和英文引号是一样的）。

{{< imgcap title="Pandoc 3.2.1 及之后的版本中，Pandoc 优化了中文在 DOCX 中的排版，可以将包裹中文的引号渲染为宽字符，上图为 Pandoc 3.2 转换得到的 DOCX 文件，下图为 Pandoc 3.6.3 转换得到的 DOCX 文件" src="https://cdn.retompi.com/ce4e252e-2527-454d-b4b4-06e93cdfe9a1.png" >}}

除了 DOCX 外，LaTeX 中的引号也是十分棘手的问题，这同样是因为 Pandoc 没有将中文和英文区别对待。在 LaTeX 中，英文单引号为 `` `text' ``，输出结果为 `‘text’`，双引号为 ` ``text'' `，输出结果为 `“text”`。而中文引号直接使用 `“`、`”`、`‘`、`’` 表示就可以了。此外，对于 HTML 和 ePub 这两种格式来说，由于它们是基于网页排版的，所以需要使用直角引号 `「`、`」`、`『`、`』` 来包裹中文，因此也就不需要对正文进行处理，只需将参考文献列表中的蝌蚪引号转换为直角引号，确保全文引号使用一致。

为了解决不同文件格式中的中英文引号问题，我的解决方案是在 Markdown 中包裹中文的引号使用直角引号 `「`、`」`、`『`、`』`。这样做有两个好处：一是输入上方便明确，二是可以在纯文本里直观地区分出中文引号的语义范围。然后在输出不同格式时，通过以下三个 Lua filters 自动转换为对应格式下合适的引号：

- [latex-quotes.lua](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/latex-quotes.lua)：处理 LaTeX 中的引号，将中文直角引号转换为东欧语系的引号 `«`、`»`、`‹`、`›` 作为中介（因为它们在中英文中基本上不会出现），然后在编译 LaTeX 时通过宏包 [newunicodechar](https://ctan.org/pkg/newunicodechar) 将其转换为蝌蚪引号，并对标题中的中文引号进行特别处理，使其在 PDF 书签中 [正确显示](https://tex.stackexchange.com/questions/592335/wrong-double-quotes-in-pdf-bookmarks)。
- [docx-quotes.lua](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/docx-quotes.lua)：处理 DOCX 中的引号，将直角引号转换为蝌蚪引号。
- [cnbib-quotes.lua](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/cnbib-quotes.lua)：处理 HTML 和 ePub 参考文献列表中的引号，将蝌蚪引号转换为直角引号。

通过这一套方案，我们就可以让 Quarto 输出的 DOCX、PDF、HTML 和 ePub 都各自使用符合其格式的引号，即在 DOCX 和 PDF 中使用看上去较宽的蝌蚪引号包裹中文，在 HTML 和 ePub 中使用直角引号包裹中文，而英文引号则保持不变。

{{< imgcap title="在不同格式下，中文引号被转换为不同的样式，DOCX 和 PDF 中使用蝌蚪引号，HTML 和 ePub 中使用直角引号" src="https://cdn.retompi.com/fe0d315b-2601-4607-85cc-75f87f141b47.png" >}}

### 中西文盘古之白

[pangu.js](https://github.com/vinta/pangu.js) 中提到：

> 有研究显示，打字的时候不喜欢在中文和英文之间加空格的人，感情路都走得很辛苦，有七成的比例会在 34 岁的时候跟自己不爱的人结婚，而其余三成的人最后只能把遗产留给自己的猫。毕竟爱情跟书写都需要适时地留白。

尽管这是一句玩笑话，但添加「盘古之白」，也就是中西文混排时在合适位置留空，的确可以让版面更加 [美观易读](https://sspai.com/prime/story/markdown-linter-a-primer)。尽管手动在中英文、数字之间加一个空格是一个 [好习惯](https://www.zhihu.com/question/19587406)，但在实际写作过程中，难免会有疏漏，因此在排版时，我们需要借助工具来自动完成这个工作。

为此，我编写了一个 Python filter [auto-correct.py](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/auto-correct.py) 来帮助解决这个问题。借助 [AutoCorrect](https://github.com/huacnlee/autocorrect) 的 Python 库，实现在 Pandoc 转换过程中自动检查并补全中英文、中文与数字之间应有的空格，并且还顺带做了一些常用标点符号、单词拼写的自动纠正，可谓一举多得。当然，你完全可以根据需要修改这个 filter，例如只补全中英文、中文与数字之间的空格，或者只补全标点符号、单词拼写的自动纠正，设置各个参数对应的代码如下：

```python
def load_config():
    # yaml-language-server: $schema=https://huacnlee.github.io/autocorrect/schema.json
    config = {
        # 0 - 关闭, 1 - 错误, 2 - 警告
        "rules": {
            # 在某些标点符号之间添加空格
            "space-punctuation": 0,
            # 在与 CJK 相邻时，在括号 ()、[] 与其之间添加空格
            "space-bracket": 0,
            # 在与 CJK 相邻时，在反引号 `` 之间添加空格
            "space-backticks": 0,
            # 在短横线 `-` 前后添加空格
            "space-dash": 0,
            # 转换为全角
            "fullwidth": 1,
            # 去除蝌蚪引号 “”、‘’ 两侧的空格
            "no-space-fullwidth-quote": 0,
            # 将全角字母数字转换为半角
            "halfwidth-word": 1,
            # 将英文中的全角标点转换为半角
            "halfwidth-punctuation": 1,
            # 拼写检查
            "spellcheck": 0
        }
    }
    config_str = json.dumps(config)
    autocorrect.load_config(config_str)
```

{{< imgcap title="使用 `auto-correct.py` 自动添加中西文之间的空格并纠正标点符号" src="https://cdn.retompi.com/ce1f0124-ec3d-438d-8030-e47b30eda43e.png" >}}

值得一提的是，在不同的输出格式下，对「中西文盘古之白」的处理存在着差异。对于通过 LaTeX 生成的 PDF 来说，用于中文排版的 [ctex](https://ctan.org/pkg/ctex) 宏包会自动处理中英文之间的空格，因此无需使用这个 Python filter。只有在转换为 HTML、ePub 等其他格式，才需要使用这个 filter。而对于 DOCX 来说，情况则比较特殊，这是因为 Microsoft Word 有自动调整中西文间距的功能。

{{< imgcap title="Microsoft Word 中自动调整中西文间距的设置" src="https://cdn.retompi.com/6494e9fe-3356-4bcc-a415-23aa35c8a6f5.png" >}}

因此，如果你习惯在 Markdown 中手动输入空格，那么在转换为 DOCX 时，请使用 [remove-spaces](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/remove-spaces/remove-spaces.lua) 这个 Lua filter 来移除中西文之间的空格。如果你不想手动在 Markdown 中添加中西文之间的空格，则在转换为 DOCX 时，无需进行额外的操作，交给 Word 自动处理就好。

### 中文自由换行

Markdown 中连续两个换行会生成一个空段落，而单个换行则会生成一个空格。对于英文写作来说，「一句话换一行」的写作方式是非常自然的，因为英文单词之间总是需要存在空格，Markdown 中连续多个空格或单个换行符都会被渲染为一个空格，但对于汉字之间不存在空格的中文来说则不同。在 Pandoc 中，我们可以通过开启 `east_asian_line_breaks` [扩展](https://pandoc.org/MANUAL.html#extension-east_asian_line_breaks) 来忽略中文（也包括日文和韩文）段落中一个换行所产生的空格。

尽管 Quarto 是基于 Pandoc 开发的，但它并 [不支持](https://github.com/quarto-dev/quarto-cli/issues/8520) `east_asian_line_breaks` 扩展。为了能够在中文写作时自由换行，用文字随心所欲地表达自我，而不用拘泥于是否应该在哪里换行，基于 [涛叔](https://taoshu.in/unix/markdown-soft-break.html) 的博客文章，我编写了一个 [Lua filter](https://github.com/TomBener/quarto-cn-tools/blob/main/_extensions/ignore-softbreaks/ignore-softbreaks.lua)，在 Quarto 中模拟 Pandoc 的 `east_asian_line_breaks` 扩展。需要注意的是，这个 Lua filter 假设文档中只包含中文和英文，判断中文的条件也十分简单粗暴，即「如果字符串不是 ASCII 字符，则认为是中文」。因此，如果你的文档中包含其他语言，可能会出现问题，不过对于中文学术论文来说，这个 Lua filter 还是适用的。

{{< imgcap title="在 Quarto 中使用 Lua filter 模拟 Pandoc 的 `east_asian_line_breaks` 扩展，左侧为 Markdown 源码，右侧为转换后的 HTML 文件，可以看到标点符号后单个换行被忽略" src="https://cdn.retompi.com/17aecf68-0753-41de-b24e-eded7e336e45.png" >}}

## 结语

本文分享了我使用 Quarto 写作论文的一些经验和技巧，以及一些相关的工具，尽管不能面面俱到，但希望能帮助你更好地使用 Quarto，特别是针对中文学术论文的写作。在 GitHub 上开源的项目中，除了以上介绍的技巧外，还有其他的一些实用工具，等待你去发掘。比如生成参考文献的反向链接、移除 DOI 超链接、生成带水印或适合打印的 PDF，以及使用 Quarto 制作 [reveal.js](https://revealjs.com) 幻灯片等。限于篇幅，无法一一介绍，感兴趣的读者可以自行探索。

需要指出的是，与相对稳定的 Pandoc 相比，Quarto 仍在积极开发中，很多功能还有待完善。比如目前它不支持在 `citeproc` 之后执行 Lua filter，这导致与处理引用相关的 filters 无法通过 `_quarto.yml` 配置文件来调用。为此，我采取了折中的办法：借助 [Makefile](https://github.com/TomBener/quarto-cn-tools/blob/main/Makefile)，通过命令行来执行脚本。不过好在 Quarto 的开发者们已经意识到了这个问题，并将其加入了版本 [1.7](https://github.com/quarto-dev/quarto-cli/milestone/15) 的更新计划中，相信未来这一问题会有更加优雅的解决方案。

2024 年是人工智能狂飙突进的一年，人们越来越依赖大语言模型进行内容消费和创作。为了让互联网更好地兼容 AI，Markdown 越来越受到人们的 [青睐](https://p.migdal.pl/blog/2025/02/markdown-saves)，有人甚至提出了使用 [/llms.txt](https://llmstxt.org) 文件来提供信息，帮助 LLMs 更好地理解网站内容。事实上，纯文本不仅对 AI 友好，对人类来说也是更高效、更灵活的写作方式。我一直在中文互联网上推广用纯文本进行学术写作的理念，起初只是出于对 Word 和 LaTeX 的不满，想要找到一种更符合自己习惯的写作方式，而从 Pandoc 到如今的 Quarto，依然使用 Markdown，我的纯文本学术写作之路走过了探索、实践、再完善的循环。

在 2024 年全面应用 Quarto 写作论文的过程中，我深切体会到工具的进步为创作带来的便利和乐趣：写作时只需关注文字本身，不再为排版琐事分心，转换格式时不再焦头烂额地处理兼容问题，论文的结构和样式也更易于维护和迁移。当然，我并不是鼓吹花时间折腾工具胜过打磨内容。恰恰相反，只有当我们不再花费过多时间折腾形式上的排版，才能有更多时间去思考内容本身，从而产出更高质量的学术成果。学术写作之难，难在如何清晰准确地传达思想，但愿我们的工具箱不断丰富之余，写作的初心不变：让技术化繁为简，助力思想闪烁光芒。期待在不远的将来，看到有更多人加入纯文本写作的行列，分享你的故事和成果，而你的写作实践，又将成为下一年别人眼中的经验和灵感。祝我们在创作的道路上共同进步。
