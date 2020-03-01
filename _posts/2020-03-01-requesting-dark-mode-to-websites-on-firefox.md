---
layout: post
title: Requesting dark mode to websites on Firefox
date: 2020-03-01
type: post
tags:
    - firefox
comments: true
---
### Introduction
Most mainstream web-browsers including Firefox now-a-days come with a feature
where your browser sends your preferred colorshemes to websites when you visit
them.  If the website supports this feature, then you are presented with a
light or dark version of the website based on your preference. In this post I
will share how to manually configure it in Firefox.

---
**Table of Contents**
* TOC
{:toc}
---

### prefers-color-scheme
[prefers-color-scheme](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme)
is a CSS feature that can be used by websites to detect if the browser has
requested a light or a dark color theme. And if your browser sends the preference
of dark theme and if a visited website chooses to
implement an alternate dark CSS colorsheme then the web content will be
displayed in dark mode. Here are the allowed values for *prefers-color-scheme*:

```
no-preference
light
dark
```

Just to  mention, this is different from the browser extensions that
converts the web contents into dark mode on the client side.

### Automatic detection of preferred themes
If your browser has implemented this feature, then it should be
able to automatically  detect the preferred theme from your OS theme for
websites you are visiting . Here is the *duckduckgo.com* search website in
both dark and light mode.

#### Duckduckgo in dark mode
![duckduckgo in dark mode](assets/images/duckduckgo-dark-mode.png)
<br/>
<br/>

#### Duckduckgo in light mode
![duckduckgo in light mode](assets/images/duckduckgo-light-mode.png)
<br/>
<br/>

But sometimes this does not work properly where your browser fails to detect
the theme of your OS or you may want a different themes for your websites
and your OS.

### Manually updating the preferred colorscheme in Firefox
Here are the steps to manually configure Firefox to send dark colorscheme
preference.
1. Type *about:config* in the address bar of Firefox and press *Enter*.
2. Accept the warning.
3. Enter *ui.systemUsesDarkTheme* in the search box.
4. Select *Number* and click on the *+* button.
5. Enter *1* as the value and click on the tick button.

The steps for opting out the dark colorscheme preference is similar to the
above steps except for *step 5* where instead of *1*, enter *0* and save.

And now Firefox should automatically update the opened tabs with your
preferred colorsheme.

### Conclusion
These steps were tested on Firefox 73 (latest version at the time of writing
this post) on Debian Linux 10.

One thing I like about this feature is that it works even after you clear your
browser cache or when browsing in *Private* mode.

Based on your personal preference, you may or may not like the content of the
websites in dark mode but luckily Firefox provides a manual
configuration option to override the automatically detected preference.

### Resources
- [Firefox: How to test prefers-color-scheme? - Stack Overflow](https://stackoverflow.com/questions/56401662/firefox-how-to-test-prefers-color-scheme)
- [Can the system dark mode preference implemented in release 70.0 be changed? - Mozilla Support Forum](https://support.mozilla.org/en-US/questions/1271928)
