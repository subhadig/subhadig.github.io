---
layout: post
title: Creating word documents on the command line
date: 2020-02-23
lastModifiedDate: 2020-05-10
type: post
tags:
    - command-line
    - pandoc
comments: true
---
### Introduction
The command line has always seemed to me something that is both fascinating and
under-utilized to a large extent at the same time.
Creating a document on the command line is easy and sometimes it is more
straightforward than using WYSIWYG tools like LibreOffice or MS Office or
Google Docs. In this post I share how I use Pandoc, Vim and Markdown for
creating good professional grade documents on the command line.

---
**Table of Contents**
* TOC
{:toc}
---

### Pandoc
From the [Wikipedia](https://en.wikipedia.org/wiki/Pandoc):

> Pandoc is a free and open-source document converter, widely used as a writing
tool and as a basis for publishing workflows.

Basically what Pandoc does is that it converts one document format to another.
It has a large array of
[supported document types](https://github.com/jgm/pandoc/blob/master/README.md#the-universal-markup-converter)
including Markdown, .doc and .pdf.

I will be using Pandoc for converting the raw documents to the final presentable
formats(pdf).

Something to note here is that Pandoc uses another software called
[Latex](https://www.latex-project.org/) internally to convert the raw
document files to some intermediate format before finally converting them to
the intended output format, which is PDF in this case. So some of the Latex
project packages will also be needed to be installed along with Pandoc in the next
section.

#### Installation
Pandoc and Latex packages are available in the official repository of almost
all major Linux distributions although the package names may vary.
Here's how I install them on Debian:

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

### Markdown
Markdown is a simple markup language that is easy-to-read and easy-to-write.
It first appeared in 2014 and over the years, it has gained acceptance in the
developer community and is widely used as a tool to write software
documentations and README files.

It has very intuitive syntaxes and it supports most of the common text stylings.
Markdown will be used here for writing the raw document files.

### Vim
[Vim](https://en.wikipedia.org/wiki/Vim_(text_editor))
is a fantastic text editor for the command line that needs little introduction.
It has inbuilt support for highlighting multiple languages including Markdown
among other things.
I use Vim as the editor for this job. But any capable
editor with Markdown support should be fine.

#### Installation
For Debian

```bash
sudo apt install vim
```

Or for MacOS HomeBrew

```bash
brew install macvim
```

### Connecting the pieces
Now that we have all the required tools for our job, here are the steps.

#### Create the document in Markdown in Vim (or any other editor)
Markdown has a very simple set of
[syntaxes](https://daringfireball.net/projects/markdown/syntax)
for styling the texts.
It's very straight-forward once you get the hang of it.
Although at times especially in the beginning you'd find yourself in situations
where you're not sure how to do certain things.
Here is a list of a few tricks that I learnt along the way:

##### Front matter
This is not really a part of the Markdown specifications but it's something that
is supported by Pandoc. If you want to include title, author and other metadata
in the document, there's a designated place for it. Insert a section like
below at the top of the document:

```markdown
---
title: My Super Important Document
author: Subhadip
---
```

You can include other metadata also like data, tags, description etc.

##### Resizing an image
Here's how you'd normally include an image in Markdown:

```markdown
![](media/my-awesome-image.png)
```
where *media/my-awesome-image.png* is the relative path to
*my-awesome-image.png* file.
Now if the image is too large or too small, you'd probably want to resize it.
The easiest way to do that is:

```markdown
![](media/my-awesome-image.png){width=50%}
```

You can specify *height* also along with *width*.

##### Block quotes
Block quotes are easy. Just put a *>* at the beginning of the line that you want
to include in the quote:

```markdown
> This is a quoted line.
> This is another quoted line.
```

Or if you are feeling lazy

```markdown

> This is a quoted line.
This is another quoted line.

```

If the first line in a paragraph starts with a *>*, then the whole paragraph
becomes quoted.

##### Code blocks
If you want to insert a code block inside, here's the way to do it:

~~~markdown
```python
print('I am a Python code!')
```
~~~

And during conversion, Pandoc will automatically create a code block and add
syntax highlighting based on the specified language type. Most common
languages are all supported.

Here is a 
[Markdown cheat sheet](https://www.markdownguide.org/cheat-sheet/) for you
if you are new to it. This official
[Pandoc manual](https://pandoc.org/MANUAL.html) contains plenty of
configuration options and tricks.

##### Tables
Tables in markdown is the only unintuitive feature that I have found so far.
Tables were not supported by the
[original markdown specifications](https://daringfireball.net/projects/markdown/)
designed by *John Gruber*. But
[Pandoc markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) is an
extended version of the original markdown that has support for tables.

Pandoc supports four formats to create tables. I prefer using the *pipe_tables*
format.

```markdown
Header 1 | Right aligned header | Left aligned header | Center aligned header
---------|---------------------:|:--------------------|:---------------------:
Value 1 | The quick brown fox jumps over the lazy dog | Another long text | 156.76
Value 1 | 60 | A string | The next row is a blank row
 | | |
```

When Pandoc converts it to PDF, it looks like this.
![pandoc table](assets/images/pandoc-table.png)

A few points about creating tables in markdown:
- The `|` character works as a delimiter between two cells.
- Leave a blank line above and below the table.
- Note the positions of the colons in the row below the header row in the table
definition. These colons determine if a column will be treated as right-aligned
or left-aligned.
- Merging cells are not allowed.

Although it works fine, creating complex tables should be avoided whenever
possible in my opinion.
Refer to the [Pandoc manual on tables](https://pandoc.org/MANUAL.html#tables)
to learn about the other table formats.

#### Convert the Markdown document to PDF using Pandoc
Now comes the fun part. I use the following Pandoc command to convert
Markdown files to PDF documents.

```bash
pandoc \
    -V geometry:margin=0.8in \       #Customize the margin
    -V fontsize:10pt \               #Customize the fontsize
    -V mainfont='DejaVu Serif' \     #Customize the main font
    -V monofont='DejaVu Sans Mono' \ #Customize the mono font
    -V urlcolor=blue \               #Customize the hyperlink color
    -V toccolor=NavyBlue \           #Customize the table of content color
    -s \                             #Create a standalone document, default when converting to PDF
    -N \                             #Number the sections
    --toc \                          #Generate table of content automatically
    -f markdown-implicit_figures \   #Input document type. 
    --pdf-engine=xelatex\            #The engine it will use for the conversion
    -o my-printable-document.pdf\    #Output document
    my-raw-document.md               #Input document
```

I use *markdown-implicit_figures* as the input file type instead of plain *markdown*
because it has better support for images. The default *pdf-engine* that Pandoc
uses is called *pdflatex* but I use *xelatex* because it provides a few
additional customization options including the font types.

This command may look a lot but it does not have to be. The additional options
I use are hardly something that I need to change daily. So I have created an alias
and stored it in my *.bashrc* or *.bash_alias* file and use the alias as the actual
command.

```bash
alias pandoc-convert-doc="pandoc \
                          -V geometry:margin=0.8in \
                          -V fontsize:10pt \
                          -V mainfont='DejaVu Serif' \
                          -V monofont='DejaVu Sans Mono' \
                          -V urlcolor=blue \
                          -V toccolor=NavyBlue \
                          -s \
                          -N \
                          --toc \
                          -f markdown-implicit_figures \
                          --pdf-engine=xelatex"

pandoc-convert-doc -o my-printable-document.pdf my-raw-document.md
```

### Conclusion
As with many other software, I started with the defaults and then changed
them according to my need. There are a lot of other configuration options
including header and footer settings available. Pandoc can also be instructed
to use custom Latex templates for the intermediate latex conversion it
does, this will give you even greater control on the document formatting.

To conclude, this solution may not have all the bells and whistles of the full featured
office suites but for quick reports or letters, it should be more than enough.
I have even read about people publishing e-books with Pandoc. The best advantage
in my opinion is that, it puts your focus back on the contents where it is
more required than the styling and presentation.
