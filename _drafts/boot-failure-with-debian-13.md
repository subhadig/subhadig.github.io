---
layout: post
title: Intermittent boot failure with Debian 13 Trixie
date: 2026-01-21
type: post
tags:
    - debian
comments: true
---
### The Problem
Last year after Debian 13 was released, I had upgraded by Dell Inspiron 3559
laptop running Debian 12 to it.
The upgrade process itself went smoothly without an issue.
But later I started noticing an occassional issue where the laptop would
abruptly turn off during very early boot process.
It would not happen always, and even when it happened, usually if I retried a
few times after that, it would boot properly.
Also, after a successful booting, it would never cause any issue as long as the
system was up.

---
**Table of Contents**
* TOC
{:toc}
---

### The Troubleshooting
Initially for a very justified cause, I had strongly suspected a hardware
failure.
After all, it was not unheard of for a ten years old laptop!
I first took it to the Dell service centre only to learn that they do not
service laptops older than 5 years!
So I took it to a local repairing shop where the guy told me that it's likely a
software issue than a hardware one as it's too intermittent and it only happened
at a very specific point during the boot.

#### System Logs
So I first checked the system logs using the following command:

```bash
journalctl -b -1
```

But then I realized that the failure was happening so early in the boot process
that the journald service, responsible for collecting the logs was not even
initialized.
So there was no logs stored in the system.

#### Boot Logs
Next 
