---
layout: post
title: A practical guide to get started with Pass
date: 2023-09-02
type: post
tags:
    - command-line
    - pass
comments: true
---
### Introduction
In my recent endeavour to upgrade my digital security, I started using 
[Pass](https://www.passwordstore.org/),
the command-line based password manager for my online accounts.
While there were a few online guides that I could follow to get started with
Pass, I did feel a need of a comprehensive guide for new users of Pass.
In my attempt to fill the gap, I will try to touch upon various aspects that one
needs to be mindful of to use Pass in the most secure and optimal way.

---
**Table of Contents**
* TOC
{:toc}
---

### Why a (dedicated) password manager
The days are over when you remembered the passwords for all your online
accounts.
In this age, you need to use an online account virtually for every other
service.
And even though many services are offering multi-factor authentication (MFA)
options today for securely logging into your accounts, the importance of a
strong password is still as high as ever.
And the best security practices say that a password is the strongest when it is
as random as possible, something that an average human mind can neither
create nor remember easily.
And this is where the importance of a password manager lies.
It's far easier to rather lock all your keys behind a master lock and have one
very secure key than to carry around separate unique keys with you for all the
locks.

But when in today's age, effectively all major browsers provide password storage
and sync features, it may not sound very practical to have a separate piece of
software for storing your passwords.
There can be 
[arguments](https://www.howtogeek.com/447345/why-you-shouldnt-use-your-web-browsers-password-manager/)
on both sides but it's generally a more secure practice to not give away too
many responsibilities to one software and trust a browser for what it does best
\- browse the internet.

### Why Pass
Pass is a command-line password manager.
It may not sound very attractive compared to various cloud-based alternatives
that are available today especially if you are not a command-line person but the
main power of Pass comes from it's simplicity and transparency.
At it's core, Pass does not do much by itself and makes use of other Unix
software that are already available and are industry standards.
Namely it uses [gpg](https://gnupg.org/) for encryption of the stored passwords
and [git](https://git-scm.com/) for version control and cloud syncing.

Another inspiration to use Pass could be that if you do not feel too inclined to
blindly trust the cloud-based and closed-source password managers available in
the market.

In the next sections, I will discuss about different aspects of installing and
using Pass.

### GPG key for Pass
Before we can use Pass, the very first step is to create a GPG key that will be
used by Pass.
If you already have an existing one and you wish to reuse it, you can skip this
step.
If you are using a Linux or Mac system, chances are that GPG is already
installed in your system. Try entering this command which will print the
installed version of GPG to make sure that it's already installed.

```bash
gpg --version
```

If not, use your package manager to install it.

#### Coming up with a good pass phrase
Before you create your GPG key, it's extremely important to come up with a good
pass phrase that you can use with your key.
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

#### Creating the GPG key
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
- You can use the comment field to put a unique value for uniquely identifying
  keys sharing the same email address.
- Enter the pass phrase from the above section when prompted.

This ought to create a private and public key pair for you.

#### Taking back up of the GPG key
It's awfully crucial to take backup of the GPG private key that you just
created.
It will help you to restore access to your passwords from backups and also to
share the passwords between computers.

Use the following command to list all your GPG keys:

```bash
gpg --list-secret-keys
```
![](assets/images/gpg-list-keys.png){: width="100%" }

The above image highlights the ID part of a GPG key.
Copy the ID of the key that you created from your output list.
Next use the following command to export it to a file.
Use the actual path of where the private key will be exported to in the below
command and replace the `<key ID>` with the ID copied from the above step.

```bash
gpg --export-secret-keys --armor --output </path/to/secret-key-backup.asc> <key ID>
```

The above exported private key is already secure with the pass phrase that you
entered earlier.
But to put an additional layer of security around it, let's compress and encrypt
the exported keys.
Also remove the `secret-key-backup.asc` file afterwards.

```bash
tar -cvJf - </path/to/secret-key-backup.asc>|gpg --symmetric --output keys.tar.xz.gpg
rm </path/to/secret-key-backup.asc>
```

Enter a new password for the encryption when prompted.
This password will be required again when you will decrypt the content of the
archive later, so make sure that you can remember it again when needed.
You can now safely store the `keys.tar.xz.gpg` file in a CD or in your back up
hard drive.

### Initializing Pass
You need to initialize Pass before you can start using it.
It's a very easy step to initialize Pass.

```bash
pass init <key ID>
```
Replace `<key ID>` with the actual GPG key ID.
And that's it.

### Storing and retrieving a password in Pass
Pass encrypts your passwords with the GPG key and keeps the encrypted files
organizes in a directory structure under the default root directory
`~/.password-store`.
To insert a new password for the website `example.com` into Pass, use the
following command:
```bash
pass insert example.com
```
Enter the password for `example.com` when prompted.
This will create an encrypted file named `example.com.gpg` inside
`~/.password-store` and store the password in it.
If you have multiple accounts for a website, you may use the following
convention:
```bash
pass insert example.com/username1
```
This will an encrypted file named `username1.gpg` inside
`~/.password-store/example.com` to store the password.

To print a password to the terminal, use the following:
```bash
pass example.com
```
You will need to enter your GPG pass phrase.
Alternatively to copy the password securely in your clipboard, use the `-c`
flag without printing it on the terminal.
```bash
pass -c example.com
```
This command also automatically clears the copied password from the clipboard
after 45 seconds to prevent you from inadvertently pasting it in some other
place.

You can also auto-generate a random password with the following command:
```bash
pass generate example.com
```

### Integrating Pass with Git
Pass also provides integration with Git - the revision control system.
This in turn can be used to back up the stored passwords to an online remote
repository like [GitHub](https://github.com/) or
[GitLab](https://about.gitlab.com/).
This is also useful if you want to share your passwords between multiple
computers.

In this example, I will be using GitHub.
But any other online version control system that uses Git can also be utilized
instead of GitHub.
Follow this
[guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
to create a private GitHub repository.

Now, to initialize the Pass root directory as a git repository, run the
following:
```bash
pass git init
```

And to add the remote Git repository URL, use the following:
```bash
pass git remote add origin git@github.com:<username>/<repository-name>.git
```
Replace your username and the newly created repository name in the above
command.

With every `insert` , `edit` and `generate` operations, Pass will automatically
make a new commit to your local Git repository.
You can use the following commands to push or pull your changes to and from the
remote repository.
```bash
pass git push
pass git pull
```

### A common problem and the solution
Pass has clients for many platforms including Firefox and Chrome.
But I prefer using it without the clients which means copying the passwords to
the clipboard from Pass and then pasting them directly in the browser.
The problem with this approach is that some websites block users from copying or
pasting anything on them for some unfounded security reasons.
Follow [this guide](https://www.howtogeek.com/251807/how-to-enable-pasting-text-on-sites-that-block-it/)
for a workaround to this problems on Firefox and Chrome.

### Conclusion
I understand that Pass may not be to everyone's taste and it's completely fine
to use another, a more user friendly password manager as long as you are using
one.
But to the ones who want to use it and are looking for a way to get started, I
hope you find this article useful.
