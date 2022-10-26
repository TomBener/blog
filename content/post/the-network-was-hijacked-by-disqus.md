---
title: 为什么我的博客外链会被重定向？
description: 尊重隐私，拒绝追踪
date: 2021-03-04T09:34:25+08:00
categories:
    - Privacy
---


## 出了什么问题？

3 月的第一天晚上，我更新完上一篇博客文章 [中英双语写作，输出指定语言](https://blog.retompi.com/post/input-bilingual-output-either-en-or-cn/) 后，饶有兴致地在 iPhone 上的 Safari 浏览器上进行阅读的过程中，意外发现文章中的外链会经过地址为 `redirect.viglink.com` 和 `cdn.viglink.com`，然后重定向到目标网址，其链接形如：

```
https://redirect.viglink.com/?format=go&jsonp=vglnk_161464852211413&key=cfdfcf52dffd0a702a61bad27507376d&libId=klrc0l970103ci3q000MAgzia7d3b&subId=6626339&loc=https%3A%2F%2Fblog.retompi.com%2Fpost%2Finput-bilingual-output-either-en-or-cn%2F%23%25e6%2580%25bb%25e7%25bb%2593&v=1&out=https%3A%2F%2Fsspai.com%2Fpost%2F64842&ref=https%3A%2F%2Fblog.retompi.com%2F&title=中英双语写作，输出指定语言&txt=写作流程
```

Safari 地址栏的重定向过程不仅肉眼可见，通过网络代理工具 [Quantumult X](https://apps.apple.com/app/quantumult-x/id1443988620) 的日志，也证实了我的网络确实经过了 `viglink.com`。然而令人费解的是，这个重定向问题只在 iPhone 上存在，iPad 和 Mac 上都不存在[^fn]。

[^fn]: Mac 上的网络规则更完善，广告链接 `viglink` 会被拦截，除此之外，我安装了 [AdGuard](https://adguard.com)，也可能会阻止重定向的广告链接。但 iPad 上就很迷惑。

{{< imgcap title="Quantumult X 中的网络日志" src="https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/iphone-safari-viglink-log.png" >}}

在浏览器地址栏中输入 [viglink.com](https://viglink.com)，发现这是一家广告推广公司。我费尽心思屏蔽各种广告，而自己的博客被插入广告，这怎么能忍呢？必须干掉它！

## 尝试解决

**我尝试了以下方式来排查可能的问题：**

### 1. 博客源码出现问题？

这是我的第一反应，猜测可能是博客源码在我不知情的情况下，被嵌入了广告（比如使用的主题）。于是打开博客源码，搜索关键词 `viglink`，然而，并没有任何相关内容。

### 2. 代理工具引用了远程恶意代码？

由于我的 Quantumult X 引用了一大堆远程订阅链接，用于分流、重写和定时任务，不排除脚本作者为了赚点咖啡钱，在其中插入广告链接的可能性。

{{< imgcap title="Quantumult X 中的重写资源列表" src="https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/quantumultx-rewrite-list.png" >}}

然而经过我点击一条又一条链接查看，也没有发现任何端倪，看来是我错怪了各位「为爱发电」的大佬 🙈️。

### 3. Safari 浏览器的设置问题？

我在苹果讨论社区搜索到一个类似的 [问题](https://discussions.apple.com/thread/251777815)，按照唯一一个回复的解决方案试了一下，没有作用。然后给苹果客服打电话，在客服的建议下，又重复进行了一次操作 ——「清除历史记录与网站数据」，并开启 Safari 浏览器的「阻止跨网站跟踪」和「阻止所有 Cookie」，依然没有用。

{{< imgcap title="开启 Safari 浏览器的「阻止跨网站追踪」" src="https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/iphone-safari-block-tracking.jpg" >}}

除此之外，我也在苹果客服的建议下删除了 Quantumult X 的描述文件，尽管删除之后确实解决了链接重定向的问题，但描述文件是必须要安装的，删除它并不能从根本上解决问题。

## 都是 Disqus 的锅

在派友 [\@Brick 713](https://sspai.com/u/Brick713) 的提示下，我使用的评论系统 [Disqus](https://disqus.com) 会把数据 [卖给 Viglink](https://disqus.com/data-sharing-settings/)。于是前往 Disqus 后台看看有没有相关设置，意料之中果然有一个：Disqus 默认会在文章链接中加入推广链接。

{{< imgcap title="Disqus 默认会在文章链接中加入推广链接" src="https://cdn.jsdelivr.net/gh/TomBener/image-hosting/images/disqus-ads-settings.png" >}}

没想到啊，Disqus 你这个浓眉大眼的家伙，竟然干这种事。果断关闭上图中的这个选项，果然就不再有重定向了。Disqus 作为一款流行的评论系统，通过广告赚点收入无可非议，不过好在提供选项关闭一部分广告。

经过这一番折腾，我再一次体会到「使用免费的产品，你就是商品本身」。当下的互联网已不再是万维网之父 [Tim Berners-Lee](https://en.wikipedia.org/wiki/Tim_Berners-Lee) 设计的那个乌托邦式的理想世界，处处充斥着广告与追踪，用户数据成为互联网公司盈利的重要来源，我想这也是 Tim Berners-Lee 对互联网的现状 [感到失望](https://ipfs.io/ipfs/QmW2hRwYU7QPY37yAUACUuwtXiaKujXi3SvctZQL1iuT49) 而开发 [Solid](https://inrupt.com/solid/) 的原因。在互联网数据获取与共享方式没有发生根本性变革之前，作为用户，我们能做的，就是尽量 [保护好自己的隐私](https://sspai.com/post/65277)。特别地，对于中国大陆用户而言，应该尽量避免使用微信，因为除了广告之外，还有高压之下的 [审查与监控](https://github.com/TomBener/stay-away-from-wechat)。
