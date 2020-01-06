---
layout: post
title: My list of things to do after installing Debian
date: 2019-12-25
type: post
tags:
    - debian
comments: true
---

I like the fact that Debian by default does not do a lot of customizations over
the upstream packages but this also means extra work for you for setting up
things after installing Debian. The upside is that you get to customize 
things exactly the way you like it. It definitely helps to have a list to start
with and this post lists some of the customizations I make after installing a 
fresh copy of Debian.

## Adding a swap file
Nowadays I prefer having swap files over swap partitions, mainly because files 
can be resized more easily than partitions. To create a swap file and use as
swap, execute the following commands:

```bash
sudo dd if=/dev/zero of=/swapfile bs=1024 count=$((4*1024*1024))
sudo chmod /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

And to reload the configuration after restart, append the following to 
*/etc/fstab*:

```
# Swap file created on DATE
/swapfile       none    swap    sw      0       0
```

More details can be found on the [Debian wiki](https://wiki.debian.org/Swap).

## Install updates and required packages
This section lists the packages that I absolutely need to have on my systems
and does not come pre-installed with Debian but the list can be different for
others.

```bash
sudo apt update
sudo apt upgrade
sudo apt install \
        tmux \
        vim \
        arc-theme \
        git \
        wget \
        menu-libre \
        bash-completion \
        chromium \
        bsd-mailx \
        unattended-upgrades \
        apt-listchanges
```

Here are the brief descriptions about the installed packages:
- tmux - I extensively use the Terminal for my workflow and tmux is a
multiplexer for the Terminal.
- vim - my text editor of choice.
- arc-theme - A nice GTK theme with three variants - normal, dark and darker.
- git - git command line client.
- wget - a download manager.
- menu-libre - a utility for editing menus.
- bash-completion - a utility for autocompletion on bash.
- chromium - the open source variant of the Google Chrome browser.
- bsd-mailx - a very simple mail client for Unix mails.
- unattended-upgrades - required for installation of automatic system updates.
- apt-listchanges - required by unattended-upgrades for sending change-list of
installed updates.

## Enable bash completion
Unlike some of the other distributions, tab-completion for bash is not enabled
in Debian by default. To enable it, uncomment the following section in
*/etc/bash.bashrc*:

```
```

## Enable auto-update
Unlike the Gnome and KDE variants of Debian, there is no pre-installed utility
for automatic installation of updates. I use *unattended-upgrades* for that.

## Add firewall rules
By default the Debian firewall policy allows all incoming and outgoing network
traffics. This is not necessarily insecure but I like restricting what goes in
and comes out of my system. Here are the steps to setup a very simple
firewall policy suitable for personal computers.

### Create a script with the required rules
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

### Add a systemd service
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

More information is available on the 
[Debian wiki](https://wiki.debian.org/DebianFirewall)

## Install latest Firefox
Debian comes with the ESR version of Firefox. To install the latest stable
version of Firefox, I use a bash script which is hosted on my GitHub.

```bash
git clone git@github.com:subhadig/firefox_updater.git
cd firefox_updater
/firefox-updater.sh
```

It downloads the latest tarball package of Firefox from the official site and
unpacks it under /opt. This script can also be used to update Firefox when a
new version is available.

Execute the following command to link the Firefox executable to 
*/usr/bin/firefox*:

```bash
sudo ln -s /opt/firefox/firefox /usr/bin/firefox
```

To create a launcher, paste the following content in 

## Generate ssh keys

## Enable showing user lists at login
Debian by default does not display the available usernames on graphical 
login screen but I like to show the list for easier selection of usernames.
To enable user lists at login for *lightdm*, my display manager of choice,
paste the following content in */etc/lightdm/lightdm.conf.d/01_my.conf*:

```
[Seat:*]
greeter-hide-users=false
```

## Create users
To create new users, use the following Debian command:

```bash
adduser <username>
```

To change/update passwords of users:

```bash
passwd <username>
```

## Desktop Environment specific customizations

### Panel customizations

### Update appearances

## Enable splash screen
