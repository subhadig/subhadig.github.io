---
title: Neovim autocomplete for dictionary words
tags:
- neovim
---


I use the [coq_nvim](https://github.com/ms-jpq/coq_nvim) plugin in Neovim for
code completion.
But increasingly, more often than code, I find myself editing plaintext or
markdown files with Neovim.

The coq_nvim plugin mainly relies on the Neovim LSP feature to provide
autocompletion.
Additionally, it also has support for custom sources.
But the absence of dictionary words completion out-of-the-box in coq_nvim is
disappointing.

So I created a custom coq_nvim source for dictionary words completion over the
weekend.
I also published it as a Neovim plugin on my
[GitHub](https://github.com/subhadig/coq_words) for others to use.

The plugin internally uses the
[look](https://linuxcommand.org/lc3_man_pages/look1.html)
command for dictionary search before providing the autocomplete suggestions.
The `look` command is used for searching lines beginning with a given
string in a file.
When no input file is specified, `look` uses the `/usr/share/dict/words` file.
The `look` command is available out-of-the-box on MacOS and Linux.

The [words](https://en.wikipedia.org/wiki/Words_(Unix)) file contains a
newline-delimited list of dictionary words.
This file is
* available by default on MacOS
* provided by the `words` package on Arch Linux and the `wbritish` or
  `wamerican` packages on Debian/Ubuntu

The [coq_words](https://github.com/subhadig/coq_words) can be installed using
the Neovim native package manager or any other package manager of choice.
