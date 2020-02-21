---
layout: post
title: Creating documents on the command line
date: 2020-01-20
type: post
tags:
    - command-line
    - pandoc
comments: true
---
# Introduction
The command line has always seemed to me something that is both fascinating and
under-utilized at the same time to a large extent.
Creating a document on the command line is easy and sometime it is more
straightforward than using WYSIWYG tools like Libreoffice or MS Office or
Google Docs. In this post I share how I use pandoc, vim and markdown for
creating good professional grade documents using nothing but the command line.

---
**Table of Contents**
* TOC
{:toc}
---

# Pandoc
From the [Wikipedia](https://en.wikipedia.org/wiki/Pandoc):

> Pandoc is a free and open-source document converter, widely used as a writing
tool and as a basis for publishing workflows.

Basically Pandoc converts one document format to another. It has a large
array of
[supported document types](https://github.com/jgm/pandoc/blob/master/README.md#the-universal-markup-converter)
including markdown, .doc and .pdf.

I use Pandoc for converting the raw documents to the final presentable
formats(pdf).

Something to note here is that pandoc uses another software called
[Latex](https://www.latex-project.org/) internally to convert the raw
document files to some intermediate format before finally converting it to
the indended output format, which is pdf in this case. So some of the Latex
project packages will also need to be installed along with Pandoc in the next
section.

## Installation
Pandoc and Latex packages are available in the official repository of almost
all of major Linux distributions although the package names may vary.
Here's how I install it on Debian:

```bash
sudo apt install pandoc \
                 texlive \
                 texlive-pstricks \
                 texlive-latex-extra \
                 texlive-xetex
```

For MacOS, the required packages can be installed with
[HomeBrew](https://brew.sh/).

```bash
brew install pandoc
brew cask install mactex-no-gui
```

# Markdown
Markdown is a simple markup language that is easy-to-read and easy-to-write.
It first appeared in 2014 and over the years, it has gain acceptance in the
developer community and is widely used as a tool to write software
documentations and README files.

It has very intuitive syntaxes and supports most of the text styling.
I use Markdown for writing the raw document files.

# Vim
[Vim](https://en.wikipedia.org/wiki/Vim_(text_editor))
is a fantastic text editor for the command line that needs little introduction.
It has inbuilt support for highlighting multiple languages including Markdown
among other things.
I use Vim as the editor for creating the raw documents. But any capable
editor with Markdown support should do the job.

## Installation
For Debian

```bash
sudo apt install vim
```

or for MacOS HomeBrew

```bash
brew install macvim
```

# Stitching everything together


# Conclusion
