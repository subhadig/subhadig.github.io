---
layout: post
title: Preview markdown files from Vim - The easy way
date: 2020-11-07
type: post
tags:
    - vim
    - markdown
comments: true
---
### Introduction
I primarily take notes in vim in markdown format.
The upside is that editing in vim is a pleasure.
But a downside is that my notes often contains images and rich texts (as
opposed to plain texts) and vim is not a good tool to view anything that is
not just text.
In this post, I discuss about how with the help of a small vim script and an
utility called *pandoc*, you can easily preview your markdown notes in your
browser directly from your vim editor in just a couple of keystroke.
All without any fancy external vim plugin.

---
**Table of Contents**
* TOC
{:toc}
---

### My note-taking setup

Disclaimer: I actually use [neovim](https://neovim.io/), a fully backward
compatible fork of vim that offers betters out-of-the-box defaults and more
ease to configure certain things compared to vim.
But for the purpose of this post, I will use the term vim to mean both vim and
neovim.

Now that out of the way, I wanted to take a moment to describe my note-taking
setup.
My notes are synced to a private repository on my GitHub account so that I can
access them from multiple computers.
And I launch vim from a terminal to access and edit my notes.
This setup works because I use more traditional computers (laptops or desktops
as opposed to mobiles) for my note-taking.
If you have used vim as your full-time editor, they you'd probably know that
vim is awesome.
But one area where vim falls short is to show rich text or images.
I could view the notes directly on GitHub if I wanted to, on the web or
by using their mobile app (GitHub is very good at previewing markdown).
But it makes it a lot easier if I can preview the them directly from my local
computer without pushing them to GitHub first.

### Pandoc

[Pandoc](https://pandoc.org/) is a small command-line utility that champions
in text file conversion from one format to another.
I will be using *pandoc* to convert the markdown files to html for comfortably
viewing them in browsers.

To install *pandoc* on Debian or a Debian based Linux distribution, use

```
sudo apt install pandoc
```

Or on Mac using [Homebrew](https://brew.sh/), use

```
brew install pandoc
```

### The script

Here is the script in it's simplest form that will get the job done.

```vim
" View markdown files as HTML on browser
function! MarkdownView()
    execute "silent !" . "pandoc " . "%:p" . " -o " . "%:p" . ".html"
    execute "silent !" . "firefox" . "%:p" . ".html &"
    call getchar()
    execute "silent !" . "rm " . "%:p" . ".html &"
endfunction

" Custom key bindings
nnoremap <localleader>v :call MarkdownView()<cr>
```

The function `MarkdownView()` does the following things:

- Converts the currently opened file to html assuming that it is in markdown
using `pandoc`.
- Opens the converted html file in Firefox web browser.
- Waits for any user keypress to know that the converted html file has been
rendered in the browser, after which it deletes it (after all, I don't want
my notes folder to be polluted with the converted html files).

The custom key binding tells vim to call the `MarkdownView()` function when
a combination of the leader key (by default mapped to the `\` key) and v is
pressed.

Add this script to your `.vimrc` or `init.vim` file if you use neovim.

You can replace the `firefox` command in the script with the full path to your
Firefox browser command or with a different browser altogether if you are not
a fan of Firefox.
For example on Mac, you may want to use the whole path
`/Applications/Firefox.app/Contents/MacOS/firefox` instead of just `firefox`.

If you are interested in having a common vimrc shared between your Linux and
Mac and intelligently detect the browser command based on the platform,
take a look at my nvim
[init.vim](https://github.com/subhadig/dotfiles/blob/master/nvim/init.vim)

### Preview in action

Now that we have all the pieces ready, it's time to see them in action.
I have saved the following markdown content in a file from vim.

```markdown
# This is a header

## This is a subheader

**Bold**

*Italic*

![An image](a-grumpy-frog.png)
```

And assuming that the image file `a-grumpy-frog.png` is also present in the
same location as the markdown file, if I press the `\` and `v` keys, it will
open the preview in my Firefox browser.

![kafka-on-docker-internal-clients](assets/images/vim-markdown-preview.png)

### Conclusion

I am a fan of minimalism.
Even though there were a number of vim plugins available out there that would
have got the job done and some more,
the installations were not very straigtforward and they were not necessarily
supported by the native vim package manager.
So instead I wrote my own custom solution.
