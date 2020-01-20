---
layout: post
title: Linux equivalent for MacOS open
date: 2020-01-20
type: post
tags:
    - command-line
comments: true
---
### Introduction
I have been using a Mac at my work for a few months now and there's one command
line utility
in MacOS that I am quite impressed with called *open*. In this post I talk about
a similar alternative in Linux world.

---
**Table of Contents**
* TOC
{:toc}
---

### What is *open*?
From the *open* man page:

> Open a file or folder.
>
> The open command opens a file (or a folder or URL), just as if you had
> double-clicked the file's icon. 

That is what it is, a command line utility for MacOS that will open a file or 
folder with
it's default application. It may not sound a lot but in reality it's very
handy. You don't need to remember what type of a file it is or what is the
preferred application to open these kind of files, you simply type:

```bash
open <file-name>
```

And it opens the file with the default application for its type in the 
background and leaves the prompt.

### Linux equivalent of *open*
Surprisingly in Linux world, there was already an available alternative with
the same functionality, it's called *xdg-open*. From the man page of
*xdg-open*:

> xdg-open opens a file or URL in the user's preferred application. If a URL is
> provided the URL will be opened in the user's
> preferred web browser. If a file is provided the file will be opened in the
> preferred application for files of that type.
> xdg-open supports file, ftp, http and https URLs.
> 
> xdg-open is for use inside a desktop session only. It is not recommended to
> use xdg-open as root.

Similar to *open*, *xdg-open* also opens the files in the background. The only
problem that I noticed with *xdg-open* is that although *xdg-open* does not
print anything on the screen by default when launched the actual applications
used to
open the file (eg. libreoffice) can sometimes, which may not what you would
want. To work around it, I have defined an alias in my *.bash_alias* file like
this:

```bash
which xdg-open 1>/dev/null && alias open='xdg-open 2>/dev/null'
```

The *which xdg-open 1>/dev/null* is useful if you share your *.bash_alias*
between Linux and other flavour of Unixes including MacOS. Also I have renamed it
to *open* so that I don't have to remember which OS I am on before opening
a file.
