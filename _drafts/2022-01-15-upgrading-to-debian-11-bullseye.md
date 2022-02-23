---
layout: post
title: Upgrading to Debian 11 Bullseye
date: 2022-01-15
type: post
tags:
    - debian
comments: true
---
### Introduction
Although Debian 11 codenamed *Bullseye* was released on
[14h August, 2021](https://www.debian.org/releases/bullseye/), 5 months back,
it was only in January, 2022 that I upgraded all my computers running
Debian 10 to Debian 11.
Admittedly a little late to the party, I like to take a cautious approach to
upgrading the system version, which is not very difficult to predict given my
Linux distribution of choice!
In this post, I am going to share the steps I used while doing the upgrade and
my experience.

---
**Table of Contents**
* TOC
{:toc}
---

### A word of caution
This post should not be considered a guide on how to do Debian upgrades.
The simple reason is that every system is configured differently and there is
no one guide that can cover all types of system configurations.
This post should give you some practical experience on how to go about it.
But it is strongly suggested that you go through the 
[Official Debian guide to upgrade from Debian 10](https://www.debian.org/releases/bullseye/amd64/release-notes/ch-upgrading.en.html))
before you actually do the upgrade.

### Plan for the worst
Even the best-laid plans can sometimes fail spectacularly.
So I can't stress enough on the importance of taking backup of important files
and directories before starting the upgrade process.
Additionally download the
[Live Install CD image](https://www.debian.org/CD/live/#live-install-stable)
for Debian 11 and follow the instructions to [prepare a USB stick with the CD
image](https://www.debian.org/releases/stable/amd64/ch04s03.en.html#usb-copy-isohybrid).
If things go sideways, you can always use the USB to live boot your system and
do investigations.

### Disable third party sources
If you have installed any third party packages (packages that do not come from
the official Debian repositories) in your system, it's always a good idea to
uninstall them before going the upgrade so that there are least chances of
interference.
You can install them back once your upgrade is complete.

To find out such packages, use the following command (you may need to install
`aptitude` if not already installed:
```bash
aptitude search '?narrow(?installed, ?not(?origin(Debian)))'
```

Uninstall the packages from the output list using the following command:
```bash
sudo apt remove <package-name(s)>
```

### Remove third party packages

### Update Buster system

### Remove obsolete packages

### Modify apt sources

### Start recording the session

### Update packages

### Dry run upgrade

### Minimal system upgrade

### Full system upgrade

### Purge removed packages

### Conclusion
