---
layout: post
title: Moving My Blog to GitHub Pages from Wordpress.com
date: 2019-12-25
type: post
tags:
    - github-pages
comments: true
---
### Introduction
I recently moved my personal blog to GitHub Pages from
Wordpress.com. I have been thinking about doing it for
sometime and this time I finally did it. And in this post 
I wanted to share the a few things about it.

### What this post is and what it is not
This post talks about about how I made the switch to Jekyll and GitHub
Pages from Wordpress.com and the reasons behind it. It is 
not a rant about Wordpress.com.

### What are GitHub Pages?
GitHub Pages are public static webpages hosted and published through
GitHub, completely free of cost. The source code of
the website is also hosted in a public repository in GitHub.

### What is Jekyll?
Jekyll is a static site generator. Contents are written in simple
HTML or Markdown and it creates static HTML pages out of it. It uses Liquid,
a simple templating language which makes it very easy to have
custom templates designed for all your pages and when you run
Jekyll, it automatically combines the contents and the templates togethe
and creates the final static pages.

### Why Jekyll?
Although I did not do any extensive comparison between Jekyll and
the other similar solutions, Jekyll seemed one of the best
choice to start with because:
- GitHub Pages have supports for Jekyll out of the box.
- Although it is written in Ruby, it does not require any knowledge
of Ruby to use it.
- It seemed to have the right blend of simplicity and features.

### Why did I do it?
I have been blogging with Wordpress since 2011 and when I started,
it did seem one of the best choices out there. It's easy to start
with, it has a nice editor, there are a lots of ready-to-use themes 
to choose from, there is a vast community of users, so finding help was
never much difficult. But over the
years, my expectations about the way I blog have evolved, new needs
have emerged. Here are the main reasons why I made the switch.

#### Freedom
Although Wordpress.com has supports for themes and many aspects of the
themes are customizable, the free version does not allow one to
completely edit the themes and have a completely customized look and
feel. Often times I don't need all the bells and whistles that come
with a full blown theme but I want certain things in certain way.
For example, I like to show a page listing all my post titles and links
to my visitors which was apparently very hard to accomplish if not 
impossible with Wordpress.com.

#### Simplicity
With GitHub Pages and Jekyll, everything is very transparent. The whole
project is just a collection of a few markup files, images and configurations.
There is no database. There is no fancy editor. There is no bloat of 
features. Out of the box, you get nothing more than a static HTML page.
But it's easy to add the features you need whether they are natively 
available or by using third party services.

#### Vim and Markdown
Vim is my editor of choice and I extensively use it wherever I can. And when 
in some cases, I have to use another editor, I always look for ways to enable
vi like key bindings. 
Markdown is a simple markup language that makes it stupidly simple to write in
rich text and is way better than WYSIWYG editors in browser in my opinion.
Blogging with Jekyll and GitHub Pages gives me an option to use both vim and
markdown.

### How did I do it?
The starting point was to head over to the GitHub Pages 
[Getting Started](https://guides.github.com/features/pages/) 
page and follow the instructions for creating a project with one simple 
HTML page with one of their featured css themes. After that I followed the
[Step by step](https://jekyllrb.com/docs/step-by-step/01-setup/)
tutorial for setting up a Jekyll blog that walked me through from installing
Jekyll to creating HTML templates for the pages to writing my first blog post 
in markdown.

But at this point, the resulting site is so basic that if you are coming from
a feature-rich platform like Wordpress.com, you'll see a lot of missing features,
features that you always took for granted. Here you will have to add them
manually either by adding small snippets of code or plugins or by using third 
party services.

#### Site map
Site map is a dedicated link on your blog that will contain the list of pages and 
URLs from your blog. Adding a site map is effortless in Jekyll if you use the
[Jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap) plugin.

#### But what about comments?
An essential part of a blog site is the support for comments for the posts. But Jekyll
being a static site generator lacks inbuilt ability to support comments. For that, 
I used a third party service called [Disqus](https://disqus.com/). They offer a 
[Basic tier](https://disqus.com/pricing/)
that should be more than sufficient for a personal blog site.

#### But isn't the site looking empty?
So I imported my older posts from the previous blog to this one and with the
[Jekyll-import](https://import.jekyllrb.com/docs/wordpressdotcom/) plugin, it
was not much of a hassle. True, I had to do some editing to the imported posts
to fix a few style related issues.

#### Search engine optimization
[Jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) plugin automatically
generates metadata and tags for search engines and social networks sites for
better indexing. Also you can manually add tags and metadata to each posts.

### Is it worth it?
Absolutely. Now every time I want to write a new post, I just
need to do this in my terminal.

```
vim
<Type content in markdown>
git add
git commit
git push
```

And my new post post is published without ever having to leave the comfort of
the command line. Can it get any simpler than this?
