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
of other applications. In this post, I will be discussing about the second
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

### DataCollectionConfig
A *DataCollectionConfig* contains the required details for the *Data Collection
Service* to start collecting data (metrics) from a source system and push to a
destination system. One *Data Collection Service* is capable of collecting
data from multiple source systems and publish to multiple destination systems.

#### Source configs
Although *Data Collection Service* includes a flexible enough framework which
is capable of supporting data collection from various source types and also
publishing to multiple destination types, currently it depends on a polling
based mechanism for data collection and only the applications supporting the
[Spring Boot Actuator](https://spring.io/guides/gs/actuator-service/) APIs like
the
[Data Provider Service](ams-data-provider-service-generating-performance-metrics-with-spring-boot-actuator.html)
is supported.

A *SourceConfig* specifies the source system details within a
*DataCollectionConfig*.

#### Destination configs
Currently only pushing data to [MongoDB](https://www.mongodb.com/) is supported
but in future *Data Collection Service* is also going to support pushing data
to a [Kafka](https://kafka.apache.org/) stream. While the destination type can
be selected in a *DataCollectionConfig*, the destination system details are not
exposed and is not user configurable.

Here's how a complete *DataCollectionConfig* looks like:

```json
{
  "id": "an-auto-generated-long-uuid-value",
  "description": "An arbitary user input field",
  "destination": "Database",
  "source": "SpringActuator",
  "sourceConfig": {
	"pollInterval": 60,
	"protocol": "http",
	"ipAddress": "source-ip-address-or-hostname",
	"port": 8080,
	"userName": "admin",
	"password": "admin"
  }
}
```

### Config operations
Several *DataCollectionConfig* operations are supported by the
*Data Collection Service* REST APIs. Here's a list of supported operations.

#### Store
A *DataCollectionConfig* can be created or updated. If the payload
*DataCollectionConfig* contains the *id* field, then it is treated as an
existing *DataCollectionConfig*, or else a new *DataCollectionConfig* is
created.

#### Retrieve
A *DataCollectionConfig* can be searched by *ids* or they can be retrieved as
a collection. 

#### Remove
*DataCollectionConfigs* can be removed by *ids* from the database.

### Data collection
Although data collection is started as soon as a *DataCollectionConfigs* is
created and stopped when deleted, data collection status for a
*DataCollectionConfigs* can be monitored or administered.

#### Start/stop
A *DataCollectionConfigs* can be manually started or stopped by *id*.

#### Status
The running status of a *DataCollectionConfigs* can be monitored.

### Conclusion
The source code for the *Data Collection Service* can be found
[here](https://github.com/subhadig/application-monitoring-system/tree/master/data-collection-service).
While the *Data Collection Service* does not support most of the source and
destination system types, it can be easily enhanced to support additional
array of protocols and systems.

In the next post, I will talk about the *Data Streaming Service* and pushing
data from the *Data Collection Service* to the *Data Streaming Service*.
