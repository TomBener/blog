---
title: 换种方式刷朋友圈——微信朋友圈数据分析
date: 2023-01-13
categories:
  - WeChat
  - R
  - Python
---


{{< admonition title="🔖 Note" >}}
本文是少数派 [2022 年度征文活动] 的入围文章，你可以在 [少数派] 上阅读本文，也可以阅读使用 [Tufte][G9K] 样式排版的版本。

  [2022 年度征文活动]: https://sspai.com/post/77562
  [少数派]: https://sspai.com/post/77815
  [G9K]: https://up.retompi.com/wechat-moments-analysis/tufte
{{< /admonition >}}

<h2>目录</h2>

- [缘起](#缘起)
- [数据收集](#数据收集)
- [数据可视化](#数据可视化)
  - [使用 Python 制作词云图](#使用-python-制作词云图)
  - [加载 R 包和数据](#加载-r-包和数据)
  - [朋友圈可见时长](#朋友圈可见时长)
  - [朋友圈活跃人群](#朋友圈活跃人群)
  - [发朋友圈次数](#发朋友圈次数)
  - [发布的媒介类型](#发布的媒介类型)
  - [每天的发布次数](#每天的发布次数)
  - [一天中的时间分布](#一天中的时间分布)
  - [背景信息](#背景信息)
  - [属性](#属性)
  - [情绪](#情绪)
  - [图片数量](#图片数量)
  - [点赞数量](#点赞数量)
  - [评论数量](#评论数量)
- [结语](#结语)

## 缘起

互联网上有不少网友分享自己的朋友圈总结，例如 [豆瓣](https://www.douban.com/people/timtian/status/3878856217/)
上一位网友总结的自己的朋友圈，从下方的评论来看，非常真实而又十分精准：

> 朋友圈里半数是学术圈的人，凭印象总结发圈方式：院级以上领导一般不发消息，偶尔点赞；院级领导转发与本院或本学科有关资讯，以及中央文件和政策；教授转发自己撰写的书著、论文、评论或发言；副教授和讲师转发学科资讯，以及间接与时政有关的内容；媒体编辑和作家转发直接与时政有关的内容；学生发照片、饮食娱乐资讯，有时还发我们看不懂的牢骚。

2022 年 5 月 23
日晚上，我在洗澡的时候突然冒出一个「浴室沉思」：我的微信朋友圈中的主要内容是什么？大家都爱在什么时间段发朋友圈？主要发的是文字、图片还是链接？分享的内容透露出什么样的情绪？什么样的内容比较受欢迎？……

此前，我读了学术期刊 Journal of Contemporary China 上的
[一篇论文](https://www.tandfonline.com/doi/full/10.1080/10670564.2021.1985839)，标题为
*Censorship in the Semi-Private Domain: A Theory of Cross-Domain Variation and Evidence from WeChat*，作者通过自然实验的方法，研究了微信如何对半私域——微信公众号——进行审查。这种关注我们的日常经历的研究，让我非常感兴趣，同时也深受启发，因此我决定试一试，对自己的微信朋友圈做个简单的数据分析，看看会有什么有趣的发现。实际上，在进行分析之前，相信大多数人和我一样，心中已有一些推断，而通过定量的数据分析，则可以验证或推翻这些判断。

本来我的计划是在收集完朋友圈数据之后，用 [Python] 和 [R] 对它们做一些数据分析，主要是可视化一下，然后使用 [R Markdown] 的 [Tufte] [^78C] 样式生成 HTML 和 PDF
分享出来。然而，当我前几天打开该文件夹的时候，却发现 Git
仓库中半年前的修改内容还没有被提交（commit），只做了一部分，真是一个不折不扣的「烂尾工程」🤦。

[^78C]: Tufte 样式源于美国多栖科学家 [Edward Tufte](https://www.edwardtufte.com) 的手稿，它的特点是右侧有大片的空白，脚注、注释、参考文献等都放在右侧作为旁注，个人感觉非常优雅，你可以在 [这里](https://edwardtufte.github.io/tufte-css/) 预览 Tufte 的样式。

  [Python]: https://www.python.org/
  [R]: https://www.r-project.org/
  [R Markdown]: https://rmarkdown.rstudio.com/
  [Tufte]: https://github.com/rstudio/tufte

现在想来，大概是半年前的生活太过混乱，各种事情应接不暇，心态也很不稳定，搁置下来的任务后来就被遗忘了。而半年之后，表格中的个别联系人已经和我单向或双向屏蔽或删除，我们在基于微信构建的人际关系网络中失去了联系，不由让人感慨，成年人的世界就是这么悄无声息而又直击要害。

最近，我又需要做几个类似的数据分析，为了复用之前的代码，自然就翻出了这个项目。可是由于时间过去太过久远，而我当时主要「[面向 Stack Overflow 编程]」，现在几乎已经想不起来这些代码的含义，因此也就不知道如何修改它们。为了温习一下半年前的「遗迹」，也为了赶上少数派
2022 年度征文活动，我花了几天整理并回顾了这些代码，并加上了自己的解释和理解，写出了这篇文章，打算给半年前的这个「烂尾工程」收个尾，彻底与
2022 年挥手告别。之所以这样做，是因为一方面我可以在回顾的过程中，唤起曾经的久远记忆，另一方面，如果有童鞋需要使用
Python 和 R 进行简单的数据分析，也可以复用这些代码。除此之外，你还可以顺便看看我的微信朋友圈究竟是什么样的 🤪。

  [面向 Stack Overflow 编程]: https://www.zhihu.com/column/p/25294066

需要提醒的是，由于数据的可获取性，我只能总结自己的朋友圈，因此下面的结论可能不具有普遍性，本文的意义在于提供分析微信朋友圈的角度，希望可以抛砖引玉。另外，我也不打算为「微信研究」做出所谓的「理论贡献」，本文既不是学术论文，也不是调研报告，下面我所写的内容充满了主观色彩，在某些评价体系中，有可能全都是错的，各位读者权当一乐。

## 数据收集

根据我的观察，一条朋友圈在发布 24
小时后，几乎就不会再有互动，它的各项数据基本就稳定了下来，而由于微信朋友圈最短的时间是「三天可见」，发布后超过三天，相当一部分朋友圈就消失不见。因此，我当时采取的策略是每天收集两天之前的朋友圈，并对每一条朋友圈截图归档，前后一共持续了
16 天，最终收集了 69 位联系人 [^684] 的 245 条朋友圈信息。

在数据收集的过程中，由于我需要在手机上操作，不方便使用 Excel
表格，因此选择将原始数据保存在
[Notion](https://www.notion.so/) 数据库中，最后再将其导出为 CSV 文件。

[^684]: 「联系人」的叫法来自于主流 IM（Instant Messaging）的英文称呼 contacts，而不是中文语境下的「朋友」或「好友」。在我看来，微信里的大部分 contacts 都不足以被称之为 friends。

{{< imgcap title="保存在 Notion 中的原始数据" src="https://p15.p3.n0.cdn.getcloudapp.com/items/9Zuzo5Nx/08a10f0f-5bee-4cf2-927e-e434113bbc04.png" >}}

这些数据的格式可以参见下面这个 CSV
文件示例，应该可以从表头名称猜出各自的含义：

```text
name, relationship_with_me, time_of_visibility, published_time, day, hour, keywords, medium, number_of_images, context, property, emotional_level, number_of_likes, number_of_comments, last_edited_time
张大锤, 高中同学, 半年, "May 24, 2022 13:20", 2022-05-24, 13:20, 投票, "emoji, 图片, 文字", 2, 是, personal, positive, 13, 0, "June 15, 2022 04:47 PM"
王二云, 本科同学, 三天, "May 22, 2022 9:26", 2022-05-22, 09:26, 毕业答辩, "emoji, 文字, 标签, 链接", 0, 是, exclusive, neutral, 0, 0, "June 13, 2022 11:29 AM"
李小乐, 研究生同学, 一个月, "May 30, 2022 22:31", 2022-05-30, 22:00, 音乐, 音乐, 0, 否, exclusive, neutral, 0, 0, "June 15, 2022 10:28 PM"
```

存储数据的 CSV 文件一共有
15 列，其中的 12 列都是我手动输入的，最后的 `last_edited_time` 字段是 Notion
自动生成的，而 `day` 和 `hour` 则是用 Notion 函数根据
`published_time` 转换得到的：

```text
# Get the day
formatDate(prop("published_time"), "YYYY-MM-DD")

# Get the hour
formatDate(prop("published_time"), "HH:00")
```

虽然用 R 转换时间格式也是可以的，但使用 Notion
函数非常简单，这是一种「[重器轻用]」的方法，也是我在
2022 年折腾各类工具时，多次告诫自己的一条原则：[放弃纠结、拥抱妥协]，**不要执着于只用某一个工具完成某一项任务**，怎么方便快捷怎么来，完成任务最重要。

  [重器轻用]: https://sspai.com/prime/story/vol07-their-note-taking-methodology
  [放弃纠结、拥抱妥协]: https://sspai.com/post/71576

## 数据可视化

### 使用 Python 制作词云图

在我收集的数据中，其中一项是
`keywords`，这是我对每一条朋友圈的总结，一般是一个或多个短语，也可以看作是对它们打的
tag，一看见这些标签，我就可以想起对应的朋友圈的大致内容。为了视觉上直观地看看大家都在微信朋友圈中发些什么，首先用下面的
Python 代码对 `keywords` 字段制作一张词云图：

```python
# Import libraries
import pandas as pd
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# Load the data
df = pd.read_csv("moments.csv")
text = " ".join(key for key in df.keywords.astype(str))

# Create the wordcloud
wordcloud = WordCloud(font_path = "LXGWWenKai-Regular.ttf",
                      width = 3200,
                      height = 1600,
                      max_font_size = 200,
                      max_words = 400,
                      background_color = "#fffff8",
                      collocations = False
                      ).generate(text)

plt.figure(figsize = (20,10))
plt.imshow(wordcloud, interpolation = "bilinear")
plt.axis("off")
plt.tight_layout(pad = 0)

# Save the image
wordcloud.to_file("keywords.png")
```

其实 R 也是可以 [制作词云图] 的，但 Python 库 [WordCloud]
使用更广泛，似乎更好用，因此我就选择了它。为了运行这段代码，你需要搭建一个
Python 运行环境，并安装另外两个
Python 库 [pandas] 和 [Matplotlib]。除此之外，这里还用到了字体
[LXGW WenKai]（霞鹜文楷），需要单独安装，当然你也可以替换为系统中的其他字体。用于生成词云图的数据保存在
`moments.csv` 中，是从 Notion 中导出的。

  [制作词云图]: https://cran.r-project.org/web/packages/wordcloud/index.html
  [WordCloud]: https://github.com/amueller/word_cloud
  [pandas]: https://pandas.pydata.org
  [Matplotlib]: https://matplotlib.org/
  [LXGW WenKai]: https://github.com/lxgw/LxgwWenKai

由于我的朋友圈关键词涉及个人隐私，这里不便分享，因此以著名的《[兰亭集序](https://zh.wikipedia.org/zh-cn/蘭亭集序)》为例，展示一下生成的词云图：

{{< imgcap title="使用《兰亭集序》生成的词云图" src="https://p15.p3.n0.cdn.getcloudapp.com/items/mXub2KWY/620ee116-8377-4e38-a37b-3f3d3e6a9851.png" >}}

<details>
<summary>点击展开《兰亭集序》</summary>

```text
keywords
永和九年
岁在癸丑
暮春之初
会于
会稽山阴
之兰亭
修稧事也
群贤毕至
少长咸集
此地有
崇山峻岭
茂林修竹
又有
清流激湍
映带左右
引以为
流觞曲水
列坐其次
虽无
丝竹管弦
之盛
一觞一咏
亦足以
畅叙幽情
是日也
天朗气清
惠风和畅
仰观
宇宙之大
俯察
品类之盛
所以
游目骋怀
足以极
视听之娱
信可乐也
夫人之相与
俯仰一世
或取诸怀抱
悟言
一室之内
或因
寄所托
放浪形骸
之外
虽趣舍万殊
静躁不同
当其
欣于所遇
暂得于己
怏然自足
不知
老之将至
及其
所之既倦
情随事迁
感慨
系之矣
向之所欣
俯仰之间
已为陈迹
犹不能不
以之兴怀
况修短随化
终期于尽
古人云
死生
亦大矣
岂不痛哉
每揽
昔人兴感
之由
若合一契
未尝不
临文嗟悼
不能
喻之于怀
固知
一死生
为虚诞
齐彭殇
为妄作
后之视今
亦犹
今之视昔
悲夫
故列叙时人
录其所述
虽世殊事异
所以兴怀
其致一也
后之揽者
亦将
有感于斯文
```

</details>

### 加载 R 包和数据

在制作完词云图之后，Python 的任务就完成了，下面的数据可视化，就该轮到
R 登场了，这是因为我使用的是 R Markdown，并且在数据可视化方面，与
Python 相比，我相对更加熟悉 R。首先，我们需要做的是加载需要用到的
R 包和数据文件，这样后面就不再需要重复加载了：

```r
# `install.packages("package-name")`
# Using Python in R Markdown
library(reticulate)
use_python("~/.pyenv/shims/python")

# Import packages
library(tufte)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggrepel)
library(showtext)
font_add("lxgw", "LXGWWenKai-Regular.ttf")
showtext_auto()

# Load the data
data <- read.csv("moments.csv")
sepdata <- separate_rows(data, medium, sep = ",\\s")
```

请注意，运行后文所有的 R 代码片段都需要依赖上面这段代码，否则会报错，你可以将它们写在一个文件中，或者前往
[这里](https://gist.github.com/TomBener/c3ebeb2c4da66d2a9a146c6925fe077b) 下载完整的 R 代码文件。

由于所有的数据都保存在 CSV 文件 `moments.csv` 中，这里使用 R 内置的
`read.csv()` 函数来读取它并保存为 `data` 变量。如果有些
R 包没有安装，可以在终端中进入 R 环境，使用命令
`install.packages("package-name")` 来安装对应的包，例如使用命令
`install.packages("ggplot2")` 安装 [ggplot2]，当然，你也可以直接安装
[Tidyverse]—一个用于数据分析的 R
包集合，其中包括这里用到的大部分 R 包。除了在命令行中操作 R，你也可以安装
[RStudio] 进行可视化操作。

  [Tidyverse]: https://www.tidyverse.org
  [ggplot2]: https://ggplot2.tidyverse.org
  [RStudio]: https://posit.co/download/rstudio-desktop/

值得一提的是，为了在 R Markdown 中使用 Python，这里使用了 R 包
[reticulate]，因此需要在第 4 行中指定 Python 的路径，我使用的是
[pyenv] 安装的 Python 3.10.0，因此第 4 行是
`~/.pyenv/shims/python`。最后一行的作用是以逗号 `,`
和空格 `\s` 为分隔符，用 `separate_rows`
函数将一行内容拆分为多行，保存为 `sepdata`
变量，便于后续的分析，这是 [tidyr] 包提供的功能。而
`library(tufte)` 的作用是为了在 R Markdown
中使用 Tufte 样式，其中的 YAML 块的内容如下，供你参考：

  [reticulate]: https://github.com/rstudio/reticulate/
  [pyenv]: https://github.com/pyenv/pyenv
  [tidyr]: https://tidyr.tidyverse.org

```yaml
title: "An Analysis of the WeChat Moments"
subtitle: "An Implementation in R Markdown"
author: "Tom Ben"
date: "`r Sys.Date()`"
output:
  tufte::tufte_handout:
      latex_engine: xelatex
  tufte::tufte_html:
    tufte_features: ["fonts", "background"]
    pandoc_args: ["--shift-heading-level-by=-1", "--wrap=none"]
    # toc: true
    # tufte_variant: "envisioned"
mainfont: Palatino
monofont: JetBrainsMono-Regular
CJKmainfont: NotoSerifCJKsc-Regular
CJKmonofont: FangSong
# bibliography: bibliography.bib
# link-citations: yes
header-includes:
    - \usepackage{hyperref}
    - \hypersetup{colorlinks=true,
                  urlcolor=blue!80,
                  citecolor=red!80}
```

{{< imgcap title="使用 Tufte 样式排版的文章" src="https://p15.p3.n0.cdn.getcloudapp.com/items/xQuOOeDB/86b566ac-f7fd-4284-92cc-274a7f3aed3b.png" >}}

### 朋友圈可见时长

众所周知，微信用户可以对自己的朋友圈设置可见时长，其他人只能看见这个时间段内用户发布的朋友圈，具体来说，可以设置为：

- 三天可见
- 一个月可见
- 半年可见
- 无时限

那么我的微信联系人是怎么设置的呢？从下图可以看出，4
种类型的可见时长分布比较平均，印象中最多的「三天可见」果然占比最高，但与其它
3 类相比，差距并不是很大，而占比最低的则是「无时限」。占比最高和最低的可见时长，分别是最短的「三天」和最长的「无时限」，这与我的推测基本一致。

{{< imgcap title="朋友圈可见时长比例" src="https://p15.p3.n0.cdn.getcloudapp.com/items/GGuJKmxg/4daa07ca-f023-4934-83a8-48d19f4315c9.png" >}}

<details>
<summary>点击展开代码</summary>

```r
data0 <- distinct(data, name, time_of_visibility)

df <-
  data0 %>%
  count(time_of_visibility) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc))

df %>%
  ggplot(aes(x = "", y = n,
            fill = factor(time_of_visibility,
            levels = c("三天", "一个月", "半年", "无时限")))) +
  geom_col() +
  geom_label(aes(label = labels),
             position = position_stack(vjust = 0.5),
             size = 3,
             family = "lxgw",
             show.legend = FALSE) +
  coord_polar(theta = "y") +
  guides(fill = guide_legend(title = "朋友圈可见时长")) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>
<br>

[张小龙称](https://www.jiemian.com/article/2779633.html)「可能有两亿以上的用户朋友圈设置三天可见」，并称「我们鼓励用户去设置三天可见，希望这样子使得他更加勇敢的去发朋友圈」，可是这二者的因果关系是存在的吗？难道不是因为用户不太喜欢发朋友圈、不想让他人看见自己过去所发的内容，才设置为三天可见吗？而喜欢发朋友圈的人，往往会很大方地向他人展示自己的过往。不得不说，每天
[一亿人教张小龙做产品](https://www.huxiu.com/article/280552.html)
不是没有原因的。

尽管微信提供了 4
类设置朋友圈可见时长的选项，但我一个都没有使用，而采取了另外一种策略——手动删除发送后的每一条朋友圈。一方面，我可以通过这种方式「自定义」朋友圈可见时长，因为我可以在任意时间点进行删除（被微信屏蔽的朋友圈除外），另一方面，微信不提供朋友圈导出功能，而我不想把数据保存在它的平台上，在每次删除朋友圈前，我都会将其截图，相当于手动备份一下。当然，这种手动删除朋友圈的方式也有弊端，例如联系人无法进入我的朋友圈——因为它是空的，无法点击，甚至连一条空落落的横杠线都没有，不免让人产生一点距离感，可能也是因为这个原因，部分曾经的联系人把我删除了。

### 朋友圈活跃人群

从下图可以看出，发朋友圈最多、最活跃的人群是我的高中同学，其次是本科同学，加起来超过
80%。这大概是因为高中同学和本科同学本来就在所有联系人中占有很高的比例，其他人群如小学同学、老师、亲戚的数量不多，而研究生同学被我屏蔽了不少，或者对方把我屏蔽了，因此形成了这种「两极分化」的结果。很大程度上，微信朋友圈而不是微信的聊天功能，才是曾经的老同学的联系方式，甚至是唯一的方式。对我来说，没有互相加过微信的同学，往往更容易忘记对方的名字。

{{< imgcap title="朋友圈活跃人群" src="https://p15.p3.n0.cdn.getcloudapp.com/items/YEuDWgq6/8db28349-563e-417b-bedf-a961db703ad8.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <-
  data %>%
  count(relationship_with_me) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc)) %>%
  arrange(desc(relationship_with_me)) %>%
  mutate(text_y = cumsum(n) - n / 2)

df %>%
  ggplot(aes(x = "", y = n, fill = relationship_with_me)) +
  geom_col() +
  # reference: https://stackoverflow.com/a/69715619
  geom_label_repel(aes(label = labels, y = text_y),
                   force = 0.5,
                   nudge_x = 1,
                   nudge_y = 0.5,
                   size = 3,
                   show.legend = FALSE,
                   family = "lxgw") +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette = "Pastel1") +
  guides(fill = guide_legend(title = NULL)) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>

### 发朋友圈次数

在我统计的 16 天时间里，最多的联系人发了 17 条朋友圈，平均 1 天超过 1
条。在我的印象中，这两位同学本身就是「话唠」一样的性格，极富「表达欲」，几乎什么内容都往往朋友圈里发，甚至还要在底下加一大段自己的评论。对于这种行为，我认为无可非议，毕竟那是个人的自由，我们也不应该用自己狭隘的单一标准去评价别人：在习惯性作出一项价值判断时，**试着反思一下它背后的来源以及是否合理**。

尽管如此，朋友圈作为一个人际关系广场，还是应该考虑到其他受众的感受。因为朋友圈是
relationship-based 而不是 interest-based
的，所以如果你发的内容不是你的朋友们感兴趣的（而这几乎是必然的），而数量又很多的话，那么他们就会觉得你在「刷存在感」，或者在「立人设」，甚至其他各种乱七八糟的看法。也许正是基于这种顾虑，发 1
条朋友圈的联系人是最多的（当然没有发的联系人更多，但不在此次统计范围之内）。

{{< imgcap title="发朋友圈次数分布情况" src="https://p15.p3.n0.cdn.getcloudapp.com/items/WnuZDDjl/bd33cde8-3d61-4937-9d5b-dee29a914f8e.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <- data %>%
  group_by(name) %>%
  mutate(count_name_occurr = n())

ggplot(data = df,
       aes(y = reorder(name, count_name_occurr),
       fill = name)) +
  geom_bar() +
  scale_x_continuous(breaks = seq(0, 18, 1)) +
  theme_minimal() +
  labs(x = "发朋友圈次数", y = "隐藏的姓名") +
  theme(text = element_text(family = "lxgw"),
        axis.text.y = element_blank(),
        legend.position = "none")
```

</details>

### 发布的媒介类型

朋友圈可以发布文字、图片、链接等多种类型的的内容，我将它们分成了
7 类，一条朋友圈可以同时包括多种类型：

- **文字**
- **图片**
- **emoji**：包括系统自带的 emoji 和微信的 emoji
- **标签**：微信中可点击的链接，以 `#` 开头
- **链接**：包括以 `https://` 开头的文本式链接和微信生成的卡片式链接
- **音乐**：网易云音乐、QQ 音乐等国内音乐平台的链接
- **视频**：包括自己上传的不超过 30 秒的视频和转发的微信视频号中的视频

从下图可以看到，文字、图片和 emoji 是最多的，合计占到了 80%
以上。相比之下，标签、链接、音乐和视频占比就很低了，合计不到
20%。很大程度上，这是微信朋友圈产品设计的结果，因为文字和 emoji
是最容易使用的，标签相对较新，很多用户对此不熟悉。

而朋友圈的设计对图片是非常友好的，它的发布入口是一个相机图标，点击之后有「拍摄」和「从手机相册选择」两个选项，如果首次长按该图标发送文字，微信会提示「长按拍照按钮发文字，为内部体验功能。后续版本可能取消，也有可能保留，请勿过于依赖此方法」。而如果你点击「我
-> 朋友圈」之后，则会在顶部显示「拍一张图片，开始记录你的生活」。

{{< imgcap title="发布的媒介类型" src="https://p15.p3.n0.cdn.getcloudapp.com/items/llugdj1K/6558b388-3385-433a-b375-03df0cc4d189.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <-
  sepdata %>%
  count(medium) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc)) %>%
  arrange(desc(medium)) %>%
  mutate(text_y = cumsum(n) - n / 2)

df %>%
  ggplot(aes(x = "", y = n, fill = medium)) +
  geom_col() +
  geom_label_repel(aes(label = labels, y = text_y),
                   force = 0.5,
                   nudge_x = 0.8,
                   nudge_y = 0.5,
                   size = 3,
                   show.legend = FALSE,
                   family = "lxgw") +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette = "Pastel2") +
  guides(fill = guide_legend(title = NULL)) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>
<br>

众所周知，微信是一个对开放互联网极度不友好的平台，它的公众号不支持跳转外部链接，内容无法被搜索引擎索引，还会无故屏蔽所谓的「有害链接」，这无疑会极大降低用户分享外部链接的意愿，甚至会潜移默化地改变用户使用互联网的方式，而这导致的后果是非常糟糕的 [^177]，正如 [Yiqin Fu](https://twitter.com/yiqinfu/status/1578082198594367489) 所说：

[^177]: 极度悲观的后果是，一出生就开始接触微信的年轻人可能不再知道超链接是什么，这不是危言耸听，成长在智能手机时代的 Z 世代（Generation Z）已不知道 [文件管理](https://www.theverge.com/22684730/students-file-folder-directory-structure-education-gen-z) 是怎么回事。

> WeChat, by not allowing external links and not allowing content published on their platform to be indexed, did permanent damage to at least two generations of Chinese people.
>
> ---
>
> 微信不允许外部链接，不允许在其平台上发布的内容被索引，对至少两代中国人造成了永久性的伤害。

在我收集的数据中，链接所占的比例是
9.3%，排名第 4，但我没有统计该链接是微信内部链接（如微信公众号）还是外部链接，这有一点遗憾，不过印象中几乎都是微信内部链接。的确如 Yiqin Fu
所说，高度依赖微信的中国人似乎已经忘记了 [超链接](https://book.douban.com/subject/35438602/)，这已经并将长久地影响中国人的信息获取习惯 [^F6E]。顺便一提，在我看来，微信中的卡片式链接并不是真正的超链接，因为它可能会在后面添加冗长的链接追踪参数，这是用户无法控制的，此外，如果一篇微信公众号文章被屏蔽，则无法通过卡片式链接获取到这篇文章的 URL。

[^F6E]: 一位 [网友](https://jubeny.com/2022/08/the-minimum-limit-usage/) 说：「钟情于微信的人，在我看来缺少一种反抗和自由的精神」。对此我非常认同，而在我看来，超链接就是互联网的基本自由。

### 每天的发布次数

从 2022 年 5 月 22 日至 2022 年 6 月 6 日的 16 天时间里，发布朋友圈条数最多的一天是
6 月 1 日，达到了 26 条，也许因为这一天是一年一度的儿童节，很多同学都还不想长大，幻想着自己还是一个要过节的小孩子，所以想要发条朋友圈庆祝一下。而最少的一天则是
5 月 24 日，只有 9 条，大概是因为这一天是星期二，大家都在上课或上班，煎熬地度过「求死 Day」（Tuesday），而痛苦的日子大多是不适合发布在微信朋友圈中的。平均来看，每天大约发布 15.3 条。

{{< imgcap title="每天的发布次数，按发布次数排列" src="https://p15.p3.n0.cdn.getcloudapp.com/items/v1uEQjg2/7cecc7a1-5ecb-447a-b698-40e76db608f3.png" >}}

{{< imgcap title="按发布次数排列，按时间顺序排列" src="https://p15.p3.n0.cdn.getcloudapp.com/items/E0uRZKyv/8c68d651-ba06-4d03-8d3f-bf3486f58740.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <- data %>%
  group_by(day) %>%
  mutate(count_day_occurr = n())

ggplot(data = df,
       aes(y = reorder(day, count_day_occurr),
       fill = day)) +
  geom_bar() +
  scale_x_continuous(breaks = seq(0, 26, 4)) +
  theme_minimal() +
  labs(x = "每天的发布次数") +
  theme(text = element_text(family = "lxgw"),
        axis.title.y = element_blank(),
        legend.position = "none")

ggplot(data = df, aes(x = day,
                      y = count_day_occurr,
                      group = 1)
                      ) +
  geom_line(color = "blue") +
  geom_point() +
  scale_y_continuous(breaks = seq(0, 26, 4)) +
  theme_minimal() +
  labs(x = "每天的发布次数") +
  theme(text = element_text(family = "lxgw"),
        axis.title.y = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none")
```

</details>

### 一天中的时间分布

发布朋友圈最多的时间段是北京时间 21:00，其次是 17:00 和
22:00，总的来说，基本都集中于晚上的时间段。大概是因为这个时间段是大家下课、下班后的休息时间，不用上课和上班，所以才会有更多的时间来发朋友圈。而在晚上的时间段中，18:00–20:00
是相对低谷的时段，我猜是因为这个时间段大部分人都在吃晚饭吧。相比而言，发朋友圈最少的时间段是凌晨
01:00 到 06:00 之间，很明显这个时间段大家都在睡觉，即使是夜猫子，大概也会蛰伏在床上，享受独自快乐的时光。

{{< imgcap title="一天中的发朋友圈时间分布，按发布次数排列" src="https://p15.p3.n0.cdn.getcloudapp.com/items/WnuZDkDK/f1b54498-3398-4898-a3dc-6caaea14d7c9.png" >}}

{{< imgcap title="一天中发朋友圈的时间分布，按时间顺序排列" src="https://p15.p3.n0.cdn.getcloudapp.com/items/4gu4ePey/925b4520-3b99-45b1-8f93-1c6500e670c4.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <- data %>%
  group_by(hour) %>%
  mutate(count_hour_occurr = n())

ggplot(data = df,
       aes(y = reorder(hour, count_hour_occurr),
       fill = hour)) +
  geom_bar() +
  scale_x_continuous(breaks = seq(0, 26, 4)) +
  theme_minimal() +
  labs(x = "一天中的时间分布") +
  theme(text = element_text(family = "lxgw"),
        axis.title.y = element_blank(),
        legend.position = "none")

ggplot(data = df,
       aes(x = hour, y = count_hour_occurr,
       group = 1)) +
  geom_line(color = "blue") +
  geom_point() +
  scale_y_continuous(breaks = seq(0, 26, 4)) +
  theme_minimal() +
  labs(x = "一天中的时间分布") +
  theme(text = element_text(family = "lxgw"),
        axis.title.y = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none")
```

</details>

### 背景信息

背景信息这一项非常主观，判断标准是从我的角度来看，**是否了解这条朋友圈背后的一些信息**。例如，一条朋友圈称「我们的房租减免下来了，但是我们的补偿呢？」对于大部分人来说，看见这条信息都会一头雾水，往往就会直接略过，不再有进一步的互动。而如果一条朋友圈称「坐高铁
🚄，去看海 🌊，我的意思是一起 🍻」，配有几张和异性的合影，并且加上了定位，大概能猜出这是在「秀恩爱」，尽管观看者并不认识对方、去了哪里，但其中最关键的背景信息是具有普遍性的，这是一种长久以来形成的「网络社交共识」，如
[普世价值](https://en.wikipedia.org/wiki/Universal_value) 一样被绝大部分人所熟知和接受，因此是存在背景信息的。

从我的统计来看，将近 60%
的朋友圈没有背景信息。但是必须要承认，这是不可避免的，因为对我来说没有背景信息，对其他人来说则并非如此，而这就与接下来的「[属性](#属性)」密不可分。

{{< imgcap title="朋友圈是否具有背景信息" src="https://p15.p3.n0.cdn.getcloudapp.com/items/8Lug1DWx/442adb56-79f4-4e12-83d7-264323b9c3c7.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <-
  data %>%
  count(context) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc))

df %>%
  ggplot(aes(x = "", y = n, fill = context)) +
  geom_col() +
  geom_label(aes(label = labels),
             position = position_stack(vjust = 0.5),
             size = 3,
             family = "lxgw",
             show.legend = FALSE) +
  coord_polar(theta = "y") +
  guides(fill = guide_legend(title = "背景信息")) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>

### 属性

属性同样是一个非常主观的概念，它指的是**朋友圈内容涉及的对象是自己、特定人群还是公共议题**。比如发朋友圈称「自己脱单了、考研上岸了」对应的是自己（personal），「与室友去外面开心地聚餐、学术或工作相关内容、自己独特的兴趣爱好」对应的是特定人群（exclusive），而「为
[丰县铁链女] 发声、转发 [中共二十大] 相关消息」则对应着公共议题（public）。

  [丰县铁链女]: https://chinadigitaltimes.net/chinese/tag/丰县铁链女
  [中共二十大]: http://www.xinhuanet.com/politics/cpc20/index.htm

在我的统计中，53% 的朋友圈是关于自己的。这很容易理解，对不少人来说，微信朋友圈已经成为一个「人生大事发布平台」，比如宣布结婚、离婚、生小孩等消息。而按照我的标准，42%
的朋友圈涉及的内容是特定人群，往往让人看不懂，这些朋友圈往往也会高度缺乏背景信息，从我的观察来看，似乎也不太受欢迎
[^91A]。剩下与公共议题相关的只有 5%，比例很低，这大概与大部分中国人
[不关心](https://twitter.com/bb1cm/status/1576017739709566976) 公共问题、无力做出改变密切相关，当然也有日趋严酷的网络审查的原因。

[^91A]: 「受欢迎」的依据是点赞和评论的数量，但由于只能看见双方共同联系人的互动，因此据此作出判断并不十分可靠。

{{< imgcap title="朋友圈的属性" src="https://p15.p3.n0.cdn.getcloudapp.com/items/xQuOxqkj/4fe343d2-c8ba-4b93-8e85-d8c613d2054e.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <-
  data %>%
  count(property) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc))

df %>%
  ggplot(aes(x = "", y = n, fill = property)) +
  geom_col() +
  geom_label(aes(label = labels),
             position = position_stack(vjust = 0.5),
             size = 3,
             family = "lxgw",
             show.legend = FALSE) +
  coord_polar(theta = "y") +
  guides(fill = guide_legend(title = "属性")) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>

### 情绪

[人类的情绪] 捉摸不定，[如何描述情绪]
是一件极具挑战性的事情，在世界上很多语言中，甚至没有合适的词语来表达某些情绪，因此存在不少「无法翻译」的词语。尽管如此，为了简便，这里我只将情绪分成了正面（positive）、负面（negative）和中立（neutral）这三类。

  [人类的情绪]: https://www.newyorker.com/magazine/2022/08/08/how-universal-are-our-emotions
  [如何描述情绪]: https://pudding.cool/2022/12/emotion-wheel/

从下图可以看出，在所有的朋友圈中，正面和中立情绪几乎各占了一半，而负面情绪只有不到
3%。当然，这样的分类完全基于我的主观判断，不具有客观性。但可以肯定的是，负面情绪在朋友圈中是非常少见的，而这与我此前的推测一致，即在朋友圈中「积极的真实生活的记录」是受欢迎的，而带有负面情绪的内容在长期的选择过程中会被逐渐淘汰掉。

{{< imgcap title="朋友圈透露出的情绪" src="https://p15.p3.n0.cdn.getcloudapp.com/items/2Nu67zQ8/cb2d9669-c84f-435b-899c-be254928c76e.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <-
  data %>%
  count(emotional_level) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc))

df %>%
  ggplot(aes(x = "", y = n, fill = emotional_level)) +
  geom_col() +
  geom_label(aes(label = labels),
             position = position_stack(vjust = 0.5),
             size = 2.5,
             family = "lxgw",
             show.legend = FALSE) +
  coord_polar(theta = "y") +
  guides(fill = guide_legend(title = "情绪")) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>

### 图片数量

前文提到，微信朋友圈的产品设计对图片非常友好，鼓励用户分享图片。尽管如此，我的朋友圈中，最多的还是「没有图片」，占比超过
40%，而图片最多的「九宫格朋友圈」只占 10% 左右，可能是因为挑选 9
张图片比较费时费力，而生活中大多数事情不值得这样做。除此之外，1
张图片所占的比例也相对较高，超过 20%，这类朋友大概秉持着「少即是精」的原则。

{{< imgcap title="朋友圈中的图片数量分布" src="https://p15.p3.n0.cdn.getcloudapp.com/items/llugdkdO/92facc6e-7808-4949-a1d7-913a18921ee5.png" >}}

{{< imgcap title="朋友圈中的图片数量比例" src="https://p15.p3.n0.cdn.getcloudapp.com/items/d5uyn6nq/07a14b46-a464-481a-9d89-d4a4a52c4211.png?v=6872f066c8dcdec9f11c2c5a4f7ab231" >}}

<details>
<summary>点击展开代码</summary>

```r
df <- data %>%
  group_by(number_of_images) %>%
  mutate(count_image_occurr = n())

ggplot(data = df,
       aes(x = reorder(number_of_images,
                       -count_image_occurr),
       fill = factor(number_of_images))) +
  geom_bar() +
  scale_y_continuous(breaks = seq(0, 100, 10)) +
  theme_minimal() +
  labs(x = "图片数量") +
  theme(text = element_text(family = "lxgw"),
        axis.title.y = element_blank(),
        legend.position = "none")

df <-
  data %>%
  count(number_of_images) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc))

df %>%
  ggplot(aes(x = "", y = n,
            fill = factor(number_of_images))) +
  geom_col() +
  geom_label(aes(label = labels),
             position = position_stack(vjust = 0.5),
             size = 2.3,
             family = "lxgw",
             show.legend = FALSE) +
  coord_polar(theta = "y") +
  guides(fill = guide_legend(title = "图片数量")) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>

### 点赞数量

点赞（like）最早是由 Facebook（现已改名为 [Meta](https://about.meta.com)）发明的，被认为是 Facebook
最成功、最具标志性的功能。Facebook 的点赞功能在 2009 年推出，不久之后，Twitter、Instagram
以及中文互联网上的各种社交媒体纷纷抄袭了这个功能，如今点赞已遍布互联网的各个角落。开发这一功能的主要工程师 Justin Rosenstein
在接受 [The Guardian](https://www.theguardian.com/technology/2017/oct/05/smartphone-addiction-silicon-valley-dystopia) 采访时说：

> Facebook’s “like” feature was, Rosenstein says, “wildly” successful: engagement soared as people enjoyed the short-term boost they got from giving or receiving social affirmation, while Facebook harvested valuable data about the preferences of users that could be sold to advertisers.
>
> ---
>
> Rosenstein 说，Facebook 的「点赞」功能「非常」成功：随着人们享受从给予或接受社会肯定中获得的短期激励，参与度飙升，与此同时，Facebook 收集了关于用户偏好的宝贵数据，用来出售给广告商。

在一篇研究青年女性美颜的 [论文](https://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&dbname=CJFDLAST2021&filename=XWXZ202104008) 中，作者写道：

> 社交媒体平台上的点赞和评论都是公开可见和量化的，因此平台上的展演者可以根据反馈来调整自己的形象，而积极的受众反馈也会增强个体的自我呈现意愿…… 除了社交媒体平台的完美形象建构仪式，还会期待着「观众」给予的掌声和称赞。「理想我」的呈现也有一部分来自于「观众」的评价和反馈，以他人的评价和点赞作为反射自我形象的一面镜子。

由此可见，在今天的互联网上，点赞数量是衡量人们在社交媒体参与过程中的重要指标之一，比如青少年会因为 Instagram 的点赞而苦恼，而这严重危害了他们的 [心理健康](https://www.wsj.com/articles/facebook-knows-instagram-is-toxic-for-teen-girls-company-documents-show-11631620739)。同样作为社交媒体，微信朋友圈中的点赞自然也是如此。

从下图可以看出，在我的朋友圈中，将近 70% 是没有点赞的，而约
12% 的朋友圈有 1 个赞，点赞超过 1 个的朋友圈加起来不到
20%。之所以会有这样的结果，一个非常重要的原因是微信朋友圈是一个「半开放」的平台，只会显示双方共同联系人在朋友圈动态下的互动内容，因此，我所看见的其他人朋友圈下的点赞数量并不真实，仅能反映出我和他们共同联系人的点赞数量。

{{< imgcap title="点赞数量分布" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Qwujd2dO/a29fd7dd-614d-4805-a572-1a6a426cfa23.png" >}}

{{< imgcap title="点赞数量比例" src="https://p15.p3.n0.cdn.getcloudapp.com/items/E0uRZKR6/c57fe412-42cf-46dd-95e8-5786405b3bf0.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <- data %>%
  group_by(number_of_likes) %>%
  mutate(count_like_occurr = n())

ggplot(data = df,
       aes(x = reorder(number_of_likes,
                       -count_like_occurr),
       fill = factor(number_of_likes))) +
  geom_bar() +
  scale_y_continuous(breaks = seq(0, 170, 10)) +
  theme_minimal() +
  labs(x = "点赞数量") +
  theme(text = element_text(family = "lxgw"),
        axis.title.y = element_blank(),
        legend.position = "none")

df <-
  data %>%
  count(number_of_likes) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc)) %>%
  arrange(desc(number_of_likes)) %>%
  mutate(text_y = cumsum(n) - n / 2)

df %>%
  ggplot(aes(x = "", y = n,
             fill = factor(number_of_likes))) +
  geom_col() +
  geom_label_repel(aes(label = labels, y = text_y),
                   force = 0.5,
                   nudge_x = 1,
                   nudge_y = 0.5,
                   size = 3,
                   show.legend = FALSE,
                   family = "lxgw") +
  coord_polar(theta = "y") +
  guides(fill = guide_legend(title = "点赞数量")) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>
<br>

除此之外，与其他社交平台相比，微信朋友圈中的点赞成本更高——需要点击两下，首先点击右下角的两个点，然后再点击「赞」，并且没有像 Twitter
等平台那样明显的视觉反馈。尽管这是一个非常细微的交互设计差异，但它会显著降低用户点赞的意愿，导致很多人在朋友圈中「惜赞如金」，无形中抬高了点赞的门槛，逐渐形成一种「少点赞」的社交礼仪。

### 评论数量

评论可以衡量一条朋友圈的参与度，这是一个与点赞类似的指标，可以作为它的补充。从下图可以看出，评论数量的分布与点赞类似，但是更加集中，90% 左右的朋友圈没有评论，这同样是因为朋友圈的「半开放性」，只有微信联系人能直接观察到朋友圈都评论情况，并非全部的评论。

另一方面，由于我的朋友圈中的联系人现在的生活状况千差万别，不像高中或本科阶段，大家有着共同关心的问题或者类似的价值观，看见很多朋友圈，直接划过似乎是更好的选择，看到赞同或值得祝福的内容，顶多点个赞，而不太会选择评论。长此以往，曾经无话不谈的好朋友也可能渐渐沦为「点赞之交」。

{{< imgcap title="评论数量分布" src="https://p15.p3.n0.cdn.getcloudapp.com/items/yAuAQ0Ao/1ca05aee-9044-4c06-86f3-74709a0db06e.png" >}}

{{< imgcap title="评论数量比例" src="https://p15.p3.n0.cdn.getcloudapp.com/items/4gu4eP4y/85a30a11-81cc-4bbb-be69-08427790b692.png" >}}

<details>
<summary>点击展开代码</summary>

```r
df <- data %>%
  group_by(number_of_comments) %>%
  mutate(count_comment_occurr = n())

ggplot(data = df,
       aes(x = reorder(number_of_comments,
                       -count_comment_occurr),
       fill = factor(number_of_comments))) +
  geom_bar() +
  scale_y_continuous(breaks = seq(0, 220, 10)) +
  theme_minimal() +
  labs(x = "评论数量") +
  theme(text = element_text(family = "lxgw"),
        axis.title.y = element_blank(),
        legend.position = "none")

df <-
  data %>%
  count(number_of_comments) %>%
  mutate(perc = n / sum(n)) %>%
  mutate(labels = scales::percent(perc)) %>%
  arrange(desc(number_of_comments)) %>%
  mutate(text_y = cumsum(n) - n / 2)

df %>%
  ggplot(aes(x = "", y = n,
        fill = factor(number_of_comments))) +
  geom_col() +
  geom_label_repel(aes(label = labels, y = text_y),
                   force = 0.5,
                   nudge_x = 1,
                   nudge_y = 0.5,
                   size = 3,
                   show.legend = FALSE,
                   family = "lxgw") +
  coord_polar(theta = "y") +
  guides(fill = guide_legend(title = "评论数量")) +
  theme_void() +
  theme(text = element_text(family = "lxgw"))
```

</details>

## 结语

通过手动收集我的微信朋友圈数据，使用 Python 和 R
对它们进行简单的数据分析，本文可视化呈现了我的朋友圈的一些描述性特征。本来，我还打算做一个回归分析，探究一下朋友圈的背景信息、情绪、图片数量和点赞数量、评论数量的相关性，但感觉这样会显得很
nerdy，甚至可能会被认为在学术圈里「中毒不浅」，并且从文中可视化的描述性分析来看，似乎也没有必要这样做，毕竟我的目标不是指导你如何在朋友圈中获得更多的点赞或评论。

如果非要总结一下，什么样的朋友圈最受欢迎，或者如何评价我的朋友圈中的内容？**我认为这是语言无法说清楚的**，这呼应了哲学家维特根斯坦在《[逻辑哲学论]》中那句著名的话：

> What can be said at all can be said clearly; and what we cannot talk about we must pass over in silence.
>
> ---
>
> 凡是可以说的东西都可以说得清楚；对于不能谈论的东西必须保持沉默。

2022 年是微信朋友圈十周年，对此，[魏武挥]
总结道，「朋友圈属于最为洞悉人心/人性的产品，没有之一」。在我看来，其实这并非完全是朋友圈的产品设计结果，而是因为熟人社交本身就体现了「人性的复杂」，而朋友圈只是利用或放大了这些特征。互联网上有很多人都囿于朋友圈中复杂的「人性考验」，不得不选择「逃离微信」或者关闭朋友圈，其中就包括我自己。

然而现在我认为，这并非一个明智的选择，因为即使逃离了微信朋友圈，也还是会在生活中面临着其他类似的「人性难题」，如心理学家 [Alfred Adler]
所说，一切烦恼都来自于人际关系（All problems are interpersonal relationship
problems）。但与此同时，人类又是一种群居动物，我们永远有社交需求，因此我认为，面对微信朋友圈，最合适的方式也许是去观察并总结它，并以自己舒适的方式去适应它（当然「逃离」也算是一种适应）。如果你厌烦了每天几十次「[纯生理性]」地点开微信无意识地刷朋友圈，不妨像本文一样——换种方式刷朋友圈（毕竟文中已经提供了代码，你只需要收集数据），然后把它让你感到拧巴的地方总结一下并一一写下来。根据我的经验，很多时候往往不是朋友圈的问题，而是我们自己的问题。

微信朋友圈推出已经超过 10
年，与最初的阶段相比，它早已超越了字面上的意思——朋友的圈子，而演变成了中国人日常生活中的一个「综合性社交广场」。每日人物在《[朋友圈十年，也是我们的十年]》中写道：

> 十年过去，朋友圈早已超越了「社交」的定义，它变得像米饭、睡眠、空气一样自然，成为我们日常的一部分，许多人习惯在朋友圈分享自己的毕业、结婚、离职、成为父母的重要时刻。发布在朋友圈里的文字、相片、视频，就像人生橱窗，重新构筑了我们的十年。

我认为这段话并不十分准确，时至今日，微信朋友圈还是「社交」，并没有超越，也没有重新构筑，而是「偏离了初心」，从一张平面镜变成了哈哈镜，在这里，**我再也不能没有顾虑地向朋友们分享自己的日常生活**。这其中有很多原因：随着年龄的增长，心态发生了变化，不再有旺盛的表达欲；添加的联系人五花八门，担心谁看见或谁看不见，发言不再是一件
[低成本] 的事；从学校迈入社会，身份发生了转变，朋友圈中不再有知己，难以被他人理解，不如保持沉默等等。

不可否认，以上这些问题都是客观存在的，但本质上它们大都不是微信朋友圈的原因，而更多的是使用朋友圈的用户的人生境况发生了变化，从而导致了社交关系的变化甚至恶化，甚至出现「朋友伤了我的心」的情况，不得已而选择退出微信朋友圈，正如 2022 年普利策奖获得者
[Jennifer Senior] 在 The Atlantic 发表的文章所写的那样：*[It’s Your Friends Who Break Your Heart]*，她在文中写道：

> The unhappy truth of the matter is that it is normal for friendships to fade, even under the best of circumstances. The real aberration is *keeping* them.
>
> ---
>
> 令人感到不快的事实是，即使在最好的情况下，友谊的褪色也是正常的，而真正的不正常是试图挽留它们。

事实上，通过微信朋友圈等社交媒体来留住曾经的友谊，在某种程度上是一种违反客观规律的
[不健康行为]，也是一个几乎
[不可能实现的目标]。因为随着时间的流逝，我们每个人的朋友圈都在经历着「友谊褪色」的过程，而我在
2022 年的一大变化就是试着去认识并接纳它，尽管这会让人感到有一点
unhappy。
面对这样的困境，也许我们的确需要一种创新性的网络社交方式，来重塑自己的「朋友圈」。在我看来，这种社交模式下我们既可以
[connect with people]，又可以
[lose touch with people]，而它到底应该是什么样的呢？我也不知道，这大概需要一点 [想象力]。

  [逻辑哲学论]: https://book.douban.com/subject/1005354/
  [魏武挥]: http://weiwuhui.com/8618.html
  [Alfred Adler]: https://en.wikipedia.org/wiki/Alfred_Adler
  [纯生理性]: https://pca.st/0ETe#t=5383.0
  [朋友圈十年，也是我们的十年]: https://mp.weixin.qq.com/s/ujDfSBu3jaTlh_HWMLueHw
  [低成本]: https://geekplux.zhubai.love/posts/2171646849340497920
  [Jennifer Senior]: https://jennifersenior.net/bio
  [It’s Your Friends Who Break Your Heart]: https://www.theatlantic.com/magazine/archive/2022/03/why-we-lose-friends-aging-happiness/621305/
  [不健康行为]: https://world.hey.com/dhh/growing-apart-and-losing-touch-is-human-and-healthy-f0f962a8
  [不可能实现的目标]: https://www.wsj.com/articles/being-a-parent-is-lonelyheres-how-to-find-and-keep-friends-in-2022-11643465968
  [connect with people]: https://mebassett.info/human-attention-commodity
  [lose touch with people]: https://critter.blog/2021/09/16/lose-touch-with-people/
  [想象力]: https://www.youtube.com/watch?v=y6VPp_AekPw
