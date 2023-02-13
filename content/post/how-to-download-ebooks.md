---
title: 如何在互联网上获取电子书
date: 2023-02-12T22:34:20+08:00
categories:
    - eBook
---

信息自由是每个人都应享有的基本权利，与个人发展密切相关，而人类社会的很多领域，都是由于信息封闭导致的不开放甚至寻租腐败。为什么今天人们可以相对容易地转行软件工程师？一个非常重要的原因就在于计算机领域 [知识的开放](https://t.me/bluebird_channel/705)。不过遗憾的是，这并不具备普遍性，尽管我们的社会应该尽可能降低知识获取的门槛，然而这面临着各种各样的阻碍，并不容易实现。

在学术论文领域，存在着各种各样的学术出版商，比如 [ScienceDirect](https://www.sciencedirect.com/)、[Springer](https://www.springer.com/)、[Taylor Francis](https://www.tandfonline.com)、[Wiley](https://www.wiley.com/)、[CNKI](https://www.cnki.net) 等，人类几乎所有的论文都可以在世界几大学术论文出版商处获得，尽管往往需要支付高得离谱的费用，不过好在我们有 [Sci-Hub](https://sci-hub.ru/)。因此，在一些学术论文互助群中，会有人抛出这样的问题「怎么会有下载不到的论文？」

与获取学术论文相比，下载书籍相对更加困难，因为书籍的来源多种多样，由于版权或存储介质的限制，很多书籍我们都无法搜索或下载。而人类几千年来累积的绝大多数知识都保存在书籍中，因此如何获取书籍的需求并不仅限于学术界，是一个几乎人人都可能会面临的问题。

身处网络时代，与纸质书相比，电子书更加便于传播，成本也往往更低，成为很多人的首选。基于此，本文介绍在互联网上获取电子书的方法，希望你能通过这些方式找到你需要的书籍。

## 已订阅数据库

一般来说，大学或研究机构图书馆会订阅数据库，其中有可能就包括获取书籍的方式。这种方式的好处是获取的书籍格式完善，当然最重要的是免费。不过由于不具有普遍性，这里就不展开说明了。

{{< imgcap title="通过机构 IP 登录 Springer 可以免费下载一些书籍" src="https://p15.p3.n0.cdn.getcloudapp.com/items/geuOL10w/3ca35bc9-bfb6-4b1c-bf9e-8500f871cb73.png" >}}

如果你所在的机构没有购买所需数据库，可以到公共图书馆去碰碰运气，例如 [浙江图书馆](https://www.zjlib.cn/)、[贵州图书馆](http://www.gzlib.org/)、[广西壮族自治区图书馆](http://www.gxlib.org.cn/) 等。

## Z-Library

作为全世界最大的在线图书馆，Z-Library 可以下载的书籍是非常多的，我的个人图书馆中绝大多数书籍都来自于此，一些人甚至把 Z-Library 称之为自己的「[命根子](https://telegra.ph/%E7%9B%97%E7%89%88%E4%B8%8E%E9%9D%9E%E4%BA%BA%E6%80%A7%E5%8C%96%E7%9A%84%E7%94%9F%E6%B4%BB-11-04)」。在 [被美国政府封锁](https://www.washingtonpost.com/nation/2022/11/17/fbi-takeover-zlibrary-booktok-impacted/) 之前，可以直接访问，但现在已没有公开域名，不过还是有很多访问方式。

### 访问暗网

如果你有条件访问暗网，可以在这两个地址打开 Z-Library 的官网，需要登录：

- [TOR](http://loginzlib2vrak5zzpcocc3ouizykn6k5qecgj2tzlnab5wcbqhembyd.onion)
- [I2P](http://zlib24th6ptyb4ibzn3tj2cndqafs6rhm4ed4gruxztaaco35lka.b32.i2p)

### Telegram Bot

Telegram 官方机器人 [1lib](https://t.me/zlibrary2bot) 仍然可用。但为了避免未来被封禁，可以打开 <https://singlelogin.me> 登录后，按照官方教程创建一个你的专属机器人。尽管 Telegram Bot 很方便，但由于 Telegram API 的限制，无法下载超过 50MB 的书籍。

### 登录专属域名

同样的，打开 <https://singlelogin.me> 登录后，会看到你的专属域名。记得不要泄漏出去！

### Z-Library Searcher

在 Z-Library 被封禁期间，出现了一个基于 IPFS 的项目 Zlib Searcher，它是用 Rust 语言写的，本身并不存储书籍，只提供 Z-Library 上的书籍在 IPFS 网络中的链接，搜索速度极快。不过现在它为了规避潜在的法律风险，已改名为 [Book Searcher](https://github.com/book-searcher-org/book-searcher)，不再提供索引文件，好消息是还有一些此前基于该项目的实例可以使用：

- https://book-searcher.eu.org
- https://read.liugezhou.online
- https://x.zeuslib.com
- https://zbook.lol
- https://zebra.9farm.com
- https://zlib.awesc.com
- https://zlib.goojoe.top
- https://zlib.knat.network
- https://zlib.pseudoyu.com
- https://zlib.qtoh.xyz
- https://zlib.retompi.com (我的自建)
- https://zlibrary.shuziyimin.org
- https://zlibsearch.1kbtool.com

请不要在墙内公开传播这些实例，否则可能导致 `https://zlib.cydiar.com` 一样的后果——[因「不可抗力」而不再可用](https://twitter.com/Cydiar404/status/1622581797384224775)。除了直接在浏览器中访问外，还可以 [下载桌面客户端](https://github.com/tw93/Pake/releases/tag/V1.0.4-beta)（基于 <https://x.zeuslib.com> 的套壳应用）。

## 超星/全国图书馆参考咨询联盟

超星早年间承担了国内大学图书馆藏书数字化的工作，有一大批独家的 PDF 格式的扫描版电子书，Z-Library 上的中文书籍基本来自于这种渠道，淘宝上的「[找书服务](https://mp.weixin.qq.com/s/7SX-Oztgx2q76AN5YpntTA)」基本上也是基于超星的。

超星不直接对用户提供服务，但也有一些免费的 [超星接口](https://freembook.com/)，可以直接用书名搜索，也可以用 SS/DX 号搜索，得到的结果是秒传链接，按照网站的提示下载书籍即可。除此之外，还可以使用 Telegram 机器人 [秒传书库](https://t.me/mcbooksbot) 搜索书籍的秒存直链。

如果通过这些免费方式无法获取到你需要的书籍，可以试试付费的方式：

- [互助联盟](https://u.xueshu86.com/)：1 元/本
- [一元图书](https://1yuanbook.com/)：2 元/本

关于如何下载全国图书馆参考咨询联盟的书籍，也可以参考 [超星书籍简明下载流程](https://ssdown.org/blog/quick/)。

## 其他渠道

- [Anna’s Archive](https://annas-archive.org)
- [Library Genesis](https://libgen.is)
- [Z-Library 中文书](https://bk.hallowlib.org)
- [Project Gutenberg](https://www.gutenberg.org)
- [中国哲学书籍电子化计划](https://ctext.org/zh)
