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

在平常的学习中，我需要写中英双语内容的文章，或者把已有的英文材料翻译成中文[^fn1]。相对于新开一个文档，中英对照式的翻译方式，在我看来是更加高效的，即把原文和译文写在同一个 Markdown 文件中，以行[^fn3] 为单位对原文进行翻译，然后将译文写在原文的下方（或上方）。这种写作方式能够有效同步修改原文与译文，方便进行校对。

[^fn1]: 也有把中文翻译成英文的情况。

[^fn3]: 在 Markdown 中，一行就是一段。

![在 Markdown 中写中英双语文章](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/markdown-bilingual.png)

著名的网页翻译插件 [彩云小译](https://chrome.google.com/webstore/detail/lingocloud-interpreter/jmpepeebcbihafjjadogphmbgiffiajh) 的翻译结果就是原文和译文互相穿插的形式，可以在阅读过程中同时对照着查看原文与译文，兼顾了阅读速度和翻译的准确性，受到了不少好评。

![彩云小译网页翻译效果](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/caiyun-xiaoyi-translation.png)

> 关联阅读：[如何在浏览英文网页时获得更好的阅读体验？](https://sspai.com/post/54697)

尽管在 Markdown 中可以中英对照进行写作或翻译，但在输出为 DOCX 或 PDF 分享给他人时，往往只需要一种语言的内容，或者一种语言一份文件单独保存。那么如何才能双语写作，输出指定的某一种语言的文件呢？

我所有的写作几乎都是在 Markdown 中完成，然后通过 Pandoc 进行转换。因此，在这一 [写作流程](https://sspai.com/post/64842) 的基础上，我研究了一下如何实现这个需求：在 Markdown 中用中英双语进行写作或翻译，通过 Pandoc 输出指定语言的 DOCX 和 LaTeX 文件。

## 解决思路

我们的需求是只输出一种语言，解决思路也就非常简单：在中英双语的 Markdown 文件中把不需要输出的另一种语言注释掉即可[^fn2]。尽管 [原生 Markdown](https://daringfireball.net/projects/markdown) 没有注释语法，但可以使用 [HTML 注释语法](https://www.w3schools.com/html/html_comments.asp) 来实现，即在文本两侧分别加上 `<!--` 和 `-->`，达到注释的目的，而 Pandoc 默认开启 `--strip-comments` 选项，可以在转换时忽略掉注释的内容。

[^fn2]: 直接删除肯定是不可取的。

简单分析之后，思路可行，下面是具体的实现步骤。当然，如果你不关心具体细节，可以直接跳转到最后的 [总结](#总结) 部分。

## 输出为英文文件

按照前文的解决思路，需要输出为英文文件时，把中文内容注释掉即可，那么问题就转变为如何查找所有的中文内容？由于我们是以段落（行）为单位进行写作或翻译的，于是问题就进一步简化为如何查找中文段落？而借助强大的正则表达式，这可以轻松实现：

```
.*\p{Han}+.*
```

其中 `.*` 表示任意内容（不包括空行），`\p{Han}+` 表示至少一个中文字符，翻译成自然语言就是：查找包括中文字符的段落。有了这个正则表达式，下面就可以使用 Perl 执行查找替换的操作：

```sh
perl -CSD -Mutf8 -i -pe 's/(.*\p{Han}+.*)/<!-- \1 -->/g' main.md
```

这一行命令将包括中文字符的段落开头和结尾分别加上 `<!-- ` 和 ` -->`，实现注释中文内容的目的。接下来运行 Pandoc，得到英文内容的文件（DOCX 和 LaTeX）：

```sh
pandoc -C -N -M reference-section-title="References" main.md -o en.docx

pandoc --natbib --wrap=none main.md -o en.tex

sed -i '' -e 's/<!-- //g; s/ -->//g' main.md
```

通过运行上面这三行命令，我们就得到了英文文件 `en.docx` 和 `en.tex`。需要注意的是，最后一行命令的作用是去掉所有的注释符号 `<!--`、`-->`，将 `main.md` 复原到初始状态，你可以根据需要决定是否要执行它。

## 输出为中文文件

与输出为英文文件相同，输出为中文文件时需要把英文内容注释掉。不过不同的是，由于中文段落也可能包含英文字符，直接查找英文字符可能会造成「误伤」，效果不太理想。因此，我决定还是对中文段落「动手脚」。

首先将 Markdown 文件中全部非空行的段落注释掉：

```sh
perl -CSD -Mutf8 -i -pe 's/(^.*\S)/<!-- \1 -->/g' main.md
```

然后将其中的中文段落取消注释：

```sh
perl -CSD -Mutf8 -i -pe 's/<!-- (.*\p{Han}+.*) -->/\1/g' main.md
```

接着运行 Pandoc，得到中文文件：

```sh
pandoc -C -N -M reference-section-title="参考文献" --bibliography ref.bib main.md -o cn.docx

pandoc --natbib --wrap=none main.md -o cn.tex

sed -i '' -e 's/<!-- //g; s/ -->//g' main.md
```

第一行命令与转换为 `en.docx` 相比，增加了 `--bibliography ref.bib`，这是因为 `main.md` 中 YAML 块中参考文献的元数据信息被注释掉了，因此需要在命令行中指定，否则 Pandoc 无法找到引文数据。通过上面的命令，我们就得到了中文文件 `cn.docx` 和 `cn.tex`。

## 总结

分步执行以上命令过于麻烦，于是我将上述一系列命令写到了一个 [Makefile](https://github.com/TomBener/bilingual-docs/blob/master/Makefile) 中，只需要调用这一个 `Makefile` 文件就可以了：

```makefile
.PHONY: all
all: en cn

# Sed with options
SED = sed -i '' -e 's/<!-- //g; s/ -->//g'
# Perl with options
PERL = perl -CSD -Mutf8 -i -pe
# Pandoc with options for .docx output
PAND = pandoc -C -N -M
# Pandoc with options for .tex output
PANX = pandoc --natbib --wrap=none

.SILENT:
# Generate English documents
en: main.md
	# Comment Chinese paragraphs
	$(PERL) 's/(.*\p{Han}+.*)/<!-- \1 -->/g' $<
	
	# Generate `en.docx`
	$(PAND) reference-section-title="References" $< -o en.docx
	
	# Generate `en.tex`
	$(PANX) $< -o en.tex
	# Compile LaTeX
	
	# Restore to the original status
	$(SED) $<

.SILENT:
# Generate Chinese documents
cn: main.md
	# Comment all paragraphs
	$(PERL) 's/(^.*\S)/<!-- \1 -->/g' $<
	
	# Uncomment Chinese paragraphs
	$(PERL) 's/<!-- (.*\p{Han}+.*) -->/\1/g' $<
	
	# Generate `cn.docx`
	$(PAND) reference-section-title="参考文献" --bibliography ref.bib $< -o cn.docx
	
	# Generate `cn.tex`
	$(PANX) $< -o cn.tex
	# Compile LaTeX
	
	# Restore to the original status
	$(SED) $<

.PHONY: clean
clean:
	rm *.docx *.tex 
```

使用方法如下：

- `make`：生成英文文件和中文文件，也可以使用 `make all`
- `make en`：生成英文文件
- `make cn`：生成中文文件
- `make clean`：删除生成的所有文件

Unix 类操作系统（macOS、Linux）能够直接运行 Makefile，如果你使用 Windows，可以阅读这个 [介绍](https://stackoverflow.com/questions/2532234/how-to-run-a-makefile-in-windows)，了解如何在 Windows 上使用 Makefile。

需要指出的是，我目前很少在中英双语文档中使用 Markdown 表格和代码块，因此没有专门针对两种特殊格式进行测试。另外，本文的示例使用的是 HTML 的注释语法，如果你在 Markdown 写作过程中，需要手动注释某些内容，使用 HTML 注释语法会对后续文件格式转换造成一些麻烦。不过幸运的是，Markdown 中不仅可以使用 HTML 注释语法，广大网友还整出了各式各样的注释方式，你可以在 [这里](https://stackoverflow.com/questions/4823468/comments-in-markdown) 查看。本文推荐在写作过程中手动使用下面这种注释语法：

```markdown
[//]: # (This is the ordinary comment, from <https://stackoverflow.com/a/20885980>)

[//]: # (这是写作时手动添加的注释，来源于 <https://stackoverflow.com/a/20885980>)
```

对了，如果你想知道在 Microsoft Word 中写作，如何实现「中英双语写作，输出指定语言」？我的回答是用 Pandoc 将你的 DOCX 文件转换为 Markdown：🤣️

```sh
pandoc --wrap=none input.docx -o output.md
```

前述提到的所有示例和命令，可以在我的 [GitHub 仓库](https://github.com/TomBener/bilingual-docs) 找到，你可以自由下载和修改，欢迎给个 Star 🌟️。当然，这个仓库只是为了解决中英双语独立文件输出的需求，一些细节没有进行调整，比如中文引号的问题，你可以在 [这篇文章](https://sspai.com/post/64842) 中找到更多细节调整的介绍，以及围绕 Markdown 的学术写作流程。以上就是本文的全部内容了，希望对你的写作和翻译有所帮助，如果你有什么想法或意见，欢迎留言讨论与交流。
