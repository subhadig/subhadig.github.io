---
layout: post
title: Running Kafka in Docker
date: 2020-04-14
type: post
tags:
    - kafka
    - docker
comments: true
---
### Introduction
Running *Apache Kafka* as a *Docker* container can be harder than it should be.
Or perhaps it's easy once you learn what exactly you need to do. In this post,
I'm going to discuss about how I run Kafka in *Docker*.

---
**Table of Contents**
* TOC
{:toc}
---

### What is Kafka?
[Apache Kafka](https://kafka.apache.org/) is a distributed real-time event
streaming and ingestion platform that is capable of handling very large volume
of data. With the rise in the *Microservices* architechture in recent years,
*Kafka* has gained a lot of popularity.

### Is this going to be a production or a development setup?
Contrary to the populat belief that Docker is an amazing tool only meant for
production deployments, Docker can be pretty useful for development
environments also. While the steps listed here are applicable for a production
environment as well, there are many more things one needs to take into
consideration for a production setup. This article is more geared towards
creating a development setup than a production one.

### Why Bitnami images over Confluent?
Unlike many other software, *Apache Kafka* does not have an official *Docker*
image. *Apache Kafka* as an open source project only releases compiled tarball
packages that can be extracted and executed on Linux, MacOS or Windows. There are
other third-party companies including [Confluent](https://www.confluent.io/) and
[Bitnami](https://bitnami.com/) that package and release *Kafka Docker* images.
Although *Confluent* images are more popular as they are from a company that
provides commercial support for *Kafka* deployments, The reason I chose
*Bitnami* over *Confluent* is that their images seemed simpler to start with,
were up to date with upstream and had good documentation.

### Setting up a Docker network
In a *Kafka* environment, usually there will be multiple components interacting
with each other. I will be creating a dedicated
[Docker network](https://docs.docker.com/network/) that will be used by the
containers to connect with each other. The following command creates a Docker
network named *kafka-net*.

```bash
docker network create kafka-net
```

### Starting Zookeeper
[Zookeeper](https://zookeeper.apache.org/) is another software from *Apache*
that is used by *Kafka* to store metadata information. We will need to start
a Zookeeper instance before spawning the Kafka broker containers.

```bash
docker run -d --rm --network kafka-net \
                    -p 2181:2181 \
                    --name zookeeper \
                    -e ALLOW_ANONYMOUS_LOGIN=yes \
                    bitnami/zookeeper:latest
```

A few points about the above command:
- `-d`: The container runs in detached mode, freeing up the command prompt.
- `--rm`: The container is autmatically removed as soon as it is stopped.
- `--network kafka-net`: Our container attaches itself to the *kafka-net*
Docker network that we created in the previous step.
- `-p 2181:2181`: The *2181* port of the container will be exposed on localhost.

### Starting one Kafka broker
The next step is to start a Kafka broker instance with the following command.

```bash
docker run -d --rm --network kafka-net \
			-p 9092:9092 \
			-p 29092:29092 \
			--name kafka \
            -e ALLOW_PLAINTEXT_LISTENER=yes \
            -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
            -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT \
            -e KAFKA_CFG_LISTENERS=INTERNAL://:9092,EXTERNAL://:29092 \
            -e KAFKA_CFG_ADVERTISED_LISTENERS=INTERNAL://kafka:9092,EXTERNAL://localhost:29092 \
            -e KAFKA_CFG_INTER_BROKER_LISTENER_NAME=INTERNAL \
            bitnami/kafka:2.5.0
```
A few points to note about the above command:
- `--network kafka-net` ensures that our Kafka broker also joins the same
Docker network as Zookeeper.
- `-e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181`: Our Kafka container reads
this environment variable to know where to reach our Zookeeper container on the
*kafka-net* Docker network.
- `-e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: This map specifies the *security
protocol* to use for each *listener* that we are going to use.
The *INTERNAL* listener will be used by the clients internal to the *kafka-net*
Docker network and the *EXTERNAL* listener will be used by the clients outside
the *kafka-net* network.
- `-e KAFKA_CFG_LISTENERS`: This map specifies that our *INTERNAL* listener
will listen on port 9092 and the *EXTERNAL* listener will listen on port 29092
for any incoming connection from clients.
- `-e KAFKA_CFG_ADVERTISED_LISTENERS`: This contains the host and port
combinations of Kafka brokers which are passed on to the clients when they
first connect, depending on which listener they connect to.
These are the Kafka broker addresses that the clients will finally connect to.
This means that the internal clients will connect to the broker on *kafka* host
and the
external clients will connect to *localhost*. This is expected since our 
Kafka broker container has the hostname *kafka* inside the *kafka-net* Docker
network and is exposed on the *localhost* for the outside clients.
- `-e KAFKA_CFG_INTER_BROKER_LISTENER_NAME`: Apart from the clients, the Kafka
broker instances also commnunicate with each other. They will use the
*INTERNAL* listener for this.
- I have used the Kafka `2.5.0` version. This can be replaced by
`latest` or any other future tags.

### Testing the cluster
Now that we have our local Kafka cluster up and running, it's time for testing
it out.
For this we will need a Kafka producer that will publish data to our
Kafka cluster and a consumer that will listen to it.
While we can use the *kafka-console-producer.sh* and the
*kafka-console-consumer.sh* scripts that ship with Kafka, I will use a utility
called [kafkacat](https://github.com/edenhill/kafkacat).
Although *kafkacat* can be installed in multiple ways, it can also be used as a
Docker container without the need to installing it. This is the method that
I am going to use here.

#### Connect from within the *kafka-net*

##### The producer
The following command creates a *kafkacat* Docker container that reads input
from the *stdin* and publishes to the *test-topic*. Topics will be automatically
created on use.

```bash
docker run -it --network kafka-net edenhill/kafkacat:1.5.0 \
				-b kafka:9092 \
				-t test-topic \
				-P
```

Noticed the `--network kafka-net` flag? It tells Docker to connect our
*kafkacat* container to the *kafka-net* network that we created earlier.
And probably you have already guessed that we are going to use the *INTERNAL*
listener here.
This is the reason we are passing `kafka:9092` as the broker address.

##### The consumer
In a separate terminal, use the following command to create a *kafkacat*
Docker container that reads from the *test-topic* and prints to the *stdout*.

```bash
docker run -it --network kafka-net edenhill/kafkacat:1.5.0 \
				-b kafka:9092 \
				-t test-topic \
				-C
```

Now when you type something in the producer terminal and press enter, you
should see the same text being printed by our consumer on the consumer terminal.

![kafka-on-docker-internal-clients](assets/images/kafka-on-docker-internal-clients.png)

> Press `Ctrl + D` to end the producer session.

#### Connect from outside of *kafka-net*
Now if we want to do the same thing using the *EXTERNAL* listener, here are the
commands:

```bash
# producer
docker run -it --network host edenhill/kafkacat:1.5.0 \
				-b localhost:29092 \
				-t test-topic \
				-P
```

And in a separate terminal,
```bash
# consumer
docker run -it --network host edenhill/kafkacat:1.5.0 \
				-b localhost:29092 \
				-t test-topic \
				-C
```

### Start/stop scripts
It's inconvenient to use the individual commands everytime we need to start a
Kafka cluster for development and shutting it down and cleaning it up. Most
people use [Docker Compose](https://docs.docker.com/compose/) for this, a
reasonable solution from Docker.
But I prefer using a plain old bash script with the individual commands over
using *Docker Compose*. Because it's more customizable
and therefore more useful and it also makes one less thing to learn for me.

Here's how my start and stop script looks like:

```bash
#!/bin/sh

echo "Creating network kafka-net.."
docker network create kafka-net

echo "Starting zookeeper.."
docker run -d --rm --network kafka-net -p 2181:2181 \
            --name zookeeper \
            -e ALLOW_ANONYMOUS_LOGIN=yes \
            bitnami/zookeeper:latest

echo "Starting kafka broker.."
docker run -d --rm --network kafka-net -p 9092:9092 \
            -p 29092:29092 --name kafka \
            -e ALLOW_PLAINTEXT_LISTENER=yes \
            -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
            -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT \
            -e KAFKA_CFG_LISTENERS=INTERNAL://:9092,EXTERNAL://:29092 \
            -e KAFKA_CFG_ADVERTISED_LISTENERS=INTERNAL://kafka:9092,EXTERNAL://localhost:29092 \
            -e KAFKA_CFG_INTER_BROKER_LISTENER_NAME=INTERNAL \
            bitnami/kafka:2.5.0

echo "Printing all running docker containers.."
docker ps
```

```bash
#!/bin/sh

echo "stoping kafka.."
docker stop kafka

echo "stoping zookeeper.."
docker stop zookeeper

echo "stopping network kafka-net"
docker network rm kafka-net
```

### Conclusion
As always, the code is available on my
[GitHub](https://github.com/subhadig/kafka-on-docker-scripts).
The steps were tested on MacOS and Debian but they should also work under
Windows.
Hopefully this article should save some time if you are looking for
an easy way to run Kafka in Docker for your development environment.
And once you understand the steps, it's easy to even customize it further to
suit your requirements.

Here are a few references that might come handy:
- [Bitnami Docker image for Kafka on GitHub](https://github.com/bitnami/bitnami-docker-kafka)
- [Kafka Listeners - Explained](https://rmoff.net/2018/08/02/kafka-listeners-explained/)
