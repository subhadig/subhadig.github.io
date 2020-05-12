---
layout: post
title: Getting started with Kubernetes using Minikube - Deploying an application
date: 2020-04-14
type: post
tags:
    - kubernetes
    - minikube
comments: true
---
### Introduction
This is my second article in the **Kubernetes with Minikube** series. In the
[first article](getting-started-with-kubernetes-using-minikube-installation.html)
I discussed about creating a local Kubernetes cluster with *Minikube*. In this
article, I will be talking about deploying an application in a local *Minikube*
cluster.

---
**Table of Contents**
* TOC
{:toc}
---

### Simple Web service
*Simple Web service* is a [Spring Boot](https://spring.io/projects/spring-boot)
application written it Java. It has the following REST endpoint:
`GET /details`. And following is the response format.

```json
{
  "Host name": "simple-web-service-deployment-66c45446b8-9x8bh",
  "IP address": "172.17.0.6"
}
```

It basically returns the host name and the IP address of the container it is
running on.

The source code for the *Simple Web service* is available on this
[GitHub link](https://github.com/subhadig/kubernetes-with-minikube/tree/master/simple-web-service).
The application is dockerized and published on
[Docker Hub](https://hub.docker.com/r/subhadig/simple-web-service) as well. I
am going to use it as a sample application for deploying in our *Minikube*
cluster.

### Deployment
[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
are a way to tell Kubernetes how you want to have your application deployed.
And a *Deployement* is described by a `deployment.xml` file. Following is an
example of a `deployment.xml` that I am going to use to deploy our
*Simple Web service*.

```xml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-web-service-deployment
  labels:
    app: simple-web-service
spec:
  replicas: 2
  selector:
    matchLabels:
      app: simple-web-service
  template:
    metadata:
      labels:
        app: simple-web-service
    spec:
      containers:
      - name: simple-web-service-application
        image: subhadig/simple-web-service
        ports:
          - containerPort: 8080
```

A few important notes about the above `deployment.xml`:
- The `metadata.name` fields tells the name of the *Deployment*.
- The `metadata.labels` field asks *Kubernetes* to add the
`app: simple-web-service` label to our deployment.
- In the `spec` section, the `replica` field tells *Kubernetes* to create 2
*replicas* of our application.
- The `spec.template.metadata.labels` field defines what tags
(*app: simple-web-service*) will be added to the *Pods* running our application
and the `spec.selector` field tells that our *Deployment* will only manage the
[Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod/) labeled with
*app: simple-web-service*.
- The 

### Ingress


### Service


### Accessing the web service


### Conclusion
