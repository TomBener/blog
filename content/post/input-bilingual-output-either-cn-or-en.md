---
title: 中英双语写作，输出指定语言
description: 一个小脚本，实现这个小需求
date: 2021-02-28T17:02:08+08:00
lastmod: 2021-03-03T13:48:18
slug: input-bilingual-output-either-en-or-cn
image: https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/bilingual-writing-markdown.jpg
categories:
    - Writing
---


## 需求

在平常的学习中，我需要写不少中英双语内容的文章，或者把已有的英文材料翻译成中文[^fn1]。相对于新开一个文档，中英对照式的翻译方式，在我看来是更加高效的，即把原文和译文写在同一个 Markdown 文件中，以行[^fn3] 为单位对原文进行翻译，然后将译文写在原文的下方（或上方）。这种写作方式能够有效同步修改原文与译文，方便进行校对。

[^fn1]: 也有把中文翻译成英文的情况。

[^fn3]: 在 Markdown 中，一行就是一段。

![在 Markdown 中写中英双语文章](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/markdown-bilingual.png)

著名的网页翻译插件 [彩云小译](https://chrome.google.com/webstore/detail/lingocloud-interpreter/jmpepeebcbihafjjadogphmbgiffiajh) 的翻译结果就是原文和译文互相穿插的形式，可以在阅读过程中同时对照着查看原文与译文，兼顾了阅读速度和翻译的准确性，受到了不少好评。

![彩云小译网页翻译效果](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/caiyun-xiaoyi-translation.png)

> 关联阅读：[如何在浏览英文网页时获得更好的阅读体验？](https://sspai.com/post/54697)

尽管在 Markdown 中可以中英对照进行写作或翻译，但在输出为 DOCX 或 PDF 分享给他人时，往往只需要一种语言的内容，或者一种语言一份文件单独保存。那么如何才能双语写作，输出指定的某一种语言的文件呢？

我所有的写作几乎都是在 Markdown 中完成，然后通过 Pandoc 进行转换。因此，在这一 [写作流程](https://sspai.com/post/64842) 的基础上，我研究了一下如何实现这个需求，即在 Markdown 中用中英双语进行写作或翻译，通过 Pandoc 输出指定语言的 DOCX 和 LaTeX 文件。

## 解决思路

我们的需求是只输出一种语言，解决思路也就非常简单：在中英双语的 Markdown 文件中把不需要输出的另一种语言注释掉即可[^fn2]。尽管 [原生 Markdown](https://daringfireball.net/projects/markdown) 没有注释语法，但很多网友提出了解决方案，其中 Stack Overflow 上的 [这个回答](https://stackoverflow.com/a/4829998) 很符合我的需求。

[^fn2]: 直接删除肯定是不可取的。

![能被 Pandoc 识别的特定 Markdown 注释语法](https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/stack-overflow-markdown-comment.png)

请注意，这不是常规的 [HTML 注释语法](https://www.w3schools.com/html/html_comments.asp) `<!--`、`-->`，而是 `<!---`、`-->`（多了一个 dash）。为什么要使用这种注释方式？有两方面原因：一是在转换为 HTML 时，这种特定的注释语法不会被 Pandoc 转换为注释块嵌入 HTML 中，二是常规 HTML 的注释语法需要保留，在手动编辑文章时使用[^fn4]。

[^fn4]: 在 Visual Studio Code 中，可以通过快捷键 `Cmd/Ctrl + /` 快速添加或移除注释，对于 Markdown，就是 `<!--`、`-->`。

简单分析之后，思路可行，下面是具体的实现步骤。当然，如果你不关心具体细节，可以直接跳转到最后的 [总结](#总结) 部分。

## 输出为英文文件

按照前文的解决思路，需要输出为英文文件时，把中文内容注释掉即可，那么问题就转变为如何查找所有的中文内容？由于我们是以段落（行）为单位进行写作或翻译的，于是问题就进一步简化为如何查找中文段落？而借助强大的正则表达式，这可以轻松实现：

```
.*\p{Han}+.*
```

其中 `.*` 表示任意内容（不包括空行），`\p{Han}+` 表示至少一个中文字符，翻译成自然语言就是：查找包括中文字符的段落。有了这个正则表达式，下面就可以使用 Perl 执行查找替换的操作：

```sh
perl -CSD -Mutf8 -i -pe 's/(.*\p{Han}+.*)/<!--- \1 -->/g' main.md
```

这一行命令将包括中文字符的段落开头和结尾分别加上 `<!--- ` 和 ` -->`，实现注释中文段落的目的。不过这一命令也会把本就是注释内容的内容再注释一次，变成下面这样：

```markdown
<!--- <!-- This is the ordinary comment, which can be added or removed with keyboard shortcuts `Cmd/Ctrl + /` in Visual Studio Code in a breeze. --> -->

<!--- <!-- 这是写作时手动添加的注释，在 Visual Studio Code 中可以通过快捷键 `Cmd/Ctrl + /` 快速添加或移除。 --> -->
```

这样在转换时，最后一个 `-->` 会被输出，因此需要移除多余的注释符号：

```sh
perl -CSD -Mutf8 -i -pe 's/(<!--- <!-- )(.*)( --> -->)/<!-- \2 -->/g' main.md
```

接下来就可以运行 Pandoc，得到英文内容的文件（DOCX 和 LaTeX）：

```sh
pandoc -C -N -M reference-section-title="References" main.md -o en.docx

pandoc --natbib --wrap=none main.md -o en.tex

perl -CSD -Mutf8 -i -pe 's/(<!--- )(.*)( -->)/\2/g' main.md
```

通过运行上面的前两行命令，我们就得到了英文文件 `en.docx` 和 `en.tex`，第三行命令的作用是去掉所有的注释符号 `<!---`、`-->`，将 `main.md` 复原到初始状态。

## 输出为中文文件

与输出为英文文件相同，输出为中文文件时需要把英文内容注释掉。不过不同的是，由于中文段落也可能包含英文字符，直接查找英文字符可能会造成「误伤」，效果不太理想。因此，我决定还是对中文段落「下手」。

首先将 Markdown 中全部非空行的段落注释掉：

```sh
perl -CSD -Mutf8 -i -pe 's/(.*\S)/<!--- \1 -->/g' main.md
```

然后将其中的中文段落和本就是注释行的段落取消注释：

```sh
perl -CSD -Mutf8 -i -pe 's/<!--- (.*\p{Han}+.*) -->/\1/g; s/(<!--- <!-- )(.*)( --> -->)/<!-- \2 -->/g' main.md
```

接着运行 Pandoc，得到中文文件：

```sh
pandoc -C -N -M reference-section-title="参考文献" --bibliography ref.bib main.md -o cn.docx

pandoc --natbib --wrap=none main.md -o cn.tex

sed -i '' -e 's/<!-- //g; s/ -->//g' main.md
```

上面的第一行命令与转换为 `en.docx` 相比，增加了 `--bibliography ref.bib`，这是因为在 `main.md` 中，YAML 块中的参考文献元数据信息被注释掉了，因此需要在命令行中指定，否则 Pandoc 无法找到引文数据。通过上面的命令，我们就得到了中文文件 `cn.docx` 和 `cn.tex`。

## 总结

分步执行以上命令过于麻烦，于是我将上述一系列命令写到了一个 [Makefile](https://github.com/TomBener/bilingual-docs/blob/master/Makefile) 中，使用时只需要调用这一个 `Makefile` 文件就可以了：

```makefile
# Perl with options
PERL = perl -CSD -Mutf8 -i -pe
# Pandoc with options for .docx output
PAND = pandoc -C -N -M reference-section-title
# Pandoc with options for .tex output
PANX = pandoc --natbib --wrap=none

.PHONY: all
all: en cn

.SILENT:
# Generate English documents
en: main.md
	# Comment Chinese paragraphs
	$(PERL) 's/(.*\p{Han}+.*)/<!--- \1 -->/g' $<

	# Uncomment commented paragraphs
	$(PERL) 's/(<!--- <!-- )(.*)( --> -->)/<!-- \2 -->/g' $<
	
	# Generate `en.docx`
	$(PAND)="References" $< -o en.docx
	
	# Generate `en.tex`
	$(PANX) $< -o en.tex

	# Generate PDF via `en.tex`
	
	# Restore to the original status
	$(PERL) 's/(<!--- )(.*)( -->)/\2/g' $<

.SILENT:
# Generate Chinese documents
cn: main.md
	# Comment all paragraphs
	$(PERL) 's/(.*\S)/<!--- \1 -->/g' $<
	
	# Uncomment Chinese paragraphs
	$(PERL) 's/<!--- (.*\p{Han}+.*) -->/\1/g' $<
	
	# Uncomment paragraphs which contain Chinese character
	# and the generic HTML comment symbol
	$(PERL) 's/<!--- (.*\p{Han}+.*) -->/\1/g; \
	s/(<!--- <!-- )(.*)( --> -->)/<!-- \2 -->/g' $<

	# Generate `cn.docx`
	$(PAND)="参考文献" --bibliography ref.bib $< -o cn.docx
	
	# Generate `cn.tex`
	$(PANX) $< -o cn.tex
	
	# Generate PDF via `cn.tex`
	
	# Restore to the original status
	$(PERL) 's/(<!--- )(.*)( -->)/\2/g' $<

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

需要指出的是，我目前很少在中英双语文档中使用 Markdown 表格和代码块，因此没有专门针对两种特殊格式进行测试。此外，如果你想知道在 Microsoft Word 中写作，如何实现「中英双语写作，输出指定语言」？我的回答是用 Pandoc 将你的 DOCX 文件转换为 Markdown 🤣️：

```sh
pandoc --wrap=none input.docx -o output.md
```

前述提到的所有示例和命令，可以在我的 [GitHub 仓库](https://github.com/TomBener/bilingual-docs) 找到，你可以自由下载和修改，欢迎给个 Star 🌟️。当然，这个仓库只是为了解决中英双语独立文件输出的需求，一些细节没有进行调整，比如中文引号的问题，你可以在 [这篇文章](https://sspai.com/post/64842) 中找到更多细节调整的介绍，以及围绕 Markdown 和 Pandoc 的学术写作流程。以上就是本文的全部内容，希望对你的写作和翻译有所帮助，如果你有什么想法或意见，欢迎留言讨论与交流。
