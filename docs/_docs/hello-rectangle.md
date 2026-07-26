---
title: Hello Rectangle
---

Create a Rectangle with `width: 600` and `height: 200` in a canvas `900x400`.

```d
import chitra;

void main()
{
    auto ctx = new Chitra(900, 400);

    with (ctx)
    {
        // stroke color Red
        stroke("red");

        // Fill Sapphire Blue color
        fill("sapphireblue");

        //   X    Y    W    H
        rect(100, 100, 600, 200);

        // Save as PNG image
        ctx.saveAs("hello_rect.png");
    }
}
```

![Hello Rectangle](/static/images/hello-rect.png)
