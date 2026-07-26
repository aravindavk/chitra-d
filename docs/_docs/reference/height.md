---
title: height
---

```
ctx.height;
```

Returns height of the Paper.

Example:

```d
// Draw a rectangle that fits half of the paper
//       X  Y  W    H
ctx.rect(0, 0, 400, ctx.height / 2);

// Draw vertical line
//       X1   Y1   X2   Y2
ctx.line(100, 100, 100, ctx.height - 200); 
```
