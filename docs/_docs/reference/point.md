---
title: point
---

```
ctx.point(x, y);
```

Draw a point on the Paper. Default width of the point is `1pt`. Customize the width and color using `strokeWeight` and `stroke` commands.

Drawing a point is same as drawing a zero width line with `strokeCap` set to `ROUND`. `point(x, y)` is same as

```d
ctx.strokeCap(ROUND);
ctx.line(x, y, x, y); // zero width line
```

Example:

```d
ctx.strokeWeight(10);
ctx.stroke("red");
ctx.point(100, 100);
```


![Red Dot](/static/images/point-red-dot.png)
