---
layout: post
title: The easiest way to stay always connected on IRC
date: 2020-06-28
type: post
tags:
    - irc
    - debian
comments: true
---
### Introduction
Connecting to an IRC room may not be a difficult task but if you communicate
with a group of members connecting from different locations across the globe
and are in different timezones and if you don't want to miss out messages from
them while you are offline, you may find yourself in a tricky situation.
In this post I am going to share the easiest and the most
cost-effective way to always stay connected on IRC using
[Matrix](https://en.wikipedia.org/wiki/Matrix_(protocol)).

---
**Table of Contents**
* TOC
{:toc}
---

### Internet Relay Chat
Chances are that if you are reading this post then you already know about
[IRC](https://en.wikipedia.org/wiki/Internet_Relay_Chat).
For others, IRC is an old decentralized messaging protocol that used to drive
much of the online group chatting before the era of the more modern instant
messaging platforms began.
Although the usage of IRC has been in steady decline since 2003, it's still
heavily used in many of the open source projects from that era for real-time
communications.

### Why do you need to be always connected?
In today's world of Slack, Teams and Discord, the idea of always being
connected to the servers to not to miss out any messages may seem a little
difficult to grasp at first.
At its core, IRC is a client and server protocol where the server relays a
message to the clients connected to it when the message arrives.
The server does not store any history of the messages.
So when the message arrives, if you are not connected to the server, you lose
the message.
This is why if you want to reliably communicate on IRC, you need a mean to stay
always connected to the server.

### What are the available options?
If you have a computer that is always connected to the internet or if you
can rent a VM on the cloud, then it is not much of an issue for you provided
the command line does not turn you off.
If it does, you can look into the [IRCCloud](https://www.irccloud.com/).
You can think of it as your own cloud IRC client.
After you create an account, you can log into it from any web browser or your
mobile phone and when you log out your client still stays connected collecting
messages from the IRC server.
Although their paid accounts are okay, their free version suffers
from frequent disconnections when you are inactive or away.

### Matrix and Riot.im
From the [Wikipedia](https://en.wikipedia.org/wiki/Matrix_(protocol)):

> Matrix (stylized as [matrix]) is an open standard and lightweight protocol
for real-time communication.
It is designed to allow users with accounts at one communications service
provider to communicate with users of a different service provider via online
chat, voice over IP, and video telephony.

What this basically means is that the *Matrix* protocol allows the users to
communicate with other users across different communication service providers.
This is not a new concept in other areas of the Internet powered communication
services (think email).
But it's pretty useful for instant messaging as well where you can choose to
use your own service provider and still be able to communicate with someone
who's on a different service provider.

Matrix has a server and a client component and Matrix being an open protocol
there are multiple implementations available for both the server and client
components.
The Matrix core team runs a server implementation at
[matrix.org](https://matrix.org/) that can be openly accessed.

[Riot.im](https://riot.im) is a model implementation for the matrix client
protocol. 
It is also freely hosted as the [Riot.im app](https://riot.im/app).
We will be using this along with the [matrix.org](https://matrix.org/) to set
up our IRC client.

### Using Riot.im to connect to IRC

#### Create an account on Riot.im
First things first.
Go to [riot.im/app](https://riot.im/app) and create an account with
*[matrix.org]*.
After completing all the formalities, log in to your account.

#### Joining an IRC room on OFTC
I usually hang out at the OFTC.net because the Debian IRC rooms are hosted
there.
The following instructions are specific to the OFTC IRC rooms.

##### Start a chat with @oftc-irc:matrix.org
Click on the `+` button beside *Direct Message* on the left-side pane.
Search for `@oftc-irc:matrix.org` and start a new chat.

##### Log in with your nick
Optionally, if you have a registered nick with OFTC, send the following message
to @oftc-irc:matrix.org:

```
!nick <your-nick>
```

You should receive a direct message from NickServ.
You can reply with `IDENTIFY <your-OFTC-password>` to identify yourself with
your registered nick.

##### Join a room
Now go back to the chat window for @oftc-irc:matrix.org and send
`/join #_oftc_#debian`.
This should join you to the [#debian](https://wiki.debian.org/IRC) IRC
room.
Follow the same format to join other rooms.

For other IRC services eg. [Freenode](https://freenode.net/), the steps are
similar but the Matrix addresses are different.

### Conclusion
IRC is still an excellent protocol for internet messaging.
It may never get its old popularity back but it has not lost all of its
usefulness even in today's age.
Matrix makes chatting over IRC and staying always connected easier than ever.
