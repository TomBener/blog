---
title: 汉字罗马化——转拼音与汉译英
date: 2022-11-01
categories:
    - Command Line
---

{{< admonition type=abstract title="📑 TL;DR 太长不看版" >}}
英文学术期刊一般要求将论文所引用的中文参考文献转换为拼音、翻译为英文，或者二者的混合。为了避免重复的手动操作，「一劳永逸」地解决这个问题，尝试通过 Makefile 来自动实现这个需求。本文中的 Makefile 提供了 6 个命令选项：

- `make citation`: 将 Markdown 文件中所引用的参考文献去重后提取为 BibLaTeX 文件，保存为 `citation.bib`。
- `make pinyin`: 将文章中引用的所有中文参考文献转换为没有音调的汉语拼音，并按照短语进行分组，保存为 `pinyin.bib`。
- `make trans`: 将中文参考文献的标题翻译为英文，使用 Google 翻译的 API，需要联网，中国大陆用户需要让终端网络通过代理连接，保存为 `trans.bib`。
- `make transall`: 将中文参考文献全文翻译为英文，使用 Apple 翻译的 API，本地运行，无需联网，但只能在 macOS 中使用，保存为 `transall.bib`。
- `make cnbib`: 逐行合并 `pinyin.bib` 和 `trans.bib`，用于拼音和翻译混合使用的场景，保存为 `cnbib.bib`。
- `make docx`: 生成最终的 Microsoft Word 文件 `main.docx` 及其辅助文件 `main.md`。

另外，也可以使用 `make` 或 `make all` 同时执行以上 6 个命令，`make clean` 将会删除所有生成的文件（`cnbib.bib` 除外）。
{{< /admonition >}}

## 需求

很多英文学术期刊在投稿指南中要求，文章中所引用的中文参考文献须转换为拼音、翻译为英文，或者二者的混合。一方面，这是「英语中心主义」的表现 [^E9F]，另一方面，这可能也是一个计算机排版领域的「历史遗留问题」，因为与处理拉丁文字相比，处理中文这样的东亚文字（CJK）是一个老大难问题，直到今天也仍然面临着各种各样的问题。

[^E9F]: 对于英文期刊来说，这本身并没有什么问题。

![谁也不想看见这样的中英混排吧……](https://p15.p3.n0.cdn.getcloudapp.com/items/ApuD2qX5/c58ace87-a147-4f1b-b568-85197ddd3100.png)

一般情况下，英文论文的中文文献不会太多，手动转换或翻译并不难，似乎不会耗费太多时间，但是作为一个懒人，我不想把时间浪费在这种事情上。此外，我的所有参考文献数据都保存在一个 BibLaTeX 文件中，其中有 2400 多条文献条目，从其中把引用过的中文参考文献找出来，也是一个不小的工作量。有没有工具可以自动实现这个功能呢？我在网上搜索了半天，似乎并没有，于是花了两三天时间，自己动手写了一个。下面是主要步骤拆解，如果你不感兴趣，可以直接跳转到最后的代码块部分，复制之后粘贴到文本编辑器中，保存为 `Makefile`。

## 提取引用过的参考文献

我的所有文献数据由 Zotero 插件 [Better BibTeX](https://retorque.re/zotero-better-bibtex/) 导出为一个 `.bib` 文件，大概有 3.5 MB，其中有超过 2400 条文献，无论我写什么论文，引文数据都来自这一个文件。如果我写的一篇文章中引用了 50 篇文献，如何将它们保存为一个单独的 BibLaTeX 文件？幸运的是，全能的 [Pandoc](https://pandoc.org) 可以通过 Lua Filter 来实现。

首先，需要在电脑中 [安装 Pandoc](https://pandoc.org/installing.html)，在 macOS 中可以使用 `brew install pandoc` 来快速安装。

接下来，将下面这 5 行 Lua 代码复制，保存为 `getbib.lua`：

```lua
function Pandoc(d)
  d.meta.references = pandoc.utils.references(d)
  d.meta.bibliography = nil
  return d
end
```

然后执行下面这行命令：

```shell
pandoc --bibliography bibliography.bib \
 --lua-filter getbib.lua \
 --wrap none \
 --to biblatex sections/*.md \
 --output citation.bib
```

就可以得到引用过的 50 篇文献，并保存为 `citation.bib`。其中 `bibliography.bib` 是保存所有引文数据的 BibLaTeX 文件，`--wrap none` 表示不折行，`sections/*.md` 是 `sections` 文件夹下论文的所有正文文件，格式是扩展名为 `.md` 的 Markdown。

## 只保留中文文献

在得到论文引用过的文献后，然后需要将英文文献移除，只保留中文文献，这是下一步转换为拼音的前置步骤，命令如下：

```shell
perl -0777 -i -pe 's/@[\w\n\s\p{P}—=“”‘’]*\}\n\}//g'
```

值得注意的是，这里的 `-0777` 告诉 Perl 跨行查找替换。

## 中文转换为拼音

已有不少现成的工具可以将中文转换为拼音，比较之后，我选择了 [pīnyīn](https://github.com/hotoo/pinyin)，使用 `npm install pinyin@alpha --save -g` 即可安装。

转换命令如下：

```shell
pinyin -s NORMAL -S -g 待转换的汉字
```

其中，`-s NORMAL` 表示拼音不带音调，`-S` 表示按照短语分词，`-g` 表示按照短语分组输出。

上面这行命令的输出结果为：

```text
dai zhuanhuan de hanzi
```

## 中文翻译为英文

### 在线翻译

在命令行中实现不同语言之间的相互翻译，[Translate Shell](https://github.com/soimort/translate-shell) 几乎是不二之选，在 macOS 上使用 `brew install translate-shell` 即可安装，其他操作系统的安装方式请参考 [README](https://github.com/soimort/translate-shell#installation)。

Translate Shell 的基本使用方法如下：

```shell
trans zh:en -b "中文翻译为英文"
```

输出结果为：

```text
Chinese to English translation
```

由于 Translate Shell 使用的是 Google 翻译的 API [^887]，需要联网，对于中国大陆用户来说，无法直连使用，[且速度很慢](https://github.com/soimort/translate-shell/issues/364)，我的测试文件只有 20 行，也需要 35 秒左右。因此，为了缩短翻译时间，离线翻译是更好的方式。

[^887]: 当然也可以选择其他翻译引擎，如 Bing、Yandex，但可用性很差。

### 离线翻译

在 macOS 上，离线翻译的首选方案自然是系统自带的翻译引擎。尽管不能在命令行中直接使用 Apple 翻译，但快捷指令可以在命令行中运行，通过这个变通方式，就可以实现我们的目的。

首先，需要制作一个快捷指令用于翻译，功能非常简单，如下图所示，命名为 `Translate`。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/d5und2g7/ac590806-10af-4687-9691-7d86dfccee38.png)

然后就可以在命令行中运行它：

```shell
echo "中文翻译为英文" | shortcuts run Translate | cat
```

输出结果为：

```text
Translate Chinese into English
```

与 Translate Shell 相比，离线的 Apple 翻译速度更快，但个人感觉效果似乎没有 Google 翻译好。

## 混合使用拼音和翻译

有些期刊要求不仅要把中文转换为拼音，还要将文章标题翻译为英文。因此，需要将 `pinyin.bib` 和 `trans.bib` 恰当地合并在一起，命令如下：

```shell
paste -d "\0" pinyin.bib trans.bib | perl -pe 's/(\stitle.*)(\},*)(.*)/\1 \(\3\)\2/g' > cnbib.bib
```

`paste` 命令将 `pinyin.bib` 和 `trans.bib` 逐行合并在一起，`-d "\0"` 表示不添加分界符，然后用正则表达式匹配多余的元素并移除，保存为 `cnbib.bib`。

## 转换为 Word

最终得到 Microsoft Word 文件的命令：

```shell
pandoc --citeproc --number-sections \
	--bibliography bibliography.bib \
	--bibliography cnbib.bib \
	--metadata title="This is the title" \
	--metadata author="author name" \
	--metadata date="`date`" \
	--metadata reference-section-title="References" \
	--metadata link-citations=true \
	sections/*.md --output main.docx
```

需要注意的是，这里使用了两次 `--bibliography`，而 `cnbib.bib` 是转换/翻译后的中文参考文献，与 `bibliography.bib` 中的 citation key 是相同的。但是非常妙的是，如果有重复的 citation key，Pandoc 会使用最后加载的那一个，这正满足了我们的需要。因此，`cnbib.bib` 一定要放在 `bibliography.bib` 之后。

最后，附上以上所有命令组合在一起的 Makefile，其中包括上面没有提到的格式调整等其他细节， `make.sh` 中的内容是上面生成 Microsoft Word 文件的命令。

```makefile
# This Makefile has six features:
# 1. `make citation`: Get all bibliographies cited in the article, save as `citation.bib`
# 2. `make pinyin`: Convert Chinese bibliographies to Pinyin for romanization, save as `pinyin.bib`
# 3. `make trans`: Translate the title field of Chinese bibliographies to English, save as `trans.bib`
# 4. `make transall`: Translate all Chinese bibliographies into English, save as `transall.bib`
# 5. `make cnbib`: Merge bibliographies in Pinyin and translated English titles, save as `cnbib.bib`
# 6. `make docx`: Generate the Word document `main.docx` and the auxiliary file `main.md`

# `make` or `make all` will generate all of them
# `make clean` will remove all generated files except `cnbib.bib`


# Extract bibliographies cited in the article as the BibLaTeX format
CITE = pandoc --bibliography bibliography.bib \
	--lua-filter getbib.lua \
	--wrap none \
	--to biblatex sections/*.md |

.PHONY: all
all: citation pinyin trans cnbib docx

# Extract all bibliographies cited in the article as `citation.bib`
citation:
	$(CITE) perl -0777 -pe 's/(\}\n)(@)/\1\n\2/g' \
	> citation.bib

# Extract Chinese bibliographies and then convert to Pinyin
pinyin:
	$(CITE) perl -0777 -pe \
	's/@[\w\n\s\p{P}—=“”‘’]*\}\n\}//g' | \
	xargs pinyin -s NORMAL -S -g | \
	perl -pe 's/ ，/,/g; s/ 。/./g; s/ ；/;/g; \
	s/ ：/: /g; s/ ！/!/g; s/ ？/?/g; \
	s/（ /(/g; s/ ）/)/g; s/{ /{/g; s/ }/}/g' | \
	perl -pe 's/(\})\s(@)/\n\1\n\n\2/g; \
	s/(author\s.*?)\s(\w+\})/\1\2/g; \
	s/(author\s=\s\{)(\w+)\s(.*)/\1\u\2, \u\3/g; \
	s/(address\s=\s\{+)(\w+)(\}+)/\1\u\2\3/g; \
	s/(,)\s([a-z]+\s=)/\1\n  \2/g; \
	s/(\}$$)/\n\1/g' \
	> pinyin.bib

# Translate all Chinese bibliographies into English
# with Apple Translate, can be used offline, and
# require to create a Shortcuts named `Translate`
transall:
	$(CITE) perl -0777 -pe \
	's/@[\w\n\s\p{P}—=“”‘’]*\}\n\}//g' | \
	shortcuts run Translate | \
	awk 'NF' | perl -pe '$$_=lc; s/(\w+\s=)/  \1/g; \
	s/(author\s=\s\{)(\w+)\s(.*)/\1\u\2, \u\3/g; \
	s/(address\s=\s\{+)(\w+)(\}+)/\1\u\2\3/g' | \
	perl -0777 -pe 's/(\}\n)(@)/\1\n\2/g' \
	> transall.bib

# Considering the slowness, only translate the title field
trans:
	$(CITE) perl -0777 -pe \
	's/@[\w\n\s\p{P}—=“”‘’]*\}\n\}//g; \
	s/(\})(\n@)/\1\n\2/g; s/(\stitle\s=\s\{)(.*)(\},*)/\2/g; \
	s/.*[=@].*//g; s/\}//g' | \
	perl -ne 'print if $$. > 1 || /\S/' | \
	trans zh-CN:en -b > trans.bib

# Combine `pinyin.bib` and `trans.bib` line by line
cnbib:
	paste -d "\0" pinyin.bib trans.bib | \
	perl -pe 's/(\stitle.*)(\},*)(.*)/\1 \(\3\)\2/g' \
	> cnbib.bib

# Generate the Word document `main.docx` and the auxiliary file `main.md`
.SILENT:
docx:
	$(shell ./make.sh)

# Remove all generated files except `cnbib.bib`
.PHONY: clean
clean:
	rm -f citation.bib pinyin.bib trans.bib transall.bib main.md *.docx
```
