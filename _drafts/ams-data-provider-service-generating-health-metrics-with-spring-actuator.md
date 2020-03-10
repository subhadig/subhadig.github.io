---
layout: post
title: AMS: Data Provider Service - Generating health metrics with Spring Actuator
date: 2020-01-20
type: post
tags:
    - command-line
    - pandoc
comments: true
---
### Introduction
This is the first article in a series of articles on designing and creating
an **Application Monitoring System**.
An Application Monitoring System (AMS) is a system for monitoring
performance of other running applications. I will build this application
component by component from scratch and publish it here on this blog.
In this post, I talk about creating and running services that provide
application performance metrics using Java, Spring Boot and Docker.

---
**Table of Contents**
* TOC
{:toc}
---

### What this service is and what it's not
This service is not exactly a part of the **Application Monitoring System**.
This service is an example of how to generate various performance metrics
with the help of *Spring Boot Actuator*. These metrics will be then used to test
the actual **Application Monitoring System**.

### Creating a basic Java service using Spring Boot
[Spring Framework](https://en.wikipedia.org/wiki/Spring_Framework) is probably
the most popular application framework and
[IoC](https://en.wikipedia.org/wiki/Inversion_of_control) container for Java
and [Spring Boot](https://spring.io/projects/spring-boot) is Spring's
[convention-over-configuration](https://en.wikipedia.org/wiki/Convention_over_configuration)
solution for easily creating ready-to-run, production-grade Spring applications.

To create a basic Spring Boot project, head over to
[start.spring.io](https://start.spring.io), populate the required details and
click on Generate.

![Spring boot initializer](assets/images/spring-initializer-dataproviderservice.png)

In the above screenshot, under the *Dependencies* section, I have selected
the following Spring modules:
- **Spring Boot Actuator**: Spring Boot module that monitors the application and
generate metrics data.
- **Spring Web**: Since we will expose the *Spring Actuator* generated metrics
over REST.

### Configuring Spring Boot Actuator for generating runtime metrics


### Running as a Docker container

### Conclusion
