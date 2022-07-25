---
layout: post
title: Understanding Kotlin Covariance and Contravariance
date: 2022-07-25
type: post
tags:
    - kotlin
comments: true
---
### Introduction
To someone coming from the Java world to the world of Kotlin, the concepts of
Covariance and Contravariance can be somewhat overwhelming to grab at first.
But they don't have to be once you start understanding the basic cadence of it.
This article is going to be a step by step depiction of how I have come to
understand these two topics.

---
**Table of Contents**
* TOC
{:toc}
---

### Let's create some classes!
First let's create a small class hierarchy that we can use to understand these
concepts.
`Paper` is the parent class of the `Regular` paper and the `Premium` paper.

```kotlin
open class Paper {

}

class Regular: Paper() {

}

class Premium: Paper() {

}
```

### Let's create some lists!!

First let's create a List of `Regular` papers called `regularPapers`.
```kotlin
val regularPapers: List<Regular> = listOf(Regular())
```

And now if we declare a List of the parent type `Paper` called `papers` and try
to assign the just created `regularPapers` List to it, we will see that it works
without any compilation errors.
```kotlin
val papers: List<Paper> = regularPapers
```

Sure a List of `Regular` paper is still a List of `Paper`, you say.
There is nothing earth-shattering about it!

But when you look at the following example you will surely think that there is
more going on under the hood than meets the eye.

```kotlin
    val mutableRegularPapers: MutableList<Regular> = mutableListOf(Regular())
    val mutablePapers: MutableList<Paper> = mutableRegularPapers //This line gives compilation error 
```
When you replace the `List` with a `MutableList` in our example, you will see
that the compilation fails with this error: `Type mismatch: inferred type is
MutableList<Regular> but MutableList<Paper> was expected`.

But what could be so different between a `List` and a `MutableList` so that a
List of `Regular` papers can be used as a List of `Paper` but a MutableList of
`Regular` papers can not be used as a MutableList of `Paper`?
As it turns out, the answer lies in the definitions of `List` and `MutableList`.

```kotlin
public interface List<out E> : Collection<E> {
  ..
}

public interface MutableList<E> : List<E>, MutableCollection<E> {
  ..
}
```
The `out` keyword in the List declaration makes all the difference.
This means that a `List<T>` is assignable to any `List<U>` where `U` is a
subtype of `T`.
But the same is not true for a `MutableList` since it's declared as
`MutableList<E>` and not as `MutableList<out E>`.
This is Covariance for you in a nutshell.

### Covariance
Covariance follows the natural inheritance order where a less generic subtype
can be used in place of a more generic supertype.
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
So Covariance is the Kotlin Generics feature that allows us to pass a `Box` of
`Regular` papers as a Box of `Paper`.

### Contravariance
Contravariance is the inverse of Covariance where a more generic subtype can be
used in place of a less generic supertype.
Contravariance is expressed with the `in` keyword.

Let's declare a Contravariant class called `Printer`.
```kotlin
class Printer<in T> {
    
}
```

When your office Printer that uses `Premium` papers is out of order, it may be
okay to have a temporary replacement Printer that uses any `Paper`.
The following code compiles without any error.
```kotlin
val paperPrinter = Printer<Paper>()
val premiumPrinter: Printer<Premium> = paperPrinter
```
So Contravariance is the Kotlin Generics feature that allows us to use a
`Printer` of parent type `Paper` in place of a Printer of `Premium` papers.

### Limitations of Covariance and Contravariance
Covariance and Contravariance do not come without their limitations over the
Invariant types (types that do not use either of the `out` or `in` keywords and
are rigid in terms of accepting either the subtypes or the supertypes) generic
types.

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
This is not an unreasonable ask when you think about it from the perspective of
the compiler - given that the generics type information is erased during the
compilation and is unavailable in the runtime, if we could somehow use a
Covariant type as an input to the `add` function of a `MutableList`, there would
have been nothing to stop us from inserting a `Premium` paper in a list of
purely `Regular` papers which could have caused all types of issues afterwards.
```kotlin
val regularPapers: List<Regular> = listOf(Regular())
val papers: List<Paper> = regularPapers
papers.add(Premium()) //This line does not compile, thankfully!
```

Similarly a Class using a Contravariant type can only be used as a Consumer of
the Contravariant type, never a Producer.
In other words, our `Printer` class can only have functions that take `T` as
inputs but never a function that outputs `T`.

```kotlin
class Printer<in T> {
    fun take(t: T) {} //OK!

    fun eject(): T { //This line does not compile!
    }
}
```

Which is again understandable since the Contravariant `mutableRegularPapers` has
no way to ensure in the runtime that the paper it returns is of type only
`Regular`.
```kotlin
val mutablePapers: MutableList<Paper> = mutableListOf(Paper())
val mutableRegularPapers: MutableList<in Regular> = mutablePapers
val regular: Regular = mutableRegularPapers.removeAt(0) //This line does not compile as the mutableRegularPapers.removeAt(0) returns an object of type Any?
```

### Conclusion
The Covariant and Contravariant examples used in this article are called
Declaration-site variance as they are used in Class or Interface declaration.
When Covariant and Contravariant types are used in function declaration, it's
called Use-site variance.
Although both work in the same way, it is important to know the distinction.
Even though Kotlin supports both, Java only supports the latter.
