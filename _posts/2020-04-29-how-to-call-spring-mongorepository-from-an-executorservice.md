---
layout: post
title: How to call Spring MongoRepository from an ExecutorService
date: 2020-04-29
type: post
tags:
    - java
    - spring-boot
comments: true
---
### The problem
Recently I encountered an issue in code when I tried to call the
[Spring MongoRepository](https://docs.spring.io/spring-data/mongodb/docs/current/api/org/springframework/data/mongodb/repository/MongoRepository.html)
from a non-Spring-managed thread in a Java *Spring Boot* application. Here is a
brief description of the issue.

#### The Repository interface

```java
public interface ResponseRepository extends MongoRepository<Response, String> {

}

```

It's a standard *Spring Repository* interface without any custom methods.

#### The calling class
```java
@Component //A Spring Component
public class AnImaginaryComponent {

    @Autowired
    private ResponseRepository responseRepo;

    public void saveResponseInANewThread(Response r) {
        //Create an Executor service
        ExecutorService executor = Executors.newSingleThreadExecutor();

        //Submit a Runnable instance
        executor.submit(() -> responseRepo.save(r));
    }
}
```

When `anImaginaryComponent.saveResponseInANewThread(r)` is invoked, it
never saves the *r* `Response` into the database. And the worst part is that
it doesn't throw any exceptions or print any log messages for the failure.

### The solution
Rewrite the `ResponseRepository` interface as below:

```java
import org.springframework.scheduling.annotation.Async;

public interface ResponseRepository extends MongoRepository<Response, String> {

    @Async
    <S extends Response> S save(S entity);
}

```

And enable sync.

```java
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class MySuperImportantSpringBootApplication {

```

Apparently the [@Async](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/scheduling/annotation/Async.html)
annotation tells Spring to execute the annotated methods asynchronously and not
to wait for the main thread.

It was not easy to find the workaround as there were very few resources on the
internet on this issue (which is why I decided to post it on my blog)
but [this](https://stackoverflow.com/questions/47654221/call-to-mongorepository-in-an-executorservice-fails-to-complete)
StackOverflow post did help.
