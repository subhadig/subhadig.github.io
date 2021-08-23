---
layout: post
title: Functional Global Menu with Xfce Appmenu plugin
date: 2020-04-14
type: post
tags:
    - xfce
    - debian
comments: true
---
### Introduction
So finally after tinkering with it for a while now
I finally have got a very much functional global menu working
on my Xfce desktop running on Debian 10.
In this post I will explain the steps I followed to get it configured.

---
**Table of Contents**
* TOC
{:toc}
---

### Global menu vs Local menu
For those of you who might be wondering what a *global menu* is, it is a way of
displaying the application menus on the top of the screen like the way MacOS
does.
By default the Xfce desktop displays the menus right below the Window title
bar.

![Xfce4 window menu](assets/images/xfce4-default-window-menu.png)

But if you have a small display screen (eg. a laptop display), this may not be
the most efficient use of the vertical screen space.
The MacOS does a better job at this by displaying the application menus
directly on the top panel.

![MacOS app menu](assets/images/maos-default-window-menu.png)

Apart from MacOS, global menu was most prominently used in the
[Unity DE](https://en.wikipedia.org/wiki/Unity_(user_interface)) by Ubuntu.

### xfce4-appmenu-plugin

The Xfce plugin that makes it all possible is the `xfce4-appmenu-plugin`.
This plugin uses the implementation of Global menu used by the Unity DE and
supports all features found in the Unity implementation.
To install it on Debian, run

```
sudo apt install xfce4-appmenu-plugin
```

### Load GTK_MODULES="appmenu-gtk-module"

The `xfce4-appmenu-plugin` does not support every menu implementations out of
the box.
`appmenu-gtk-module` exports the unsupported menus to the supported format so
that `xfce4-appmenu-plugin` can consume them.
`appmenu-gtk-module` gets installed as a transitive dependency of the
`xfce4-appmenu-plugin` but it needs to be loaded on start.
To do that, edit the `/etc/environment` file with root permisson and append the
following:

```
GTK_MODULES="appmenu-gtk-module"
```

### Configure the top panel

![Xfce4 panel items](assets/images/xfce4-appmenu-plugin.png)

![Xfce4 panel separator](assets/images/xfce4-appmenu-plugin-separator.png)

### Conclusion
Having been used to a Mac on my work computer for quite some time now, there
are a few features I liked.
to replicate a few things related to MacOS on my personal laptop.
And the global menu was on top of that list.

//TODO Write about docks. I have not used any external docks.

IRC is still an excellent protocol for internet messaging.
It may never get its old popularity back but it has not lost all of its
usefulness even in today's age.
Matrix makes chatting over IRC and staying always connected easier than ever.
