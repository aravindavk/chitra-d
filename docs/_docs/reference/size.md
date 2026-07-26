---
title: size
---

```
ctx.size(PAPER);
ctx.size(double width);
ctx.size(double width, double height);
Size ctx.size;
```

Set or get the size of the Paper.

Get the size of the Paper

```
auto s = ctx.size;
writefln("Width: %s  Height: %s", s.width, s.height);
```

Example:

```d
auto s = ctx.size;

// Draw a rectangle that fits half of the paper
//       X  Y  W            H
ctx.rect(0, 0, s.width / 2, s.height);

// Draw horizontal line
//       X1   Y1   X2             Y2
ctx.line(100, 100, s.width - 200, 100); 
```

Set the paper size while initializing the Chitra context. Alternatively, set the size dynamically.

```d
auto ctx = new Chitra; // Default paper size is 700x700
ctx.size(1600, 900);
```

A4 Paper

```d
auto ctx = new Chitra("a4");
// OR
auto ctx = new Chitra;
ctx.size("a4");
```

Example (Set the Paper size same as image size)

```
auto ctx = new Chitra;

auto img = ctx.imageSize("tiger.png");
ctx.size(img.width, img.height);
```
