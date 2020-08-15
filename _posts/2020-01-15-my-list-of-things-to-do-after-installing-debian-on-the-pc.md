---
layout: post
title: My list of things to do after installing Debian on the PC
date: 2020-01-15
type: post
tags:
    - debian
comments: true
---
### Introduction
I like the fact that Debian does not do a lot of customizations over
the upstream packages by default but this also means extra work for you for setting up
things after installing Debian on the PC. The upside is that you get to customize 
things exactly the way you like it. It definitely helps to have a list to start
with and this post lists some of the customizations I make after installing a 
fresh copy of Debian.

---
**Table of Contents**
* TOC
{:toc}
---

### Adding a swap file
Nowadays I prefer having swap files over swap partitions, mainly because files 
can be resized more easily than partitions. To create a swap file and use as
swap, execute the following commands:

```bash
sudo dd if=/dev/zero of=/swapfile bs=1024 count=$((4*1024*1024)) #create an empty file of size 4GB
sudo chmod 600 /swapfile #restrict the permissions of the file
sudo mkswap /swapfile #convert the file type to a swap file
sudo swapon /swapfile #use the file as swap
```

And to reload the swap configurations after restart, append the following to 
*/etc/fstab*:

```
# Swap file created on DATE
/swapfile       none    swap    sw      0       0
```

More details can be found on the [Debian wiki](https://wiki.debian.org/Swap).

### Install updates and required packages
This section lists the commands to install the packages that I absolutely
need to have on my system and does not come pre-installed with Debian.

```bash
sudo apt update
sudo apt upgrade
sudo apt install \
        tmux \
        vim \
        arc-theme \
        git \
        wget \
        bash-completion \
        chromium \
        bsd-mailx \
        unattended-upgrades \
        apt-listchanges
```

Here are the brief descriptions about the installed packages:
- tmux - tmux is a multiplexer for the Terminal. I spend a lot of time on the
Terminal and tmux makes it easy to manage multiple open Terminals.
- vim - my text editor of choice.
- arc-theme - A nice GTK theme with three variants - normal, dark and darker.
- git - git command line client.
- wget - a download manager.
- bash-completion - a utility for autocompletion on bash.
- chromium - the open source variant of the Google Chrome browser.
- bsd-mailx - a very simple mail client for Unix mails.
- unattended-upgrades - required for installation of automatic system updates.
- apt-listchanges - required by unattended-upgrades for sending change-list of
installed updates.

### Enable bash completion
Unlike some of the other Linux distributions, tab-completion for bash is not enabled
in Debian by default. To enable it for all the users, uncomment the following
section in */etc/bash.bashrc*:

```bash
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

```

### Enable auto-update
The Gnome and KDE variants of Debian come with pre-installed utilities
for automatic installation of system updates but not the XFCE variant, the one
that I use. But it can be achieved through *unattended-upgrades*.

To enable unattended upgrades, make sure that the in the
*/etc/apt/apt.conf.d/50unattended-upgrades* file the following section has
at least the *Debian* and *Debian-Security* lines uncommented:

```
Unattended-Upgrade::Origins-Pattern {
    // Codename based matching:
    // This will follow the migration of a release through different
    // archives (e.g. from testing to stable and later oldstable).
    // Software will be the latest available for the named release,
    // but the Debian release itself will not be automatically upgraded.
    //      "origin=Debian,codename=${distro_codename}-updates";
    //      "origin=Debian,codename=${distro_codename}-proposed-updates";
    "origin=Debian,codename=${distro_codename},label=Debian";
    "origin=Debian,codename=${distro_codename},label=Debian-Security";

    // Archive or Suite based matching:
    // Note that this will silently match a different release after
    // migration to the specified archive (e.g. testing becomes the
    // new stable).
    //      "o=Debian,a=stable";
    //      "o=Debian,a=stable-updates";
    //      "o=Debian,a=proposed-updates";
    //      "o=Debian Backports,a=${distro_codename}-backports,l=Debian Backports";
};

```

To enable update reports over mail, uncomment the following section and add
the user to which the reports should be sent:

```
Unattended-Upgrade::Mail "subhadip";
```

### Add firewall rules
By default the Debian firewall policy allows all incoming and outgoing network
traffics. This is not necessarily insecure but I prefer restricting what goes in
and comes out of my system. Here are the steps to setup a very simple
firewall policy suitable for personal computers.

#### Create a script with the required rules
Paste the following content in */etc/firewall/enable.sh*:

```
#!/bin/sh
# A very basic IPtables / Netfilter script /etc/firewall/enable.sh

PATH='/sbin'

# Flush the tables to apply changes
iptables -F

# Default policy to drop 'everything' but our output to internet
iptables -P FORWARD DROP
iptables -P INPUT   DROP
iptables -P OUTPUT  ACCEPT

# Allow established connections (the responses to our outgoing traffic)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow local programs that use loopback (Unix sockets)
iptables -A INPUT -s 127.0.0.0/8 -d 127.0.0.0/8 -i lo -j ACCEPT

# Uncomment this line to allow incoming SSH/SCP conections to this machine,
# for traffic from 10.20.0.2 (you can use also use a network definition as
# source like 10.20.0.0/22).
# iptables -A INPUT -s 10.20.0.2 -p tcp --dport 22 -m state --state NEW -j ACCEPT
```

To make the script executable, run:

```bash
sudo chmod +x /etc/firewall/enable.sh
```

#### Add a systemd service
This is required for automatically loading the rules at startup. Paste the
following content in */etc/systemd/system/firewall.service*:

```
[Unit]
Description=Add Firewall Rules to iptables

[Service]
Type=oneshot
ExecStart=/etc/firewall/enable.sh
#ExecStart=/etc/firewall/enable6.sh  #For IPV6

[Install]
WantedBy=multi-user.target
```

#### Enable the service
Run the following command:

```bash
systemctl enable firewall.service --now
```

More information is available on the 
[Debian wiki](https://wiki.debian.org/DebianFirewall)

### Install latest Firefox
Debian comes with the ESR version of Firefox. To install the latest stable
version of Firefox, I use a bash script which is hosted on my GitHub account.
Here are the steps to clone the script and install Firefox.

```bash
git clone git@github.com:subhadig/firefox_updater.git
cd firefox_updater
/firefox-updater.sh
```

It downloads the latest tarball package of Firefox from the official site and
unpacks it under /opt. This script can also be used to update Firefox when a
new version is available.

The script already links the *firefox* executable to */usr/bin/firefox-latest*
to make sure that it's on the PATH.
Execute the following command to also link it to */usr/bin/firefox*:

```bash
sudo ln -s /opt/firefox/firefox /usr/bin/firefox
```

To create a launcher, create the file
*/usr/share/applications/firefox.desktop* with the following content:

```
[Desktop Entry]
Version=1.1
Type=Application
Name=Firefox
GenericName=Web Browser
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Exec=/usr/bin/firefox-latest %u
Actions=new-window;new-private-window;
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
Categories=Network;WebBrowser;
Keywords=web;browser;internet;
StartupNotify=true

[Desktop Action new-window]
Name=New Window
Exec=/usr/bin/firefox-latest --new-window %u

[Desktop Action new-private-window]
Name=New Private Window
Exec=/usr/bin/firefox-latest --private-window %u

```

### Enable showing user lists at login
Debian by default does not display the available usernames on graphical 
login screen but I like to show the user list so that usernames can easily be
selected at login.
To enable user lists at login for *lightdm*, my display manager of choice,
paste the following content in */etc/lightdm/lightdm.conf.d/01_my.conf*:

```
[Seat:*]
greeter-hide-users=false
```

### Create users
To create new users, use the following Debian command:

```bash
adduser <username>
```

To change/update passwords of the created users:

```bash
passwd <username>
```

### Desktop Environment specific customizations
I use XFCE as the desktop environment. So the customizations here are specific
to XFCE only.

#### Panel customizations
By default XFCE comes with two panels, one at the top and one at the bottom of
the screen. I
move the bottom panel which is a launcher for applications to the left. Also in
the top panel, I make the following changes:

- Add the following plugins:
    - Whisker Menu
    - System Load Monitor
    - PulseAudio Plugin
- Remove the following plugins
    - Applications Menu
    - Workspace Switcher

#### Update appearances
This section includes changing themes, updating fonts settings and general 
look and feel of the desktop.

- Change the theme: I use *ark-darker* theme for both the desktop and the windows.
Also I move the window's controls (minimize, maximize and close buttons) to
the left to mimic the MacOS behaviour.
- Change the font settings: Fonts on Debian do not look the best out of the
box. This is how my font settings looks like:

![XFCE font settings](assets/images/debian-after-install-xfce-font-settings.png)

I usually play with the *Hinting* and *Sub-pixel order* settings till I get the
best combination because these settings is dependent on the hardware and can
vary from one hardware combination to another.

### Conclusion
The steps are tested on a Debian 10 Buster installation.
The choices made in this post are based on my personal needs and taste, it will
almost certainly be different for other users. So the steps shared in this
post should not be
followed without understanding what they do and if they are required for your case.
For me, this post will definitely make it easier when next time I install
Debian on a new system.
