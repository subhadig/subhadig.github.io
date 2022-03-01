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

### Remove third party packages
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

Also disable the third party sources.
The third party sources should have their own `.sources` files in the
`/etc/apt/sources.list.d` directory or added to the `/etc/apt/sources.list`
file.
Rename the `*.sources` files under the `/etc/apt/sources.list.d` directory by
appending `.disabled` at the end of the file names.
If any third party sources are added in the `/etc/apt/sources.list` file,
comment out the lines by prefixing them with a `#`.

### Update Buster system
Run the following commands to make sure that the Buster system is fully updated
before continuing with the upgrade.

```bash
sudo apt update
sudo apt upgrade
```

### Remove obsolete packages
To search for the obsolete packages, use following the command:

```bash
sudo aptitude search '~o'
```

And to remove, use:
```bash
sudo aptitude purge '~o'
```

### Modify apt sources
Before modifying the apt sources and updating to point to bullseye, make a copy
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

After this all the commands ran from the same terminal session and their
outputs will be recorded in those two files.
To exit the recording, simply enter `exit`.
After that, to replay the session later, use the following command:

```bash
scriptreplay ~/upgrade-bullseye.time ~/upgrade-bullseye.script
```

### Update package cache
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
Finally to fully upgrade the system, fun this command:

```bash
sudo apt full-upgrade
```

### Purge removed packages
Not very unexpected, the last two commands may take a long time to complete
depending on the Internet speed.
Once complete, use the following command to remove the left-over configuration
files for the removed packages during the upgrade:

```bash
dpkg -l | awk '/^rc/ { print $2 }'; sudo apt purge $(dpkg -l | awk '/^rc/ { print $2 }')
```

### Conclusion
