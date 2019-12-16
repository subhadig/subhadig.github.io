---
layout: post
---
## Introduction
I recently moved my personal blog to GitHub Pages from
Wordpress.com. I have been thinking about doing it for
sometime and this time I finally did it. And I wanted to
share the inspiration behind it.

## What this post is and what it is not
This post explains about how I switched my blog to Github
Pages from Wordpress.com and the reasons behind it. It's most certainly is 
not a rant about Wordpress.com.

## What are GitHub Pages?
GitHub Pages are public static webpages hosted and published through
GitHub. And it is completely free of cost. The source codes of
the website are also hosted in a public repository in GitHub.

## What is Jekyll?
Jekyll is a static site generator. You write contents in simple
HTML or Markdown and it creates pages out of it. It uses Liquid,
a simple templating language which makes it very easy to have
custom templates designed for all your pages and when you run
Jekyll, it automatically combines the contents and the templates
and creates the final static pages.

## Why Jekyll?
Although I did not do any extensive comparison between Jekyll and
the other similar solutions, Jekyll seemed one of the best
choice to start with because
- GitHub Pages have supports for Jekyll out of the box.
- Although it is written in Ruby, it does not require any knowledge
of Ruby to use it.
- It seemed to have the right blend of simplicity and features.

## Why did I do it?
I have been blogging with Wordpress since 2011 and when I started,
it did seem one of the best choices out there. It's easy to start
with, has a nice editor, there are lots of ready-to-use themes 
to choose from, there is a vast community of users, so finding help was
never very difficult. But over the
years, my expectations about the way I blog have evolved, new needs
have arised. Here are the main reasons why I made the switch.

### Freedom
Although Wordpress.com has supports for themes and many aspects of the
themes are customizable, the free version does not allow one to
completely edit the themes and have a completely customized look and
feel. Often times I don't need all the bells and whistles that come
with a full blown theme but I want certain things in certain way.
For example, I like to show a page listing all my post titles and links
to my visitors which was apparently very hard to accomplish if not 
impossible with Wordpress.com.

### Simplicity
With Github Pages and Jekyll, everything is very transparent. The whole
project is just a collection of some markup files, images and configurations.
There is no database. There is no fancy editor. There is no bloat of 
features. Out of the box, you get nothing more than a static HTML page.
But it's easy to add the features you need whether they are natively 
available or by using third party services.

### Vim and Markdown
Vim is my editor of choice and I extensively use it wherever I can. And when 
in some cases, I have to use another editor, I always look for ways to enable
vi like key bindings. 
Markdown is a simple markup language that makes it stupidly simple to write in
rich text and is way better than WYSIWYS editors in browser in my opinion.
Blogging with Jekyll and Github Pages gives me an option to use both vim and
markdown.

## How did I do it?
The first thing I did was heading over to the Github Pages 
[Getting Started](https://guides.github.com/features/pages/) 
page and followed the instructions for creating a project with one simple 
HTML page with one of their featured css themes. After that I followed the
[Step by step](https://jekyllrb.com/docs/step-by-step/01-setup/)
tutorial for setting up a Jekyll blog that walked me through from installing
Jekyll to creating templates for 

## Is it worth it?
Absolutely. Now every time I want to write a new post, I just
need to do this.

    vim
    Write some markdown
    git add
    git commit
    git push

And my new post post is published. Can it get any simpler?
