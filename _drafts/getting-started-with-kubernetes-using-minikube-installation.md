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

```bash
brew install kubectl
```

*kubectl* can be installed in various other ways - it can also be downloaded as
an executable binary and used without installing. I like the above mentioned
approaches because they give me the flexibiltiy of managing the packages with
a package manager.

#### VM Driver
Minikube can be deployed as a VM, a container or bare-metal. My preferred way
is to run it as a VM. To do so, we are going to need a hypervisor or
[VM driver](https://minikube.sigs.k8s.io/docs/drivers/). On Linux I prefer
using [kvm](https://minikube.sigs.k8s.io/docs/drivers/kvm2/) and on MacOS, I
prefer using [Hyperkit](https://minikube.sigs.k8s.io/docs/drivers/hyperkit/).

To install kvm on Debian 10, run the following command:

```bash
sudo apt install qemu-kvm \
                 libvirt-clients \
                 libvirt-daemon-system
```

You may need to turn on Intel VT-x or AMD-V depending on your chipset to benefit
from hardware acceleration capabilities of your CPU.

On MacOS, if you are running Docker Desktop then you already have Hyperkit
installed. If not, you can install it using Homebrew.

```bash
brew install hyperkit
```

#### minikube

##### Install on Debian
To install minikube on Debian follow the steps.

- Download the *.deb* file for the
[latest minikube release](https://github.com/kubernetes/minikube/releases).
At the time of writing the post, the latest version was 1.9.2.

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_1.9.2-0_amd64.deb
```

- Install the downloaded package. Replace *minikube_1.9.2-0_amd64.deb* with
the actual downloaded package name. 

```bash
sudo dpkg -i minikube_1.9.2-0_amd64.deb
```

##### Install on MacOS
With Homebrew, it's fairly easy to install minikube on MacOS.

```bash
brew install minikube
```

### Starting up
To start minikube on Debian, I use the following command:

```bash
minikube start --driver=kvm2
```
*--driver=kvm2* flag tells minikube to use the *kvm2* VM driver.

If everything is properly configured and minikube is successfully started, you
should see something like this:

![minikube-start-debian](assets/images/install-minikube-success-debian.png)

Similarly here is the command to start minikube on MacOS:

```bash
minikube start --driver=hyperkit
```

*--driver=hyperkit* tells minikube to use the hyperkit VM driver.

I also have *Docker Desktop* installed on my Mac and if *Docker Desktop* is
started first, then I get the following error while starting minikube:

![install-minikube-error-macos](assets/images/install-minikube-error-macos.png)

I could not determine whether the *Docker Desktop* or the VPN software running
on my Mac is causing this error. Due to this problem, the minikube VM fails to
resolve any domain name and deployment of *Docker* images fails.
As a workaround, I use the following command to start minikube on my Mac:

```bash
minikube start --driver=hyperkit \
               --hyperkit-vpnkit-sock=/Users/${USER}/Library/Containers/com.docker.docker/Data/vpnkit.eth.sock
```

To check the running status of minikube cluster, use the following command:

```bash
minikube status
```

To stop the minikube cluster, use:

```bash
minikube stop
```

To delete the local minikube cluster, use:

```bash
minikube delete
```

### Conclusion
