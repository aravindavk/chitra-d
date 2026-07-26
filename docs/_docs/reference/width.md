---
title: width
---

```
ctx.width;
```

Returns width of the Paper.

Example:

```d
// Draw a rectangle that fits half of the paper
//       X  Y  W              H
ctx.rect(0, 0, ctx.width / 2, 200);

// Draw horizontal line
//       X1   Y1   X2               Y2
ctx.line(100, 100, ctx.width - 200, 100); 
```
