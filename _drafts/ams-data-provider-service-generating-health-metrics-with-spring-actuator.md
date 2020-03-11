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

### Applications performance metrics
Undertstanding the health and performance of the deployed applications is
crucial to ensure availability and usability of the services. *application
performance metrics* are the raw measurements of various resource usage or
behaviours of an application at any given time. To monitor and analyze the
application performance, these metrics are periodically collected and stored.
Here are some exmaples of *application performance metrics*:
- CPU usage
- Memory usage
- System uptime

### What data-provider-service is and what it's not
The data-provider-service is not exactly a part of the
**Application Monitoring System**.  This service is an example of how to
generate various *application performance metrics* with the help of
*Spring Boot Actuator*. These metrics will be then used to test the actual
**Application Monitoring System**.

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
[Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html)
module has capability of monitoring a running application among other things.
It has an inbuilt set of appliation health metrics that it reports by default
that can be exposed either via JMX or via REST. Addition of custom metrics are
also supported. Here in this section, I will write the configuration to
expose the default metrics supported by *Spring Boot Actuator* over REST
endpoints.

#### Enabling the required endpoints over HTTP
In the ``data-provider-service/src/main/resources/application.properties`` file
add the following lines:

```
management.endpoint.metrics.enabled=true
management.endpoints.web.exposure.include=health, metrics
```

Now if I run the application and head over to *http://localhost:8081/actuator*,
I should see all the available endpoints.

![Spring Actuator endpoints](assets/images/data-provider-service-spring-actuator.png)

And *http://localhost:8081/actuator/metrics* should show a list of available
metrics.

![Spring Actuator endpoints](assets/images/data-provider-service-actuator-metrics.png)

And if I want to see the current value of any metric from the list like
*jvm.memory.max*, I can go to the url
*http://localhost:8081/actuator/metrics/jvm.memory.max* and it should show me
something like the below screenshot.

![Spring Actuator endpoints](assets/images/data-provider-service-actuator-metrics-jvm.memory.max.png)

### Securing the endpoints with Spring Security
Additionally, you might want to secure the metrics REST endpoints exposed by
*Spring Boot Actuator* in the previous step. With *Spring Security*, it's
simple enough to do. Here are the steps to add a *basic authentication* to the
endpoints.

#### Import the maven depeondency
In the ``data-provider-service/pom.xml``, add the following dependency.

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

#### Use fixed passwords
By default *Spring Security* will generate a new password everytime you boot up
your application which may not be the desired behaviour if you plan to poll the
endpoints from a different system.

To use a fixed username and password, add the following two lines in the
``data-provider-service/src/main/resources/application.properties`` file.

```
spring.security.user.name=admin
spring.security.user.password=admin@123
```

Now if you restart your application and go to *http://localhost:8081/actuator*,
you should be presented with the following login screen:

![Spring Actuator endpoints](assets/images/data-provider-service-spring-security-login.png)

### Running as a Docker container
I usually package my applications as *Docker* images due to ease of
running them both locally and remotely. Also Docker containers provide a more
predictable environment for the applications.

To package the *data-provider-service* as a Docker image, copy the following
content to ``data-provider-service/Dockerfile`` file.

```Dockerfile
FROM openjdk:8-alpine
MAINTAINER subhadig@github
ARG jarfile
COPY $jarfile /opt/app.jar
ENTRYPOINT ["/usr/bin/java", "-jar", "/opt/app.jar"]
EXPOSE 8080
```

The following command creates the Docker image.

```bash
mvn package
docker build -t data-provider-service:latest --build-arg jarfile="target/data-provider-service-*.jar" data-provider-service/
```

In the above *docker* command, I am passing the maven generated jar file
location to the Dockerfile where it is used to copy and package the jar with
the final image.

The following command runs the image created in the previous step as a *Docker*
container and also exposes the *data-provider-service* REST endpoints on the
8080 port of the localhost of the host machine.

```bash
docker run -d --rm -p 8080:8080 --name provider data-provider-service:latest
```

### Conclusion
[Here](https://github.com/subhadig/application-monitoring-system/tree/master/data-provider-service)
is the link to the *data-provider-service* code which is hosted on my
[GitHub account](https://github.com/subhadig).

In the next post
