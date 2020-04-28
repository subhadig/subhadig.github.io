---
layout: post
title: How to call Spring MongoRepository methods from an ExecutorService
date: 2020-04-14
type: post
tags:
comments: true
---
### The problem
Recently I found an unexpected issue when I tried to call the
[Spring MongoRepository](https://docs.spring.io/spring-data/mongodb/docs/current/api/org/springframework/data/mongodb/repository/MongoRepository.html)
from a non-Spring-managed thread in a Java *Spring Boot* application.

#### The Repository interface

```java
public interface ResponseRepository extends MongoRepository<Response, String> {

}

```

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

When `anImaginaryComponent.saveResponseInANewThread(r)` method is invoked, it
never saves the *r* `Response` to the database.

### The solution
Rewrite the `ResponseRepository` interface as below:

```java
import org.springframework.scheduling.annotation.Async;

public interface ResponseRepository extends MongoRepository<Response, String> {

    @Async
    <S extends Response> S save(S entity);
}

```

Also enable sync.

```java
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class DataCollectionServiceApplication {

```

Apparently the [@Async](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/scheduling/annotation/Async.html)
annotation tells Spring to execute the annotated methods asynchronously and not
to wait for the main thread.

It was not easy to find the workaround as there were very few resources on the
internet talking about this issue (which is why I decided to write this post)
but [this](https://stackoverflow.com/questions/47654221/call-to-mongorepository-in-an-executorservice-fails-to-complete)
StackOverflow post did help.
