---
title: 中英双语写作，输出指定语言
description: 一个小脚本，实现这个小需求
date: 2021-02-28T17:02:08+08:00
slug: input-bilingual-output-either-en-or-cn
image: https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/bilingual-writing-markdown.jpg
categories:
    - Writing
---


## 需求

不少情况下，我需要写中英双语内容的文章，或者把已有的英文材料翻译成中文[^fn1]。相对于另起一个新文档，中英对照式的翻译方式，在我看来是更加高效的。即将原文和译文写在同一个文件中，以段落为单位对原文进行翻译，然后将译文写在原文下方（或上方）。这种翻译方式能够有效同步修改原文与译文，方便进行校对。

[^fn1]: 也有把中文翻译成英文的情况。

![在 Markdown 中写中英双语文章](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/markdown-bilingual.png)

著名的网页翻译插件 [彩云小译](https://chrome.google.com/webstore/detail/lingocloud-interpreter/jmpepeebcbihafjjadogphmbgiffiajh) 就是采用的这种方式，能够在阅读过程中同时对照着查看原文与译文，兼顾了阅读速度和翻译的准确性，受到了不少好评。

![彩云小译网页翻译效果](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/caiyun-xiaoyi-translation.png)

> 关联阅读：[如何在浏览英文网页时获得更好的阅读体验？](https://sspai.com/post/54697)

尽管可以中英对照进行写作，但在输出为 DOCX 或 PDF 提交给他人时，往往只需要一种语言的内容，如何才能输出指定的语言，即只输出英文或只输出为中文？由于我平时使用 Markdown 写作，Pandoc 转换，于是在这一 [写作流程](https://sspai.com/post/64842) 的基础上，我研究了如何实现这个需求：通过 Markdown 进行中英双语写作，通过 Pandoc 输出指定语言的 DOCX 和 LaTeX 文件。

## 解决思路

我们的需求是只输出一种语言，解决思路也就非常简单：在双语的 Markdown 文件中把不需要输出的另一种语言注释掉即可[^fn2]。尽管 [原生 Markdown](https://daringfireball.net/projects/markdown) 没有注释语法，但我们可以使用 [HTML 注释语法](https://www.w3schools.com/html/html_comments.asp) 来间接实现，即在文字两侧加上 `<!-- -->` 达到注释的目的，而 Pandoc 默认开启 `--strip-comments` 选项，可以在转换时忽略掉注释掉的内容。思路可行，下面是具体实现操作。如果你不关心具体细节，可以直接跳到最后的 [总结](#总结) 部分。

[^fn2]: 直接删除肯定是不可取的。

## 输出为英文文件

按照前文的解决思路，需要输出为英文文档时，把中文文档注释掉即可，那么问题就转变为如何查找中文内容？由于我们是以段落为单位进行写作或翻译的，问题进一步简化为如何查找中文段落？而借助强大的正则表达式，可以轻松实现：

```
.*\p{Han}+.*
```

其中 `.*` 表示任意内容（不包括空行），`\p{Han}+` 表示至少一个中文字符，翻译成自然语言就是：查找包括中文字符的段落。有了这个正则表达式，接下来就可以使用 Perl 执行查找替换的操作：

```sh
perl -CSD -Mutf8 -i -pe 's/(.*\p{Han}+.*)/<!-- \1 -->/g' main.md
```

这一行命令将包括中文字符的段落两侧分别加上 `<!-- ` 和 ` -->`，达到注释中文内容的目的。接下来运行 Pandoc，得到包含英文内容的文件（DOCX 和 LaTeX）：

```sh
pandoc -C -N -M reference-section-title="References" main.md -o en.docx

pandoc --natbib --wrap=none main.md -o en.tex

sed -i '' -e 's/<!-- //g; s/ -->//g' main.md
```

通过运行上面这三行命令，我们就得到了英文文件 `en.docx` 和 `en.tex`。需要注意的是，最后一行命令的作用是去掉所有的注释符号 `<!--`、`-->`，将 Markdown 复原到初始状态，你可以根据需要确定是否要执行它。

## 输出为中文文件

与输出为英文文件相同，输出为中文文件时需要把英文内容注释掉。不过不同的是，由于中文段落也可能包含英文字符，直接查找英文字符可能会造成「误伤」，效果不太理想。因此，我决定还是对中文段落「动手脚」。首先将 Markdown 中全部非空行的段落注释掉：

```sh
perl -CSD -Mutf8 -i -pe 's/(^.*\S)/<!-- \1 -->/g' main.md
```

然后将中文段落取消注释：

```sh
perl -CSD -Mutf8 -i -pe 's/<!-- (.*\p{Han}+.*) -->/\1/g' main.md
```

接着运行 Pandoc，得到中文文件：

```sh
pandoc -C -N -M reference-section-title="参考文献" --bibliography ref.bib main.md -o cn.docx

pandoc --natbib --wrap=none main.md -o cn.tex

sed -i '' -e 's/<!-- //g; s/ -->//g' main.md
```

第一行命令与转换为 `en.docx` 相比，增加了 `--bibliography ref.bib`，这是因为 `main.md` 中 YAML 块中参考文献的元数据信息被注释掉了，因此需要在命令行中指定，否则 Pandoc 无法找到引文数据。通过上面的命令，就得到了中文文件 `cn.docx` 和 `cn.tex`。

## 总结

分步执行以上命令过于麻烦，于是我将这一系列 Shell 脚本写到了 [Makefile](https://github.com/TomBener/bilingual-docs/blob/master/Makefile) 中，便于直接执行。

![Makefile 文件](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/bilingual-makefile.png)

使用方法如下：

- `make`：生成英文文件和中文文件，也可以使用 `make all`
- `make en`：生成英文文件
- `make cn`：生成中文文件
- `make clean`：删除生成的所有文件

Unix 类系统（macOS、Linux）可以直接运行 Makefile，如果你使用 Windows，可以参考这个 [介绍](https://stackoverflow.com/questions/2532234/how-to-run-a-makefile-in-windows)，在 Windows 上使用 Makefile。

值得注意的是，我目前很少在中英双语文档中使用 Markdown 表格和代码块，因此没有专门针对两种特殊格式进行测试。另外，本文的例子使用的是 HTML 的注释语法，如果你在 Markdown 写作中过程中，需要手动注释某些内容，使用 HTML 注释语法会对后续文件转换造成一些麻烦。幸运的是，在 Markdown 中不仅仅可以使用 HTML 注释语法，广大网友整出了各式各样的注释方式，你可以在 [这里](https://stackoverflow.com/questions/4823468/comments-in-markdown) 查看。推荐在写作过程中手动使用这种注释语法：

```markdown
[//]: # (This is the ordinary comment, from <https://stackoverflow.com/a/20885980>)

[//]: # (这是写作时手动添加的注释，来源于 <https://stackoverflow.com/a/20885980>)
```

前述提到的示例和命令，可以在我的 [GitHub 仓库](https://github.com/TomBener/bilingual-docs) 找到。当然，这个仓库只是为了解决中英双语文件输出，一些细节没有进行修正，比如中文引号的问题，你可以在 [这篇文章](https://sspai.com/post/64842) 找到更多排版细节调整，以及 Markdown 写作的流程。以上就是本文的全部内容了，希望对你的写作和翻译有所帮助，如果你有什么想法或意见，欢迎留言讨论与交流。
