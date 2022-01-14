---
layout: post
title: GIMP - Crop to the edges of a document and change Perspective
date: 2022-01-14
type: post
tags:
    - gimp
comments: true
---
### Introduction
[GIMP](https://www.gimp.org/) is an free and open-source alternative of the
more popular photo-editing tool Adobe Photoshop and a rather capable one.
Since I don't have a scanner at home, if I need to quickly share a soft copy of
a physical document online, I take a photo of the document from my mobile
phone.
The problem with photos is that the sides of the document will not appear
parallely in the photo.
I used to use Google Photos to crop the document to the edges in the photos so
that it appears somewhat like a scanned document and not an obvious photo taken
from a mobile phone camera.

This solution works well for the most part.
The problem with this is that:

- This is only available for Google Photos for Android.
- Doing this on a small mobile phone screen is not really an easy thing.
- I am not much of a fan of relying too much on proprietary software.

So I use GIMP now for cropping a document image and I will explain how quick
and painless the process is in this post.

---
**Table of Contents**
* TOC
{:toc}
---

### The Image
Here's an image of an empty notebook page that we will use for demonstration.
I placed it on a reddish background and took this picture from my mobile phone
camera.

![](assets/images/gimp-crop-1.jpg)

We will open the image with GIMP for editing.

![](assets/images/gimp-crop-2.jpg)

### Crop it first
First we will crop the document to a rectangle as close as possible to it's
actual edges with the help of the *Crop* tool.

Open the *Crop* tool from Menu > Tools > Transform Tools > Crop.
Draw a rectangle around the edges of the document like this.

![](assets/images/gimp-crop-3.jpg)

Drag the edges and the corners of the rectangle to change the crop area.
Once you are satisfied with it, press enter to actually crop it.

### Delete the remaining areas outside of the document
In this step we will remove the remaining background from the image.
Go to Menu > Tools > Selection Tools and open *Free Select*.

Click on each of the corners to select the actual document like this.

![](assets/images/gimp-crop-4.jpg)

Go to Menu > Select > Invert to invert the selection so that the outer area is
selected instead of the document.
Press `Delete` to delete the selected area.

![](assets/images/gimp-crop-5.jpg)

### Do Perspective transformation
In this step we will transform the shape of the document so that becomes a
perfect rectangle.

First invert the selection again so that the inner document is selected instead
of the outer area.

Go to Menu > Tools > Transform Tools and select *Perspective* to open the
Perspective tool.
Drag the corners so that the inner document area fills the whole frame.

![](assets/images/gimp-crop-6.jpg)

When you are satisfied with the result, click on the *Transform* button on the
*Perspective* tool pop-up window.

![](assets/images/gimp-crop-7.jpg)

### Export the image
Click on Menu > File > Export As... to export the final image.
This is how our final image looks like.

![](assets/images/gimp-crop-final.jpg)

### Conclusion
I am not an expert GIMP user.
