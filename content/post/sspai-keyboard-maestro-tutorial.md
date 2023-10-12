---
title: 完全上手顶级 Mac 自动化工具，用 Keyboard Maestro 拯救效率
date: 2023-10-12
categories:
    - Keyboard Maestro
---

{{< admonition title="🔖 Note" >}}
本文节选自我在少数派上撰写的付费栏目《[生产力超频：Keyboard Maestro 拯救效率](https://sspai.com/series/350)》，如果你感兴趣，欢迎前往购买，感谢支持。
{{< /admonition >}}

<h2>目录</h2>

- [Keyboard Maestro 入门引导](#keyboard-maestro-入门引导)
  - [Keyboard Maestro 历史](#keyboard-maestro-历史)
  - [从 Unix 哲学角度看 Keyboard Maestro](#从-unix-哲学角度看-keyboard-maestro)
    - [让程序只做好一件事](#让程序只做好一件事)
    - [让程序能够互相协同工作](#让程序能够互相协同工作)
    - [所有程序都是数据的过滤器](#所有程序都是数据的过滤器)
    - [使用 Shell 脚本来提高效率和可移植性](#使用-shell-脚本来提高效率和可移植性)
    - [充分挖掘软件的潜能](#充分挖掘软件的潜能)
  - [安装 Keyboard Maestro](#安装-keyboard-maestro)
  - [赋予 Keyboard Maestro 权限](#赋予-keyboard-maestro-权限)
  - [创建 macro](#创建-macro)
  - [软件基本设置](#软件基本设置)
  - [导出、导入和同步 macros](#导出导入和同步-macros)
- [文件管理](#文件管理)
  - [文件重命名](#文件重命名)
    - [用自带 macro 批量重命名文件](#用自带-macro-批量重命名文件)
    - [执行 Shell 脚本重命名文件](#执行-shell-脚本重命名文件)
    - [文件名 Slugify 化](#文件名-slugify-化)
  - [标签管理](#标签管理)
  - [压缩文件夹](#压缩文件夹)
  - [在 VS Code 中打开文件夹](#在-vs-code-中打开文件夹)
  - [下载文件](#下载文件)
    - [下载 GitHub 仓库单个文件](#下载-github-仓库单个文件)
    - [批量下载文件](#批量下载文件)
  - [自动处理文件](#自动处理文件)
    - [自动打开或移动文件](#自动打开或移动文件)
    - [定时处理文件](#定时处理文件)
- [小结](#小结)

---

## Keyboard Maestro 入门引导

如果你是一名 Mac 用户，可能或多或少都听说过 Keyboard Maestro。一方面，有人惊呼 Keyboard Maestro 为神器，对它赞不绝口，称赞它能极大地提高个人效率，甚至将其誉为 macOS 上的终极生产力工具（The Ultimate Productivity Tool for Mac），更有网友表示，这款软件「[改变了他们的生活](https://forum.keyboardmaestro.com/t/keyboard-maestro-9-free-trial-period/15102/11)」。然而另一方面，也有不少人抱怨 Keyboard Maestro 太过复杂，面对繁杂的页面不知如何下手，自己动手制作 macro 门槛似乎有点高，或者 macro 老是运行不成功等等。

无论你此前使用过 Keyboard Maestro，相信通过阅读这篇文章，都会帮助你初步了解这款功能强大的自动化软件，助力工作和学习效率的提升。

### Keyboard Maestro 历史

Keyboard Maestro 最初由 [Michael Kamprath](https://wiki.keyboardmaestro.com/manual/Administrative_Details) 开发，于 2002 年发布 1.0 版本。后来由于 Michael Kamprath 个人精力有限，无法继续开发，这款软件在 2004 年被 Stairways Software 收购并发布 2.0 版本，一直持续更新至今。

{{< imgcap title="Keyboard Maestro 2.0 的界面" src="https://p15.p3.n0.cdn.getcloudapp.com/items/WnupBxd9/c03a0b11-6744-4b61-badd-34603ab20a42.png" >}}

{{< imgcap title="Keyboard Maestro 10.2 的界面" src="https://p15.p3.n0.cdn.getcloudapp.com/items/llu89NzY/e66c1f56-64d9-429f-8d12-8fa7634bfb12.png" >}}

截至 2023 年 9 月，Keyboard Maestro 最新版本为 10.2。从 2.0 和 10.2 版本的截图可以看出，Keyboard Maestro 的操作逻辑始终是一样的，即以 macro 为核心，而 macro 则由 trigger 和 action 组成，同时 macro 又包含在特定的 macro group 中：

- **Macro Group**: 用于组织 macro，类似于文件夹，不同的 group 可以设置不同的规则，位于上方截图的最左列。
- **Macro**: 用于自动化 Mac 上的工作流程、程序或进程，位于上方截图的中间列。
- **Trigger**: macro 的触发方式，即满足某种条件的情况下，一个 macro 会被执行，一个 macro 可以有多个 trigger。例如上方截图最右列中的 trigger 是「The clipboard filter menu item is selected」。
- **Action**: macro 要执行的特定过程的步骤，一个 macro 可以包含一个或多个 action。例如上方截图中的 action 是「Filter Trigger Clipboard with Capitalize」。此外，还可以点击每个 action 右上角的齿轮 ⚙️ 来进一步调整 action 设置，例如禁用 action、设置 action 的颜色、拷贝为图片等。

{{< imgcap title="通过点击齿轮图标查看 action 的更多设置" src="https://p15.p3.n0.cdn.getcloudapp.com/items/04udJ2rJ/487f595f-5ae4-4d68-88da-21e12657fca5.png" >}}

### 从 Unix 哲学角度看 Keyboard Maestro

Stairways Software 官网 [About](https://www.stairways.com/main/about) 页面有这样一句话介绍创始人 Peter N Lewis 的理念：

> Peter’s goal was to bring high quality Internet and Unix tools to the Mac, combining the traditional Mac ease-of-use with the power of the Internet and Unix.
> Peter 的目标是将高质量的互联网和 Unix 工具带给 Mac 用户，同时结合 Mac 的易用性与互联网和 Unix 的强大功能。

而在我看来，Keyboard Maestro 这款软件的设计理念确实恰到好处地体现了 [Unix 哲学](https://en.wikipedia.org/wiki/Unix_philosophy)。

#### 让程序只做好一件事

Unix 哲学强调软件设计的简洁、模块化和可复用性，而 Keyboard Maestro 正是遵循这些原则的典范之一。尽管这款自动化工具具有广泛的应用场景，但每一个 trigger 或 action 都专注于做好一件事，实现的功能非常明确而简单，丝毫不会越位。因此，Keyboard Maestro 完全达到了 Unix 哲学中「做好一件事」的标准，为 Mac 用户提供了高效、可靠的自动化解决方案。

比如下图中激活 Safari 的这个 macro，trigger 是快捷键是 `⌃ + ⌥ + ⌘ + S`，action 是「Activate Safari」。快捷键简单直观，完全可以自定义，而激活特定的应用程序的 action 正好也有，拿来即用。

{{< imgcap title="通过快捷键激活 Safari" src="https://p15.p3.n0.cdn.getcloudapp.com/items/kpuR7D7n/3f9e7f31-9b29-4442-aefe-23345ce68fe5.png" >}}

#### 让程序能够互相协同工作

Keyboard Maestro 中每个 trigger 或 action 的功能都非常简单，只做好了一件事，同时它也提供了数量众多、功能丰富的 triggers 和 actions，正所谓合作的力量是无穷的，将它们（尤其是 actions）结合起来，就可以实现非常实用的功能。

例如，当 Mac 从休眠状态恢复后，用于调节外接显示器亮度的软件 [Lunar](https://lunar.fyi/) 有时可能无法正常工作，为了解决这个问题，我制作了下图中的这个 macro，实现了在 Mac 从休眠状态恢复后自动重启 Lunar。尽管 Keyboard Maestro 没有直接提供「重启应用」这个功能，但我们可以将重启过程分解成两个步骤：先退出应用，然后重新启动应用。通过这种方式，我们便可以轻松实现所需功能。而这个 macro 中的第二步「Pause Until Conditions are Met」则是实现「让程序能够相互协同工作」的关键。在 Keyboard Maestro 中，这样的细节还有很多，确保了其在自动化领域具有足够的可靠性。

{{< imgcap title="在 Mac 停止休眠后重启 Lunar" src="https://p15.p3.n0.cdn.getcloudapp.com/items/o0uKEeEL/1b6fb884-8e80-43e2-90e9-55e87013e9e6.png" >}}

#### 所有程序都是数据的过滤器

作为过滤器（filter）的应用程序意味着该程序专注于接收输入数据，对其进行某种处理，然后生成输出数据。在 Keyboard Maestro 中，最为典型的就是「[Filters](https://wiki.keyboardmaestro.com/manual/Filters)」这个 action，它不仅可以过滤剪贴板、还能过滤文本、变量、图片、文件等，内置的过滤方式也是多种多样，比如首字母大写、移除空格、计算字符数量等。比如下图中的这个 macro，就可以计算出剪贴板中的字数。

{{< imgcap title="使用 Keyboard Maestro 计算剪贴板中的字数" src="https://p15.p3.n0.cdn.getcloudapp.com/items/YEuzXZX5/7572371e-c7d3-4975-8846-9c69e068b5d2.png" >}}

#### 使用 Shell 脚本来提高效率和可移植性

Shell 脚本是一种在 Unix 或类 Unix 操作系统中广泛使用的脚本语言，具有高效、灵活的特点，是用户与操作系统交互的一种重要方式。macOS 自带了很多常用的 Shell 命令，无需用户额外安装。Keyboard Maestro 的优势在于提供了快捷方式来执行 Shell 脚本，让用户不必打开打开终端（Terminal.app）即可通过快捷键等方式轻松完成脚本执行的操作。此外，我们还可以将其他 action 与 Shell 脚本结合起来，实现在终端中难以完成的复杂功能。

在下图的例子中，通过执行 Shell 脚本 `perl -pe 'tr/A-Z/a-z/'`，将剪贴板中的大写字母转换为小写字母，并保存到剪贴板中。

{{< imgcap title="执行 Shell 脚本将剪贴板中的大写字母转换为小写字母，并保存到剪贴板中" src="https://p15.p3.n0.cdn.getcloudapp.com/items/6quwQr8O/d347b577-5d02-4781-b35b-f12a68d37411.png" >}}

除了执行 Shell 脚本以外，Keyboard Maestro 中还可以运行 Python、Perl、AppleScript、JavaScript、Swift 等其他编程语言。这些脚本语言的引入，大大拓展了 Keyboard Maestro 的功能。如果你遇到内置 actions 无法满足的需求，通常可以通过执行脚本来实现。

#### 充分挖掘软件的潜能

对于软件功能来说，一句略带调侃的话是「我可以不用，但你不能没有」，这句话用来形容 Keyboard Maestro 非常贴切，因为大多数用户可能都不会用到 Keyboard Maestro 的所有功能。
但当遇到那些我们通常不会用到的功能时，往往会让人感叹购买 Keyboard Maestro 实在是一个明智之举。

对很多用户来说，给经常使用的功能分配一个键盘快捷键是一项高频需求，然而，如果 macOS 或应用程序没有给某个功能设置快捷键，就可能导致使用上的不便。

有读者可能知道，我们可以在「系统设置 -\> 键盘 -\> 键盘快捷键 -\> App 快捷键」中为大多数应用设置快捷键，但这种方式的缺点是无法跨设备同步，且不方便统一管理。而使用 Keyboard Maestro，我们可以为任意 App 的菜单栏选项分配一个快捷键，甚至还能根据个人喜好修改默认快捷键。

{{< imgcap title="默认情况下 Capture to Drafts 没有一个全局快捷键" src="https://p15.p3.n0.cdn.getcloudapp.com/items/jku6ePLq/f2e77272-30e5-423f-9c32-af505968f447.png" >}}

在这方面，Keyboard Maestro 通过与操作系统的深度整合，既利用了系统原有的功能，又进一步优化，使得系统中原本「还能用」的功能变得更加实用和全面。

{{< imgcap title="用 Keyboard Maestro 为 Safari 小书签分配一个快捷键，将繁体中文转换为简体中文" src="https://p15.p3.n0.cdn.getcloudapp.com/items/yAun6rDY/022403bd-df4d-44a2-9ab9-b746589a2c30.gif" >}}

### 安装 Keyboard Maestro

你可以在 Keyboard Maestro [官网](https://www.keyboardmaestro.com/main/)下载软件安装包。点击主页上的「Free Trial」之后，会得到一个 `.zip` 压缩包，解压缩之后就会得到 Keyboard Maestro 软件本体，只需将其拖入 `/Applications`（应用程序）文件夹中，就安装成功了。需要注意的是，Keyboard Maestro 10 最低支持 macOS 10.13 High Sierra。

{{< imgcap title="Keyboard Maestro 网站主页" src="https://p15.p3.n0.cdn.getcloudapp.com/items/ApulRzNv/c10f8816-618b-4859-b149-637deb354749.png" >}}

如果你习惯使用 [Homebrew](https://brew.sh/) 安装软件，直接在终端中输入这行命令即可完成安装：

```bash
brew install --cask keyboard-maestro
```

Keyboard Maestro 提供 30 天的免费试用，试用结束后需要购买许可证（License）才能继续使用，售价为 36 美元，一个许可证最多可激活 5 台 Mac。如下图所示，Keyboard Maestro 的激活提示信息会显示使用该软件已节约的时间，并将其与美国的最低工资挂钩，充分体现了用「金钱换时间」的理念。

{{< imgcap title="试用快结束时 Keyboard Maestro 的购买提示" src="https://p15.p3.n0.cdn.getcloudapp.com/items/2NuWEq2n/b216bf1d-5afa-48c6-9043-4c6e2d088f04.png" >}}

在软件订阅制盛行的今天，Keyboard Maestro 仍然坚持大版本买断制。每隔几年，它会发布一个升级版本，老用户需要以 25 美元的价格进行升级。当然选择不升级也是可以的，可以一直使用已购买的版本。值得一提的是，在 Keyboard Maestro 中输入已购买的序列号之后，软件会播放一个「Thank You」的语音，还是非常有趣的，记得激活时不要错过这个小彩蛋哦。

{{< imgcap title="Keyboard Maestro 已为我节省了 5 天时间，不过由于我重新安装过它，实际节省的时间远不止于此" src="https://p15.p3.n0.cdn.getcloudapp.com/items/YEuzXZvj/f83510c5-0f54-4818-91d7-4a25a3f5b1ed.png" >}}

需要注意的是，Keyboard Maestro 10 的图标还没有适配 macOS Big Sur 以来的圆角图标。如果你想要更改它的图标，可以前往 [macOS App icons](https://macosicons.com/) 这个网站下载网友制作的 Keyboard Maestro 圆角图标并进行替换。

{{< imgcap title="从 macOS App icons 网站上下载的圆角 Keyboard Maestro 图标" src="https://p15.p3.n0.cdn.getcloudapp.com/items/7KuXpox2/d78eaab7-85b0-480a-8885-d003775378aa.png" >}}

### 赋予 Keyboard Maestro 权限

作为一款功能全面的自动化应用，Keyboard Maestro 需要获取相应的 macOS 系统权限才能正常工作。一般情况下，Keyboard Maestro 会自动弹出提示，让你在系统设置中勾选相应的系统权限，但由于 macOS 逐渐收紧的安全措施或者奇怪的 bug，导致无法弹出提示。在这种情况下，你需要在系统设置（System Settings）中进行操作。具体来说，Keyboard Maestro 主要需要以下这两个系统权限：

- [辅助功能](https://wiki.keyboardmaestro.com/assistance/Accessibility_Permission_Problem)（Accessibility）：Keyboard Maestro 中很多功能都需要允许辅助功能，比如菜单项选项、操作应用窗口、监听键入字符串等。你可以在「系统设置 -\> 隐私与安全性 -\> 辅助功能」中打开「Keyboard Maestro」和「Keyboard Maestro Engine」右边的按钮。

{{< imgcap title="在系统设置中为 Keyboard Maestro 打开「辅助功能」选项" src="https://p15.p3.n0.cdn.getcloudapp.com/items/NQu5JoeZ/f2c3f9c4-306c-4e50-903d-fbf42e7dcdcd.png" >}}

- [屏幕录制权限](https://wiki.keyboardmaestro.com/assistance/Screen_Recording_Permission)（Screen Recording Permission）：在捕捉屏幕图像、在屏幕上查找图像等操作时需要用到这一系统权限。如果你在未授予 Keyboard Maestro 屏幕录制权限的情况下使用这些操作，可能会导致失败。在某些情况下，系统会提示你允许屏幕录制权限，你也可以手动在「系统设置 -\> 隐私与安全性 -\> 屏幕录制」中打开「Keyboard Maestro」右边的按钮，如下图所示。

{{< imgcap title="在系统设置中为 Keyboard Maestro 打开「屏幕录制」选项" src="https://p15.p3.n0.cdn.getcloudapp.com/items/mXuv1r7P/9f2bd557-571e-45f7-a3e4-3518029e9e1a.png" >}}

此外，「文件和文件夹」、「联系人」等系统权限一般无需手动开启，Keyboard Maestro 会在需要的时候自动弹出来让你进行确认。

除了以上这些系统权限外，Keyboard Maestro 往往还需要控制其他应用程序，因此也需要授予相关权限。不过好在这些操作会在首次用到时自动弹出，只需确认即可，如下图所示。

{{< imgcap title="为 Keyboard Maestro 授予 System Events 权限的提示窗口" src="https://p15.p3.n0.cdn.getcloudapp.com/items/OAu7gQx7/81d170d8-ce37-453f-a0f9-6dd222667842.png" >}}

如果你不确定 Keyboard Maestro 能够控制哪些应用，或者需要对其进行修改，可以前往「系统设置 -\> 隐私与安全性 -\> 自动化」中找到 Keyboard Maestro 下方的应用程序，如下图所示。

{{< imgcap title="Keyboard Maestro 控制的「自动操作」应用列表" src="https://p15.p3.n0.cdn.getcloudapp.com/items/o0uKEexz/3544525b-1dd4-4f2c-8262-a1b41e15ba69.png" >}}

### 创建 macro

在安装好 Keyboard Maestro 之后，首次启动时会显示一个新手导览页面，如下图所示。

{{< imgcap title="Keyboard Maestro 新手导览" src="https://p15.p3.n0.cdn.getcloudapp.com/items/ApulRzy4/74bd6972-41b0-416d-842d-9b2e9b370de1.png" >}}

点击其中的「Start Tutorial」按钮，将会出现一个交互式教程，演示如何创建一个简单的 macro，并在按下某个快捷键时打开文件夹。下面让我们跟着这个教程走一遍，熟悉一下 Keyboard Maestro 的界面和创建 macro 的基本操作步骤。

- 在最左侧一列中选择一个 group，这里的教程提示我们选择「Global Macro Group」，这是 Keyboard Maestro 中一个默认的 group。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/WnupBxEz/d6979389-9f31-402e-9aca-fbd5b0dc327f.png)

- 点击中间列下方的加号 ➕ 按钮。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/4guR1nx7/a5f6bba6-6fe3-4122-bf36-5c08e921e66f.png)

- 如下图所示，点击加号之后，会在当前的「Global Macro Group」中创建一个名为「Untitled Macro」的 macro。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/NQu5JovZ/cad29c95-e2b2-4946-ac29-f414447149d9.png)

- Keyboard Maestro 提示点击「New Trigger」左边的加号，添加一个 trigger。在这个例子中，我们选择「Hot Key Trigger」，然后根据提示设置快捷键为 F6。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/L1u8NBkN/a0ecda8b-4be6-4d80-865d-da8da5ca5f7c.png)

- 接下来点击「New Action」左侧的加号添加一个 action。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/v1unNYmO/b12c03d2-9a50-486f-910f-a2726006d389.png)

- 点击加号之后，左侧会弹出所有的 actions 列表，我们点击「Open」actions，然后再双击「Open a File, Folder or Application」action，就完成了添加 action 的步骤。完成之后，点击左上角的叉号关闭添加 action 的界面。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/llu89N47/53d80eed-3ab2-4287-b395-5cf69e1ca195.png)

![](https://p15.p3.n0.cdn.getcloudapp.com/items/GGuy6WAe/532590de-8dc7-4890-a64c-7c7f2028862f.png)

![](https://p15.p3.n0.cdn.getcloudapp.com/items/rRumkjLR/af0683e4-f859-4c1b-b6ae-c2dc21c3e81b.png)

- 最后，在「Open a File, Folder or Application」action 中一个文件（或者文件夹、应用程序），比如下图中的 `~/Documents`。

![](https://p15.p3.n0.cdn.getcloudapp.com/items/Jrum1DWj/5722fcd1-2126-4b65-92d1-c033648ff528.png)

![](https://p15.p3.n0.cdn.getcloudapp.com/items/xQuNn7gD/c8577718-d849-47dc-b260-83965a323af3.png)

经过上述步骤，我们就制作好了一个打开 `~/Documents` 的 macro。由于这个 macro 位于「Global Macro Group」，因此，在任意位置按下快捷键 `F6`，就会打开 `~/Documents` 目录。

{{< imgcap title="按下快捷键 `F6` 打开 `~/Documents`" src="https://p15.p3.n0.cdn.getcloudapp.com/items/YEuzXZAX/007b4feb-ef92-4d31-aea1-510880ee12c0.gif" >}}

### 软件基本设置

打开 Keyboard Maestro，点击菜单栏中的「Settings…」，或者按下快捷键 `⌘ + ,`，就会打开软件的设置界面。

{{< imgcap title="点击菜单栏图标打开 Keyboard Maestro 设置界面" src="https://p15.p3.n0.cdn.getcloudapp.com/items/7KuXpoRA/e8f45440-2f05-462a-ba74-bf8c8a6101af.png" >}}

{{< imgcap title="Keyboard Maestro 的设置界面" src="https://p15.p3.n0.cdn.getcloudapp.com/items/qGuYX5o6/f74e21c4-5e9a-4bd4-8587-15f06a3613ab.png" >}}

可以看到，设置界面的上方有 6 个图标，对应着 6 类设置：

- General：包括是否开机时启动、同步 macros、软件外观、菜单栏图标等。
- Palette：设置 4 种 Palette 的样式，包括 Default Palette、Global Macro Palette、Applications Palette、Conflict Palette，我们会在后面的文章中进行详细介绍。
- Web Server：设置 Web 服务器，很少会用到，默认为关闭状态。
- Clipboards：剪贴板设置，可以在这里添加、删除和重命名所有 Named Clipboards，并查看和更改它们的值。
- Variables：变量，可以在这里查看、添加和删除所有 macros 中的变量，以及查看和更改变量值。
- Exclude：管理排除应用程序的列表，包括 Application Switcher、Applications Palette 排除以及剪贴板历史。

如果你需要查看所有 macro 的历史执行记录，可以点击菜单栏中的「Help -\> Open Logs Folder」，然后就会打开位于 `/Users/username/Library/Logs/Keyboard Maestro` 的日志文件，双击打开 `Engine.log` 即可看到所有 macro 的历史执行记录。对于制作某些复杂的 macro 来说，查看日志文件有助于测试和诊断 macro 的执行结果。

{{< imgcap title="点击菜单栏选项打开日志文件夹" src="https://p15.p3.n0.cdn.getcloudapp.com/items/mXuv1rq4/f1a23bd8-4167-4c1a-befd-693fbe4de394.png" >}}

在菜单栏中的「Help」选项中，还有很多其他选项，比如打开 Keyboard Maestro 官网、用户手册、论坛等网页。如果你在首次启动 Keyboard Maestro 时忽略了新手导览，并且取消勾选「Show this window when Keyboard Maestro opens」，那么可以点击「Help」下方的「Welcome to Keyboard Maestro」中重新打开新手导览，如下图所示。

{{< imgcap title="点击菜单栏选项打开新手导览" src="https://p15.p3.n0.cdn.getcloudapp.com/items/v1unNYr7/12ac2be7-5435-4896-ba55-afddcb354ef6.png" >}}

值得一提的是，Keyboard Maestro 的所有设置文件都保存在以下这两个目录中：

- `~/Library/Application Support/Keyboard Maestro`：主要的设置数据文件夹，例如剪贴板数据、变量数据、所有 macros 等。
- `~/Library/Preferences` 文件夹下的`com.stairways.keyboardmaestro.editor.plist`、`com.stairways.keyboardmaestro.engine.plist` 和 `com.stairways.keyboardmaestro.plist`，包括其他的设置数据，以及许可证信息（邮箱和序列号）。

### 导出、导入和同步 macros

在 Keyboard Maestro 中，选中任意一个 macro 或 macro group，然后点击右键，选择「Export Macro」，便可导出选中的 macro 或 macro group，得到一个后缀名为 `.kmmacros` 的文件。

{{< imgcap title="在 Keyboard Maestro 中导出 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/GGuy6Wkn/494be956-a4f1-416a-9e31-9649b5435a13.png" >}}

尽管 `.kmmacros` 文件看上去是一种 Keyboard Maestro 的专属文件类型，但实际上它是一种 [Plist 文件](https://developer.apple.com/documentation/bundleresources/information_property_list)，你可以直接用 VS Code 等文本编辑器打开查看其内容或进行编辑（当然一般情况下无需手动编辑）。与 Alfred Workflow、PopClip Extension 等保存为压缩文件的形式相比，这种方式更具可读性和透明性，并且可以更好地避免恶意软件。

{{< imgcap title="用 VS Code 打开从 Keyboard Maestro 中导出的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/bLuygker/073376c3-7e94-4b10-85f3-985a8e288ee5.png" >}}

如果你需要安装其他人分享的 macro，只需双击 `.kmmacros` 文件，然后就会自动在 Keyboard Maestro 中打开。此外，你也可以在 Keyboard Maestro 中点击「File -\> Import -\> Import Macros Safely…」来导入 macro。

{{< imgcap title="通过点击菜单栏图标导入 macros" src="https://p15.p3.n0.cdn.getcloudapp.com/items/WnupBxGl/8966184c-1e58-41cd-9ffd-f008e8f07b97.png" >}}

需要注意的是，`.kmmacros` 文件可能包含一个或多个 group，也就是 macro 和 macro group。如果你的已有 macro group 中不存在要导入的 group，则会新建一个 macro group。默认情况下，导入的 macro 会被禁用（除非在导入时按住 Option 键），以防止意外触发。

如果你需要通过 iCloud、Dropbox 等服务在多台 Mac 上同步 macros，只需在 Keyboard Maestro 中点击「Setting -\> General」，然后勾选「Sync Macros」，然后会出现下图中的提示。

{{< imgcap title="选择创建或打开已有的同步文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/5zubAY1o/d564e276-4401-47bc-950b-534d43b5ae0c.png" >}}

如果你此前没有同步过，就选择「Create New」，若之前已有同步文件，就选择「Open Existing」。选择之后，会创建或打开一个以 `.kmsync` 为后缀的同步文件。请注意，「Open Existing」会替换 Keyboard Maestro 中已有的 macros，在执行此操作前务必备份一下。

## 文件管理

在数字化时代，我们每天都会与各式各样的文件打交道，因此，有效的文件管理对提升工作效率至关重要。尽管 Mac 默认的文件管理应用访达（Finder）能应对基本的文件管理操作，但如果想实现更加高级和个性化的文件管理，我们就需要更加强大的工具，在这时，Keyboard Maestro 就展现了它的价值。

尽管大部分文件管理操作可以手动完成，但借助 Keyboard Maestro，你能轻松地自动化那些日常重复且耗时的文件操作，从而提升工作效率。考虑到文件管理任务的频繁性，利用这样的工具将会为你节省大量宝贵的时间。这就像带一群毛小孩一样，新手爸妈不知从何下手，往往还费力不讨好，而 Keyboard Maestro 就像一位善于管理淘气孩子的幼儿园老师。通过设定规则，它能根据文件的「性格」（类型）、「名字」（名称）或「年龄」（大小、修改日期等信息），将它们精确地放到最合适的「位置」（目标文件夹）。不止于此，它甚至能给这些「孩子们」换上新的「衣服」（压缩文件），或者帮他们取一个新的「名字」（重命名文件）。因此，不论你是与编程语言打交道的软件工程师，还是从事音视频制作的创作者，或是每天需要处理大量文件的文职人员，Keyboard Maestro 都是你提升文件管理效率的得力助手。

### 文件重命名

文件重命名是使用 Mac 时经常需要执行的操作。对单个文件进行重命名相对简单，几乎无需过多学习就可以[掌握](https://support.apple.com/zh-cn/guide/mac-help/mchlp1144/mac)。然而，当我们面临批量重命名的任务时，情况就变得有些复杂。尽管 Mac 的默认文件管理工具访达已支持同时选中多个文件并通过右键菜单的「重命名」选项进行批量重命名，但由于这种方式不支持正则表达式，其功能仍有一定的局限性，在复杂的批量重命名任务中显得有些力不从心。例如在下图的例子中，我们无法直接通过访达来实现只保留文件名最后一位阿拉伯数字的需求（即将 `IMG_0922.jpeg` 重命名为 `2.jpeg`）。

{{< imgcap title="在访达中对文件批量重命名" src="https://p15.p3.n0.cdn.getcloudapp.com/items/P8uDk9EP/fb8c945b-4622-41f8-8d4e-360e62a1e628.png" >}}

正所谓「系统功能不够用，第三方应用来补足」，因此，一些第三方软件应运而生，比如 [Renamer](https://renamer.com/)、[Path Finder](https://www.cocoatech.io/)，它们提供了更加高级的批量重命名功能，但这些应用大多需要付费。相较之下，借助 Keyboard Maestro，我们可以无需额外的成本就实现高级的批量重命名功能。

#### 用自带 macro 批量重命名文件

Keyboard Maestro 自带的 Macro Library 中包含了一个文件重命名的 macro，你可以点击快捷键 `⌘ + 2`，然后双击「File -\> Rename Finder Files」，就能将这个 macro 导入到你的 library 中。

{{< imgcap title="导入「Rename Finder Files」" src="https://p15.p3.n0.cdn.getcloudapp.com/items/04udJ2P7/238b0aaf-9697-4cd3-8214-68322b94b4d6.png" >}}

可以看到，上图中这个 macro 的功能是「在访达中使用正则表达式批量重命名文件」。导入之后可以看到，这个 macro 的默认 trigger 是点击菜单栏图标，当然你也可以设置为其他 trigger，展开所有 action 的截图如下。

{{< imgcap title="Keyboard Maestro 自带的用于对文件批量重命名的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/9ZuL8djv/016e18d7-203a-4c96-9fd1-c0f66dfcfab6.png" >}}

按照先后次序，这个 macro 最外层用到了 3 种 action，分别是：

1. Prompt for User Input
2. Set Variable to Text
3. For Each

下面对这 3 个主要 action 的步骤进行拆解。

在第一个 Prompt for User Input 中，首先填写 Title 和 Prompt，它们会显示在弹出的窗口中，起到提示的作用，你可以自行修改。然后设置了两个变量，分别是 `Search` 和 `Replace`。最后添加两个按钮，分别是 `OK` 和 `Cancel`，并勾选 `Cancel` 后的 `Cancel Macro`，这意味着当你在弹出的窗口中点击 `Cancel` 时，这个 macro 将不会继续执行。第二个 action 将变量「Result Button」设置为文本「None Yet」，起到一个占位符的作用。

在第三个 action 中，最外层是一个遍历循环，即「For Each」，它的作用是「对于访达中选中的每个文件，都执行下面的操作」：

- 首先获取选中文件的名称，并保存到变量 `Filename` 和 `Original Filename` 中
- 然后使用正则表达式在变量 `Filename` 中查找替换，查找内容为第一步中用户输入的 `%Variable%Search%`，然后将其替换为 `%Variable%Replace%`
- 接下来引入第一个条件判断。如果用户没有点击 「Rename All」，那么就弹出一个窗口，让用户确认是否要将文件重命名，否则的话，不执行任何操作。
- 最后一步同样也是一个条件判断。如果用户点击的按钮中包括「Rename」，也就是点击「Rename」或「Rename All」，就对文件进行重命名，否则不执行任何操作。

下图中演示了使用「Rename Files」这个 macro 批量重命名文件，实现将将文件名只保留最后一位阿拉伯数字的操作。值得注意的是，我设置了一个快捷键 `⌃ + ↵`，而没有点击菜单栏图标，还用到了正则表达式 `IMG_\d{3}` 搜索文件名中除最后一位数字的内容，并将其全部移除，实现只保留最后一位阿拉伯数字的效果。

{{< imgcap title="通过 Keyboard Maestro 自带的 macro 批量重命名文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/o0uKEevB/dbc17475-30b9-4bdb-99e5-54d9f9edbbdc.gif" >}}

#### 执行 Shell 脚本重命名文件

如果你觉得 Keyboard Maestro 自带的批量重命名文件的 macro 太过复杂，不容易理解，那么下面提供另一种通过执行 Shell 脚本来批量重命名文件的方法，更加简单直接。

首先，我们需要安装一个命令行工具 [rename](http://plasmasturm.org/code/rename/)，它是一个在命令行中对文件重命名的工具，功能非常强大，可以使用 Homebrew 快速安装：

```bash
brew install rename
```

然后我们制作一个 macro，通过在 Keyboard Maestro 中执行 Shell 脚本调用 rename 来批量重命名文件，如下图所示。

{{< imgcap title="使用命令行工具 rename 对文件批量重命名的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Jrum1DLg/7eee9fdd-b0d5-4aac-b967-fed0718cdec8.png" >}}

在这个 macro 中，第一步仍然是一个需要用户输入的窗口，Search 栏中输入需要查找的文件名，Replace 输入替换后的结果，都支持正则表达式，然后分别保存为变量 `Search` 和 `Replace`。接下来模拟点击快捷键 `⌘ + ⌥ + C`，它的作用是在访达中复制选中文件的绝对路径。做好上述两步准备工作之后，最后就可以执行下面这两行 Shell 脚本：

```bash
cd "$(pbpaste | head -n 1 | sed 's/ /\\ /g' | xargs dirname)"

rename "s/${KMVAR_Search}/${KMVAR_Replace}/g" *
```

第一行的作用是从剪贴板获取内容，取第一行，将其中的空格转义，取得文件路径的目录部分，然后进入该目录：

- `pbpaste`：获取剪贴板中的内容，即复制的文件路径，形如 `/Users/username/Downloads/Image Folder/test image.jpeg`。
- `head -n 1`：`head`：获取输入内容的前几行，`-n 1` 参数表示我们只需要获取剪贴板中的第一行内容，这是为了处理同时选中多个文件的情况。
- `sed 's/ /\\ /g'`：`sed` 命令用于处理文本流，这里的 `'s/ /\\ /g'` 是一个替换命令，意思是将所有的空格替换为 Shell 中的转义空格。
- `xargs dirname`：`xargs` 命令用于将输入内容作为另一个命令的参数，这里，我们将处理过的第一行内容作为 `dirname` 命令的参数，`dirname` 命令用于获取文件或目录路径的上一级目录，得到 `/Users/username/Downloads/Image\ Folder`。
- `cd "$(command)"`：Keyboard Maestro 中 Shell 脚本的默认工作目录为用户文件夹 `/Users/username/`，这个命令用于改变当前的工作目录，`$(command)` 表示命令 substitution，也就是说，`$(command)` 的结果（即 `dirname` 命令的结果）会作为 `cd` 命令的参数。例如，如果第二步复制得到的文件路径是 `/Users/username/Downloads/Image Folder/test image.jpeg`，那么这行命令的作用就是进入目录 `/Users/username/Downloads/Image\ Folder` 中，以便进行下一步。

在第二行命令中，我们使用 `rename` 命令将文件重命名，即在当前目录中，将所有文件的文件名中的 `${KMVAR_Search}` 字符串替换为 `${KMVAR_Replace}` 字符串：

  - `s/.../.../g`：这是一个替换命令。`s` 表示替换，`g` 表示全局替换，也就是替换文件名中的所有匹配项，而不仅仅是第一个
  - `${KMVAR_Search}`：用户输入的查找文件名，表示要在文件名中查找的字符串，需要注意变量名必须以 `KMVAR_` 开头
  - `${KMVAR_Replace}`：用户输入的替换文件名，表示要将找到的字符串替换的结果
  - `*`：这是一个通配符，表示当前目录中的所有文件

{{< imgcap title="使用命令行工具 rename 对文件批量重命名" src="https://p15.p3.n0.cdn.getcloudapp.com/items/yAun6rYD/01303a37-e59a-4ea7-a275-4a61a413861b.gif" >}}

#### 文件名 Slugify 化

Slugify 通常指的是一种将字符串转换为可以用作 URL、文件名或识别符的安全格式的过程。这个过程通常会删除或替换一些特殊字符、空格、标点符号，有时还包括将文本转换为小写，以确保结果字符串适合其预期的用途。例如，如果我们有一个文件名为 `Hello World! This is a Test!`，经过 Slugify 处理后，就会变为 `hello-world-this-is-a-test`，这样既保持了文件名称的可读性，又转换成了安全统一的文件格式名称。

如果你想要在对日常使用的文件名 Slugify 化，但又不想手动操作，可以使用 Keyboard Maestro 来实现。虽然我们可以通过编写正则表达式来查找替换来实现文件名 Slugify 化，但如果要写一个功能完善的正则，还是相当复杂的，好在已有很多现成的库可供使用，比如 Python 库 [Python Slugify](https://github.com/un33k/python-slugify)，可以通过 `pip` 命令进行安装：

```bash
pip install python-slugify
```

安装完成之后，你可以在命令行中输入 `slugify --help` 查看它的使用说明，然后根据这些选项编写适合的命令对文件名 Slugify 化。需要注意的是，Python Slugify 的命令行工具只能处理字符串，不能直接对文件重命名。因此，我们需要在 Keyboard Maestro 中制作下图所示的这个简单的 macro。

{{< imgcap title="使用 Python Slugify 对文件名 Slugify 化的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/4guR1njZ/8c285673-f8b3-436c-abe7-b35c12b8d184.png" >}}

在这个 macro 中，首先模拟按下快捷键 `↵` 进入文件重命名状态，然后将原有文件名复制到剪贴板中，最后通过 Python Slugify 的处理，将 Slugify 化的文件名粘贴（paste results），使用的命令为：

```bash
 pbpaste | slugify --stdin
```

其中 `--stdin` 表示从标准输入中读取数据，也就是从剪贴板中获取文件名。使用效果如下图所示，需要注意的是，下图中的演示将汉字转换成了拼音，如果你没有这个需求，可以开启 `--allow-unicode` 选项。

{{< imgcap title="使用 Keyboard Maestro 对文件名 Slugify 化" src="https://p15.p3.n0.cdn.getcloudapp.com/items/xQuNn7DO/94b2673b-100e-4218-8c44-58c89a9e5b0e.gif" >}}

### 标签管理

除了做好文件命名外，文件管理的另外一大策略就是对文件加上合适的标签，以便更好地分类、查找文件。Keyboard Maestro 自带了一组 action，可以实现对文件进行标签管理。

{{< imgcap title="为文件加上「重要」标签的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/nOuQlPe2/87630b76-d96c-4fbb-9922-ac249a7e6b12.png" >}}

如上图所示，为文件加上标签的 macro 非常简单，只需使用「Set File Attribute」这个 action 下的「tags (add)」，然后设置相应的标签名称即可。为了在访达中将选中的每个文件都加上标签，这里在最外层套上了一个「For Each」操作。除了加标签以外，「Set File Attribute」这个 action 下还有其他一些操作，比如设置文件修改日期、是否隐藏文件扩展名、移除标签等，例如下图就是一个移除「重要」标签的 macro。

{{< imgcap title="移除文件「重要」标签的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/4guR1njE/5a04a108-128a-41ab-9ae1-54f4859b9913.png" >}}

在下图的示例中，我首先选中了 5 个文件，然后按下快捷键 `⌃ + T` 触发添加标签的 macro。由于 `Important`、`Green` 和 `Yellow` 都是同一个快捷键，所以激活了 Conflict Palette，弹出了进一步选择的界面。接着，我按下 `g` 选择添加 `Green` 标签，之后进行同样的操作，为 `IMG_4921.jpeg` 添加 `Important` 标签。最后再按下快捷键 `⌃ + R` 取消 `Important` 标签。需要注意的是，为了充分利用 Conflict Palette 进行键盘操作，我们需要避免使用中文来命名 macro，而应该使用英文或数字进行命名。

{{< imgcap title="使用 Keyboard Maestro 添加或移除文件标签" src="https://p15.p3.n0.cdn.getcloudapp.com/items/KouNZ4Bg/a29aed10-0f75-41f0-8a87-da79f9770f55.gif" >}}

### 压缩文件夹

如果你使用 macOS 中访达的内置压缩工具来压缩文件夹，然后将压缩包发送到 Windows 平台上，解压后可能会出现 `.DS_Store` 和 `__MACOSX` 这两个文件或文件夹。这是因为这两者都是 macOS 独有的隐藏文件类型，`.DS_Store` 文件用于存储文件夹的自定义属性，例如窗口位置、图标位置或背景色等，`__MACOSX` 文件夹则是存储 Mac 专有的文件元数据，例如文件的创建和修改日期。在使用访达压缩文件或文件夹时，`.DS_Store` 和 `__MACOSX` 也会被打包进去。

{{< imgcap title="在命令行中使用 `ls -a` 查看文件夹中的隐藏文件，其中就包括 `.DS_Store`" src="https://p15.p3.n0.cdn.getcloudapp.com/items/P8uDk9bj/121f0182-eaae-49c7-ba09-327570643b4e.png" >}}

当这些压缩包在 Windows 系统上被解压时，由于 Windows 无法识别这些文件类型，它们就会被显示出来。虽然这并不会影响大多数 Windows 用户使用压缩包中的其他文件，但如果你想避免这种情况，可以使用专门的压缩工具，如 [BetterZip](https://macitbetter.com/)，这类专业解压缩工具通常有选项可以排除 `.DS_Store` 和 `__MACOSX`。

{{< imgcap title="BetterZip 可以设置排除 Mac 特定文件类型" src="https://p15.p3.n0.cdn.getcloudapp.com/items/p9uY8AGj/d1db92f2-8000-4a94-9ecd-19ab0895fb72.png" >}}

然而，如果你的需求只是在压缩文件时排除 `.DS_Store` 和 `__MACOSX`，那么购买售价 24.95 美元的 BetterZip 可能并不是一个经济的选择。实际上，Mac 自带的命令行工具就能够实现这个需求：

```bash
zip -r dir.zip . -x "*.DS_Store" -x "__MACOSX/*"
```

这行命令将当前目录及其中包含的所有内容压缩成一个名为 `dir.zip` 的 .zip 文件，同时排除所有名为 `.DS_Store` 的文件以及 `__MACOSX` 目录下的所有内容：

- `zip`：用于创建 .zip 压缩文件的命令，macOS 已预先安装。
- `-r`：这是 `zip` 命令的一个选项，表示递归地压缩目录及其所有子目录和文件，如果不使用此选项，`zip` 命令只会压缩顶级目录下的文件，而不会包含任何子目录或子目录中的文件。
- `dir.zip`：创建的 .zip 文件的名称。
- `.`：代表当前目录，即该命令将压缩当前目录及其所有子目录和文件。
- `-x "*.DS_Store"`：表示在创建 .zip 文件时排除所有名为 `.DS_Store` 的文件。
- `-x "__MACOSX/*"`：表示在创建 .zip 文件时排除 `__MACOSX` 目录及其所有内容。

将上述命令稍微修改一下，添加到 Keyboard Maestro 中，就可以制作如下图所示的一个 macro。

{{< imgcap title="通过 Keyboard Maestro 压缩文件夹并排除 Mac 特定文件类型" src="https://p15.p3.n0.cdn.getcloudapp.com/items/GGuy6WRR/f4283328-7c46-4459-a40f-77aa79480c23.png" >}}

这个 macro 的主体是一个「For Each」action，前半部分用到的 3 个「Get File Attribute」，是为了获取当前文件所在的文件夹路径及文件夹名称。

最后一步执行的 Shell 脚本如下：

```bash
cd "$KMVAR_curr_folder_loc"
zip -r "$KMVAR_curr_folder_name.zip" "$KMVAR_curr_folder_name" -x "*.DS_Store" -x "__MACOSX/*"
```

使用效果如下图所示。

{{< imgcap title="通过 Keyboard Maestro 压缩文件夹" src="https://p15.p3.n0.cdn.getcloudapp.com/items/bLuygkRq/f324eaf1-9e81-4e36-b3a3-abafd870df93.gif" >}}

### 在 VS Code 中打开文件夹

对于很多代码项目来说，我们往往需要打开整个项目文件，而不只是双击打开单个文件。为了实现这个需求，我们可以在 Keyboard Maestro 中执行 AppleScript 来实现，如下图所示。

{{< imgcap title="在 VS Code 中打开当前所在文件夹的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/wbu5967X/0479ae28-691a-488d-84ee-baef5ad5d816.png" >}}

上图中使用的 AppleScript 为：

```applescript
tell application "Finder"
	set pathLoc to POSIX path of (folder of the front window as alias)
end tell
tell application "Visual Studio Code"
	open pathLoc
end tell
```

激活这个 macro，在访达中选中或打开某个文件夹（无论其中的文件是否被选中），然后按下快捷键 `⌃ + ⌥ + ⇧ + ⌘ + V` 就会在 VS Code 中打开这个文件夹，使用效果如下。

{{< imgcap title="在 VS Code 中打开当前所在文件夹" src="https://p15.p3.n0.cdn.getcloudapp.com/items/xQuNn7LO/d5a1c22d-8400-4327-87b2-a15ddc7364e2.gif" >}}

### 下载文件

#### 下载 GitHub 仓库单个文件

在大多数情况下，我们可以直接在浏览器中点击链接进行下载文件，但这并不总是最方便的方式，例如在某些情况下，无法直接获取到下载链接，或者链接数量很多，在浏览器中将一个个链接打开进行下载非常麻烦。

举个例子，如果你在没有登录 GitHub 账号的状态下打开一个仓库，是无法看到下载单个文件的按钮的。尽管 GitHub 提供了下载或克隆整个仓库的按钮，但如果仓库很大，而我们只想下载单个文件，就需要点击「Raw」按钮，然后跳转到一个新地址，最后点击浏览器中的「另存为」或按下快捷键 `⌘ + S` 将文件保存到本地，步骤太多，非常不方便。

{{< imgcap title="未登录 GitHub 账号的状态下，无法看到下载单个文件的按钮" src="https://p15.p3.n0.cdn.getcloudapp.com/items/yAun6rbz/00a75d8b-e485-4ece-a2b3-d681f77ca317.png" >}}

在 Stack Overflow 上，「[如何从 GitHub 仓库中下载单个文件](https://stackoverflow.com/q/4604663/19418090)」的问题的浏览量已超过 150 万，网友们各显神通，提供了各种解决方法。尽管最直接的方法是登录 GitHub 账号，之后就会出现下载一个「Download raw file」的按钮，但毕竟不是人人都有 GitHub 账号，即便有账号，也不一定随时都处于登录状态。因此，为了更方便地从 GitHub 仓库下载单个文件，我们可以借助 Keyboard Maestro 执行 Shell 脚本来实现，如下图所示。

{{< imgcap title="在 Safari 中下载 GitHub 仓库单个文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/2NuWEqyZ/8b763474-1055-4537-910b-1c819caf5b37.png" >}}

在上面这个 macro 中，首先将当前激活的 Safari 窗口的 URL 设置为变量 `GHURL`，例如图中显示的 `https://github.com/jgm/pandoc/blob/main/MANUAL.txt`。接下来执行下面这两行 Shell 脚本：

```bash
cd ~/Downloads

curl -O $(echo ${KMVAR_GHURL} | sed 's|github.com|raw.githubusercontent.com|;s|/blob/|/|')
```

它的作用是首先进入「下载」文件夹，然后用 sed 将 GitHub 仓库的链接转换为 Raw URL，得到形如 `https://raw.githubusercontent.com/jgm/pandoc/main/MANUAL.txt` 的链接，最后使用 Curl 将文件下载到「下载」文件夹中，`-O` 表示保存将输出写入本地文件，文件名称与远程文件名保持一致。

{{< imgcap title="在 Safari 中使用 Keyboard Maestro 下载单个 GitHub 文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/qGuYX5Nk/637bc025-590f-4169-a9a6-d4af21530ddc.gif" >}}

激活这个 macro，在 Safari 中打开 GitHub 单个文件的页面，然后点击菜单栏图标（当然你也可以修改为其他 trigger），稍等片刻，文件就会出现在下载文件夹中，使用方法如上图所示。

值得注意的是，上面演示的 macro 只能在 Safari 中使用，因此使用的是 `%SafariURL%` 这个 token 来获取 Safari URL。如果你想要在 Google Chrome 中使用，可以将其修改为 `%ChromeURL%`，并设置这个 macro 所在的 group 可以在 Chrome 中使用。当然，如果你使用多个浏览器，不想为每个浏览器都单独制作一个 macro，那么可以使用 `%FrontBrowserURL%` 这个 token，它可以获取大多数前置浏览器激活窗口的 URL。

{{< imgcap title="更改为 `%FrontBrowserURL%` 实现在大多数浏览器中使用" src="https://p15.p3.n0.cdn.getcloudapp.com/items/DOuP2q9n/f9a50354-1806-49db-913f-d7a787872aba.png" >}}

下图演示了在未登录 GitHub 账号的情况下，通过 [Arc 浏览器](https://arc.net/)下载 GitHub 仓库中的单个文件。

{{< imgcap title="在 Arc 浏览器下载 GitHub 仓库中的单个文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/v1unNY4Y/161b4e4a-7a6d-4cdf-b311-4bb76211ea33.gif" >}}

需要提醒的是，由于 Arc 浏览器推出不久，Keyboard Maestro 还无法正确识别它，不过好在 Arc 是基于 Chromium 开发的，因此可以在终端中执行下面这两行命令来让 Keyboard Maestro 正确地识别它：

```bash
defaults write com.stairways.keyboardmaestro.engine AppleScriptGoogleChromeBundleID -string "company.thebrowser.Browser"

defaults write com.stairways.keyboardmaestro.engine BrowserGoogleChromeName -string "Arc"
```

以上的例子说明了如何使用 Keyboard Maestro 下载 GitHub 仓库中的单个文件，针对其他网站，可能有很多类似之处，你可以参考上面的方法进行尝试。

#### 批量下载文件

如果你得到一系列链接，如何快速地把它们对应的远程文件下载到本地？例如下面的 3 个链接：

```text
https://cdn.sspai.com/2023/05/21/b2d2ca35d9d57aaf1f6488d4bc6e8187.png
https://cdn.sspai.com/2023/05/21/4fe45b1b2e5bf309c89c46144ff5cdaf.JPEG
https://arxiv.org/pdf/2304.01393.pdf
```

最直接的方法自然是一个个点击它们在浏览器中打开，然后保存到本地，但一个个点击的操作非常繁琐。为了快速完成批量下载文件的操作，我们可以使用 Keyboard Maestro 制作一个简单的 macro 来实现自动化，如下图所示。

{{< imgcap title="批量下载剪贴板中链接对应的文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/llu89N2w/cafdfe59-12f4-4e0b-8916-ac000f038a97.png" >}}

上面这个 macro 中使用的 Shell 脚本如下：

```bash
cd ~/Downloads

pbpaste | xargs -n 1 curl -O
```

它的作用是首先进入下载文件夹，然后通过 `pbpaste` 将剪贴板中的链接传递给 Curl 进行下载，其中 `-n 1` 参数的作用是告诉 `xargs` 每次只使用一行的链接。使用效果见下图。

{{< imgcap title="通过点击 Keyboard Maestro 菜单栏图标批量下载文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/9ZuL8dBj/66821bfa-b806-4fce-ab0d-ee4b8339a034.gif" >}}

### 自动处理文件

在 macOS 上，一提到自动处理文件，就绕不开 [Hazel](https://www.noodlesoft.com/)。尽管 Hazel 的功能非常强大，但价格也同样不便宜，如果你不想额外花费 40 多美元购买并学习使用一款新软件，并且只需要用到一些常用的文件自动化功能，那么 Keyboard Maestro 就足以应对，正如一位网友[所说](https://talk.macpowerusers.com/t/can-this-be-done-with-keyboard-maestro/17740/6)：

> There is an advantage for a KM user who isn’t really using Hazel - which would be me: You can get rid of Hazel and use the automation capabilities you’re already familiar with. It’s just the trigger that’s novel.
> 
> 对于像我这样并不真正使用 Hazel 的用户来说，使用 Keyboard Maestro 有一个优势：你可以摆脱 Hazel，使用你已经熟悉的自动化功能，新颖的只是触发器而已。

#### 自动打开或移动文件

在 Safari 的「设置 -\> 通用」中，有一个「下载后打开『安全的』文件」的选项，这是一个默认开启的功能。根据下方的说明，「安全的」文件包括影片、图片、声音、文本文稿，以及归档。

{{< imgcap title="Safari 中「下载后打开『安全』文件」的选项" src="https://p15.p3.n0.cdn.getcloudapp.com/items/RBuz4lWW/92f8a5f0-22d8-46a9-8604-8be4d2b67c22.png" >}}

在之前的 macOS 版本中，「安全的」文件还包括 PDF，不知苹果出于什么考虑，现在已将 PDF 移除。因此，在最新的 macOS Ventura 中，如果你通过 Safari 在网上下载一个 PDF 文件，不会被自动打开。如果你像我一样，想要下载的 PDF 文件自动打开，可以使用 Keyboard Maestro 制作一个下图所示的 macro，「找回」这个功能。

{{< imgcap title="自动打开下载文件夹中新添加的 PDF 文件" src="https://p15.p3.n0.cdn.getcloudapp.com/items/12uQo4r4/4861682f-c238-4d4e-b588-6be2b21acf5f.png" >}}

在上图的这个 macro 中，trigger 方式为「Folder Trigger」，这里我们设置为 `~/Downloads` 文件夹 `adds an item`，也就是当「下载文件夹」添加一个新的文件时，这个 macro 就会被触发，下方默认的「ignore partial files」表示正在被下载或拷贝的文件会被忽略，避免文件下载一部分就被移动的情况。使用的 action 是一个条件判断，即「If Then Else」。根据图中设置的条件，当 `%TriggerValue%` 包含 `.pdf` 时，就使用默认应用程序（Default Application）执行打开 `%TriggerValue%` 的 action（也可以设置为其他应用程序），否则不执行任何 action。值得一提的是，`%TriggerValue%` 这个 token 的[含义](https://wiki.keyboardmaestro.com/token/TriggerValue)是「返回与 macro 触发方式相关的值」，这里指的就是「下载」文件夹中添加的新文件。

类似地，你还可以制作移动文件的 macro，例如下图所示的 macro，用于将下载的 PDF 文件移动到桌面。

{{< imgcap title="将下载文件夹中新添加的 PDF 移动到桌面的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/bLuygkwq/8ba6af15-3e14-462f-90f9-fce9a7dcbd57.png" >}}

需要注意的是，打开或移动移动文件 macro 的 trigger 都是「当下载文件夹添加一个新文件时」，这种 trigger 属于 [Folder Trigger](https://wiki.keyboardmaestro.com/trigger/Folder)，需要设置为全局可用，而不能仅仅在访达中起作用。

#### 定时处理文件

顾名思义，「定时处理文件」是指在预设的特定时间，对指定的文件或文件夹执行特定操作的一种方式。这些操作可能涵盖各种范畴，包括但不限于文件的移动、删除、重命名，或者更为复杂的任务如内容更新、数据分析以及备份等。这种方法适用于需要定期进行的任务，例如每天清理临时文件，每周备份重要数据等。此外，定时处理文件的策略也能有效地减少由人为错误或遗漏引发的问题。

举个例子，定时备份 Mac 已安装的软件列表是一项非常重要的工作，这有利于重装系统时快速安装。但手动备份往往很繁杂，而且还经常忘记，因此，这种任务特别适合使用 Keyboard Maestro 来自动完成，例如下图中的例子。

{{< imgcap title="每周一自动导出 Mac 软件列表的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Jrum1Dge/aa6e7dda-b4f0-43e0-a2d1-153cebd0f5ab.png" >}}

在上面这个 macro 中，用到了「Time of Day Trigger」这个触发方式，它的作用是在某个特定时间执行这个 macro，在上图的示例中，我设置的时间为每周一 10:00。下方的 action 是执行两行 Shell 脚本：

```bash
# All Apps
ls -1 /Applications /Applications/Setapp > ~/Library/Mobile\ Documents/com~apple~CloudDocs/app-list/all-applist

# Homebrew Apps (Formulae, Casks, Mac App Store and Homebrew)
brew bundle dump -f --file=~/Library/Mobile\ Documents/com~apple~CloudDocs/app-list/Brewfile
```

第一行的作用是使用 `ls` 命令列出 Applications（应用程序）以及其中 Setapp 文件夹的应用列表，然后将输出写入到文本文件 `all-applist` 中，保存到 iCloud 中，其中 `-1` 的作用是为了每行只显示一个文件。第二行命令使用 Homebrew 自带的 `bundle dump` 参数将已安装的软件列表保存在文件 `Brewfile` 中，其中 `-f` 参数允许覆盖已有的 `Brewfile`。值得注意的是，`brew bundle dump` 会同时导出 Formulae、Casks 以及通过 [Mac App Store 命令行工具](https://github.com/mas-cli/mas) 安装的应用。在重装系统的 Mac 上，你只需要在 `Brewfile` 所在目录中执行 `brew bundle` 命令，Homebrew 就会自动安装其中包含的所有应用程序。

如果 Mac 处于睡眠状态，trigger 设置为特定时间的 macro 不会被触发，因为「Time of Day Trigger」要求 Mac 必须处于唤醒状态。在上面的例子中，如果我的 Mac 在周一 10:00 处于睡眠状态，那么这个 macro 不会被执行，也不会推迟到唤醒 Mac 之后再执行，而是会取消执行。

「Time of Day Trigger」最多只能每天执行一次，如果你需要周期性执行 macro，并且这个周期小于 24 小时，那么就需要使用「Cron Trigger」，如下图所示。考虑到 Cron 的规则可能比较复杂，你可以前往 [Crontab.guru](https://crontab.guru/) 查看相关例子，或者询问 ChatGPT 如何编写 Cron 表达式。

{{< imgcap title="Cron Trigger" src="https://p15.p3.n0.cdn.getcloudapp.com/items/4guR1nJE/7b46c0a5-a1e7-473b-b25c-6e3184f9d9a1.png" >}}

在 Keyboard Maestro 中，还有一些与「自动处理文件」功能相关的 trigger，如果你的工作中有需要，可以进行尝试：

- Login trigger：当 Keyboard Maestro Engine 作为 Mac 登录序列的一部分启动时，它将执行 macro
- Unlock Trigger：在 Mac 解锁屏幕时触发，要求 10.0 及更新版本
- Sleep Trigger：在 Mac 进入睡眠状态时执行 macro，可能会有最多 30 秒的延迟
- Mounted Volume trigger：当卷（磁盘）被挂载或卸载时触发
- USB Device trigger：当 USB 设备连接或断开时触发
- Dragged File Trigger：当文件或文件夹被拖拽到 macro palette 上的一个 macro 时触发

## 小结

在本文中，我们介绍了如何使用 Keyboard Maestro 进行文件管理的相关操作，包括重命名文件、添加或移除标签、压缩文件夹、下载文件、自动处理文件等内容，除特殊说明外，文中大多数示例 macro 需要设置为在访达中起作用。总的来说，这些操作大致可分为两类 macro：一类是利用 Keyboard Maestro 内置的 action 实现，例如批量重命名文件；另一类则是执行 Shell 脚本，这在我们的介绍中被广泛应用。

特别需要强调的一点是，当我们使用 Shell 脚本对文件进行操作时，将工作目录设置为文件所在的当前文件夹尤为重要。我们在本文中分享了两种方法，第一种是利用 Keyboard Maestro 的 action 来实现，如在「压缩文件夹」一节中所述；第二种则是通过模拟执行快捷键复制选中文件的路径，然后使用命令 `cd "$(pbpaste | head -n 1 | sed 's/ /\\ /g' | xargs dirname)"` 来访问当前文件的所在目录。这两种方式均可以达到相同的目的，我们在后续的文章中也将继续使用。

最后，关于「自动处理文件」一节中提及的 trigger，其应用实际上并不仅限于文件管理，还可以用于其他情况。如果你有需求或感兴趣，可以自行尝试实践，同时，如果在使用过程中有任何疑问，欢迎随时留言交流和讨论。
