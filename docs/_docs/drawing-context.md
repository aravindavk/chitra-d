---
title: Drawing Context
---

After initializing the Chitra context, it is possible to use in two different ways.

```d
auto ctx = new Chitra(1200, 900);
ctx.rect(100, 100, 600, 200);
ctx.saveAs("rect.png");
```

Using `with` block,

```d
auto ctx = new Chitra(1200, 900);
with (ctx)
{
    rect(100, 100, 600, 200);
    saveAs("rect.png");
}
```
