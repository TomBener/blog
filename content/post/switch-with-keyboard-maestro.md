---
title: 用 Keyboard Maestro 切换输入法和浏览器
date: 2023-01-20
categories:
  - Keyboard Maestro
---

{{< admonition title="🔖 Note" >}}
本文首发于 [少数派](https://sspai.com/post/77870)
{{< /admonition >}}

<br>

美国作家 [H. Jackson Brown Jr.][1] 说过一句很有名的话：

> Never make fun of someone who speaks broken English. It means they know another language.
> 
> ---
> 
> 永远不要取笑说蹩脚英语的人，因为这意味着他们懂另一门语言。

尽管这是一句给英语母语者的告诫，很多英语母语者对此也表示非常赞同，然而我第一次看见这句话时，心里却充满了对英语母语者的羡慕，因为他们可以几乎不需要切换键盘输入法。而作为一名中文母语者，在电子输入设备上切换英文和中文输入法，则是我每天的高频操作。

macOS 提供了切换输入法和浏览器的系统级方法，比如通过快捷键「[轮换][2]」输入法，或者使用 Caps Lock 键切换输入法。

{{< imgcap title="macOS 系统提供的切换输入法的方法" src="https://p15.p3.n0.cdn.getcloudapp.com/items/4gu4ROqm/da282f6a-6dd2-4c50-bb95-3249997bcf2b.png" >}}

然而，系统级的方案并不完美，基本上只是「还能用」的水平，当前使用的到底是哪种输入法，很多时候还是得靠「盲猜」，无法满足我的需求。正因如此，很多切换输入法的第三方应用应运而生，它们一般提供了更为丰富的功能，比如为每种输入法自定义一个快捷键，记住上次使用的输入法，显示当前的输入法，根据应用切换输入法等：

- [Kawa][3]
- [SwitchKey][4]
- [KeyboardHolder][5]
- [Input Source Pro][6]
- [自动切换输入法][7]

与切换输入法类似，切换系统默认浏览器也具有相同的问题。一般情况下，我们只能在 [系统设置][8] 中进行修改。

{{< imgcap title="在系统设置中切换默认浏览器" src="https://p15.p3.n0.cdn.getcloudapp.com/items/5zu2bdE9/3ace8ec6-bef8-400b-af13-e5271e6ebafb.png" >}}

与切换输入法不同的是，我们还可以直接在浏览器内的设置中将其设置为系统默认浏览器。

{{< imgcap title="在 Google Chrome 中将其设置为系统默认浏览器" src="https://p15.p3.n0.cdn.getcloudapp.com/items/X6u5n01X/50e91f7b-8b5b-41c3-8b0d-cb203987de05.png" >}}

然而，这两种方法都需要打开特定的应用程序，操作起来很麻烦。大概正是基于这样的痛点，市面上同样也有专门用于切换 macOS 默认浏览器的应用，比如：

- [Browser Ninja][9]
- [i-Picker][10]
- [OpenIn][11]

不过这几个 App 都是收费应用，对于切换默认浏览器这个简单的功能来说，价格也实在算不上便宜。

我派很多用户的原则是首选使用系统自带应用，也就是第一方应用，对于第三方应用表示谨慎。与此相比，我的原则稍微有一点不同：**尽量使用高质量的应用，不论是第一方还是第三方的**。按照我的标准，不少专门用于切换输入法和浏览器的应用都不能算是高质量的第三方应用，而它们提供的功能实际上可以通过高质量的应用来完成。

基于以上原因，本文尝试使用 macOS 自动化领域的佼佼者——[Keyboard Maestro][12] 来实现快捷切换输入法和浏览器的功能。需要指出的是，Keyboard Maestro 并非一个免费的应用，官网售价 36 美元，但考虑到 Keyboard Maestro 能够实现的丰富功能，个人认为这个价格相当值得，因此非常推荐入手。

## 切换输入法

在使用 Keyboard Maestro 切换输入法之前，我用的是 macOS 上强大的改键工具 [Karabiner-Elements][13]，并搭配 GitHub 上的 [一个配置][14]，可以实现「短按左 ⌘ Command 键切换为中文输入法，短按左 ⌥ Option 键切换为英文输入法」。我很喜欢这种方式，因为它让英文和中文输入法分别有了一个对应的快捷键，让我不用盲猜当前是什么输入法。形成肌肉记忆之后，输入英文前，短按一下左 ⌥ Option 键，输入中文前，短按一下左 ⌘ Command 键，打字时基本上不会出错。

{{< imgcap title="使用 Karabiner-Elements 切换输入法" src="https://p15.p3.n0.cdn.getcloudapp.com/items/rRu5m0YY/515fdb1b-a897-44fd-8c00-57b8c3d72d6e.png" >}}

然而，如这个配置文件所写的那样，这个方法的问题在于「可能会出现切换失败的情况」，我在实际使用过程中也经常遇到切换失败或延迟的情况，非常影响打字效率。也正是由于存在这个问题，我一直在寻找**快捷准确地切换输入法**的方法，于是将目光转向了 Keyboard Maestro。

Keyboard Maestro 中有一个叫作「Set Keyboard Layout」的动作，用于设置系统中已开启的输入法。与 Karabiner-Elements 相比，这个动作相当快速而且十分准确，我从没有遇到延迟或切换失败的情况。为了使用它，我们只需设置一个触发条件，就可以实现切换输入法的功能。你可以按照上面提到的 Kawa 那样，在 Keyboard Maestro 中选择触发条件为「Hot Key Trigger」，为每种输入法设置一个单独的快捷键（不仅限于英文和中文），但这种触发方式只能是组合快捷键，不能是单独的一个 ⌘ 或 ⌥ 等修饰键（Modifier Keys）。

{{< imgcap title="使用 Keyboard Maestro 切换英文 ABC 和中文双拼输入法" src="https://p15.p3.n0.cdn.getcloudapp.com/items/RBuBzlEZ/4e396027-1540-4d20-8bc5-e132f46721ac.png" >}}

由于切换输入法是一个相当高频的操作，为了找回熟悉的快捷切换方式，我没有使用快捷键触发，而选择的触发条件是「USB Device Key Trigger」，因为这样可以实现「**短按左 ⌘ Command 键，切换为中文双拼输入法，短按左 ⌥ Option 键，切换为英文 ABC 输入法**」，如下图所示。

{{< imgcap title="短按左 ⌘ Command 键，切换为中文双拼输入法，短按左 ⌥ Option 键，切换为英文 ABC 输入法" src="https://p15.p3.n0.cdn.getcloudapp.com/items/QwujBAqW/39509ae7-db36-476c-8069-c2065fbf63d0.gif" >}}

需要提醒的是，上面的 Keyboard Maestro 宏之所以会显示「Karabiner DriverKit VirtualHIDKeyboard 1.6.0」，是因为我安装了 Karabiner-Elements。另外，由于 ⌘ Command 是组合快捷键的修饰键，按下其他快捷键的时候也会触发切换输入法的操作，比如按下左边的 ⌘ Command + A，也会将当前输入法切换为中文。也就是说，无论单独还是组合按下 ⌘ Command/ ⌥ Option 键，都会触发切换输入法的操作，不过，好消息是这并不会影响快捷键的正常工作，因此并没有什么「副作用」。当然，如果你不喜欢单个修饰键的触发方式，可以根据键盘布局和个人偏好，设置为其他按键触发。

### 根据应用切换输入法

不少切换输入法的 App 可以「根据应用切换输入法」，这对于一些只需使用特定输入法的应用来说，非常实用，比如在 [iTerm][15]、[VS Code][16] 中，一般不需要使用中文输入法，只需要使用 ABC 输入法。借助 Keyboard Maestro 的「Set Keyboard Layout」动作，我们只需将触发条件设置为「特定应用激活时」，就可以非常简单地实现「根据应用切换输入法」这个功能，如下图所示。

{{< imgcap title="一打开 iTerm 就将输入法切换为 ABC" src="https://p15.p3.n0.cdn.getcloudapp.com/items/wbuv5KGW/7aff4711-c13d-4135-99dd-2de2a194e6f3.png" >}}

### 在浏览器地址栏切换为 ABC

在浏览器地址栏中，我们一般只会输入网址，因此希望光标定位到浏览器地址栏时，输入法自动切换为 ABC 输入法，而不是中文输入法。

尽管 Keyboard Maestro 无法将「[光标定位到浏览器地址栏][17]」作为触发条件，但我们可以用快捷键山寨一个类似的操作。在 Safari、Chrome、Firefox 等主流浏览器中，定位到地址栏的快捷键是 ⌘ Command + L，它的名称一般叫作「Open Location…」，因此可以将触发条件设置为快捷键 Command + L，然后将输入法切换为 ABC，再模拟按下快捷键 Command + L，如下图所示。

{{< imgcap title="在浏览器地址栏切换为 ABC 的 Keyboard Maestro 宏" src="https://p15.p3.n0.cdn.getcloudapp.com/items/YEuDzQxZ/d4c14de7-eec4-41b5-beaa-fe04949bd882.png" >}}

{{< imgcap title="使用快捷键定位到浏览器地址栏时切换输入法为 ABC" src="https://p15.p3.n0.cdn.getcloudapp.com/items/6quNwrme/a0be59f0-5c00-453e-af0e-f6297b8cc571.gif" >}}

关于切换输入法，还不得不提到 [Vim][18]，因为在 Vim 是基于英文开发的，在其中使用中文是一件非常痛苦的事。如果你在 Mac 上使用 Vim，想要提高使用中文输入的效率，推荐使用 [SmartIM][19] 这个插件，用于切换输入法。

## 切换浏览器

### 切换默认浏览器

Keyboard Maestro 论坛上有一位网友分享了一个切换系统默认浏览器的 [宏][20]，但它需要安装 [Xcode][21]，看起来非常复杂，因此我没有使用它。

{{< imgcap title="Keyboard Maestro 论坛中的一个切换浏览器的复杂的宏" src="https://p15.p3.n0.cdn.getcloudapp.com/items/geuO1oLP/d797b461-c1b4-4d49-a175-1e319fe7c1d4.png" >}}

但也是在 Keyboard Maestro 论坛上相关的讨论中，我发现了 [defaultbrowser][22] 这个命令行工具——用于切换 macOS 系统中的默认浏览器，可以使用 [Homebrew][23] 来安装它：

```shell
brew install defaultbrowser
```

你也可以下载源代码，然后自行构建并安装它：

```shell
make && make install
```

安装完成之后，在终端中输入 `defaultbrowser`，会输出 Mac 上已安装的所有浏览器的 HTTP handler，这可以看作是浏览器的编码。例如在我的 Mac 上，输出结果为：

```text
  chrome
  torbrowser
  firefox
  kagimacos
  browser
  iterm2
  downie-setapp
  folx3-setapp
  safari
  bettertouchtool-setapp
  edgemac
```

以上输出结果中，大多数名称都能直接看出是哪个浏览器，但也有几个不是那么明显，比如 `kagimacos` 是 [Orion 浏览器][24]，`browser` 是 [Arc 浏览器][25]，`edgemac` 是 [Microsoft Edge][26]。

知道了浏览器的编码，我们就可以通过 defaultbrowser 在命令行中来切换系统默认浏览器，例如设置为 Google Chrome：

```shell
defaultbrowser chrome 
```

按下回车键执行上面这行命令之后，Mac 会弹出一个二次确认窗口，询问你是否确定要切换默认浏览器，你需要手动点击切换或不切换。

{{< imgcap title="切换默认浏览器时 Mac 弹出的二次确认窗口" src="https://p15.p3.n0.cdn.getcloudapp.com/items/P8uNDmB4/adc51113-d7e1-499c-b6e0-afb92e12979a.png" >}}

为了避免每次都要手动点击这个弹出式窗口，我们可以借助 [下面的 AppleScript][27] 来自动进行确认：

```applescript
tell application "System Events"
  tell application process "CoreServicesUIAgent"
    tell window 1
      tell (first button whose name starts with "use")
        perform action "AXPress"
      end tell
    end tell
  end tell
end tell
```

因此，切换系统默认浏览器需要两个步骤（以切换为 Google Chrome 为例）：

1. 在终端中输入 `defaultbrowser chrome`
2. 执行 AppleScript 在弹出式窗口中进行确认

为了方便快捷地执行这两个步骤，我在 Keyboard Maestro 中创建了一个切换浏览器的宏组，其中有 7 个宏，分别切换为我的 Mac 中可能会用到的浏览器。

{{< imgcap title="Keyboard Maestro 中切换浏览器的宏" src="https://p15.p3.n0.cdn.getcloudapp.com/items/04uydNpb/f5e6a614-a4ff-4138-a2fe-271770a689cb.png" >}}

这 7 个宏的动作基本一致，都只有两个步骤，第一步执行 Shell 脚本切换默认浏览器，第二步执行 AppleScript 进行确认。需要注意的是，在 Keyboard Maestro 中执行 Shell 脚本，需要指定可执行文件的绝对路径，否则无法运行成功。由于我在 M1 Mac 上使用 Homebrew 安装 defaultbrowser，因此第一栏中写的是：

```shell
/opt/homebrew/bin/defaultbrowser browser
```

这 7 个宏设置的触发条件都是同一个快捷键 `⇧ + ⌥ + Right Arrow`，目的是为了利用 Keyboard Maestro 的 [Conflict Palette][28]，而这正是能实现快捷切换默认浏览器的关键。

{{< imgcap title="通过 Keyboard Maestro 的 Conflict Palette 切换默认浏览器" src="https://p15.p3.n0.cdn.getcloudapp.com/items/OAu27QKE/afbaafb7-56c2-4ed4-8cd3-23cbb1c9a70f.gif" >}}

在上面的演示图中，切换前的默认浏览器是 Safari，我一共按了两次键盘（有些按键没有被录制下来），将默认浏览器切换成了 Chrome。首先按下快捷键 `⇧ + ⌥ + Right Arrow`，由于这 7 个宏的触发方式都是这个快捷键，因此 Keyboard Maestro 会调出 Conflict Palette，将 7 个宏同时显示出来。

{{< imgcap title="按下快捷键后弹出的 Conflict Palette" src="https://p15.p3.n0.cdn.getcloudapp.com/items/Z4ump69r/83dff6ab-16ad-485d-8de1-5d3564c068b9.png" >}}

注意到每个宏名称的首字母是灰色的，与其他字母的颜色不同，而这就是它们的快捷键。因此我们直接在键盘上按下对应的字母，比如 `c`，就可以将默认浏览器切换为 Chrome [^1]，而完全不需要使用鼠标进行点击，不得不说，Keyboard Maestro 不愧为名副其实的「键盘大师」。

### 在另一个浏览器打开当前标签页

除了切换默认浏览器外，有时候我们也需要在特定浏览器中打开某些网页。例如，我主要使用 Safari，但为了在某些网页中使用 Chrome 浏览器上独有的插件，需要将 Safari 中当前打开的网页在 Chrome 中打开。当然，你可以选择在 Safari 中复制当前网页标签的链接，然后粘贴到 Chrome 的地址栏中打开，不过这显然不是一个高效的方法。借助 Keyboard Maestro，我们可以通过快捷键，一步实现「在另一个浏览器打开当前标签页」。

{{< imgcap title="在另一个浏览器打开当前标签页的 Keyboard Maestro 动作" src="https://p15.p3.n0.cdn.getcloudapp.com/items/xQuONYyE/26e1e8ec-ddc5-4dc8-8560-31d9d2e31f7e.png" >}}

上图中的这个宏通过快捷键 `⌃ + ⌥ + ⇧ + ⌘ + J` 触发，然后执行下面这段 AppleScript：

```applescript
tell application "Safari"
	activate
	set sameURL to URL of document 1
end tell
tell application "Google Chrome"
	open location (sameURL)
	activate
end tell
```

就可以将 Safari 中当前打开的网页窗口在 Chrome 中打开，当然，你也可以修改这段 AppleScript，用于其他浏览器。

{{< imgcap title="在 Chrome 中打开 Safari 中的当前标签页" src="https://p15.p3.n0.cdn.getcloudapp.com/items/OAu27Pk6/64a1162c-e59c-4e00-8488-8b4cceeba3d3.gif" >}}

## 小结

在 macOS 上，很多细小的功能没有提供系统级的支持，用户不得不选择安装第三方应用来实现。例如，为了隐藏太多的菜单栏图标，不得不安装 [Bartender][29] 或类似的免费替代品，为了像 Windows 一样通过右键新建文件，需要安装 [iBoysoft MagicMenu][30]。

尽管如此，单独下载一个 App 并非必选项，挖掘自动化应用的潜力，其实可以实现同样的功能，足以省下一些不必要的开支。例如 [BetterTouchTool][31] 就可以实现 [隐藏菜单栏图标][32] 的功能，而使用 [Alfred][33]，则可以通过键盘轻松 [新建文件][34]。

Keyboard Maestro 是 macOS 上一个非常强大的自动化应用，如果善加利用，足以代替很多不必要的 App。本文介绍了使用 Keyboard Maestro 在 Mac 上实现切换输入法和浏览器，这是两个很常见的需求，可以极大地提高使用 Mac 的效率，希望对你有所帮助。

[^1]:	在我的测试中，Firefox 需要使用大写字母 `F`，也就是点击 `Shift + F` 才能切换成功，其他浏览器使用小写的首字母即可。

[1]:	https://en.wikipedia.org/wiki/H._Jackson_Brown_Jr.
[2]:	https://support.apple.com/zh-cn/guide/mac-help/mh35591/mac
[3]:	https://github.com/hatashiro/kawa
[4]:	https://github.com/itsuhane/SwitchKey/
[5]:	https://keyboardholder.leavesc.com/zh-cn/
[6]:	https://inputsource.pro/zh-CN
[7]:	https://www.better365.cn/AutoSwitchInput.html
[8]:	https://support.apple.com/zh-cn/guide/safari/ibrwa008/mac
[9]:	https://apps.apple.com/us/app/browser-ninja/id995838410
[10]:	https://okaapps.com/product/1556461417
[11]:	https://loshadki.app/openin/
[12]:	https://www.keyboardmaestro.com
[13]:	https://karabiner-elements.pqrs.org/
[14]:	https://github.com/chavyleung/karabiner
[15]:	https://iterm2.com/
[16]:	https://code.visualstudio.com
[17]:	https://forum.keyboardmaestro.com/t/determining-if-focus-input-is-in-the-browser-address-bar/13813/2
[18]:	https://www.vim.org
[19]:	https://github.com/ybian/smartim
[20]:	https://forum.keyboardmaestro.com/t/change-default-browser-macro-v9-0-5/18558
[21]:	https://developer.apple.com/xcode/
[22]:	https://github.com/kerma/defaultbrowser
[23]:	https://brew.sh/
[24]:	https://browser.kagi.com
[25]:	https://arc.net
[26]:	https://www.microsoft.com/edge
[27]:	https://github.com/kerma/defaultbrowser/issues/3#issuecomment-319434425
[28]:	https://wiki.keyboardmaestro.com/Conflict_Palette
[29]:	http://www.macbartender.com
[30]:	https://iboysoft.com/magic-menu/
[31]:	https://folivora.ai/
[32]:	https://community.folivora.ai/t/how-to-do-a-bartender3-like-action-with-btt/18723
[33]:	https://www.alfredapp.com/
[34]:	https://github.com/zzhanghub/alfred-template-file
