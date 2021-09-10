---
layout: post
title: Functional Global Menu with Xfce Appmenu plugin
date: 2021-09-10
type: post
tags:
    - xfce
    - debian
comments: true
---
### Introduction
After tinkering with it for a while now I finally have got a very much
functional global menu working on my Xfce4 desktop running on Debian 10.
I will list down the steps I followed to get the global menu configured on my
Debian Xfce box in this post.

---
**Table of Contents**
* TOC
{:toc}
---

### Global menu vs Local menu
For those of you who might be wondering what a *global menu* is, it is a way of
displaying the application menus on the top of the screen like the way MacOS
does.
By default the Xfce4 desktop displays the menus right below the Window title
bar separately in each Window.

![Xfce4 window menu](assets/images/xfce4-default-window-menu.png)

But if you have a small display screen (eg. a laptop display), this may not be
the most efficient use of the vertical screen space.
The MacOS does a better job at this by displaying the application menus on the
top panel.

![MacOS app menu](assets/images/maos-default-window-menu.png)

Apart from MacOS, global menu was most prominently featured in the
[Unity DE](https://en.wikipedia.org/wiki/Unity_(user_interface)) by Ubuntu.

### xfce4-appmenu-plugin
The Xfce plugin that makes it all possible is called the
`xfce4-appmenu-plugin`.
This plugin uses the same global menu implementation used by the aforementioned
Unity DE and supports all the features found in the Unity implementation.

To install the `xfce4-appmenu-plugin` on Debian, run

```
sudo apt install xfce4-appmenu-plugin
```

### Load appmenu-gtk-module on startup
The `xfce4-appmenu-plugin` does not support every menu implementations out of
the box.
The `appmenu-gtk-module` exports the unsupported menus to the supported format
so that `xfce4-appmenu-plugin` can display them.
`appmenu-gtk-module` is automatically installed as a transitive dependency of
the `xfce4-appmenu-plugin` but it needs to be loaded on start up.

To do that, edit the `/etc/environment` file with root permisson and append the
following:

```
GTK_MODULES="appmenu-gtk-module"
```

And restart the system.

### Configure the top panel
1. Edit the top panel and replace the `Windows Buttons` plugin with the `AppMenu
Plugin`.

![Xfce4 panel items](assets/images/xfce4-appmenu-plugin.png)

2. Edit the `Separator` plugin that appears right after the `AppMenu Plugin`
and uncheck the `Expand` option.

![Xfce4 panel separator](assets/images/xfce4-appmenu-plugin-separator.png)

Here's how it looks like in the end.

![Xfce4 panel with appmenu](assets/images/xfce4-appmenu-plugin-view.png)

### Conclusion
The steps have been tested in Debian 10.
This plugin is quite functional and I have rarely noticed any glitches for the
applications that I use day-to-day including LibreOffice.
One notable exception was [IntelliJ Idea](https://www.jetbrains.com/idea/).
Although it supports the global menu plugin but at times the menu will not be
automatically refreshed.
I need to switch to some other window and switch back to it so that the menu
items are refreshed.
