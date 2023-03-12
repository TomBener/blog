---
title: 如何在互联网上获取电子书
date: 2023-02-12T22:34:20+08:00
categories:
    - eBook
---

<h2>目录</h2>

- [已订阅数据库](#已订阅数据库)
- [Google Books](#google-books)
- [Internet Archive](#internet-archive)
- [Z-Library](#z-library)
  - [访问暗网](#访问暗网)
  - [Telegram Bot](#telegram-bot)
  - [登录专属域名](#登录专属域名)
  - [Book Searcher](#book-searcher)
- [超星/全国图书馆参考咨询联盟](#超星全国图书馆参考咨询联盟)
- [其他渠道](#其他渠道)

---
<br>

信息自由是每个人都应享有的基本权利，与个人发展密切相关，而人类社会的很多领域，都是由于信息封闭导致的不开放甚至寻租腐败。为什么今天人们可以相对容易地转行软件工程师？一个非常重要的原因就在于计算机领域 [知识的开放](https://t.me/bluebird_channel/705)，不过遗憾的是，这并不具备普遍性。尽管我们的社会应该尽可能降低知识获取的门槛，然而这面临着各种各样的阻碍，并不容易实现。

在学术论文领域，存在着各种各样的学术出版商，比如 [ScienceDirect](https://www.sciencedirect.com/)、[Springer](https://www.springer.com/)、[Taylor Francis](https://www.tandfonline.com)、[Wiley](https://www.wiley.com/)、[CNKI](https://www.cnki.net) 等，人类几乎所有的论文都可以在世界几大学术论文出版商处获得，尽管往往需要支付高得离谱的费用，不过好在我们有 [Sci-Hub](https://sci-hub.ru/)。因此，在一些学术论文互助群中，经常会有人抛出这样的问题「怎么会有下载不到的论文？」

与获取学术论文相比，下载书籍相对更加困难，因为书籍的来源多种多样，由于版权或存储介质的限制，很多书籍我们都无法搜索或下载。而人类几千年来累积的绝大多数知识都保存在书籍中，因此如何获取书籍的需求并不仅限于学术界，是一个几乎人人都可能会面临的问题。

在我不长的学术研究生涯中，面临着各种各样的困难，其中的困难之一就是无法获取到研究所需要的书籍，而大学图书馆往往只是一个「摆设」，完全满足不了我的需求，因为对我的研究非常重要的书籍往往印刷数量不多，很难获取。可是没有必需的资料，我的研究就无法开展，因此常常陷入「巧妇难为无米之炊」的困境。更加糟糕的是，在这方面几乎没有人帮助或指导我，或者旁人的经验并不适用，而我只能慢慢摸索，也因此拖慢了论文写作进度。在这个过程中，我总结了一些获取电子书的方法，希望对你有所帮助，能够通过这些方式找到你需要的书籍。正如 [Yibook](https://guide.yibook.org) 所说：收集前人经验，希望能帮助后人少走弯路。

## 已订阅数据库

一般来说，大学或研究机构图书馆会订阅数据库，其中有可能就包括获取书籍的方式。这种方式的好处是获取的书籍格式完善，当然最重要的是免费。不过由于不具有普遍性，这里就不展开说明了。

{{< imgcap title="通过机构 IP 登录 Springer 可以免费下载一些书籍" src="https://p15.p3.n0.cdn.getcloudapp.com/items/geuOL10w/3ca35bc9-bfb6-4b1c-bf9e-8500f871cb73.png" >}}

如果你所在的机构没有购买所需数据库，可以到公共图书馆去碰碰运气，例如 [浙江图书馆](https://www.zjlib.cn/)、[贵州图书馆](http://www.gzlib.org/)、[广西壮族自治区图书馆](http://www.gxlib.org.cn/) 等。

除了机构已订阅的数据库外，也可以考虑它们的馆藏书籍，尽管这并非本文所涉及的电子书，但可以通过借阅得到纸质书，如果有需要的话，也可以扫描成电子书。

## Google Books

[Google Books](https://books.google.com) 是 Google 提供的一项服务，可以搜索到大量的书籍，不过由于版权问题，很多书籍并不是完整的，只能预览部分内容。如果你不需要一本完整的书籍，并且需要的页面正好能够预览，可以将它们下载下来。

GitHub 上的一个开源项目 [JavaScript Google Books Preview Pages Downloader](https://github.com/mcdxn/google-books-preview-pages-downloader) 可以将 Google Books 上可预览的页面下载为图片。使用方法非常简单：

1. 在 Google Chrome 或其他基于 Chromium 内核的浏览器打开书籍的页面
2. 进入正在预览的书籍的起始页面，右键单击预览页面并选择「Inspect」打开 JavaScript 控制台
3. 将下面的代码粘贴进去之后，然后按下回车键：

    ```javascript
    var gbppd=function(){let e=document.getElementById("viewport"),t=null,n=[],o=[],l=document.getElementsByClassName("overflow-scrolling"),i=l[0].scrollHeight,r=0,c="",s=function(e,t){for(let t of e)if("childList"==t.type&&(o=t.target.getElementsByTagName("img")))for(let e of o)n.push(e.src)},a=function(){(r+=700)<i?l[0].scrollBy(0,700):clearInterval(c)};return{start:function(){(t=new MutationObserver(s)).observe(e,{attributes:!0,childList:!0,subtree:!0}),c=setInterval(a,500)},finish:function(){{let e=new Set(n),o=window.open(),l=0;for(let t of e)o.document.write('<a href="'+t+'" download="page-0'+l+'">'+t+"</a><br>"),l+=1;!function(e){!function t(n){n>=e.length||(e[n].href.match(/books.google./)&&e[n].click(),setTimeout(function(){t(n+1)},500))}(0)}(o.document.getElementsByTagName("a")),t&&(t.disconnect(),t=null)}}}}();
    ```

4. 粘贴 `gbppd.start()`，然后按下回车键，开始获取图片链接
5. 在需要停止的页面后，粘贴 `gbppd.finish()`，然后按下回车键

之后会在一个新标签页中打开一个页面，里面包含了所有获取到的图片链接，点击链接即可下载。

除此之外，也可以使用另一个类似的项目 [GoBooDo](https://github.com/vaibhavk97/GoBooDo)，它可以将 Google Books 上的书籍下载为 PDF 并对其进行 OCR，不过无法直接在浏览器中使用，需要安装 Python 环境。

## Internet Archive

[Internet Archive](https://archive.org/details/internetarchivebooks) 上有很多书籍的扫描版，少部分书籍可以免费下载。对于大部分无法直接下载的书籍，你可以免费借阅（Borrow）1 小时或 14 天，需要有一个 Internet Archive 账号。如果需要将借阅的书籍下载为 PDF 保存到本地，可以参考这个 [文字教程](https://www.reddit.com/r/Piracy/comments/l9exis/how_to_download_books_from_archive_org_and_how_to/) 或这个 [视频教程](https://www.youtube.com/watch?v=w21AoTx0ztk)。

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

### Book Searcher

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
