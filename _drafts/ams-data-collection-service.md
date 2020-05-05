---
layout: post
title: 'AMS: Data Collection Service'
date: 2020-03-15
type: post
tags:
    - application-monitoring-service
comments: true
collection_keyword: ams
---
### Introduction
This is the second article in my
[Application Monitoring System](collections/application-monitoring-system.html)
series where I am building an open source application to monitor performances
of other applications. In this post, I will be disucssing about the second
component, the **Data Collection Service**.

---
**Table of Contents**
* TOC
{:toc}
---

### Data Collection Service
The *Data Collection Service* is a
[Spring Boot](https://spring.io/projects/spring-boot) application written in
Java. As the name suggests, it is the collector component which is capable of
pulling metrics data from various source systems and sending to various
destination systems.

### The API page
The *Data Collection Service* does not have a traditional UI. It exposes a set
of REST APIs for various administrations and configurations related tasks. It
uses the [Swagger API Documentation](https://swagger.io/) tool to generate a
webpage that lists all the REST APIs and the best part is that the REST APIs
can be tried directly from the webpage.

The API page uses the default context root for *Swagger UI* which is
*/swagger-ui.html*. This URL and other REST URLs are protected by basic 
authentication. The default username is *admin* and the password is also
*admin* although it can be configured to use something else. Once you go past
the authentication page, here's how the API page looks like:

![The API page](assets/images/ams-data-collection-service-api-page.png)

### Configs
*Configs* is the short for the *JSON configuration* objects

#### Source configs

#### Destination configs

### Config operations

#### Store

#### Retrieve

#### Remove

### Data collection

#### Start/stop

#### Status

### Conclusion
