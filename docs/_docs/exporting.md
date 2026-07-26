---
title: Exporting the generated Graphics
---

Chitra supports exporting to `PDF`, `PNG` and `SVG` formats.

### Export to PDF

```d
import chitra;
​
void main()
{
    auto ctx = new Chitra(700);
    with (ctx)
    {
        rect(100, 100, 500, 200);
        saveAs("rect.pdf");
    }
}
```

### Export to PNG

```d
import chitra;
​
void main()
{
    auto ctx = new Chitra(700);
    with (ctx)
    {
        rect(100, 100, 500, 200);
        saveAs("rect.png");
    }
}
```

### Export to SVG

```d
import chitra;
​
void main()
{
    auto ctx = new Chitra(700);
    with (ctx)
    {
        rect(100, 100, 500, 200);
        saveAs("rect.svg");
    }
}
```

## Resolution

Default resolution is `300`. Change the resolution while saving.

```d
saveAs("rect.pdf", resolution: 72);
saveAs("rect.png", resolution: 72);
saveAs("rect.svg", resolution: 72);
```
