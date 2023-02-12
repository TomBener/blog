---
title: 批量下载、处理图片和 PDF，这些任务你可以在命令行中完成
date: 2022-10-10
categories:
    - Command Line
    - PDF
---

{{< admonition type=tip title="📑 导语" >}}
日常工作和学习中有很多需要重复操作的任务。稍微了解一些命令行的解决方案，就能起到事半功倍的效果。本文从日常使用需求出发，介绍了从互联网上批量下载文件、处理图片和处理 PDF 三方面的命令行应用。
{{< /admonition >}}

![](https://p15.p3.n0.cdn.getcloudapp.com/items/P8u7955R/76e246e7-fdec-443a-9f80-894a2f89f2ac.jpg)

## 为什么使用命令行？

「命令行」（界面）是一个舶来品，翻译自英文 [Command Line Interface](https://en.wikipedia.org/wiki/Command-line_interface)（CLI），是指用户通过键盘输入指令，计算机接收到指令后，予以执行的操作界面。通常认为，命令行界面没有图形化界面（[Graphical User Interface](https://en.wikipedia.org/wiki/Graphical_user_interface), GUI）那么方便用户操作。

如今，我们使用的大多数应用程序都是图形化或菜单导向型应用，需要用户结合鼠标和键盘或完全使用鼠标进行操作。对于非程序员用户来说，命令行往往充满着神秘色彩，一般不会轻易去触碰。互联网上关于使用某些命令行的 [教程](https://www.webnots.com/how-to-increase-or-decrease-launchpad-icons-size-in-macos/)，往往也事无巨细，生怕出了一点差错，一步一步指导读者如何找到终端（Terminal）、打开、粘贴命令、按下回车、查看输出结果、最后关闭。

在命令行中，键盘是唯一的交互方式。因此，为了输入特定的指令，用户需要记住各式各样的命令，以及复杂琐碎的各种选项，再加上命令行单调乏味、毫不留情的提示语句，学习曲线非常陡峭，拉高了大多数用户的使用门槛。于是人们纷纷转向图形化应用，以致于有人会开发图形化应用，来封装需要复杂命令行操作的应用，降低用户使用门槛，比如最近很火的 [Diffusion Bee](https://github.com/divamgupta/diffusionbee-stable-diffusion-ui)。

必须要承认，图形化应用在很多场景下具有明显的优势，但情况并不总是这样。例如，在数据分析领域，我们应该使用 Excel 还是 [R](https://www.r-project.org)？尽管 Microsoft Excel 是世界上使用最广泛的 [编程语言](https://arunkprasad.com/log/the-most-widely-used-programming-language/)，功能非常 [强大](https://www.youtube.com/watch?v=OrwBc6PwAcY)，但遗憾的是，这个问题的答案往往是「[使用 R 而不是 Excel](https://shkspr.mobi/blog/2021/07/why-do-we-use-r-rather-than-excel/)」。对此，[Hacker News](https://news.ycombinator.com/item?id=27800291) 上一位用户评论道：如果某项操作你只需要做一次，使用 GUI（Excel），如果需要做十次，使用快捷键，如果需要做一百次，写一个脚本（R）。虽然这个说法有点简单粗暴，但是「话糙理不糙」，在处理一些**繁琐重复的任务**时，基于文本的命令行，能够避免重复的鼠标点击，的确更加高效便捷。

如果说图形化应用通过鼠标点击带来的收益是直观而便捷的操作方式，那么其背后的成本则是 [工作流程难以复用](https://plain-text.co/reproduce-work.html)（[A non-reproducible workflow](https://www.youtube.com/watch?v=s3JldKoA0zw)）。举个例子，假设你需要将 100 个 DOCX 文件转换为 PDF，那么按照 GUI 的处理方式，你必须在 Microsoft Word 中重复「另存为 PDF」的动作 100 次，如果之后这些文件的内容都发生了变化，那么你还需要再重复 100 次此前的操作，用软件开发领域的话来说，这种做法违背了「一次且仅一次」原则（[Don’t repeat yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), DRY）。而与图形化应用正好相反，命令行工具则把需要重复的操作用文本的形式记录下来，如果之后还会用到，只需再次执行此前的命令，边际人力成本为零或非常小。针对这个「DOCX 转 PDF」的具体例子，使用命令行工具 [docx2pdf](https://github.com/AlJohri/docx2pdf)，只需一行命令即可完成：`docx2pdf myfolder/`。

{{< imgcap title="Is It Worth the Time? 对于重复的任务，值得花时间来提高效率吗？图片来源：https://xkcd.com/1205/" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Jru8GkNn/987cc023-d2d7-4876-b481-a19080e29173.png" >}}

在我的日常工作和学习中，有很多任务需要重复操作，比如批量下载文件、转换文件格式等，在不堪忍受图形化应用中繁琐重复的操作之后，我将目光转向了命令行。经过一段时间的摸索，总结了一些用命令行工具处理日常工作任务的方法，具体包括从互联网上批量下载文件、对图片和 PDF 进行处理三方面。

本文所有的操作都在 macOS 上完成，但所使用的命令行工具都有 Linux 和 Windows 版本。除特别说明外，文中所用到的命令行工具都使用 [Homebrew](https://brew.sh/) 安装，安装命令为 `brew install [package-name]`，如 `brew install imagemagick`，更详细的使用方法，推荐阅读我派上的 [Homebrew 使用指北](https://sspai.com/post/56009)。Linux 系统可以使用包管理器如 [APT](https://en.wikipedia.org/wiki/APT_(software))、[YUM](https://en.wikipedia.org/wiki/Yum_(software)) 进行安装。Windows 平台可使用 [Chocolatey、WinGet 或 Scoop](https://sspai.com/post/65933) 等包管理器进行安装，在 [PowerShell](https://learn.microsoft.com/en-us/powershell/) 或者 [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) 环境中运行。

尽管下文尽量将每条命令的含义都解释清楚，但考虑到 [Unix-like](https://en.wikipedia.org/wiki/Unix-like) 系统有着 [非常庞杂](http://danluu.com/cli-complexity/) 的命令行语法，常常让人摸不着头脑，如果你对下文中用到的命令有疑惑，或者想深入研究某些命令，可以在终端中输入 `man [command-name]` 来查看对应命令的官方文档，例如 `man curl`。不过由于某些命令没有 [man page](https://en.wikipedia.org/wiki/Man_page) 或者不够详细，这里也推荐下面这几个网站，你可以在需要时在线查询更为丰富的文档内容：

- [explainshell](https://explainshell.com): Write down a command-line to see the help text that matches each argument
- [ManKier](https://www.mankier.com): ManKier tries to make reading and man pages as convenient as possible
- [Linux 101](https://101.lug.ustc.edu.cn)：中国科学技术大学 Linux 用户协会编写的在线讲义
- [Linux 命令搜索引擎](https://wangchujiang.com/linux-command/)
- [Linux 命令行与 Shell 脚本教程](https://archlinuxstudio.github.io/ShellTutorial)

## 在命令行中下载文件

从互联网上下载文件是上网冲浪的基本操作，即使用户没有主动下载，应用也可能会在后台自动下载所需资源。下载单个文件非常简单，直接在浏览器中打开对应链接即可，这似乎不是一个值得拿出来说的操作。然而，如果你有一系列链接，需要从互联网上把它们指向的文件一个个下载下来，如何简单快速地完成呢？这是我前段时间遇到的一个实际问题：用户提交的 PDF 文件存储在 Google Cloud Storage 中，网站后台无法直接下载，只有导出的 CSV 文件中有对应的文件存储链接。

### 使用 Curl

如何下载这些文件？我想到了 [Curl](https://curl.se)（Client URL）—— 一个通过指定 URL 语法传输数据的命令行工具。作为一项互联网基础设施，Curl 在今天的互联网中几乎无处不在 [^hks]，甚至连 macOS 都预装了 Curl，因此如果你使用的是 macOS，就不需要额外安装，开箱即用 [^jia]。

[^hks]: 比如 Homebrew 就使用的是 Curl 来下载软件。

[^jia]: 我非常喜欢这种「开箱即用」的工具，可以省掉繁琐的安装步骤，避免「从安装到放弃」，~~说的就是你 Python~~。

使用 Curl 下载单个文件很符合直觉，命令非常简单：

```shell
# 下载远程文件，并指定文件保存在本地的名称
curl https://cross-currents.berkeley.edu/sites/default/files/e-journal/articles/Kauffman.pdf --output output.pdf

# 下载远程文件，使用远程文件名称
curl -O https://cross-currents.berkeley.edu/sites/default/files/e-journal/articles/Kauffman.pdf
```

上面的两行命令中，`--output` [参数](https://curl.se/docs/manpage.html#-o) 表示输出为文件而不是标准输出（stdout），也可以用 `-o` （小写字母 o）代替。如果不需要重命名，可以使用 [参数](https://curl.se/docs/manpage.html#-O) `-O`（大写字母 O），这将把输出写入本地文件，文件名称与远程文件名保持一致。

为了使用 Curl 批量下载文件，我们需要先将所有链接保存在一个纯文本文件中，其中每行一个链接，例如 `urls.txt` 的内容如下：

```text
https://neodb.social/media/movie/2022/09/09fb7e2d34-e22b-4f96-843b-709db076b7c5.jpg
https://i.stack.imgur.com/sk5Pr.png
https://www.tug.org/mactex/TeXLive2020+Changes.pdf
```

然后打开终端，进入 `urls.txt` 所在文件夹，输入：

```shell
xargs -n 1 curl -O < urls.txt
```

按下回车键之后，Curl 就会自动开始将 `urls.txt` 中所有链接对应的文件下载到当前文件夹中。其中，`xargs -n` 参数指定每次将多少项作为命令行参数，上面这行命令指定将每一项 `-n 1` 标准输入作为命令行参数，分别执行一次 `curl` 命令。以下是使用 Curl 批量下载 3 个文件的示例，如果你觉得 Curl 的输出太过冗长，可以加上 `-#` 参数，这样就只会在输出中显示下载进度。

```shell
$ echo -e "https://neodb.social/media/movie/2022/09/09fb7e2d34-e22b-4f96-843b-709db076b7c5.jpg\nhttps://i.stack.imgur.com/sk5Pr.png\nhttps://www.tug.org/mactex/TeXLive2020+Changes.pdf" > urls.txt

$ cat urls.txt
https://neodb.social/media/movie/2022/09/09fb7e2d34-e22b-4f96-843b-709db076b7c5.jpg
https://i.stack.imgur.com/sk5Pr.png
https://www.tug.org/mactex/TeXLive2020+Changes.pdf

$ xargs -n 1 curl -O < urls.txt
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  161k  100  161k    0     0   199k      0 --:--:-- --:--:-- --:--:--  201k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  258k  100  258k    0     0   158k      0  0:00:01  0:00:01 --:--:--  158k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 91781  100 91781    0     0  50648      0  0:00:01  0:00:01 --:--:-- 50876

$ ls
09fb7e2d34-e22b-4f96-843b-709db076b7c5.jpg sk5Pr.png TeXLive2020+Changes.pdf urls.txt
```

如果 Curl 提示 `(3) URL using bad/illegal format or missing URL`，这可能是因为 `urls.txt` 为 [DOS/Windows](https://stackoverflow.com/q/70660633/19418090) 的文件格式，你可以用文本编辑器将其 CRLF 换行方式改成 LF 换行方式，也可以使用 [dos2unix](https://waterlan.home.xs4all.nl/dos2unix.html) 这个工具批量将其转换为 Unix 文件格式。

{{< admonition title="🔖 Note" >}}
本文为少数派会员文章，以上是其中部分内容，欢迎加入少数派会员 [阅读全文](https://sspai.com/prime/story/cli-utils-for-ordinary-tasks)。
{{< /admonition >}}

<!-- 

### 使用 Wget

除了使用 Curl 批量下载文件之外，[GNU Wget](https://www.gnu.org/software/wget/) 也可以实现同样的功能，如今大多数 Linux 发行版都 [预装了](https://linuxize.com/post/wget-command-examples/) Wget。与 Curl 相比，Wget 的 [命令参数](https://www.gnu.org/software/wget/manual/wget.html) 相对更加简单：

```shell
# 下载单个文件，不重命名，使用文件远程名称
wget https://tug.org/TUGboat/Articles/tb14-2/tb39rahtz-nfss.pdf

# 下载单个文件，重命名为 `output.pdf`
wget -O output.pdf https://tug.org/TUGboat/Articles/tb14-2/tb39rahtz-nfss.pdf
```

使用 Wget 批量下载文件的命令和输出结果如下：

```shell
$ wget -i urls.txt
--2022-09-28 11:46:13--  https://neodb.social/media/movie/2022/09/09fb7e2d34-e22b-4f96-843b-709db076b7c5.jpg
Connecting to 127.0.0.1:6152... connected.
Proxy request sent, awaiting response... 200 OK
Length: 165330 (161K) [image/jpeg]
Saving to: ‘09fb7e2d34-e22b-4f96-843b-709db076b7c5.jpg’

09fb7e2d34-e22b-4f96-843 100%[==================================>] 161.46K   898KB/s    in 0.2s

2022-09-28 11:46:15 (898 KB/s) - ‘09fb7e2d34-e22b-4f96-843b-709db076b7c5.jpg’ saved [165330/165330]

--2022-09-28 11:46:15--  https://i.stack.imgur.com/sk5Pr.png
Connecting to 127.0.0.1:6152... connected.
Proxy request sent, awaiting response... 200 OK
Length: 264477 (258K) [image/png]
Saving to: ‘sk5Pr.png’

sk5Pr.png              100%[==================================>] 258.28K   418KB/s    in 0.6s

2022-09-28 11:46:17 (418 KB/s) - ‘sk5Pr.png’ saved [264477/264477]

--2022-09-28 11:46:17--  https://www.tug.org/mactex/TeXLive2020+Changes.pdf
Connecting to 127.0.0.1:6152... connected.
Proxy request sent, awaiting response... 200 OK
Length: 91781 (90K) [application/pdf]
Saving to: ‘TeXLive2020+Changes.pdf’

TeXLive2020+Changes.pdf 100%[==================================>]  89.63K   211KB/s    in 0.4s

2022-09-28 11:46:19 (211 KB/s) - ‘TeXLive2020+Changes.pdf’ saved [91781/91781]

FINISHED --2022-09-28 11:46:19--
Total wall clock time: 6.7s
Downloaded: 3 files, 509K in 1.2s (417 KB/s)
```

其中 `-i` 表示从本地或外部文件中读取 URL，即 `urls.txt`。类似地，如果想要抑制 Wget 冗长的输出结果，可以加上 `-q` 参数。

### 替换图床链接为本地图片链接

为了避免图床出现不可访问的情况，我想要将 [Logseq](https://github.com/logseq/logseq) & [Obsidian](https://obsidian.md/) [^hup] 中所有 Markdown 文件中的图片下载到本地，并将图床链接替换为本地图片链接，毕竟 Logseq 和 Obsidian 都是 local-first 的应用，将笔记及其附属文件全都保存在本地，才算实现完整备份。

[^hup]: 我的 Logseq 和 Obsidian 共用一个图谱（graph or vault）。

事实上，已有一些工具可以实现这个功能，比如 Obsidian 插件 [Obsidian Local Images](https://github.com/aleksey-rezvov/obsidian-local-images) ，以及 Python 库 [Markdown articles tool](https://github.com/artiomn/markdown_articles_tool)。不过，受到上述批量下载文件的启发，我尝试了使用命令行工具来实现这个功能。

「替换图床链接为本地图片链接」这个操作有三个步骤：

1. 找到 Markdown 文件中所有的图床链接
2. 用 Curl 或 Wget 下载所有图片到本地
3. 替换 Markdown 中的图床链接为本地图片链接

为了使用 Curl 批量下载图床中的图片，我写了下面这 3 行代码：

```shell
# 找到此文件夹 Markdown 文件中的图床链接，下载所有图片到文件夹 `images`
sed G *.md | grep -Eio 'https*.*\.(jpe*g|png|webp|gif|svg)(\?.*[^)])*' | xargs -n 1 curl -# -C - --create-dirs -O --output-dir images

# 对下载得到的图片重命名
rename 's/\?alt=media.*//g; s/%2F/-/g' images/*

# 替换 Markdown 中图床 URL 为本地图片链接
sed -i '' -E 's/(!\[.*\]\()(https*.*)(\/)/\1images\3/g; s/\?alt=media.*\)/\)/g; s/%2F/-/g' *.md
```

第一行代码中的 `sed G` 是一个不太常用的 [命令](https://unix.stackexchange.com/a/3135/538728)，它的作用是读取同一文件夹下的所有 Markdown 文件，并在每行后面增加一个空行，但不会更改源文件（也可以 [使用](https://unix.stackexchange.com/a/420622) `awk 1`）。之所以不直接使用 `cat` 命令读取 Markdown 文件，是因为如果前一个文件最后一行是一个图床链接，会和下一个文件的第一行合并为同一行，导致 Curl 将后者当作 URL 的一部分，给出错误提示 `curl: (3) bad range specification in URL position 2`。`|` 是 Shell 中的 [管道操作](https://en.wikipedia.org/wiki/Pipeline_(Unix))（Pipeline），作用是将其前面的命令的输出结果，传递给后一个命令作为输入。在上面的例子中，`sed` 读取到 Markdown 之后，通过 `|` 将结果传递给 `grep`，然后 `grep` 在其中查找图床链接的 URL，其中，`-E` 表示使用扩展正则表达式（Extended regular expressions），`-i` 表示忽略字符大小写的差别（因为可能同时有 `.png` 和 `.PNG` 这两种扩展名），`-o` 表示只输出文件中匹配到的部分。接下来用 `curl` 的 `--create-dirs` 命令 [创建文件夹](https://curl.se/docs/manpage.html#--create-dirs) `images`，将下载的所有图片 [保存](https://curl.se/docs/manpage.html#--output-dir) 到该文件夹中，其中 `-C -` 告诉 `curl` 接着从上次中断的位置开始下载，而不需要从头开始，这是为了应对可能因网络连接而导致的中断问题。

一些图床 URL 不是以文件扩展名结尾的，例如，[Cloud Storage for Firebase](https://firebase.google.com/docs/storage) 中的图片链接：

```text
https://firebasestorage.googleapis.com/v0/b/someapp.com/o/imgs%2Fapp%2FUser%2FG02DwOi9oF.jpeg?alt=media&token=a3eqfe0c-265c-47abc-8l7a3-4b1f2af10b78
```

直接通过 Curl 或 Wget 下载的话，上面这个链接对应的图片在本地会被保存为：

```text
imgs%2Fapp%2FUser%2FG02DwOi9oF.jpeg?alt=media&token=a3eqfe0c-265c-47abc-8l7a3-4b1f2af10b78
```

无法被文件系统正确识别扩展名。除此之外，文件名中的 `%2F` 是斜杠符号 `/` 在 URL 中编码（[URL encoding](https://stackoverflow.com/q/60215602/19418090)）后的结果，不能用于 Markdown 中图片的引用链接。为了解决这两个问题，第二行代码使用 `rename` [命令](http://plasmasturm.org/code/rename)（在 macOS 上需要单独安装 `rename`）将下载得到的图片重命名，移除掉图片文件扩展名后多余的参数，并替换 `%2F` 为 `-` [^guq]。

[^guq]: 如果你的图床链接不存在此类情况，可以将这一行命令删除。

最后一行通过 `sed` 的正则匹配，将 Markdown 文件中的图床链接替换为本地图片链接，并移除图片扩展名后多余的参数，替换 `%2F` 为 `-`。这里使用的 `sed` 命令是 macOS 自带的 [BSD sed](https://man.freebsd.org/sed/)，其中 `-i ''` 表示直接对源文件进行更新，无需备份，`-E` 表示使用扩展正则表达式。需要注意的是，这与 Linux 发行版安装的 [GNU sed](https://www.gnu.org/software/sed/manual/sed.html) [有所不同](https://stackoverflow.com/a/24276470/19418090)。因此，如果你的系统中安装的是 GNU sed，则需要使用下面这行命令来完成查找替换的操作，其中 `-i` 表示更新源文件，不备份，`-r` 表示使用扩展正则表达式（其实 `-E` [也是可以的](https://www.austingroupbugs.net/view.php?id=528)）：

```shell
sed -i -r 's/(!\[.*\]\()(https*.*)(\/)/\1images\3/g; s/\?alt=media.*\)/\)/g; s/%2F/-/g' *.md
```

当然，你也可以在 macOS 中使用 `brew install gnu-sed` 来安装 GNU sed，然后将上述这行命令中的 `sed` 替换为 `gsed` 即可。

尽管 Curl 有一个 [参数](https://curl.se/docs/manpage.html#-J) `-J` (`--remote-header-name`)，可以使用远程服务器中的文件名，而不是 URL 中的文件名，但似乎对存储在 Cloud Storage for Firebase 中的文件没有作用。不过，Wget 可以做到「正确下载文件并命名」：

```shell
# 找到所有 Markdown 文件中的图床链接，下载所有图片到文件夹 `images`
find . -type f -name "*.md" -not -path '*/\.*' -exec sed G {} + | grep -Eio 'https*.*\.(jpe*g|png|webp|gif|svg)(\?.*[^)])*' | xargs wget -nc -nv --content-disposition --directory-prefix=images

# 替换一级子文件夹 Markdown 中图床 URL 为本地图片链接，移除 Cloud Storage for Firebase 图床中图片扩展名前后多余的参数
sed -i '' -E 's/(!\[.*\]\()(https*.*)(\/)/\1..\/images\3/g; s/imgs%2F.*%2F//g; s/\?alt=media.*\)/\)/g' */*.md

# 同上，处理二级子文件夹，以此类推，可以处理更深层的子文件夹
sed -i '' -E 's/(!\[.*\]\()(https*.*)(\/)/\1..\/..\/images\3/g; s/imgs%2F.*%2F//g; s/\?alt=media.*\)/\)/g' */*/*.md
```

与前文使用 Curl 的 3 行代码相比，上面这 3 行代码主要有这两个优势：

1. 使用 `find` 命令查找当前目录中所有 Markdown 文件（包括所有子文件夹），然后批量下载 Logseq/Obsidian 图谱中所有存储在图床中的图片。
2. Wget 的 `--content-disposition` 参数可以将存储在 Cloud Storage for Firebase 中的图片正确下载并命名，无需再使用 `rename` 在本地重命名。

在下载文件方面，Curl 和 Wget 各有优劣，难分伯仲，因此本文同时给出了这两个工具的使用方法，你可以根据自己的实际需求和操作系统选择使用哪一个。


## 在命令行中处理图片

### 用 ImageMagick 转换图片格式

转换图片格式是一种常见需求。例如，为了加快静态资源的加载速度，现在很多网站会采用 WebP 图片格式，因为与 `.jpeg` 和 `.png` 相比，`.webp` 文件的 [体积相对较小](https://developers.google.com/speed/webp)，而在大多数情况下，图片还是以 JPEG 或 PNG 存储的，在这种时候，图片格式转换就不可避免。

又如，[苹果](https://support.apple.com/zh-cn/HT207022) 在 iOS 11 和 macOS High Sierra 后，将相机拍摄的默认图片存储格式改为 [HEIF](https://en.wikipedia.org/wiki/High_Efficiency_Image_File_Format)（High Efficiency Image File Format），与传统的 JPEG 相比，HEIF 在无损画质的前提下，占用存储空间更小。尽管各方面都比 JPEG 要好，但 HEIF 仍然存在兼容性问题，比如将 HEIF 格式的图片上传到某些图床平台后，无法被正常引用。

在 iOS/iPadOS 中，将相册中由相机拍摄的图片隔空投送（AirDrop）到 Mac 上时，都会是 HEIF 格式。尽管可以制作一个简单的 [快捷指令](https://www.icloud.com/shortcuts/916f143f07b745a59e0f7ffd7d8a6dd1)，将隔空投送的图片格式改为 JPEG，但在一次性分享多张图片时，这种传输方式的效率就会大打折扣。

{{< imgcap title="一个快捷指令，在隔空投送前将 HEIF 格式改为 JPEG 格式。" src="https://p15.p3.n0.cdn.getcloudapp.com/items/12uz4A4z/6636edd0-24ce-41bd-8aa7-ea7697014b36.png" >}}

命令行特别适合转换图片格式这种流程化的操作，而其中首屈一指的工具就是 [ImageMagick](https://imagemagick.org) —— 一个用于查看、编辑位图文件以及进行图像格式转换的命令行软件。

ImageMagick 的命令很复杂，选项非常多，你可以在需要时查阅它的 [文档](https://imagemagick.org/script/command-line-tools.php)，或者在 [Stack Overflow](https://stackoverflow.com/questions/tagged/imagemagick) 上搜索已有的相关问答。

使用 ImageMagick 的 `convert` 命令转换单张图片：

```shell
# 将 JPEG 转换为 PNG
convert image.jpg image.png

# 将 HEIF 转换为 JPEG
convert image.HEIC image.jpg
```

使用 ImageMagick 的 `mogrify` 命令一次性转换多张图片：

```shell
# 将 HEIF 批量转换为 JPEG
mogrify -format jpg *.HEIC
```

`mogrify` 命令不会替换源文件，而会创建新文件。在上面的例子中，如果你想删除原有的所有 HEIF 图片，只保留 JPEG 图片，可以使用命令 `rm *.HEIC`。我尝试使用 ImageMagick 将 731 张 iPhone 相机拍摄的 HEIF 图片转换为 JPEG，共耗时 23 分钟 27 秒，平均转换速度约 1.9 秒/张。

假设你有一系列 PNG 格式的视频截图，希望将其转换为 WebP 格式，以减小图片体积，并按照一定的规则重命名，可以使用下面这行命令：

```shell
convert *.png converted-%d.webp
```

这行命令中，`%d` 表示数字，因此转换后得到的图片名称为 `converted-0.webp`、`converted-1.webp`……

### 用 ImageMagick 拼接图片

在 iPhone 上，我使用 [Picsew](https://apps.apple.com/app/picsew-screenshot-stitching/id1208145167) 拼接屏幕截图，但在 Mac 上一直没有找到一个趁手的工具，此前我一直使用 [Pixelmator Pro](https://www.pixelmator.com/pro/) 调整图片的画布大小，间接达到拼图的目的，但是这需要用计算器计算一下图片的尺寸，每次还得在 Pixelmator Pro 中拖拽来对齐图片，对于我这样的懒人来说，感觉有点麻烦。而使用 ImageMagick 则非常方便，一行命令即可搞定 [^fql]。

[^fql]: 不过 ImageMagick 无法像 Picsew 那样自动移除屏幕截图中的重叠部分。

横向拼接图片：

```shell
convert 1.png 2.png +append image.png
```

纵向拼接图片：

```shell
convert 1.png 2.png -append image.png
```


上面的两行命令中，`+append` 表示水平拼接图片，`-append` 表示垂直拼接图片。当然，拼接的图片可以不止 2 张。如果输入的图片较多，懒得手动输入，可以使用通配符来匹配图片，比如 `*.png`  会匹配同一目录下所有的 PNG 图片，对于既有 JPEG 又有 PNG 的情况，则可以使用 `*g` 来匹配。

{{< imgcap title="使用 ImageMagick 将 3 张屏幕截图横向拼接在一起" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Kou1Y0D6/f1fc2025-f21d-4d94-9fad-6b1e41734fa9.png" >}}

### 用 TinyPNG 和 ImageMagick 压缩图片

压缩图片是一项高频需求，有很多工具可以实现，由于算法不同，这些工具的压缩效率也不尽相同。在图片压缩软件中，[TinyPNG](https://tinypng.com/) 以压缩效率高而著称，根据 TinyPNG 官网的介绍，它采用智能有损压缩技术来减小 WebP、JPEG 和 PNG 文件的体积大小，压缩前后的差别几乎不可见。

TinyPNG 有多种使用方式，比如直接拖动图片到它的网站中，使用第三方图形化应用 [TinyPNG4Mac](https://github.com/kyleduo/TinyPNG4Mac)，当然，也可以使用它的命令行工具 [TinyPNG CLI](https://github.com/websperts/tinypng-cli)。TinyPNG CLI 是一个 NPM 包，在 macOS 上需要先使用 `brew install node` 安装 [Node.js](https://nodejs.org/)，然后在终端中输入 `npm install -g tinypng-cli` 即可安装。

使用 TinyPNG CLI 之前，需要注册账号并申请一个 [API](https://tinypng.com/developers)，免费的 API 每月有 500 张图片的压缩额度，对于个人用户使用基本足够。

使用 TinyPNG CLI 的第一种方式是明确在命令中提供 API key，例如：

```shell
tinypng demo.png -k E99a18c4f8cb3EL5f2l08u368_922e03
```

不过每次都需要输入 API key，感觉很麻烦。因此推荐使用第二种方式，将 API key 保存在用户文件夹下的一个文本文件中，命名为 `.tinypng` [^gqj]。保存好 API key 之后，就可以在终端中输入下面的命令来压缩图片：

[^gqj]: 以 `.` 开头的文件会被隐藏，在 macOS 上的访达（Finder）中可以使用快捷键 `⌘ + ⇧ + .` 来显示隐藏文件。

```shell
# 压缩当前目录中的所有图片
tinypng .

# 压缩当前目录及其子目录中的所有图片
tinypng . -r
```

以下是我用 TinyPNG CLI 压缩 4 张图片的示例，压缩比率超过 75%：

```shell
$ tinypng .

TinyPNG CLI
vO.0.7

✔ Found 4 images

Processing...
✔ Panda just saved you 2 MB (93%) for `./shortcuts-airdrop-jpgs.png`
✔ Panda just saved you 1.6 MB (78%) for `./convert-731-heic-images.png`
✔ Panda just saved you 1.7 MB (78%) for `./tinypng-cli.png`
✔ Panda just saved you 1.9 MB (80%) for `./photo-1518432031352-d6fc5c10da5a.jpg`
```

需要注意的是，TinyPNG 会用压缩后的图片替换掉原有图片，如果你需要保留源文件，请记得在压缩前保留备份。

TinyPNG 不支持压缩 GIF 图片，尽管有不少 GUI 应用可以做到，比如 [GIF Brewery](https://gfycat.com/gifbrewery)、[Gifox](https://gifox.app)，但基本上都需要付费。如果你想在命令行中压缩 GIF，全能的 ImageMagick [也可以实现](https://stackoverflow.com/a/47343340/19418090)：

```shell
mogrify -layers 'optimize' -fuzz 10% test.gif
```

这行命令中，`-layers` [参数](https://www.imagemagick.org/script/command-line-options.php#layers) 表示处理动画帧，使用 `optimize` 方法优化 GIF 动画，再通过 `-fuzz 10%` [参数](https://www.imagemagick.org/script/command-line-options.php#fuzz)，将 RGB 空间中目标颜色 10% 距离内的颜色视为相等的，最终达到压缩 GIF 的目的。需要注意的是，这行命令会替换掉原有的 GIF 图片，使用前请小心。

{{< imgcap title="将一个 27.2 MB 的 GIF 图片压缩到 9.5 MB，肉眼几乎分辨不出二者的区别，GIF 图片来源：https://twitter.com/ScottDuncanWX/status/1561040349535113217" src="https://p15.p3.n0.cdn.getcloudapp.com/items/E0uZAYj2/4351ca26-abf7-4acf-a9c8-0b2e13954733.png" >}}

除此之外，也有一些其他的命令行工具可以用于压缩图片，比如 [ImageOptim-CLI](https://github.com/JamieMason/ImageOptim-CLI)，以及专门用于处理 GIF 图片的命令行工具
[Gifsicle](https://www.lcdf.org/gifsicle/)，如果你有需要，可以前往下载使用。

### 用 ImageMagick 将图片转换为 PDF

对我来说，图片转 PDF 的应用场景主要在需要打印的情况，因为一张张打开图片再打印真的很麻烦，如果一次性打印多张图片，往往还会分不清哪些图片已打印，哪些图片未打印。因此，每次去打印店前，我都会使用下面这行命令，将所有图片合并成一个单独的 PDF：

```shell
convert *g merged.pdf
```

这行命令将同一文件夹下的所有图片（JPEG 和 PNG）按照文件名称排序 [^gql]，合并成一个 PDF 文件，每张图片单独一页，命名为 `merged.pdf`。

[^gql]: 不过对于打印文件来说，页面顺序不是特别重要。

由于图片的分辨率可能不尽相同，得到的 `merged.pdf` 不太方便阅读，为了统一分辨率，可以加上 `-density` [这个参数](https://imagemagick.org/script/command-line-options.php#density) 来设置分辨率，例如设置为 150 DPI：

```shell
convert * -density 150 merged.pdf
```

如果图片的尺寸不同，合并得到的 PDF 页面大小不一，为了方便阅读与打印，可以将页面统一调整为 A4（210 x 297 mm），而命令行工具 [pdfjam](https://github.com/rrthomas/pdfjam) 可以轻松完成这一操作。值得注意的是，pdfjam 包含在 [TeX 发行版](https://www.latex-project.org/get/) 中，如果已安装了 [MacTeX](https://www.tug.org/mactex/) [^fan]，就不需要再安装，它的默认路径是 `/Library/TeX/texbin/pdfjam`，可以直接使用。当然，如果你不想安装硕大无朋的 MacTeX，也可以 [单独安装](https://github.com/rrthomas/pdfjam#-installation) pdfjam。

[^fan]: 可以使用 `brew install --cask mactex` 或 `brew install --cask mactex-no-gui` 安装 MacTeX，后者不包括其中的 GUI 应用。

通过 ImageMagick 得到合并后的 `merged.pdf` 后，使用 pdfjam 命令将全部页面统一为 A4：

```shell
pdfjam merged.pdf --a4paper --outfile a4paper.pdf
```

执行上面这行命令会有一个警告：`unknown keyword LC_PAPER`，pdfjam 的 GitHub 仓库有一个关于这个问题的 [issue](https://github.com/rrthomas/pdfjam/issues/48)，看样子是 pdfjam 的问题，不过，这并不影响使用。为了抑制输出冗长的提示，可以加上 `--quiet` 参数（尽管这并不能抑制输出上面这行警告）：

```shell
pdfjam --quiet merged.pdf --a4paper --outfile a4paper.pdf
```


## 在命令行中处理 PDF

### 用 pdftoppm 转换 PDF 为图片

我一直使用 Mac 自带的 [预览](https://sspai.com/post/73291) 将 PDF 转换为图片，不过这种方式只适用于单页的 PDF，如果是多页的 PDF，则无法将每页单独导出为一张图片。

我尝试过使用 ImageMagick 和 [Ghostscript](https://www.ghostscript.com/) 转换 PDF 为图片，比如使用 `convert` 命令：

```shell
convert -density 300 input.pdf -quality 100 output.jpg
```

尽管我已将分辨率设置为 300 DPI，但转换得到的图片效果依然不太理想。后来在 Stack Overflow 上的 [这个回答](https://stackoverflow.com/a/58795684/19418090) 中发现了 pdftoppm —— 一个将 PDF 转换为便携式像素图（Portable Pixmap, PPM）的命令行工具，同时它也可以将 PDF 转换为 JPEG 和 PNG（JPEG 和 PNG 不是 PPM 图片格式）。

pdftoppm 包含在 [Poppler](https://poppler.freedesktop.org) 中，使用 `brew install poppler` 即可安装。基本使用方式如下：

```shell
# 转换为 JPEG
mkdir -p images && pdftoppm -jpeg -jpegopt quality=100 -r 300 input.pdf images/page

# 转换为 PNG
mkdir -p images && pdftoppm -png -r 300 input.pdf images/page
```

上面的命令中，首先用 `mkdir` 命令创建一个文件夹 `images`，其中 `-p` 表示如果文件夹已存在的话则不报错，根据需要创建父目录，然后将 `input.pdf` 转换为图片（`-jpeg` 或 `-png`），每页保存为一张，`-r 300` 表示分辨率设置为 300 DPI（默认为 150 DPI），转换后得到的图片名称为 `page-1.jpg`、`page-2.jpg`……

如果需要将同一目录下的所有 PDF 文件转换为 JPEG 图片，并保存到同名的文件夹中，可以使用下面的脚本：

```shell
for file in *.pdf
do
    folder=$(basename "$file" ".pdf")
    mkdir -p "${folder}" && pdftoppm -jpeg -jpegopt quality=100 -r 300 "${folder}".pdf "${folder}"/page
done
```

### 用 PDFtk 合并 PDF

与「图片转 PDF」类似，合并 PDF 的目的之一也是为了方便打印。除此之外，我也会在合并书籍章节时用到，因为不少出版社出版的书籍（例如 [剑桥大学出版社](https://www.cambridge.org/core/what-we-publish/books)），每个章节是一个单独的 PDF 文件，如果需要得到一本完整的书籍，就需要将各个章节的 PDF 全部合并到一起。

很多工具都可以 [合并 PDF](https://stackoverflow.com/questions/2507766/merge-convert-multiple-pdf-files-into-one-pdf)，比如 GUI 应用 [Adobe Acrobat](https://acrobat.adobe.com)、[PDF Expert](https://pdfexpert.com)，命令行工具 [pdfunite](https://manpages.ubuntu.com/manpages/bionic/man1/pdfunite.1.html) [^hqv]、Ghostscript、[QPDF](https://github.com/qpdf/qpdf)。对于打印的需求来说，使用这些工具都没什么区别，因为它们都能在视觉上把 PDF 组合在一起。但是对于合并书籍章节的 PDF 来说，原有的链接、书签等信息需要保留，在比较过很多合并 PDF 的工具后，我发现只有 [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) 可以做到这一点。

[^hqv]: 前文提到的 Poppler 是一个 PDF 套件，其中就包括 pdfunite，除此之外，Poppler 还包括其他一些实用的 PDF 工具，比如提取 PDF 元数据的 pdfinfo，为 PDF 嵌入附件的 pdfattach，导出 PDF 中嵌入式附件的 pdfdetach。

使用 Homebrew 安装 PDFtk 前，需要先添加一个 [Tap](https://github.com/zph/homebrew-cervezas) ([Third-Party Repository](https://docs.brew.sh/Taps)) `brew tap zph/cervezas`，然后执行 `brew install zph/cervezas/pdftk` 就可以安装 PDFtk。

使用 PDFtk 合并 PDF：

```shell
pdftk *.pdf cat output merged.pdf
```

这行命令将同一目录下的所有 PDF 文件合并为一个文件 `merged.pdf`。

### 用 MuPDF 和 Briss 分割 PDF

分割 PDF 是指将双栏或多栏 PDF 的每一栏单独成页。在处理一些扫描版 PDF 书籍时，为了方便在电子屏幕上阅读或打印成纸质版，同时也为了使用 [DEVONthink](https://www.devontechnologies.com/apps/devonthink)（或其他软件）提取 PDF 批注时得到正确的页码，这个步骤必不可少。

{{< imgcap title="一本扫描版的双栏 PDF 书籍" src="https://p15.p3.n0.cdn.getcloudapp.com/items/geuygbAz/4206649e-8cf6-4dcf-9fac-505e7b00c2c3.png" >}}

如果你得到的 PDF 是电子排版的双栏或多栏，或者页面基本规整的扫描版 PDF，可以用 [MuPDF](https://mupdf.com) 来分割 PDF 页面。执行下面这行命令，就可以将双栏 PDF 转换为单栏 PDF：

```shell
mutool poster -x 2 input.pdf output.pdf
```

其中，`mutool poster` [命令](https://www.mupdf.com/docs/manual-mutool-poster.html) 读入 `input.pdf` 准备将其分割，`-x 2` 表示将 PDF 的每一页从垂直方向的正中间分割为两部分（`-y` 表示从水平方向上分割，紧接着后面的数字 `n` 表示分割成 `n` 部分），输出为 `output.pdf`。

{{< imgcap title="Elsevier 旗下的学术期刊大多采用双栏排版，你可以用上面的命令将其转换为单栏，不过这也会将通栏排版的标题、摘要、表格等分割开。PDF 表示：我裂开了：https://doi.org/10.1016/j.paid.2022.111723" src="https://p15.p3.n0.cdn.getcloudapp.com/items/OAujQPnN/1d5d9a94-fdc8-41ae-a401-814d195423eb.png" >}}

尽管使用 MuPDF 分割 PDF 非常简单，不需要手动操作，但如果 PDF 页面偏转角度过大，同时有横向（Landscape）和纵向（Portrait）页面的情况，MuPDF 的处理方式就难以令人满意。好在另一个工具 [Briss](https://briss.sourceforge.net) 可以帮助我们更精细地进行调整。

安装 Briss 后，在终端中输入 `briss`，会自动打开 Briss 的 GUI 窗口，然后点击选择需要处理的 PDF 文件，加载完成后输入需要排除的页面的页码，如果没有的话，就直接点击 `OK`，接下来拖动鼠标选择矩形覆盖需要裁剪的区域，完成之后可以选择预览（快捷键 `P`）或直接保存裁剪后的文件（快捷键 `C`）。动态的操作步骤可以参考 [这个视频](https://www.youtube.com/watch?v=4Wp4RIYUqC8)。根据我的试验，一次性可能无法将全部 PDF 页面都分割成功，如果你也遇到了这种情况，可以对首次分割后的 PDF 再用 Briss 处理第二次。

{{< imgcap title="在 Briss 中选择裁剪的 PDF 页面" src="https://p15.p3.n0.cdn.getcloudapp.com/items/NQujow7D/3bef339e-8bbb-4443-88d0-82402ded2e34.png" >}}

严格来说，Briss 不算是一个命令行工具，而应该是一个结合了 CLI 和 GUI 的软件。M1 芯片的 Mac 使用 Homebrew 安装的 Briss 路径为 `/opt/homebrew/Cellar/briss/0.9/bin/briss`，其他类型的设备可以在命令行中输入 `which briss` 或 `whereis briss` 找到 Briss 的安装路径），这是一个 Unix 可执行文件，你可以鼠标双击来打开它，这相当于在终端中输入 `briss`。如此操作的话，Briss 就可以完全当作一个图形化软件来使用。

### 用 OCRmyPDF 识别文字

为了在阅读扫描版 PDF 的过程中进行批注，并将其导出到笔记软件中，我经常需要识别扫描版 PDF 中的文字，即光学字符识别（[Optical Character Recognition](https://en.wikipedia.org/wiki/Optical_character_recognition), OCR）。[Adobe Acrobat Pro DC](https://helpx.adobe.com/document-cloud/help/using-ocr-exportpdf.html)、[DEVONthink](https://www.devontechnologies.com/apps/devonthink/editions#scanning)、[PDF Expert](https://pdfexpert.com/how-to-ocr-pdf) 等常用 PDF 软件都有 OCR 的功能，但共同特点是需要付费，尽管我已购买了 Adobe Acrobat 和 DEVONthink，但仍想尝试一下开源免费的解决方案。

得益于开源社区的贡献，我们可以使用 [OCRmyPDF](https://github.com/ocrmypdf/OCRmyPDF) 在命令行中免费识别 PDF 中的文字。OCRmyPDF 使用 Python 语言编写，基于 [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) 引擎处理多语言，因此还需要额外使用 `brew install tesseract-lang` 安装语言包，对于 Linux 系统来说，无需安装全部语言包，可以根据需要只安装特定的语言。

下面这行命令中，`-l chi_sim` 指定输入文件 `input.pdf` 中文字的语言为「简体中文」，输出文件为 `output.pdf`。如果不指定语言，OCRmyPDF 默认输入 PDF 的语言为 [English](https://ocrmypdf.readthedocs.io/en/latest/cookbook.html#ocr-languages-other-than-english)，Tesseract OCR 支持的各种语言缩写代码可以在 [这里](https://github.com/tesseract-ocr/tesseract/blob/main/doc/tesseract.1.asc#languages-and-scripts) 查看。

```shell
ocrmypdf -l chi_sim input.pdf output.pdf
```

{{< imgcap title="使用 OCRmyPDF 识别扫描版 PDF 中的文字，识别文字后的 PDF 变得更小。" src="https://p15.p3.n0.cdn.getcloudapp.com/items/lludN5kX/4bfb18af-3012-4513-8701-0e8eb90f20c1.png" >}}

一些 PDF 文件的页面不全是扫描版，可能其中有页面本身就有文字，这种情况下 OCRmyPDF [会报错](https://ocrmypdf.readthedocs.io/en/latest/errors.html#common-error-messages)，你可以尝试加上 `--force-ocr`, `--skip-text`, `--redo-ocr` 这三个参数之一。

最后需要提醒一下，我的多次试验表明，OCRmyPDF 识别文字的效果比不上 Adobe Acrobat 和 DEVONthink，更准确地说，识别英文还不错，但中文还有待提高。总的来说，如果没有其他工具 OCR PDF 的话，OCRmyPDF 还是可堪一用的。

### 用 ImageMagick「扫描」PDF

出于一些 [官僚理由](https://gitlab.com/edouardklein/falsisign)，在某些情况下，对方会要求我提交扫描文档，有时还需要手写签名甚至完全手写一份文件再扫描成 PDF，以证明所谓「程序正当」。

如果你也像我一样，不想暴露自己太久没有提笔写字，或者单纯就是不想如此麻烦，那么可以试试「扫描 PDF」。一般来说，「扫描」针对的是物理世界的纸张，对数字世界的 PDF 来说，则不存在「扫描」一说，但是我们可以把 PDF「模拟」（simulate）成已被扫描过的样子。

为了「扫描 PDF」，我们再次使用 ImageMagick：

```shell
convert -density 150 input.pdf -colorspace gray +noise Gaussian -rotate -0.5 -depth 2 scanned.pdf
```

这行命令中，`-density 150` 设置 PDF 分辨率为 150，使之看上去比较模糊。`-colorspace gray` [参数](https://www.imagemagick.org/script/command-line-options.php#colorspace) 设置图像颜色空间为灰度，`+noise Gaussian` [参数](https://www.imagemagick.org/script/command-line-options.php#noise) 为图像添加高斯噪声，`-rotate -0.5` [参数](https://www.imagemagick.org/script/command-line-options.php#rotate) 将图像顺时针旋转 0.5°，最后，`-depth 2` [参数](https://www.imagemagick.org/script/command-line-options.php#depth) 设置颜色深度为 2，输出为 `scanned.pdf`。

{{< imgcap title="原始 PDF 与经 ImageMagick「扫描」后的 PDF" src="https://p15.p3.n0.cdn.getcloudapp.com/items/12uz4APn/90e566c8-7526-4481-8d22-ba2e072c5815.png" >}}

如果你对上面这行命令得到的「扫描版 PDF」不够满意，可以查阅 ImageMagick 手册，增加其他参数，例如下面这行略显复杂的 [命令](https://gist.github.com/andyrbell/25c8632e15d17c83a54602f6acde2724?permalink_comment_id=3206269#gistcomment-3206269)：

```shell
convert -density 150 input.pdf -rotate "$([ $((RANDOM % 2)) -eq 1 ] && echo -)0.$(($RANDOM % 4 + 5))" -attenuate 0.4 +noise Multiplicative -attenuate 0.03 +noise Multiplicative -sharpen 0x1.0 -colorspace Gray scanned.pdf
```

### 用 Ghostscript 压缩 PDF

在合并、分割、OCR 和扫描 PDF 后，PDF 的体积可能会变得非常大，为了节约存储空间，缩短传输时间，有必要对 PDF 进行压缩。

尽管很少有专门用于压缩 PDF 的命令行工具，但有一些「PDF 全能选手」可以实现这个功能，比如 Ghostscript，它是一个 [PostScript](https://en.wikipedia.org/wiki/PostScript) 语言和 PDF 文件的解释器，由于 Ghostscript 是很多其他命令行工具的依赖（比如 ImageMagick、OCRmyPDF 都依赖于 Ghostscript），执行安装命令时，包管理器可能会提醒你已安装过。

使用 `gs` 命令压缩 PDF：

```shell
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf input.pdf
```

这行命令中，`gs` 是 Ghostscript 的命令行指令（Ghostscript 的缩写），`-sDEVICE=pdfwrite` [参数](https://ghostscript.readthedocs.io/en/latest/Use.html#selecting-an-output-device) 设置输出设备为 pdfwrite，你可以在终端中输入 `gs -h` 查看所有支持的输出设备。`-dCompatibilityLevel=1.4` 设置输出 [PDF 版本](https://sspai.com/post/47092) 为 1.4。`-dNOPAUSE` [参数](https://ghostscript.readthedocs.io/en/latest/Use.html#dnopause) 表示页与页之间不暂停，`-dQUIET` [参数](https://ghostscript.readthedocs.io/en/latest/Use.html#dquiet) 表示抑制标准输出中的注释信息，`-dBATCH` [参数](https://ghostscript.readthedocs.io/en/latest/Use.html#dbatch) 使 Ghostscript 在处理命令行上指定的所有文件后退出。输入文件为 `input.pdf`，输出文件为 `output.pdf`。

`-dPDFSETTINGS=/ebook` [参数](https://ghostscript.readthedocs.io/en/latest/VectorDevices.html#controls-and-features-specific-to-postscript-and-pdf-input) 控制输出的 PDF 适用于电子书，分辨率为 150 DPI，这是影响压缩比率的主要参数，`-dPDFSETTINGS` 的 [可选项](https://askubuntu.com/a/256449) 如下：

- `/screen`：类似于 [Acrobat Distiller](https://helpx.adobe.com/acrobat/using/creating-pdfs-acrobat-distiller.html) (X 版本之前) 中的 Screen Optimized 设置，分辨率为 72 DPI。
- `/ebook`：类似于 Acrobat Distiller 中的 eBook 设置，分辨率为 150 DPI。
- `/printer`：类似于 Acrobat Distiller 中的 Print Optimized 设置，分辨率为 300 DPI。
- `/prepress`：类似于 Acrobat Distiller 中的 Prepress Optimized 设置，分辨率为 300 DPI。
- `/default`：输出各种用途的 PDF，文件体积较大。

不得不承认，Ghostscript 的命令的确有点复杂。如果你不想输入如此多的参数，可以试试 Ghostscript 中的另一个命令 ps2pdf，它将 PDF 转换为 PostScript，然后再转换回来，可以有效地压缩 PDF：

```shell
ps2pdf -dPDFSETTINGS=/ebook input.pdf output.pdf
```

另外需要注意，使用 Ghostscript 压缩 PDF 会使文件的 [内部链接失效](https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file/256449#comment494603_243753)，如果你有保留 PDF 内部链接的需求，请谨慎使用这种压缩方式。


## 小结

本文根据我的实际使用场景，分享了一些在 macOS 上使用命令行下载文件、处理图片和 PDF 的方法。这只是我个人经验，文中所提及的方法也可能并非最优解，希望能抛砖引玉，一起探索高效的文件处理流程，同时也让更多人感受到 [命令行的魅力](https://github.com/jlevy/the-art-of-command-line)。

~~俗话说~~，「好看是第一生产力」。一个好看的终端，能够显著提升命令行的视觉魅力，让你更加愉快地使用命令行。如果你觉得系统自带的终端颜值不够高的话，可以参考以下这几篇文章，配置一个「漂亮得不像实力派」的终端：

- [打开终端总有好心情：我的美化方案及配置分享](https://sspai.com/post/74216)
- [iTerm2 配置和美化](https://sspai.com/post/63241)
- [macOS 最佳命令行客户端：iTerm 使用详解](https://sspai.com/post/56352)

著名软件工程师 Matt Rickard 在他的博客中写道：[Every Unix Command Becomes a Startup](https://matt-rickard.com/every-unix-command-becomes-a-startup)，例如，grep 对应的初创企业是 [Google](https://www.google.com/)，man 对应的初创企业是 [Stack Overflow](https://stackoverflow.com/)，cron 对应的初创企业是 [Zapier](https://zapier.com)。因此，我们可以说，虽然如今互联网的新工具层出不穷，但它们的核心理念早已在命令行中实现过。尽管命令行的上手门槛相对较高，但那只是门槛而已，只要你「入了门」，就会惊叹于命令行的高效便捷。如何才能在没有程序员 [女婿](https://www.unixsheikh.com/articles/my-70-year-old-mother-has-been-using-linux-on-the-desktop-for-the-past-21-years.html) 或 [父亲](https://thejavaguy.org/posts/008-my-kid-learned-bash-in-one-hour/) 的帮助下，不畏惧 Unix/Linux 命令行？除了善于查阅文档手册、掌握 [提问的智慧](https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way) 以外，这里我想引用一下 Newsletter「生活实验记录」主理人 [晴子酱](https://qingzijiang.zhubai.love/posts/2162960344065327104) 的观点：**相信任何技能都能学会** [^qzo]：

[^qzo]: 这同样适用于生活中的其他方面。

> 在面对一项技能时，玄学会让人迷惑，产生畏难情绪，而不是相信自己可以学会，先入为主的畏难情绪会让这项技能更加难以学会。

知识分子之间存在文人相轻的现象，计算机领域也有各种由使用工具而带来的 [鄙视链](https://vinta.ws/blog/695)。大概是因为使用命令行给人一种「[充满力量的感觉](https://www.reddit.com/r/ProgrammerHumor/comments/xbxvds/modal_editing/)」，从而让 CLI 使用者看不上 GUI 用户，这种鄙视现象经常被做成各种 [meme](https://www.google.com/search?q=cli+gui+meme&tbm=isch)，流传甚广。

{{< imgcap title="GUI vs CLI，图片来源：https://www.reddit.com/r/ProgrammerHumor/comments/g7ck8h/gui_vs_cli/" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Jru8Gkvn/d94f5688-07d8-4a41-81f2-5fbb7997de64.jpg" >}}

尽管如此，我们应该意识到，与图形化应用相比，命令行工具并不必然「高人一等」，交互新颖、UI 出彩的图形化应用同样非常具有吸引力。在这方面，我的观点是，不一定非要局限于某一类应用，各取所长，怎么好用怎么来，正如一位 [Reddit](https://www.reddit.com/r/programming/comments/axtsiw/comment/ehw856s) 网友所说：

> CLIs are better than GUIs. Also, GUIs are better than CLIs. In other words, it depends.

事实上，在压缩单张图片时，我一般不会用命令行，而会在 [Alfred](https://www.alfredapp.com/blog/tips-and-tricks/tiny-png-workflow-compress-images/) 中使用快捷键呼出 TinyPNG，结合 [BetterTouchTool](https://folivora.ai) 的增强触控板功能，并且还有音效通知，与打开终端再在命令行中执行相比，更加快捷优雅。有时候，点击一下鼠标或触控板的动作，与在命令行中得到预期的结果一样，都会让人感到愉悦，大概这就是软件世界的「过程-结果哲学观」。 
-->
