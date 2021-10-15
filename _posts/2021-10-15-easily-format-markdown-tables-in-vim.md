---
layout: post
title: Easily format markdown tables in Vim
date: 2021-10-15
type: post
tags:
    - vim
    - markdown
comments: true
---
### Introduction
Creating markdown tables in Vim is not very intuitive.
Out of the box Vim does not have the capability of formatting markdown tables.
And manually keeping them formatted is no less than a tedious job.
For reasons like these, I have for years avoided using tables in markdown.
But a good thing about Vim is that it's very easy to customize it and add new
functionalities.
Recently I spent some time to make the task of creating and keeping markdown
tables formatted a little easier in Vim.

---
**Table of Contents**
* TOC
{:toc}
---

### Vim plugins that could do the job
Although there were a handful of Vim plugins available out there that had the
ability to format markdown tables, they seemed bloated to me with
additional functionalities that I do not need.
Here are a couple of plugins that I explored before coming up with a solution
of my own:
- [vim-easy-align](https://github.com/junegunn/vim-easy-align) - a very good
plugin for basically aligning anything in Vim.
- [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode) - another
good plugin which is for creating and formatting tables in Vim and has support
for markdown tables also.

### The script
So I wrote a very simple Python script that basically does three things:
1. Reads the markdown table as text from the standard Unix input.
2. Formats it so that the columns of the table are all aligned properly.
3. Prints it in the standard output.

Here's the script:
{% gist 6083306f990fad35fd010aa8d0e60069 markdown_table_format.py %}

You can also download the script from my GitHub
[here](https://github.com/subhadig/dotfiles/blob/master/nvim/scripts/markdown_table_format.py).

Put the script somewhere on your computer from where you can invoke it.
I have conveniently stored it in my
[dotfiles](https://github.com/subhadig/dotfiles) directory.

Now you may ask why I wrote the script in Python instead of Vimscript.
The reasons are simple - I am more familiar with Python and with Vim I have a
choice!

### Invoking the script from Vim
Before invoking the script, you need to visually select the entire markdown
table in Vim.
Then the script can invoked manually from Vim like this in command mode:
```
:!/path/to/markdown_table_format.py
```
But for ease of use, you should create a keymap like this in your `.vimrc` file
for Vim or in `init.vim` file for NeoVim:
```
vnoremap <localleader>mft :!/path/to/markdown_table_format.py<cr>
```
After this, the script can be invoked by just pressing `<Leader>mft` in visual
mode.

![Vim markdown format table](assets/images/vim-markdown-format-table.gif)

### Conclusion
I am not a fan of adding plugins to my Vim configuration unless I am very
sure of the additional value they bring to the table.
And sometimes simple problems require simple solutions.
This was one such example.
