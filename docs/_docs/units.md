---
title: Units
---

Default unit when no unit is specified is points.

```d
//   X    Y    W    H
rect(100, 100, 600, 200);
```

## Pixels

Thanks to [Unified Function Call Syntax (UFCS)](https://tour.dlang.org/tour/en/gems/uniform-function-call-syntax-ufcs) feature in D. Use `.px` to specify the units in pixels.

```d
//   X       Y       W       H
rect(100.px, 100.px, 600.px, 200.px);
```

## Inches, cm and mm

It is also possible to provide the units in inches, cm or mm.

```d
//   X      Y      W      H
rect(10.mm, 10.mm, 60.mm, 20.mm);
//   X     Y     W     H
rect(1.cm, 1.cm, 6.cm, 2.cm);
//   X       Y       W       H
rect(1.inch, 1.inch, 4.inch, 2.inch);
```
