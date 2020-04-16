---
layout: post
title: Getting started with Kubernetes using Minikube - Installation
date: 2020-04-14
type: post
tags:
    - kubernetes
    - minikube
comments: true
---
### Introduction
I am working on a series of opinionated posts on how to get started with the
basics of Kubernetes using Minikube. In this series, I will discuss on a range
of topics starting from installation of Minikube to the deployment of pods and
also fixes to a few annoying issues I faced along the way. This is the first
article in the series where I talk about how to install Minikube in your local
workstation.

---
**Table of Contents**
* TOC
{:toc}
---

### Kubernetes
From the [Wikipedia](https://en.wikipedia.org/wiki/Kubernetes):

> Kubernetes is an open-source container-orchestration system for automating
> application deployment, scaling, and management.

Kubernetes is probably the most popular and widely used system for deploying
and managing scalable and highly available applications world wide. Not only
Kubernetes can be self-hosted, managed Kubernetes cluster services are
available on most of the major cloud service providers including AWS, Azure
and Google Cloud.

### Minikube
[Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/)
is a command line tool for running single node Kubernetes clusters
in local workstations. Although Minikube only supports a subset of all the
Kubernetes features, Minikube is still a fantastic tool meant for users or
developers who want to try out Kubernetes in local computer or deploy services
in local Kubernetes before pushing to an actual multi-node test or production
environment. Minikube is supported on MacOS, Linux and Windows.

### Installation
In this section, I will share the steps of installing Minikube and other
required components on MacOS and Debian Linux. The steps should be fairly
similar for any other Debian based Linux distributions including Ubuntu. However
if you are using a different variant of Linux, the steps might be a little bit
different.

#### kubectl
[Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) is not
exactly a part of Minikube but it's a command-line tool for interacting with
a Kubernetes cluster and perform various administrative tasks including
deployment of [pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/).

To install *kubectl* on Debian, follow the below steps:

```bash
#Install the key
- curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

#Add the Kubernetes repository to sources
- echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

#Update the APT package index
- sudo apt update

#Install kubectl
- sudo apt install -y kubectl
```

On MacOS, if you have installed
[Docker Desktop](https://www.docker.com/products/docker-desktop) then you
already have *kubectl* installed. Otherwise the package can be easily installed
using [Homebrew](https://brew.sh/)

```eash
brew install kubectl
```

*kubectl* can be installed in various other ways - it can also be downloaded as
an executable binary and used without installing. I like the above mentioned
approaches because they give me the flexibiltiy of managing the packages with
a package manager.

#### Hypervisor

#### minikube

### Starting up

### Conclusion
