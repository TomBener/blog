---
title: 写 Lua Filter——自己提出问题并解决它
date: 2022-11-18
categories:
    - Pandoc
---


昨晚我意识到两件关于**写作自由**的事：

1. 内容上，我在自己的博客上写文章，几乎没有什么限制。我想写什么就写什么，我想写多长就写多长，没有其他人指指点点，不用考虑是否结构合理、内容是否有深度、引用是否恰当等等。即使有其他人提出意见，我也可以考虑接受与否，当然，对于我的即兴创作，我大概率不会接受任何意见。
2. 形式上，用 Markdown 写作，我几乎可以在任何地方换行，写到兴奋之处，敲一下回车换行，写到文思枯竭之处，再敲一下回车换行。对于英文写作来说，这是非常自然的，因为英文单词之间总是存在空格，而 Markdown 中单个换行会被转换为一个空格。如果是中文，则可以加上 Pandoc 专门针对东亚文字的 [扩展](https://pandoc.org/MANUAL.html#extension-east_asian_line_breaks) `east_asian_line_breaks`。

今天下午，在充满斗志写论文的时候，我发现随意换行会有一个问题：如果 HTML 注释内容与上一行之间没有空行，并且单独成行，那么这个位置会存在两个空格。文字表达起来有点费劲，请看下面的 Markdown 示例：

```markdown
The first line,
and some texts here
<!-- need more references here -->
One more line
```

这 4 行文字看起来似乎「人畜无害」，看不出有啥问题，但这只是表面现象。将上面 4 行文字拷贝到剪切板，然后执行下面的命令：

```shell
pbpaste | pandoc -t native
```

这行命令将 Markdown 转换成 Pandoc 的 Abstract Syntax Tree (AST)，这样就很容易看出端倪：

```text {hl_lines=["15-18"]}
[ Para
    [ Str "The"
    , Space
    , Str "first"
    , Space
    , Str "line,"
    , SoftBreak
    , Str "and"
    , Space
    , Str "some"
    , Space
    , Str "texts"
    , Space
    , Str "here"
    , SoftBreak
    , RawInline
        (Format "html") "<!-- need more references here -->"
    , SoftBreak
    , Str "One"
    , Space
    , Str "more"
    , Space
    , Str "line"
    ]
]
```

逐行阅读输出结果，可以发现问题出在第 15-18 行，因为 `RawInline` 的内容前后各有一个 `SoftBreak`，而一个 `SoftBreak` 对应一个空格，在输出为其他文件格式时，HTML 的注释默认会被隐藏，因此这里会出现连续两个空格。

连续两个空格，破坏了我的写作自由，当然不能容忍，必须刻不容缓地解决！于是，我把写论文的任务放在了一边，迫不及待地着手解决 [^8D0]。首先，我在 [Pandoc 手册](https://pandoc.org/MANUAL.html) 中搜索了一番相关内容，为什么要这样做？因为如 [谢益辉](https://yihui.org/en/2018/09/target-blank/) 所说：

[^8D0]: 因此今天论文没写几个字 😅。

> You won't really appreciate how powerful Pandoc's Markdown is until you read the full manual once.

根据我以往的经验，的确如此，Pandoc 总是会带给我惊喜。当然，这次也不例外，我在手册中发现了一个 `--strip-comments` 的 [选项](https://pandoc.org/MANUAL.html#general-writer-options)，它的作用如下：

> Strip out HTML comments in the Markdown or Textile source, rather than passing them on to Markdown, Textile or HTML output as raw HTML. This does not apply to HTML comments inside raw HTML blocks when the `markdown_in_html_blocks` extension is not set.

看这个解释，感觉满足了我的需求，那就试试吧：

```shell
pbpaste | pandoc --strip-comments -t native
```

得到 diff 后的结果：

```diff
[ Para
    [ Str "The"
    , Space
    , Str "first"
    , Space
    , Str "line,"
    , SoftBreak
    , Str "and"
    , Space
    , Str "some"
    , Space
    , Str "texts"
    , Space
    , Str "here"
    , SoftBreak
    , RawInline (Format "html") ""
-       (Format "html") "<!-- need more references here -->"
    , SoftBreak
    , Str "One"
    , Space
    , Str "more"
    , Space
    , Str "line"
    ]
]
```

如它的解释所说，`--strip-comments` 真的把 HTML 注释删除了，但不幸的是，其后的 `SoftBreak` 依然保留了下来，还是会有连续两个空格。

遗憾的是，`--strip-comments` 并没有解决我的问题。于是，我在 Pandoc 的 GitHub 仓库提了一个 [issue](https://github.com/jgm/pandoc/issues/8443)，希望能够改进一下。虽然 Pandoc 作者 John MacFarlane 很快回复了我，但他只说了用 Lua filter。一开始看见这个消息，我是有点失望的，一方面我寄希望于 Pandoc 的改进，另一方面，我不会写 Lua filter 啊，尽管我很早以前就想学了 😂。

我回复说希望他能帮我写一下，但与此同时也搜索了一下 [Lua filter](https://pandoc.org/lua-filters.html) 的手册。幸运的是，在 [一个例子](https://pandoc.org/lua-filters.html#remove-spaces-before-citations) 的启发下，试了几次，真让我写出来了。不得不说，我在「依葫芦画瓢」这方面还是很有天赋的哈哈哈：

```lua
-- Strip out the softbreak after the html comment

local function strip_html_comments_softbreak(ril, sbk)
  return ril and ril.t == 'RawInline'
      and sbk and sbk.t == 'SoftBreak'
end

function Inlines(inlines)
  for i = #inlines - 1, 1, -1 do
    if strip_html_comments_softbreak(inlines[i], inlines[i + 1]) then
      inlines:remove(i + 1) -- Remove softbreak
      -- inlines:remove(i) -- Remove html comment
    end
  end
  return inlines
end
```

在当前文件夹中把它保存为 `stripbreak.lua`，执行下面的命令：

```shell
pbpaste | pandoc -L stripbreak.lua -t native
```

得到 diff 后的结果：

```diff
[ Para
    [ Str "The"
    , Space
    , Str "first"
    , Space
    , Str "line,"
    , SoftBreak
    , Str "and"
    , Space
    , Str "some"
    , Space
    , Str "texts"
    , Space
    , Str "here"
    , SoftBreak
    , RawInline
        (Format "html") "<!-- need more references here -->"
-   , SoftBreak
    , Str "One"
    , Space
    , Str "more"
    , Space
    , Str "line"
    ]
]
```

第 18 行的 `SoftBreak` 被顺利移除了，因此也就解决了连续两个空格的问题。当然，你也可以将上面 Lua 脚本中第 12 行取消注释，以完全移除 HTML 注释内容，虽然这对于导出为其他文件格式没有什么影响。

在 Markdown 中插入 HTML 注释，然后导出为其他格式时，不希望出现连续两个空格，感觉应该没有几个人会有我这样的需求，甚至有点自己给自己找麻烦的感觉 🤪，因此我把它叫做「自己提出问题」[^828]。为什么我要坚持这么写而不改变注释方式？因为 [你应该试试一句话换一行](https://sspai.com/post/73957)。

[^828]: 当然还是要感谢 Pandoc 的作者 John MacFarlane。

Lua filter 本身就比较小众，我的这个需求就更小众了，但幸运的是，我最终解决了它，因此把它分享出来，希望对互联网上的有缘人有所帮助。考虑到 Lua filter 的 [优势](https://pandoc.org/lua-filters.html#introduction)，后面我可能会用 Lua filter 替换之前使用的 Shell，希望有时间来完成。
