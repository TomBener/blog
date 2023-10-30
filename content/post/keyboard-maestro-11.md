---
title: Keyboard Maestro 11 更新，这些功能值得关注
date: 2023-10-29
categories:
    - Keyboard Maestro
---

{{< admonition title="🔖 Note" >}}
本文首发于 [少数派](https://sspai.com/post/83932)
{{< /admonition >}}

<h2>目录</h2>

- [全新的宏向导](#全新的宏向导)
- [新增 macOS 内置 OCR](#新增-macos-内置-ocr)
- [剪贴板历史记录仅显示图片](#剪贴板历史记录仅显示图片)
- [文本片段自定义弹窗](#文本片段自定义弹窗)
- [执行脚本的变化](#执行脚本的变化)
- [新增的权限面板](#新增的权限面板)
- [在所有 Mac 上的禁用 Macro Group](#在所有-mac-上的禁用-macro-group)
- [新增警告或提示功能](#新增警告或提示功能)
- [界面更新](#界面更新)
- [其他更新](#其他更新)

---

<br>

2023 年 10 月 24 日，Stairways Software 发布了 Keyboard Maestro 的大版本更新——[Keyboard Maestro 11](https://wiki.keyboardmaestro.com/manual/Whats_New)。此前，Keyboard Maestro 的版本是 2022 年 9 月 6 日发布的 [10.2](https://www.stairways.com/press/2022-09-06)，经过一年多的打磨，除了修复常规的 bug 以外，Stairways Software 团队为 Keyboard Maestro 本次大版本更新带来了诸多新功能。这其中包括了全新的宏向导（New Macro Wizard）、安全偏好设置面板（Security preference pane）、`keyboardmaestro` 命令行工具，以及全新支持的 Apple 文本识别功能等等。

系统版本方面，Keyboard Maestro 11 需要 macOS 10.13 High Sierra 或更高版本，原生支持 Intel 和 Apple Silicon Mac。价格方面，Keyboard Maestro 11 沿袭了一贯的买断制，售价依然是 36 美元，今年 3 月 1 日之后购买的用户可以免费升级，Keyboard Maestro 10 老用户在 2023 年 12 月 15 日之前可以以 18 美元的优惠价格升级，之后的升级价格将变为 25 美元。值得注意的是，由于 Keyboard Maestro 采用的是老式软件的销售方式（old-fashioned），只需一次性付款，想升级时再升级（[pay once and upgrade when you want to](https://news.ycombinator.com/item?id=38018743)），因此如果你在使用 Keyboard Maestro 10.x 或之前的版本，出于各种原因不想升级 Keyboard Maestro 11，也可以继续使用老版本，完全没有问题。

尽管如此，对于 Keyboard Maestro 这样一款相当优秀的软件来说，还是非常建议升级到最新版本的，因为这既是支持软件开发者的一种方式，让后续开发良性发展下去，同时也能让我们在第一时间体验到 bug
修复和全新推出的功能。在著名的在线论坛 [Hacker News](https://news.ycombinator.com/item?id=38017831) 上，针对 Keyboard Maestro 11 发布的消息，不少网友都给出了极高的评价，甚至有用户评论说「[很乐意为 Keyboard Maestro 付费](https://news.ycombinator.com/item?id=38019659)」：

> I was actually going to make a post about software that you actually enjoy paying for and I was going to use Keyboard Maestro as one of those examples. Truly remarkable piece of software.
> 
> ---
> 
> 我打算写一篇关于软件的文章，谈谈那些你真正乐意为之付费的软件，我打算用 Keyboard Maestro 作为其中一个例子，这真的是一款非常出色的软件。

在下文中，我们将介绍 Keyboard Maestro 11 中值得关注的新功能。无论你是 Keyboard Maestro 的老用户，还是刚刚接触这款软件，相信都能对你有所帮助。不过，作为一款超过 20 年历史的老牌 macOS 自动化应用，Keyboard Maestro 的功能非常复杂，能够实现的功能也相当丰富，无聊是文本扩展、窗口管理，还是处理 PDF、控制浏览器操作，它都能应对自如，可以说 Keyboard Maestro 的功能上限仅仅受限于我们的 [创造力](https://news.ycombinator.com/item?id=38021261)。对于 Keyboard Maestro 新手来说，首次打开 Keyboard Maestro，面对陌生繁杂的界面，往往不知所措，如果你想要系统学习如何使用这款 macOS 顶级自动化应用，欢迎购买我撰写的专栏《[Keyboard Maestro 拯救效率——完全上手顶级 Mac 自动化工具](https://sspai.com/series/350)》。

## 全新的宏向导

尽管 Keyboard Maestro 11 的更新日志将全新的宏向导（New Macro Wizard）作为第一个更新功能，但这个功能实际上非常简单。如下图所示，New Macro Wizard 就是左下角红色箭头所在位置的图标，点击之后会弹出如图所示的窗口，用于快速创建 macro。比如在下图中，我们将 trigger 设置为快捷键 `⌃ + ⌥ + D`，action 设置为「Activate an application」。

{{< imgcap title="New Macro Wizard" src="https://p15.p3.n0.cdn.getcloudapp.com/items/bLuyBdmN/16701c40-ae53-485c-a0e5-9c9786e42e77.png" >}}

可以发现，新增加的向导功能对于新手非常友好，可以通过这种方式快速创建简单的 macro。不过，在熟悉了如何使用 Keyboard Maestro 创建 macro 之后，New Macro Wizard 的作用就不是太大了。

## 新增 macOS 内置 OCR

在 Keyboard Maestro 11 之前，Keyboard Maestro 使用的是开源 OCR 引擎 [Tesseract](https://github.com/tesseract-ocr/tesseract)，需要在使用前下载特定的语言包。遗憾的是，Tesseract 对中文字符的识别效果不佳，而目前的 macOS 已经原生支持 OCR 框架。因此，Keyboard Maestro 11 更新带来了支持调用 macOS 内置 OCR 的功能。

{{< imgcap title="在 Keyboard Maestro 中使用 macOS 内置 OCR" src="https://p15.p3.n0.cdn.getcloudapp.com/items/ApulXErd/9836b0ab-adb8-43f3-aa25-a93b2e5273e0.png" >}}

在上图中，我们制作了一个用于识别选定屏幕区域文字的 macro，首先执行 Shell 脚本 `screencapture -ic`，在交互式模式下获取屏幕截图，并保存到剪贴板中，然后使用「OCR Image」action 对上一步系统剪贴板中的图片进行 OCR，选择的语言为「Apple Text Recognition」，最后将识别得到的文字保存到系统剪贴板中。

## 剪贴板历史记录仅显示图片

在 Keyboard Maestro 中，内置的剪贴板历史记录面板叫做「Activate Clipboard History Switcher」，快捷键为 `⌘ + ⌃ + ⇧ + V`，激活之后会出现下图所示的窗口。

{{< imgcap title="剪贴板历史记录面板" src="https://p15.p3.n0.cdn.getcloudapp.com/items/wbu5X8m4/acb180c5-578d-4e4c-b2cb-1d44fd5cb201.png" >}}

在 Keyboard Maestro 11 中，我们可以点击右上角的搜索框，在左侧点击下拉菜单，勾选「Images Only」或「Favorite Only」，只显示剪贴板历史记录中的图片或收藏过的条目。

关于剪贴板，Keyboard Maestro 11 还增加了一个名为「[Remove Clipboard Flavors](https://wiki.keyboardmaestro.com/action/Remove_Clipboard_Flavors)」的 action，用于从剪贴板中移除特定类型的数据，可以是系统剪贴板、Trigger Clipboard 或 Named Clipboard，如下图所示。

{{< imgcap title="「Remove Clipboard Flavors」action" src="https://p15.p3.n0.cdn.getcloudapp.com/items/E0umyKqk/2202b13b-5f02-4c04-b96e-97678d8b95ce.png" >}}

## 文本片段自定义弹窗

Keyboard Maestro 11 引入了一个名为「Prompt For Snippet」的全新 action，可以用来实现更加灵活的文本扩展。

{{< imgcap title="使用「Prompt For Snippet」实现文本扩展的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Wnup7kNQ/ca5655bb-9727-4db5-a2c7-231ace88ebf6.png" >}}

在上图中，我们在添加的「Prompt For Snippet」action 中填写了一封预设的邮件模板，内容如下：

```text
Hello %Ask20=curr_folder_name%,

Can you please contact me on %Ask10:Tuesday% at %Ask5:7:50% to discuss:

%Ask4%

Thanks!
```

在这段文字中，一共有 4 个占位符，也就是 Keyboard Maestro 中的 [%Ask%](https://wiki.keyboardmaestro.com/token/Ask) token：

- `%Ask20=curr_folder_name%`：20 个字符宽的文本字段，初始值来自变量 `curr_folder_name`
- `%Ask10:Tuesday%`：12 个字符宽的文本字段，初始值为 `Tuesday`
- `%Ask5:7:50%`：5 个字符宽的文本字段，初始值为 `7:50`
- `%Ask4%`：4 个字符宽的文本字段

容易发现，`%Ask%` token 的写法形如 `%Ask<Size><=Variable Name>` 或 `<:Default Value>%`。其中，`size` 是字符数或行数，默认为 20。因此，键入 `se/` 激活上面这个 macro，就会弹出如下图所示的窗口，我们只需修改或填写其中的文本框，最后点击「OK」，就可以快速插入一个邮件模板。

{{< imgcap title="文本片段自定义弹窗" src="https://p15.p3.n0.cdn.getcloudapp.com/items/yAun102G/7a1a502a-3451-4a7b-ba39-58dcac450c94.png" >}}

## 执行脚本的变化

Keyboard Maestro 11 带来了多项与脚本执行相关的改进。例如，现在支持在 AppleScript 的 smart groups 中使用 `macros`，以及在 AppleScript 脚本字段中通过 `option-Return` 插入 `¬` 字符，此外，AppleScript 的 `do script` 现在可以从 Return 操作中返回结果。默认情况下，新的「[Execute a JavaScript](https://wiki.keyboardmaestro.com/action/Execute_a_JavaScript_in_Front_Browser)」actions 使用现代语法，并且不包含任何变量，这是为了避免对网页内容产生不必要的干扰。此外，此次更新还新增了对限制传递给脚本的变量的支持，以及在变量标记数组项目分隔符中处理换行符 `\`。

除了以上这些脚本执行方面的更新，Keyboard Maestro 11 还提供了一个全新的命令行工具 `keyboardmaestro`，用于触发或编辑 macros。你可以打开终端，粘贴下面这行命令查看 `keyboardmaestro` 的帮助说明：

```bash
/Applications/Keyboard\ Maestro.app/Contents/MacOS/keyboardmaestro --help
```

其中 `/Applications/Keyboard\ Maestro.app/Contents/MacOS/keyboardmaestro` 是可执行文件 `keyboardmaestro` 的绝对路径，点击回车之后的输出结果如下：

```text
Usage: keyboardmaestro [options...] <macro name/uid>
-a, --async              Do not wait for macro to complete
-e, --edit               Edit the macro instead of triggering it
-h, --help               Show this help message
-p, --parameter <value>  Pass value as the parameter. Use `-` to read the value from stdin
-v, --verbose            Show debugging information
-V, --version            Show version number

This command will edit or trigger a Keyboard Maestro macro as specified.
The macro name can be the name of a unique macro, the UUID of a macro, or the XML of an action to execute.
In edit mode, macro name can be the name or UUID of a macro, macro group or smart macro.
```

{{< imgcap title="在终端中查看命令行工具 `keyboardmaestro` 使用说明" src="https://p15.p3.n0.cdn.getcloudapp.com/items/6quwzv5O/51cd4e2c-3a68-4554-bd61-11db2bbc780c.png" >}}

从 `keyboardmaestro` 的使用说明来看，我们可以使用它来触发或编辑 macros，支持通过 macro 名称、UUID 或要执行的操作的 XML 来指定。

## 新增的权限面板

由于 macOS 越来越收紧的 [系统权限](https://mastodon.social/@peternlewis/111061348410294060)，如今的 Mac 应用程序基本上都会把系统授权的功能列在一起并且提供文字说明，方便用户排查。在 Keyboard Maestro 11 中，设置面板（Preferences）中新增加了「Security」选项。

{{< imgcap title="新增的权限面板" src="https://p15.p3.n0.cdn.getcloudapp.com/items/2NuWmPXK/f896efbb-90a4-4131-b5ab-b6ab9a26f1e6.png" >}}

在「Security」选项下，包括下列这些可能需要用到的系统权限，你可以点击右侧的「Ask for Permission」授予权限，或者点击「Open System Settings」打开系统设置：

- 辅助功能：Accessibility Permission
- 屏幕录制：Screen Recording Permission
- 联系人：Contacts Permission
- 网页浏览器自动化与控制：Web Browser Automation and Control
- 安全输入模式：Secure Input Mode
- 应用程序迁移安全性：App Translocation Security

## 在所有 Mac 上的禁用 Macro Group

如下图中的「Disable On All Macs」所示，这是一个关于同步的设置，可以在所有 Mac 上禁用 macro group，它也会将该 macro group 在新添加的 Mac 默认设置为禁用。

{{< imgcap title="在所有 Mac 上的禁用 macro group 的选项" src="https://p15.p3.n0.cdn.getcloudapp.com/items/NQu5l7Dz/36334681-baae-4066-9742-5a3eb6045527.png" >}}

对于同时使用 Intel 和 Apple Silicon 芯片的 Mac 用户来说，这个功能非常实用，你可以默认勾选它，之后如果你需要在指定的 Mac 上启用，可以取消勾选这个选项。

## 新增警告或提示功能

- 报告被删除的 macro 是否被其他 macro 使用

由于 Keyboard Maestro 一个 macro 中可以执行另一个 macro，因此删除被执行的 macro 会导致 macro 执行失败，此次更新新增的删除提醒功能可以有效避免这个问题。

{{< imgcap title="删除被其他 macro 使用的 macro 时的提示信息" src="https://p15.p3.n0.cdn.getcloudapp.com/items/jku6XElq/7e1a1162-a309-45a4-bc05-2048baa4cb80.png" >}}

- Keyboard Maestro 运行时被移动时的警告

如果 Mac 上正在运行的应用程序被移动或重命名，可能会导致 [应用崩溃](https://weblog.rogueamoeba.com/2019/09/05/avoiding-crashes-caused-by-application-moves/) 或出现意外的状况。为了避免这个操作可能导致的问题，Keyboard Maestro 11 会在它被移动后弹出一个警告窗口，提示用户重启应用程序，如下图所示。

{{< imgcap title="移动 Keyboard Maestro 后的警告信息" src="https://p15.p3.n0.cdn.getcloudapp.com/items/geu1RpW0/a7b2a36a-4557-4cd6-84e5-5a67b35a7112.png" >}}

除了以上两项更新，Keyboard Maestro 11 还改进了浏览器相关操作中的错误检测，查找和定位操作浏览器相关 macro 的错误更加可靠，总的来说，此次更新对安全性和用户数据保护更加完善。

## 界面更新

- 在菜单栏选项中显示 macro 的图标

{{< imgcap title="在菜单栏选项中显示图标" src="https://p15.p3.n0.cdn.getcloudapp.com/items/qGuYORdD/d40f3720-c942-4275-ac2c-689b91dbc48b.png" >}}

Keyboard Maestro 11 新增了在菜单栏选项（Keyboard Maestro Engine）中显示 macro 的图标的选项，macro 之间的视觉差异更加明显，可以让用户更加快速地找到对应的 macro，提高点击速度。你可以在「Setting…… -\> General」中打开，如下图所示。

{{< imgcap title="勾选在菜单栏选项中显示 macro 图标的选项" src="https://p15.p3.n0.cdn.getcloudapp.com/items/L1u8Xe77/1d192380-3961-4287-a393-c2d07d63d2a4.png" >}}

- 显示激活的 Macro Group

如果你想要查看哪些 Macro Group 处于激活状态，在 Keyboard Maestro 11 中，可以点击菜单栏选项「Help -\> Show Active Macro Groups」，如下图所示。

{{< imgcap title="在「Help」菜单栏中点击「Show Active Macro Groups」" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Z4upArLY/0ec82b67-1cae-4a34-b2ef-568a04f9291d.png" >}}

如果 Keyboard Maestro Editor 处于未打开的状态，那么可以点击菜单栏中的 Keyboard Maestro Engine 图标中的「Show Active Macro Groups」，如下图所示。

{{< imgcap title="在「Keyboard Maestro Engine」图标中点击「Show Active Macro Groups」" src="https://p15.p3.n0.cdn.getcloudapp.com/items/mXuvxPB5/c92ca497-5642-45bc-8868-d44d2637ab37.png" >}}

- 在面板样式中新增 Blue Topaz 主题

在 Keyboard Maestro 的设置中，一共有 4 种面板类型（Palette）：

- Default Palette
- Global Macro Palette
- Application Palette
- Conflict Palette

{{< imgcap title="在 Keyboard Maestro 中设置面板样式" src="https://p15.p3.n0.cdn.getcloudapp.com/items/v1unOjDY/dfc0380f-04fd-4ca4-81f7-04563768a1ba.png" >}}

你可以双击上图中对应的面板，打开下图所示的「Theme Editor」，自定义面板主题样式，例如在下图中，我将「Default Palette Style」设置为 Keyboard Maestro 11 新增的「Blue Topaz」主题。值得一提的是，Keyboard Maestro 11 中的「Blue Topaz」主题 [来源于](https://forum.keyboardmaestro.com/t/custom-palette-style-colors/3516/28) 颇受欢迎的同名 [Obsidian 主题](https://github.com/PKM-er/Blue-Topaz_Obsidian-css)。

{{< imgcap title="Keyboard Maestro 面板的主题编辑窗口" src="https://p15.p3.n0.cdn.getcloudapp.com/items/llu80kD6/1069c72c-11bb-45bf-b7cd-bd37a5a94081.png" >}}

- 在进度条中显示「For Each」action 的自定义标题

在 Keyboard Maestro 10.x 中，点击「For Each」action 右上角的齿轮按钮，可以开启「Display Progress」选项。然而，在此前的版本中，即使用户将该 action 重命名，进度条窗口中仍然只会显示「Keyboard Maestro For Each Progress」，用户往往难以弄清楚究竟是哪个「For Each」action。

{{< imgcap title="在「For Each」action 中开启「Display Progress」选项" src="https://p15.p3.n0.cdn.getcloudapp.com/items/OAu78Gb8/6b77e796-f4e6-4e16-81dd-e9ba4523cf96.png" >}}

Keyboard Maestro 11 改进了这个进度条显示功能。在上图所示的 macro 中，我将「For Each」action 的标题修改为「Dump PDF Metadata」，并开启「Display Progress」。通过这样的设置，在运行该 macro 导出 PDF 元数据时，会弹出下图所示的一个窗口，显示 macro 的运行进度，标题为自定义的「Dump PDF Metadata Progress」，起到的提示效果更加明显。

{{< imgcap title="运行 macro 时的进度条窗口" src="https://p15.p3.n0.cdn.getcloudapp.com/items/9ZuLoREz/7b1f77cf-4b2e-4941-8434-a6c796da9260.png" >}}

- 移除显示文字窗口中的 `The text is`

在此前的版本中，如果在某些 action 中选择「Display text in a window」，那么运行 macro 之时弹出的窗口中，会在上方显示 `The text is`，如下图所示。

{{< imgcap title="获取前置应用程序 Bundle ID 的 macro" src="https://p15.p3.n0.cdn.getcloudapp.com/items/rRumOW9B/e12becbe-8def-409c-9dac-9b2904ac6017.png" >}}

{{< imgcap title="Keyboard Maestro 10.2 显示文字的弹出式窗口界面" src="https://p15.p3.n0.cdn.getcloudapp.com/items/12uQLPyj/0b45e2d7-7273-49f8-91a5-0dfc23511af9.png" >}}

Keyboard Maestro 11 改进了这个窗口的样式，更新后的显示效果如下图所示。可以看到，窗口上方的 `The text is` 被移除了，整个界面显得更加简洁，看上去更加现代。

{{< imgcap title="Keyboard Maestro 11 显示文字的弹出式窗口界面" src="https://p15.p3.n0.cdn.getcloudapp.com/items/bLuyBdeN/55fc5b07-933a-4495-99a5-6e039b50afd6.png" >}}

## 其他更新

除了以上这些更新外，Keyboard Maestro 11 还有很多其他值得关注的更新亮点。主要包括 triggers、actions 和 tokens 这 3 个方面。

**Triggers**:

- 桌面切换可以作为触发条件，也就是 [Space Changed Trigger](https://wiki.keyboardmaestro.com/trigger/Space_Changed)。
- 为 [Hot Key](https://wiki.keyboardmaestro.com/trigger/Hot_Key) 和 [USB Device Key](https://wiki.keyboardmaestro.com/trigger/USB_Device_Key) 触发器添加了只点击一次、两次或三次的选项，也就是说，可以通过点击快捷键不同的次数，来实现触发不同的 macro。
- 修饰键可以独立作为文本输入替换的触发键，比如可以键入 `e + m + ⇧` 来输入一段替换文本。

**Actions**:

- 新增创建日历事件（[Create Calendar Event](https://wiki.keyboardmaestro.com/action/Create_Calendar_Event)）action，可以直接在 Keyboard Maestro 中添加一个日历事件，或者与其他 action 结合使用。
- 允许在 [Prompt for User Input action](https://wiki.keyboardmaestro.com/action/Prompt_for_User_Input) 滑块中返回小数。
- 新增 [Send Pushover Notification](https://wiki.keyboardmaestro.com/action/Send_Pushover_Notification)，可以通过 Keyboard Maestro 发送 [Pushover](https://pushover.net/) 推送通知。
- 新增设置屏幕分辨率 action，即 [Set Screen Resolution](https://wiki.keyboardmaestro.com/action/Set_Screen_Resolution)。
- 新增按照名称选择菜单选项（[Select Menu by Name](https://wiki.keyboardmaestro.com/action/Select_Menu_by_Name)），而不再需要像以前那样在现有的菜单栏选项里进行选择。
- 新增 [Set Audio Device](https://wiki.keyboardmaestro.com/action/Set_Audio_Device) action，可以设置音频设备的输入、输出和音效。
- 新增 [Mute Audio Device](https://wiki.keyboardmaestro.com/action/Mute_Audio_Device) action，用于实现音频设备静音功能。
- 新增 [Get Location](https://wiki.keyboardmaestro.com/action/Get_Location) action，用于获取当前 Mac 所在位置的地理坐标。
- 执行 [Click at Found Image](https://wiki.keyboardmaestro.com/action/Move_or_Click_Mouse) 或 [Find Image on Screen](https://wiki.keyboardmaestro.com/action/Find_Image_on_Screen) action 时，新增「等待图片出现」（wait until the image appears）的选项，减少因为找不到目标图片而执行失败的可能。
- 支持在执行 [Get a URL](https://wiki.keyboardmaestro.com/action/Get_a_URL)、[Execute Script](https://wiki.keyboardmaestro.com/action/Execute_a_Shell_Script)/[Shortcut](https://wiki.keyboardmaestro.com/action/Execute_Shortcut)、[Plug In](https://wiki.keyboardmaestro.com/action/Plug_In) 等 actions 时，以多种格式将图片保存到剪贴板或文件中。

**Tokens**:

- 新增 [%Safari/Chrome/FrontBrowserWindowName%](https://wiki.keyboardmaestro.com/token/FrontBrowserWindowName) token，用于获取前置浏览器窗口名称。
- 新增 [%FrontDocumentPath%](https://wiki.keyboardmaestro.com/token/FrontDocumentPath) token，用于获取前置文档路径。
- 新增 [%ApplicationVersion/LongVersion%](https://wiki.keyboardmaestro.com/token/ApplicationVersion) token，用于获取应用程序的详细版本信息。
- 新增 [%AudioInputDevice(UID)%](https://wiki.keyboardmaestro.com/token/AudioInputDevice)、[%AudioOutputDevice(UID)%](https://wiki.keyboardmaestro.com/token/AudioOutputDevice) 和 [%AudioSoundEffectsDevice(UID)%](https://wiki.keyboardmaestro.com/token/AudioSoundEffectsDevice) tokens，用于获取音频设备的名称或 UID。
- 新增 [%MusicPlayerState%](https://wiki.keyboardmaestro.com/token/MusicPlayerState) token，用于获取音乐播放状态。
  
以上介绍了 Keyboard Maestro 11 的新功能，总的来说，操作逻辑没有大的变化，主要更新内容是增加了部分全新功能，以及针对现有功能的优化和改善。如果你此前使用过 Keyboard Maestro，那么可以通过本文了解一下此次大版本更新推出的新功能，如果你是第一次听说接触或听说 Keyboard Maestro 的话，希望本文能够帮助你「入坑」Keyboard Maestro，提升 Mac 使用效率。由于篇幅和时间的限制，本文无法对所有新功能一一介绍，如果你想要了解 Keyboard Maestro 11 的所有更新内容，可以前往 [Keyboard Maestro Wiki](https://wiki.keyboardmaestro.com/manual/Whats_New) 或 [Keyboard Maestro 论坛](https://forum.keyboardmaestro.com/t/keyboard-maestro-11-0/33598) 查看完整的更新日志。最后，如果你想要系统学习如何使用 Keyboard Maestro，欢迎购买我撰写的专栏《[Keyboard Maestro 拯救效率——完全上手顶级 Mac 自动化工具](https://sspai.com/series/350)》。
