---
layout: post
title: 'AMS: Data Provider Service - Generating performance metrics with Spring Boot Actuator'
date: 2020-03-15
type: post
tags:
    - application-monitoring-service
    - java
    - spring-boot
    - spring-boot-actuator
    - spring-security
    - docker
comments: true
---
### Introduction
This is the first article in a series of upcoming articles on designing and
creating an **Application Monitoring System**.
An Application Monitoring System (AMS) is a system that can monitor
performance of other running applications. I am building this application
component by component from scratch and I will publish it here on this blog.
In this post, I talk about how to create and run services that provide
application performance metrics using Java, Spring Boot and Docker.

---
**Table of Contents**
* TOC
{:toc}
---

### What are *applications performance metrics*?
Understanding the health and performance of the deployed applications is
crucial to ensure availability and usability of the services. *Application
performance metrics* are the raw measurements of various resource usage or
behaviours of an application at any given time. To monitor and analyze the
performance of an application, these metrics are periodically collected and stored.
Here are some examples of *application performance metrics*:
- CPU usage
- Memory usage
- System uptime

### What the data-provider-service is and what it's not
The data-provider-service is not exactly a part of the
**Application Monitoring System**.  This service is an example of how to
generate various *application performance metrics* with the help of
*Spring Boot Actuator*. This service will then be used to test the actual
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
click on *Generate*.

![Spring boot initializer](assets/images/spring-initializer-dataproviderservice.png)

In the above screenshot, I have selected
the following Spring modules under the *Dependencies* section:
- **Spring Boot Actuator**: The *Spring Boot* module that monitors a running
application and generate performance metrics.
- **Spring Web**: Since we will be exposing the *Spring Actuator* generated
metrics over REST.

### Configuring Spring Boot Actuator for generating runtime metrics
The
[Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html)
module has the capability of monitoring a running application among other things.
It has an inbuilt set of *application performance metrics* that it reports by default
which can be exposed via either JMX or REST. Custom metrics are
also supported. Here in this section, I will only use
the default metrics supported by *Spring Boot Actuator* and I will expose those
over REST.

#### Enabling the required endpoints over HTTP
In the ``data-provider-service/src/main/resources/application.properties`` file
add the following lines:

```
management.endpoint.metrics.enabled=true
management.endpoints.web.exposure.include=health, metrics
```

Now if I run the application and head over to *http://localhost:8080/actuator*,
I should see all the available *Spring Boot Actuator* endpoints.

![Spring Actuator endpoints](assets/images/data-provider-service-spring-actuator.png)

In this example, I have only enabled the *health* and *metrics* endpoints.
[Here](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready-endpoints)
is the full list of available endpoints.

*http://localhost:8080/actuator/metrics* should show a list of available
metrics.

![Spring Actuator endpoints](assets/images/data-provider-service-actuator-metrics.png)

And if I want to see the current value of any metric from the list like
*jvm.memory.max*, I can go to the URL
*http://localhost:8080/actuator/metrics/jvm.memory.max* and it should show me
something like the below screenshot.

![Spring Actuator endpoints](assets/images/data-provider-service-actuator-metrics-jvm.memory.max.png)

### Securing the endpoints with Spring Security
Additionally, you might want to secure the metrics REST endpoints exposed by
*Spring Boot Actuator* in the previous step with authentication. With
*Spring Security*, it's simple enough to do. Here are the steps to add a
*basic authentication* to the endpoints.

#### Import the maven dependency
In the ``data-provider-service/pom.xml``, add the following dependency.

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

#### Use fixed passwords
By default *Spring Security* will generate a new password every time you boot up
your application which may not be the desired behaviour if you plan to poll the
endpoints from a different system.

To use a fixed username and password, add the following two lines in the
``data-provider-service/src/main/resources/application.properties`` file.

```
spring.security.user.name=admin
spring.security.user.password=admin@123
```

Now if you restart your application and go to *http://localhost:8080/actuator*,
you should be presented with the following login screen:

![Spring Actuator endpoints](assets/images/data-provider-service-spring-security-login.png)

### Running as a Docker container
I usually package my applications as *Docker* images due to the ease of
running them both locally and remotely. Also Docker containers provide a more
predictable runtime environment for the applications.

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
location to the Dockerfile.It copies and packages the jar file from the 
location with the final image.

The following command runs the image created in the previous step as a *Docker*
container and also exposes the *data-provider-service* REST endpoints on the
8080 port of the localhost of the host machine.

```bash
docker run -d --rm -p 8080:8080 --name provider data-provider-service:latest
```

### Conclusion
[Here](https://github.com/subhadig/application-monitoring-system/tree/master/data-provider-service)
is the source code of the *data-provider-service*.

Although there are multiple ways to generate application performance metrics
*Spring Boot Actuator* provides an easy yet powerful approach to start with.
One more thing
to keep in mind is that, generating these performance metrics also impacts the
overall performance of the application, so one should be cautious about
generating too many of them too frequently.

In the next post, I will discuss about how to create a
*data-collection-service* and configure it to collect
*application performance metrics* from the *data-provider-service*.
