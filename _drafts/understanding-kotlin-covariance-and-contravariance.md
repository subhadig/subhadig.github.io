---
layout: post
title: Understanding Kotlin Covariance and Contravariance
date: 2022-07-18
type: post
tags:
    - kotlin
comments: true
---
### Introduction
To be honest, there is no dearth of articles on the Internet explaining the ever
so difficult and confusing concepts of Covariance and Contravariance in Kotlin
Generics.
This article is a mere step by step depiction of how I have come to understand
these two topics.

---
**Table of Contents**
* TOC
{:toc}
---

### Let's create some classes!
First let's create a small class hierarchy that we can use to understand these
difficult concepts.

```kotlin
open class Paper {

}

class Regular: Paper() {

}

class Premium: Paper() {

}
```

### Let's create some lists!!

First let's create a list of `Regular` papers.
```kotlin
val regularPapers: List<Regular> = listOf(Regular())
```

And now if we declare a list of the parent type `Paper` and try to assign the
just created `regularPapers` list to it, we will see that it works without any
compilation errors.
```kotlin
val papers: List<Paper> = regularPapers
```

Sure a list of `Regular` paper is still a list of `Paper`, you say.
There is nothing earth-shattering about it!

But when you look at the following example you will surely think that there are
more going on under the hood than meets the eye.

```kotlin
    val mutableRegularPapers: MutableList<Regular> = mutableListOf(Regular())
    val mutablePapers: MutableList<Paper> = mutableRegularPapers //This line gives compilation error 
```
When you replace the `List` with a `MutableList` in our example, you will see
that the compilation fails with this error: `Type mismatch: inferred type is
MutableList<Regular> but MutableList<Paper> was expected`.

But what could be so different about a `List` and a `MutableList` so that a List
of `Regular` papers can be used as a List of `Paper` but a MutableList of
`Regular` papers can not be used as a MutableList of `Paper`?
As it turns out, the answer lies in the definition of `List` and `MutableList`.

```kotlin
public interface List<out E> : Collection<E> {
  ..
}

public interface MutableList<E> : List<E>, MutableCollection<E> {
  ..
}
```
So it seems that the `out E` makes all the difference.
This means that a `List<T>` is assignable to any `List<U>` where `U` can be any
subtype of `T`.
This is Covariant for you in a nutshell.

### Covariant
Covariant follows the natural inheritance order where a Class of a more generic
subtype can be used in place of a Class of a less generic supertype.
Covariant is expressed with the `out` keyword.

Let's declare a Covariant class called `Box`.

```kotlin
class Box<out T> {
    
}
```

Now we can create a Box of `Regular` papers and assign it to a Box of `Paper`.
The following code compiles without any error.
```kotlin
val regularPaperBox = Box<Regular>()
val paperBox: Box<Paper> = regularPaperBox
```
So Covariant is the Kotlin Generics feature that allows us to pass Box of
`Regular` papers as a Box of `Paper`.

### Contravariant
Contravariance is the inverse of Covariant where a Class of a generic supertype
can be used instead of a Class of a generic subtype.
Contravariance is expressed with the `in` keyword.

Let's declare a Contravariant class called `Printer`.
```kotlin
class Printer<in T> {
    
}
```

When your office Printer printing `Premium` papers is out of order, it is may be
okay to have a temporary replacement Printer that prints any `Paper`.
The following code compiles without any error.
```kotlin
val paperPrinter = Printer<Paper>()
val premiumPrinter: Printer<Premium> = paperPrinter
```
So Contravariance is the Kotlin Generics feature that allows us to use a Printer
of any `Paper` in place of a Printer of `Premium` papers.

### Limitations of Covariant and Contravariant
Covariant and Contravariant do not come without their limitations over Invariant
(that does not use either of the `out` or `in` keywords and is rigid in terms of
accepting either the subtype of the supertype Classes) generic types.

A Class using a Covariant type can only be used as a Producer of the Covariant
type, never a Consumer.
What this means is that our Box class can only have functions that output `T`
but never a function that takes `T` as an input.

```kotlin
class Box<out T> {
    fun take(): T { //OK!
      ...
    }
    fun put(t: T) {} //This line does not compile
}
```

### Conclusion
