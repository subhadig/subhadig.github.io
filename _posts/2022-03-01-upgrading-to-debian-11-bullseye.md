---
layout: post
title: Upgrading to Debian 11 Bullseye
date: 2022-03-01
type: post
tags:
    - debian
comments: true
---
### Introduction
Although Debian 11 codenamed *Bullseye* was released almost 7 months
back on [14th August, 2021](https://www.debian.org/releases/bullseye/), it was
only in January, 2022 that I upgraded all my computers running Debian 10 to
Debian 11.
Admittedly a little late to the party, I like to take a cautious approach to
upgrading my systems, which is not very difficult to predict given my Linux
distribution of choice!
In this post, I am going to share my experience and the steps I used while
doing the actual upgrade.

---
**Table of Contents**
* TOC
{:toc}
---

### A word of caution
This post should not be considered as a guide about how to do Debian upgrades.
The simple reason is that every system is configured differently and there is
no one guide that can cover all types of system configurations.
So what worked for me may not work for your systems.
This post should give you some practical experience on how to go about it and
the obvious pitfalls.
But it is strongly suggested that you go through the 
[Official Debian guide to upgrade from Debian 10](https://www.debian.org/releases/bullseye/amd64/release-notes/ch-upgrading.en.html)
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
diagnose the problems and even recover.

### Remove the third party packages and sources
If you have installed any third party packages (packages that do not come from
the official Debian repositories) in your system, it's always a good idea to
uninstall them before doing the upgrade so that there are least chances of
surprises.
You can install them back once your upgrade is complete.

To find out such packages, use the following command (you may need to install
`aptitude` if not already installed):
```bash
aptitude search '?narrow(?installed, ?not(?origin(Debian)))'
```

Uninstall the packages from the output list using the following command:
```bash
sudo apt remove <package-name(s)>
```

Also disable the third party sources.
The third party sources should have their own `.sources` files in the
`/etc/apt/sources.list.d` directory or added to the `/etc/apt/sources.list`
file.
Rename the `*.sources` files under the `/etc/apt/sources.list.d` directory by
appending `.disabled` at the end of the file names.
If any third party sources are added in the `/etc/apt/sources.list` file,
comment out the lines by prefixing them with a `#`.

### Update the Buster system
Run the following commands to make sure that the Buster system is fully updated
before continuing with the upgrade.

```bash
sudo apt update
sudo apt upgrade
```

### Remove the obsolete packages
To search for the obsolete packages, use following the command:

```bash
sudo aptitude search '~o'
```

And to remove, use:
```bash
sudo aptitude purge '~o'
```

### Modify the apt sources
Before modifying the apt sources to point to the bullseye release, make a copy
of the existing `/etc/apt/sources.list` file.

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.buster
```

After this, open the `/etc/apt/sources.list` file as root with your favourite
text editor and replace the following:
- `buster/updates` with `bullseye-security`.
- `buster` with `bullseye` in the remaining places.

### Start recording the session
It's a good idea to record the terminal session when the upgrade is running.
If something goes wrong, the session can be replayed to debug the issue.
To record the session, an utility called `script` will be used.
Install it if it is not already installed.

To start the recording, use this command:

```bash
script -t 2>~/upgrade-bullseye.time -a ~/upgrade-bullseye.script
```

After this all the commands are run from the same terminal session and their
outputs will be recorded in those two files.
To exit the recording, simply enter `exit`.
After that, to replay the session later, use the following command:

```bash
scriptreplay ~/upgrade-bullseye.time ~/upgrade-bullseye.script
```

### Update the package cache
Update the APT's package cache with the bullseye package information:

```bash
sudo apt update
```

### Dry run upgrade
Before running the actual upgrade, do a dry run of the upgrade process to make
sure that there are sufficient disk spaces for doing the upgrade.

```bash
sudo apt -o APT::Get::Trivial-Only=true full-upgrade
```

### Minimal system upgrade
While the upgrade can be done in one go, I prefer to do it in two steps.
In the first step, do minimal system upgrade where only the installed packages
are upgraded and no new packages are installed or existing packages are
removed.

```bash
sudo apt upgrade --without-new-pkgs
```

### Full system upgrade
Finally to fully upgrade the system, run this command:

```bash
sudo apt full-upgrade
```

### Purge removed packages
The last two commands may take a long time to complete depending on the
Internet speed.
But once complete, use the following command to remove the left-over
configuration files from the removed packages during the upgrade:

```bash
dpkg -l | awk '/^rc/ { print $2 }'; sudo apt purge $(dpkg -l | awk '/^rc/ { print $2 }')
```

### Restart the system
You should restart the system at the end of the upgrade so that the system can
boot with the shiny new packages and the kernel.

### Conclusion
That's it.
Run the command: `cat /etc/debian_version` to print the Debian version you are
currently on and hopefully it will print 11.

The upgrade process in Debian is not as straight forward as you would see in
many other Linux distributions that ship with specific tools that hide the
complexities and automatically take care of the system upgrades.
But in my opinion the Debian way gives you greater control and more insight
into how your system is upgraded, which in turn will help you diagnose the
problems should something go wrong.
