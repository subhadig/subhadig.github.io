---
layout: post
title: Preview markdown files from Vim - The easy way
date: 2020-11-28
type: post
tags:
    - vim
    - markdown
    - pandoc
comments: true
---
### Introduction
I primarily take notes in vim in markdown format.
The upside is that editing in vim is a pleasure.
But one downside of this approach is that my notes often contain images and
rich texts (as
opposed to plain texts) and vim out of the box is not a good tool to view
anything that is more than just text.
In this post, I discuss about how you can easily preview your markdown notes in
your browser directly from your vim editor with the help of a small vim script
and an utility called *pandoc* in just a couple of keystroke.
All without a fancy external vim plugin.

---
**Table of Contents**
* TOC
{:toc}
---

### My note-taking setup

Disclaimer: I actually now-a-days use [neovim](https://neovim.io/), a fully backward
compatible fork of vim that offers better out-of-the-box defaults and more
ease in configuring certain things compared to vim.
But the steps listed in this post should work well for both vim and neovim
and for the purpose of this post, I will use the terms vim and neovim
interchangeably.

Now that out of the way, I wanted to take a moment to describe my note-taking
setup.
My notes are written in markdown syntax and synced to a private repository on
my GitHub account so that I can access them from multiple computers.
And I use vim from a terminal to access and edit my notes.
This setup works because I mainly use traditional computers (laptops or desktops
as opposed to mobiles) for my note-taking.
If you have used vim as your full-time editor, they you'd probably know that
vim is awesome.
But one area where vim probably falls short is to display formatted text or
images.
And my notes have plenty of those.
I can view the formatted notes and images directly on GitHub if I want to, on
the website or by using the GitHub mobile app (GitHub is very good at
rendering markdown).
But it does make it a lot easier if I can preview the them directly on my local
computer without pushing them to GitHub first.

### Pandoc

[Pandoc](https://pandoc.org/) is the secret sauce in this solution.
*Pandoc* is a small command-line utility that champions
in text file conversion from one format to another.
I will be using *pandoc* to convert the markdown files to html for comfortably
viewing them in browsers.

To install *pandoc* on Debian Linux or a on Debian based Linux distribution, use

```
sudo apt install pandoc
```

Or on Mac with [Homebrew](https://brew.sh/), use

```
brew install pandoc
```

### The script

Here is the vim script in it's simplest form that will get the job done.

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
- Waits for any user key press to confirm that the converted html file has been
rendered in the browser, after which it deletes it (you don't want
your notes folder to be polluted with the converted html files).

The custom key binding tells vim to call the `MarkdownView()` function when
a combination of the leader key (by default mapped to the `\` key) and `v` is
pressed.

Add this script snippet to your `.vimrc` (`init.vim` if you use neovim).

You can replace the `firefox` command in the script with the full path to your
Firefox browser command or with a different browser altogether if you are not
a fan of Firefox.
For example on Mac, you may want to use the whole path
`/Applications/Firefox.app/Contents/MacOS/firefox` instead of just `firefox`.

If you are interested in having a common vimrc shared between your Linux and
Mac and intelligently detect the browser command based on the platform,
take a look at my nvim
[init.vim](https://github.com/subhadig/dotfiles/blob/master/nvim/init.vim)

Restart your vim or source your .vimrc for the changes to take effect.

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
same location as the markdown file, if I press the `\` (localleader) and `v`
keys, it will open the preview in my Firefox browser.

![kafka-on-docker-internal-clients](assets/images/vim-markdown-preview.png)

And now going back to vim, if I press `Enter`, it will place the cursor back
inside the editor.

### Conclusion

I am a fan of minimalism.
Even though there were a number of vim plugins available out there that would
have done job and some more,
the installations were not very straightforward and not necessarily
supported by the native vim package manager (which I use to manage the handful
of vim plugins that I use).
So instead I wrote my own solution which is simple, does not depend on
external dependencies that I wouldn't otherwise have in my system and gets
the job done.
And it only shows how powerful an editor vim is.
