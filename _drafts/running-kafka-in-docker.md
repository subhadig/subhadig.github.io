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
Or perhaps it's easy once you know what exactly you need to do. In this post,
I'm going to discuss about my prefered way to run Kafka in a *Docker*
container.

---
**Table of Contents**
* TOC
{:toc}
---

### What is Kafka?
[Apache Kafka](https://kafka.apache.org/) is a distributed real-time event
streaming and ingestion platform that is capable of handling very large volume
of data. With the rise in the *Microservices* architechture in recent years,
*Kafka* has gained popularity.

### Is this a production or a local setup?
Contrary to the populat belief that Docker is an amazing tool only meant for
Production deployments, Docker can be pretty useful for development
environments also. While the steps listed here are applicable for a production
environment as well, there will be many more things one needs to take into
consideration for a production setup. This article is more geared towards
creating a development setup than a production one.

### Why Bitnami images over Confluent?
Unlike many other software, *Apache Kafka* does not have an official *Docker*
image. *Apache Kafka* as an open source project only releases compiled tarball
packages that can be executed on Linux, Mac or Windows. There are other
third-party companies including [Confluent](https://www.confluent.io/) and
[Bitnami](https://bitnami.com/) that package and release *Kafka Docker* images.
Although *Confluent* images are more popular as they are from a company that
provides commercial support for *Kafka*, The reason I chose *Bitnami* over
*Confluent* is that their images seemed simpler to start with, were up to date
with upstream and had good documentation.

### Setting up a Docker network
In a *Kafka* environment, usually there will be multiple components interacting
with each other. I will be creating a dedicated
[Docker network](https://docs.docker.com/network/) that will be used by the
containers to connect to each other. The following command creates a Docker
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

The above command does the following things:
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
					bitnami/kafka:2.5.0
```
A few points about the above command:
- `--network kafka-net` ensures that our Kafka broker also joins the same
Docker network as Zookeeper.
- `-e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181`: Our Kafka container reads
this environment variable to know how to reach our Zookeeper container on the
Docker network.
- `-e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP`: This map defines the *security
protocol* to use for each *listener* that we are going to use. The *INTERNAL*
listener will be used by the clients internal to the *kafka-net* Docker
network and the *EXTERNAL* listener will be used by the clients outside the
*kafka-net* network.
- `-e KAFKA_CFG_LISTENERS`:


### Testing the cluster

### Start/stop scripts

### Conclusion
