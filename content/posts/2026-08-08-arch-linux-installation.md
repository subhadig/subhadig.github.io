---
title: Switched to Arch Linux
tags:
- arch-linux
---


# BACKGROUND

After using Debian for almost 8 years on my laptop, I wiped it out a few
months back to install Arch Linux.
This post talks through the installation process and the story behind it.

DISCLAIMER

Duplicating the instructions from the
[Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
is not the intention of this post.
The Arch Linux installation guide has much more detailed and up-to-date steps
for a lot of hardware and software combinations.
This post merely talks about the steps I used and the package selection I made
for my hardware.
This is partly for my own future reference.

REASON FOR THE SWITCH

I started getting an intermittent hardware issue with my laptop after
upgrading to Debian 13 (Trixie) last year.
The laptop would abruptly shut down at boot.

Initally the occurances were rare.
But slowly the problem became more frequent.
I did a lot of advanced troubleshooting without any obvious outcome.
So as a last resort, I wanted to try another Linux distribution instead, to
dismiss any issue with Debian 13 itself.

WHY ARCH?

I wanted something that was:
1. upstream (rules out Ubuntu, Linux Mint or any other Debian derivative)
1. community-driven without the involvement of a corporate (rules out Fedora,
   openSUSE etc.)
1. mainstream (rules out Solus and the sorts)

I must say though, I didn't think I would choose:
1. a rolling release distribution (after all you'd hardly expect someone to use
   Debian stable for as many years as I have only to switch to Arch!)
1. a distribution without a guided installer (I had never installed a
   distribution manually before)

But surprisingly, I wasn't left with too many choices after the initial
screening.
Other than Debian, only Arch Linux and Gentoo made it to the list.
Arch Linux seemed less riskier option among the two!


# INSTALLATION

My laptop is a Dell Inspiron model.
It was one of those models that came with Ubuntu preinstalled.
But I had replaced it with Debian long back.
It was running Debian 13 at the time of the installation.

The installation used the GPT partitioning scheme.
The HDD had four partitions:
1. the root ("/") partition
1. the home ("/home") partition
1. the swap partition
1. the EFI partition

I didn't want to erase the existing home partition.
So I avoided repartioning and reused the existing partitions table.

For the installation, I followed the Arch Linux Installation Guide end to end.


## PHASE 1 - PREPARING FOR THE INSTALLATION

Booted the Arch Linux live install using a USB device.

A working internet connection is required for the installation.
I used the `iwctl` utility to connect to my wifi.

```
# Enter into the iwctl cli
$ iwctl

# List all available wifi devices
[iwd]# device list

# Scan and get available network list
[iwd]# station <device name> scan
[iwd]# station <device name> get-networks

# Finally, connect to the selected SSID
[iwd]# station <device name> connect <SSID>
```

After the internet connection is established, use `timedatectl` to ensure the
system clock is synchronized.

As mentioned earlier, I skipped the disk partitioning and directly jumped onto
formatting the partitions.

FORMATTING THE PARTITIONS

Use `fdisk -l` to see available partitions.

Formatted the root partition:
```
mkfs.ext4 /dev/root_partition
```
Then the swap partition:
```
mkswap /dev/swap_partition
```
And the EFI System partition:
```
mkfs.fat -F 32 /dev/efi_system_partition
```

MOUNTING THE FILE SYSTEMS

```sh
# Mounting the root partition
mount /dev/root_partition /mnt

# Mounting the home partition
mount /dev/home_partition /mnt/home

# Mounting the EFI System partition
mount --mkdir /dev/efi_system_partition /mnt/boot

# Swapon
swapon /dev/swap_partition
```


## PHASE 2 - INSTALLING THE BASE SYSTEM

These initial packages are needed for the system to boot.
My laptop uses an Intel processor, hence the intel-ucode package.

```
pacstrap -K /mnt base linux linux-firmware intel-ucode
```


## PHASE 3 - CONFIGURING THE SYSTEM

Generate the file-system table (and store in /etc/fstab):
```
genfstab -U /mnt >> /mnt/etc/fstab
```

Chroot into the new system:
```
arch-chroot -S /mnt
```

Set the timezone (Asia/Kolkata for me):
```
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
```

[Generate](https://www.man7.org/linux/man-pages/man5/adjtime_config.5.html)
the `/etc/adjtime` file:
```
hwclock --systohc
```

Enable automatic timesync:
```
systemctl enable systemd-timesyncd.service
```

Uncomment the appropriate locales in `/etc/locale.gen` to enable (`en_IN UTF-8` in my
case).
Run `locale-gen` to generate the locales.

Create `/etc/locale.conf`, set the LANG variable:
```
LANG=en_IN.UTF-8
```

Set a computer hostname in `/etc/hostname`.

CONFIGURE NETWORK CONNECTION

Install `networkmanager`:
```
pacman -S networkmanager
```

Enable NetworkManger.service:
```sh
systemctl enable NetworkManger.service
```

Connect to a network (wifi in my case):
```sh
# List available wifi devices
nmcli device wifi list

# Connect to a wifi device
nmcli device wifi connect <SSID> -a
```

Set a root password:
```
passwd
```

INSTALL BOOT LOADER

I used GRUB as the boot loader.

Install the required packages:
```
pacman -S grub efibootmgr
```

The following command installs GRUB to disk:
```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

For Dell laptops though, the above doesn't work.
Use the following
[workaround](https://wiki.archlinux.org/title/GRUB/Tips_and_tricks#UEFI_firmware_workaround)
command:
```
grub-install --target=x86_64-efi --efi-directory=/boot --removable
```

Finally, generate the GRUB configuration file:
```
grub-mkconfig -o /boot/grub/grub.cfg
```

Now exit the chroot environment and `reboot`.


## PHASE 4 - POST INSTALLATION

Add user and set password:
```
useradd -m <username>
passwd <username>
```

DESKTOP ENVIRONMENT

I use the Xfce4 desktop environment and the lightdm display manager.

Install them with the packages:
```
pacman -S xorg-desktop \
          xfce4 \
          xfce4-goodies \
          lightdm \
          lightdm-gtk-greeter

```

Xfce4-goodies is an optional group package.
It installs some of the Xfce4 recommended packages and applications (eg. a file
manager, a terminal emulator, some plugins).
But thankfully, not too many.

Also install the `xdg-user-dirs` package.
Then run `xdg-user-dirs-update` to create the XDG directories under the home
directory.

That's it.
Now install other applications as required.


# PARTING THOUGHTS

Installing Arch Linux made the boot failure issue much more rare on my laptop.
But it still happened once or twice,
likely a sign of weakening hardware components of a 10+ years old aging
laptop.
