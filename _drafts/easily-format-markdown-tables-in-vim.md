---
layout: post
title: Easily format markdown tables in Vim
date: 2021-10-14
type: post
tags:
    - vim
    - markdown
comments: true
---
### Introduction
Creating tables in markdown in Vim is not very intuitive.
Out of the box Vim does not have the capability of formatting markdown tables.
Manually keeping them formatted is no less than a tedious job.
For reasons like these, I have avoided using tables in markdown for years.
But a good thing about Vim is that it's very easy to customize it and add new
functionalities.
Recently I spent some time to make the job of creating and keeping markdown
tables formatted in Vim a little easier.

---
**Table of Contents**
* TOC
{:toc}
---

### Vim plugins that could do the job
Although there were a handful of Vim plugins available out there that are
capable of formatting markdown tables, they seemed bloated to me with
additional functionalities that I do not need.
Here are a couple of plugins that I explored before coming up with a solution
of my own:
- [vim-easy-align](https://github.com/junegunn/vim-easy-align) - a very good
plugin for basically aligning anything in Vim.
- [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode) - another
good plugin which is for creating and formatting tables and has support for
markdown tables also.

### The script
So I wrote a very simple Python script that basically does three things:
1. Reads the markdown table as text from the standard Unix input.
2. Formats it so that the columns are all aligned properly.
3. Prints it in the standard output.

Here's the script:
{% gist 6083306f990fad35fd010aa8d0e60069 markdown_table_format.py %}

You can also download the script from my GitHub [here](https://github.com/subhadig/dotfiles/blob/f553b85f2a0496ffb5b420c17399267ba19b061f/nvim/scripts/markdown_table_format.py).

Now you may ask why use Python over Vimscript.
The reason is that I am more familiar with Python.
And I have a choice with Vim.

### Invoking the script from vim
Before invoking the script, you need to visually select the entire markdown
table in Vim.
Then the script can invoked manually from Vim like this from the command mode:
```
:!$HOME/workspaces/personal/dotfiles/nvim/scripts/markdown_table_format.py
```
But for ease, you should create a keymap like this in your `.vimrc` file for
Vim or in `init.vim` file for NeoVim:
```
vnoremap <localleader>mft :!$HOME/workspaces/personal/dotfiles/nvim/scripts/markdown_table_format.py<cr>
```
After this, the script can be invoked by just pressing `<Leader>mft` in visual
mode.

![Vim markdown format table](assets/images/vim-markdown-format-table.gif)

### Conclusion
Sometimes simple problems require simple solutions.
And I am not a fan of adding more plugins to my Vim configuration unless I am
very sure of the value they bring to the table.
And I am quite pleased with the result so far!
