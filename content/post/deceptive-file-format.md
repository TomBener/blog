---
title: 所谓「自主研发」
date: 2023-08-28
---

今天上午和 ChatGPT 对话的过程中，它给我推荐了一本书 *[Modern China: A Very Short Introduction](https://doi.org/10.1093/actrade/9780199228027.001.0001)*。在下载下来这本书之后，我大致浏览了一下，一不小心瞥见了第四章开头作者 Rana Mitter 引用的民国新闻记者、出版家 [邹韬奋](https://zh.wikipedia.org/zh-cn/%E9%84%92%E9%9F%9C%E5%A5%AE) 的一句话：

> Not every person’s natural intelligence or strength is equal. But if each person develops his mind towards service and morality … so as to contribute to the mass of humanity, then he can be regarded as equal. That is *real* equality.

作为中文母语者，好奇心让我想知道这句话的中文原文是什么，也可以顺便了解一下邹韬奋其人。于是我去搜索了一下邹韬奋的相关著作。幸运的是，我搜索到了十四卷的《[韬奋全集](https://book.douban.com/subject/3053519/)》，直觉告诉我，这套书里面肯定有这句话。然而不幸的是，我获取到的电子书是一个压缩包，解压缩之后是一系列扩展名为 `.pdg` 的文件，macOS 无法识别，也无法打开它们。尽管有在线工具可以将 PDG 文件格式转换为 PDF，但由于这本书的体积过大，超过了网站的限制，无法实现在线转换。

## PDG

既然无法在线转换，我就决定来研究一下 PDG 格式，看看能不能实现在本地转换。搜索一番之后，发现 PDG 文件是超星公司特有的电子书格式，需要专门的阅读器才能打开。在 Windows 平台上，可以使用 [Pdg2Pic](https://www.cnblogs.com/stronghorse/p/17406168.html) 这款软件将 PDG 转换为 PDF，然而 macOS 上没有类似的软件。不过我没有放弃，还是在 GitHub 上搜索了一下，想看看有没有什么开源的实现方案。

我在 GitHub 上搜到了 [3 个相关的工具](https://github.com/search?q=pdg%20to%20pdf&type=repositories)，其中两个是用 Python 写的，还有一个是用 macOS 上的 Automator 实现的。它们的 README 中都提到「PDG 格式本质就是一种图片」，从代码实现思路来看，也证实了这一点。尽管受到了这一点的启发，不过我并没有使用它们，而是参考 [这个仓库](https://github.com/nizaiwo/pdg2pdf) 的思路，通过 Shell 脚本将文件扩展名从 PDG 转换为 PDF，在 ChatGPT 的帮助下写了以下几行代码：

```shell
# Rename all files with extension .pdg to .jpg
rename 's/\.pdg$/.jpg/' *.pdg

# Function to add existing files to the list
add_files() {
    for f in $(ls $1 2>/dev/null | sort); do
        files+="$f "
    done
}

# Initialize an empty string to hold the file names
files=""

# Add files in the desired order
add_files "cov001.jpg"
add_files "bok001.jpg"
add_files "leg001.jpg"
add_files "fow*.jpg"
add_files "!*.jpg"
add_files "000*.jpg"
add_files "cov002.jpg"

# Create the PDF
convert $files output.pdf
```

上面的代码首先使用 `rename` 命令批量将 `.pdg` 修改为 `.jpg`，在 macOS 上可以使用 [Homebrew](https://brew.sh/) 快速安装 `rename`：

```shell
brew install rename
```

接下来按照书籍页面的顺序将 JPEG 文件排序，使用 ImageMagick 中的命令 `convert` 将其合并为一个 PDF，输出为 `output.pdf`。需要注意的是，ImageMagick 同样需要额外安装：

```shell
brew install imagemagick
```

事实上，这几行代码的作用与我此前介绍的「[图片转 PDF](https://sspai.com/prime/story/cli-utils-for-ordinary-tasks)」是类似的，只不过多了一步修改文件扩展名的步骤，不过，在弄明白 PDG 的真正面目之后，这一步也是可以省略的。

假设当前目录中有一个 `test.pdg` 的文件，在终端中输入 `file test.pdg`，按下回车之后会输出以下结果：

```text
test.pdg: JPEG image data, JFIF standard 1.02, resolution (DPI), density 300x300, segment length 16, Exif Standard: [TIFF image data, big-endian, direntries=7, orientation=upper-left, xresolution=98, yresolution=106, resolutionunit=2, software=Adobe Photoshop CS3 Windows, datetime=2015:06:12 15:36:02], baseline, precision 8, 1560x2504, components 1
```

可以看到，输出结果赫然写着 `JPEG image data`，说明 PDG 就是常见的 JPEG 格式。因此，我们可以简化上述 Shell 脚本，直接使用 ImageMagick 将 PDG 转换为 PDF，而不用修改文件扩展名：

```shell
# Function to add existing files to the list
add_files() {
    for f in $(ls $1 2>/dev/null | sort); do
        files+="$f "
    done
}

# Initialize an empty string to hold the file names
files=""

# Add files in the desired order
add_files "cov001.pdg"
add_files "bok001.pdg"
add_files "leg001.pdg"
add_files "fow*.pdg"
add_files "!*.pdg"
add_files "000*.pdg"
add_files "cov002.pdg"

# Create the PDF
convert $files output.pdf
```

将上述 Shell 脚本的最前面加上 `cd "$KMVAR_curr_folder_loc"`，然后将其添加到 Keyboard Maestro 中，就可以制作一个将 PDG 转换为 PDF 的 macro，如下图所示。

{{< imgcap title="将 PDG 转换为 PDF 的 Keyboard Maestro macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Bluzkdyd/6ae13a24-237a-403f-8a9c-0cd6ff6d4962.png" >}}

激活这个 macro，只需点击一下菜单栏中的图标，就可以轻松将访达中选中的文件所在目录中的所有 PDG 文件转换为一个 PDF[^1]。

[^1]: 所以关键的问题就是如何获取 PDG 文件了。

如果有需要，你还可以对转换得到的 PDF 进行 OCR，以便批注或搜索其中的文字。在完成这一步之后，我终于在《韬奋全集（第一卷）》第 739 页找到了 Rana Mitter 引用的邹韬奋的中文原文：

> 这样的做去，各人天生的聪明才力虽不平等，而各人的服务道德心发达，各就平等的出发点而尽量发展，以贡献于人群，也可算是平等了。这是真平等。

{{< imgcap title="邹韬奋在 1927 年所说的「什么是真平等？」" src="https://p15.p3.n0.cdn.getcloudapp.com/items/yAu9dkLL/1e709c4c-0d4b-4a23-bf16-61a1cf8e8ac3.png" >}}

## OFD

搞清楚 PDG 格式之后，我想起了之前有同学问过我的国产 PDF 格式——OFD，想顺便看看这又究竟是一种什么格式。根据 [IT 之家](https://www.ithome.com/0/521/264.htm) 的介绍，OFD 是 Open Fixed-layout Document 的简称，是一种所谓「版式文件」，对标的是 PDF，它最大的特点是中国自主研发、自主制定的版式文件格式标准。

众所周知，PDF 的最大特点是「保真性」，即文件外观不会因操作系统或软件类型发生改变。那么「相比 PDF 有一些技术上的优势的 OFD」是否也有这种特征呢？一探究竟的前提是获得一个 OFD 文件，而我实在是无法在本地生成这样一个文件，好在 GitHub 上有人上传了一个 [OFD 文件](https://github.com/Sakura726/ofdtest/blob/main/src/main/resources/%E7%99%BE%E6%9C%9B%E4%BA%91%E5%A2%9E%E5%80%BC%E7%A8%8E%E5%8F%91%E7%A5%A8.ofd)，于是我就用它测试了一番。

首先，将下载得到的 OFD 文件重命名为 `test.ofd`，在终端中输入 `file test.ofd`，得到如下结果：

```text
test.ofd: Zip archive data, at least v2.0 to extract, compression method=deflate
```

可以看到，这是一个压缩文件。作为对比，在终端中输入 `file test.pdf` 的输出结果如下：

```text
test.pdf: PDF document, version 1.4, 18 pages
```

既然确定 OFD 是压缩文件格式，自然就可以将其解压缩，使用如下命令：

```shell
unzip test.ofd -d unzip
```

将 `test.ofd` 解压缩到文件夹 `unzip` 中，其中包含以下内容：

```text
Archive:  test.ofd
  inflating: unzip/OFD.xml
  inflating: unzip/Doc_0/Document.xml
  inflating: unzip/Doc_0/DocumentRes.xml
  inflating: unzip/Doc_0/Annotations.xml
  inflating: unzip/Doc_0/Annotation.xml
  inflating: unzip/Doc_0/Attachs/Attachments.xml
  inflating: unzip/Doc_0/TPLS/TPL_0/Content.xml
  inflating: unzip/Doc_0/TPLS/TPL_1/Content.xml
  inflating: unzip/Doc_0/Pages/Page_0/Content.xml
  inflating: unzip/Doc_0/Pages/Page_1/Content.xml
  inflating: unzip/Doc_0/Pages/Page_2/Content.xml
  inflating: unzip/Doc_0/Pages/Page_3/Content.xml
  inflating: unzip/Doc_0/Pages/Page_4/Content.xml
  inflating: unzip/Doc_0/Res/image_0.png
  inflating: unzip/Doc_0/Attachs/original_invoice.xml
  inflating: unzip/Doc_0/Tags/CustomTags.xml
  inflating: unzip/Doc_0/Tags/Tag_e-invoice.xml
  inflating: unzip/Doc_0/Signs/Sign_0/Seal.esl
  inflating: unzip/Doc_0/Signs/Signatures.xml
  inflating: unzip/Doc_0/Signs/Sign_0/Signature.xml
  inflating: unzip/Doc_0/Signs/Sign_0/SignedValue.dat
```

可以发现，如 IT 之家的那篇文章所说，OFD 内部的确采用可扩展标记语言 XML 来描述数据和结构，但「体积精简，安全开放，易于扩展」就完全说不过去了。事实上，只要修改一下 XML 文件中的内容，然后再将文件夹 `unzip` 压缩回 OFD，就可以轻松实现文件内容的修改，何谈「精准呈现、安全有保障」？就算 OFD 采用了额外的加密算法来防止篡改，仅采用 XML 描述文件这一点就已经被 PDF 甩开几条街了，也难怪 [网友评论](https://zhuanlan.zhihu.com/p/150242512) 道「放着世界通用便捷的 PDF 不用，不知道为什么要搞这种小众格式，折腾」。

前几天，数字广东网络建设有限公司发布的「CEC-IDE 软件研发工具」引起了不少 [讨论](https://github.com/microsoft/vscode/issues/191229)，因为基于开源的 VS Code 开发了一个套壳软件 CEC-IDE，并宣称这是「国企品牌，自主研发」。而这已不是第一次类似的案例了，去年 10 月，国内有人将免费的 VS Code 放在网上 [销售](https://github.com/microsoft/vscode/issues/163798)，「领取 20 元优惠券即可以超低价 39.7 元购买 VS Code 代码编辑器官方中文版」，实在是让人无语至极。

以上这几个例子，只是软件开发领域所谓「自主研发」的冰山一角，如果从整个中国经济社会来看，这样的现象可能更加数不胜数。我不知作何评价，就用严复[^2] 的这段话来结尾吧：

> 中国之政，所以日形其绌，不足争存者，亦坐不本科学，而与**通理公例**违行故耳。是故以科学为艺，则西艺实西政之本。设谓艺非科学，则政艺二者，乃并出于科学，若左右手然，未闻左右之相为本末也。

[^2]: 严复. [严复集](https://book.douban.com/subject/2141017/). 中国近代人物文集丛书. 北京: 中华书局, 1986. p. 559.
