---
layout: post
title: A practical guide to get started with Pass
date: 2023-04-22
type: post
tags:
    - command-line
    - pass
comments: true
---
### Introduction
In my recent endeavour to upgrade my digital security, I started using the
[Pass](https://www.passwordstore.org/),
the command-line based password manager for my online accounts.
While there were a few online guides that I could find to get started with Pass,
I did have a feeling that a comprehensive guide for new users was missing.
In my attempt to fill the gap, I will try to touch upon various aspects that one
needs to be mindful of to use pass in the most secure and optimal way.

---
**Table of Contents**
* TOC
{:toc}
---

### Why a (dedicated) password manager
The days are over when you remembered the passwords for your online accounts.
In this age virtually for every other service, you need to use an online
account.
And even though many services are offering multi-factor authentication (MFA)
today for securely logging into your accounts, the importance of a strong
password is still as high as ever.
And the best security practice says that the passwords are strongests when they
are as random as possible, something that an average human mind can neither
create nor remember easily.
And this is where the importance of a password manager lies.
It's far easier to rather lock all your keys behind a master lock and have one
very secure key than to carry around separate keys for all the locks with you.

But when in today's age effectively all major browsers provide password storage
and sync features, it may not sound very practical to have separate piece of
software for storing your passwords.
There can be 
[arguments](https://www.howtogeek.com/447345/why-you-shouldnt-use-your-web-browsers-password-manager/)
on both sides but it's generally a more secure practice to not give too many
responsibilities to one software and trust a browser for what it does best -
browse the internet.

### Why Pass
Pass is a command-line password manager.
It may not sound very attactive compared to various cloud-based alternatives
that are available today especially if you are not a command-line person but the
main power of Pass comes from it's simplicity and transperency.
At it's core, Pass does not do much by itself and makes use of other unix
software that are already available and are industry standards.
Namely it uses gpg for encryption of the stored passwords and git for version
control and cloud syncing.

Another reason to use Pass is if you are not too inclined to blindly trust a
cloud-based and closed-source password manager.

### GPG key for Pass
Before we can use Pass, the very first step is to create a GPG key that will be
used by Pass if you don't already have one or you don't wish to reuse the
existing one(s).
If you are using a Linux or Mac system, chances are that GPG is already
installed in your system. Try entering this command which will print the
installed version of GPG to make sure that it's already installed.

```bash
gpg --version
```

If not, use your package manager to install it.

#### Coming up with a good pass phrase
Before you create your GPG key, it's extremely important to come up with a good
pass phrase that you can use for your key.
And the characteristics of a
[good pass phrase](https://theintercept.com/2015/03/26/passphrases-can-memorize-attackers-cant-guess/)
are that it should as random as possible and yet it should be easy to remember.
The
[Diceware](https://theworld.com/~reinhold/diceware.html)
method is an excellent way to generate a truly random pass phrase.

You can use the
[diceware](https://github.com/ulif/diceware)
command-line tool for this.
It's available in the Debian package repository.
You can also install it using pip.
To generate a random 6-words long pass phrase with space as the delimiter, use
the following command:

```bash
diceware -d ' '
```

#### Create the GPG key
Creating a GPG key is easy, just use the following command to interactively
create one:

```bash
gpg --full-gen-key
```
- Go with the default crypto algorithm.
- Use the maximum allowed length: 4096.
- It's not recommended to have keys that never expire.
  2y should be a reasonable expiry period.
- Enter your name and email address.
- You can use the comment field to differentiate between keys sharing the
  same email address.
- Enter the pass phrase from the above section when prompted.

This ought to create a private and public key pair for you.

#### Take back up of the GPG key
It's awfully crucial to take backup of the GPG private key that you just
created.
It will help you to restore access to your passwords from backups and also to
share the passwords between computers.

Use the following command to list all your GPG keys:

```bash
gpg --list-secret-keys
```
![](assets/images/gpg-list-keys.png){: width="50%" }

Copy the ID of the key that you created from the list.
Next use the following command to export it to a file.
Put the actual path where the private key will be exported and replace `<key
ID>` with the ID copied from the above step.

```bash
gpg --export-secret-keys --armor --output </path/to/secret-key-backup.asc> <key ID>
```

The above exported private key is already secure with the pass phrase that you
entered earlier.
But to put an additional layer of security around it, let's compress and encrypt
the content.

```bash
tar -cvJf - </path/to/secret-key-backup.asc>|gpg --symmetric --output keys.tar.xz.gpg
```

Enter a new password for the encryption when prompted.
This password will be required when you will need to access the key later.
You can now safely store the `keys.tar.xz.gpg` file in a CD or in your back up
hard drive.

### Initializing Pass

### Store and retrieve a password in Pass

### Git integration with Pass

### Common issues and solutions

### Conclusion
In the next article, talk about replicating in a new computer or restore.
