---
title: Coordinate system and the Paper sizes.
---

Chitra uses a coordinate system that starts at the top left. The point `(0, 0)` is located at the top left corner. The x-axis goes from left to right, and the y-axis goes from top to bottom.

<IMG>

For example, to draw a rectangle starting from `(100, 100)`, set its width to `400` points and height to `200` points. This demonstrates how coordinates and dimensions interact in Chitra.

```d
auto ctx = new Chitra;
//       X    Y    W    H
ctx.rect(100, 100, 400, 200);
```

Chitra supports customizing paper sizes in multiple ways. If only the width is provided, a square paper or canvas is created. Standard page sizes, such as `A0–A10`, `B0–B10`, and `C0–C10`, are also supported.

```d
// Standard paper size
auto ctx = new Chitra("a4");

// Standard paper size with landscape orientation
auto ctx = new Chitra("a4,landscape");

// Custom size square paper
auto ctx = new Chitra(400);

// Default size: 700x700 points
auto ctx = new Chitra;

// Custom width and height
auto ctx = new Chitra(1600, 900);

// Using utility functions (4x6 inch photo paper)
auto ctx = new Chitra(4.inch, 6.inch);

// A4 paper in mm
auto ctx = new Chitra(210.mm, 297.mm);
```

The equivalent code with the Chitra Lua plugin is

```lua
-- Standard paper size
size("a4")

-- Standard paper size with landscape orientation
size("a4,landscape")

-- Custom size square paper
size(400)

-- Default size: 700x700 points
-- Not Applicable, skip calling the `size` command

-- Custom width and height
size(1600, 900)

-- Using utility functions (4x6 inch photo paper)
size(inch(4), inch(6))

-- A4 paper in mm
size(mm(210), mm(297))
```

Once the paper/canvas is created, other commands can retrieve the width and height using the `width` and `height` commands. For example, to draw a vertical line in the middle of the paper.

```d
//       X1             Y1  X2             Y2
ctx.line(ctx.width / 2, 0,  ctx.width / 2, ctx.height / 2);
```
