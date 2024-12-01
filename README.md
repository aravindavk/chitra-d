# Chitra - 2D graphics library - D programming language

## Hello Rectangle

```d

import chitra;

void main()
{
    auto ctx = Chitra(700);
    with (ctx)
    {
        background(255);
        fill(0, 0, 255);
        rect(100, 100, 500, 200);
        saveAs("rect.png");
    }
}
```

## Sponsors

![Kadalu Technologies](static/kadalu-technologies-logo.svg)

## Install

Currently the Chitra project uses Cairo Graphics and Pango libraries. Once it gets the GIF and animation video creation capabilities, I will update the new dependencies here.

Ubuntu

```
sudo apt install libcairo2 libcairo2-dev libpango1.0-dev
```

Fedora

```
sudo yum install cairo-devel pango-devel
```

Mac
```
brew install cairo pango
```

Once the dependencies installed, add Chitra to your project by running

```
dub add chitra
```

## Documentation

### Canvas

Create the canvas to suit your requirement.

```d
// Default size 700x700 pixels
auto ctx = new Chitra;
// Create a Square
auto ctx = new Chitra(800);

// Create a custom size in pixels
//                    w     h
auto ctx = new Chitra(1600, 900);

// Create the canvas with the given resolution (Default is 300)
auto ctx = new Chitra(800, resolution: 72);

// Create with the required paper size
auto ctx = new Chitra("a4");
auto ctx = new Chitra("a4", resolution: 72);
auto ctx = new Chitra("a4,landscape");

// By giving specific size in inch, cm, mm
auto ctx = new Chitra(10.inch, 5.inch);
```

### Using the Canvas

Canvas context can be used in two ways

```d
ctx.rect(100, 100, 500, 200);
ctx.saveAs("rect.png");

// OR using the with statement
with (ctx)
{
    rect(100, 100, 500, 200);
    saveAs("rect.png");
}
```

In this documentation, I will use the second method using `with` statement.

### Properties

#### Width and Height

Access the width and height of the canvas.

```d
rect(100, 100, width - 200, height - 200);
```

#### Background

Fill the background with given color. Color can be provided in `RGB`, or Gray scale or hex strings. Background will draw a rectangle with canvas width and height.

```d
// Black background. 0 - Black and 255 - White
background(0);
// Black background with 50% opacity
background(0, 0.5);

// Blue Background
background(0, 0, 255);

// Blue background with opacity 0.7
background(0, 0, 255, 0.7);

// Hex String
background("#9694FF");

// Or color names
background("blue");
```

#### Fill
Similar to background, specify the color before drawing a shape or the text. For example,

```d
//   color
fill("red");
//   x    y    w    h
rect(100, 100, 500, 200);
```

To remove filling use `noFill`

```d
noFill;
rect(100, 100, 500, 200);
```

Set the Fill opacity with color or set it seperately using `fillOpacity`

```d
fill(0, 0, 255, 0.7);
// OR
fill(0, 0, 255);
fillOpacity(0.7);
```

#### Stroke

Similar to background and fill, specify the stroke color before drawing a shape or the text.

```d
//     color
stroke("red");
noFill;
rect(100, 100, 500, 200);
```

To disable stroke, use `noStroke` and change the width of stroke using `strokeWidth`

```d
// Draw a rectangle with red border, without fill
noFill;
stroke("red");
strokeWidth(2);
rect(100, 100, 500, 100);

// Draw a blue rectangle without the border
noStroke;
fill("blue");
rect(100, 210, 500, 100);
```

Set the Stroke opacity with color or set it seperately using `strokeOpacity`

```d
stroke(0, 0, 255, 0.7);
// OR
stroke(0, 0, 255);
strokeOpacity(0.7);
```

### Shapes

#### Pixel
Draw a single pixel on screen.

```d
//   R  G  B
fill(0, 0, 255);
//    x    y
pixel(100, 100);
```

#### Rectangle
Draw a rectangle

```d
//   x    y    w    h
rect(100, 100, 500, 200);
```

#### Square
Draw a square using `rect` or `square` function

```d
rect(100, 100, 500);
// OR
square(100, 100, 500);
```

Draw a rounded rectangle.

```d
//   x    y    w    h    Radius
rect(100, 100, 500, 200, r: 10);
// Only Top right border radius
rect(100, 100, 500, 200, rtr: 10);
// Similarly use, rtl, rbl, rbr to customize the respective border radius
```

#### Oval
Draw a Oval shape by giving width and height

```d
//   x    y    w    h
oval(100, 100, 500, 200);
```

#### Circle
Draw a circle using `oval` or `circle` function

```d
oval(100, 100, 500);
// OR
circle(100, 100, 500);
```

#### Point
Alias to `circle`.

```d
// Default 2px point
point(100, 100);
point(100, 100, 10);
```

#### Polygon

Give all points in a array or give point pairs in a array to draw a polygon.

```d
//       x1  y1   x2  y2  x3   y3  x4   y4    closePath
polygon([50, 450, 50, 50, 450, 50, 100, 100], true);
//        x1  y1     x2  y2    x3   y3    x4   y4     closePath
polygon([[50, 450], [50, 50], [450, 50], [100, 100]], true);
```

#### Line

Draw a line from one point to another point.

```d
//   x1   y1   x2   y2
line(100, 100, 200, 200);
```

#### New Page and new drawing

While working with PDF documents, use `newPage` to create a new page.

```d
fill("red");
rect(100, 100, width - 200, height - 200);
newPage;
fill("blue");
rect(100, 100, width - 200, height - 200);
saveAs("rects.pdf");
```

To clear the document and start the fresh canvas, use `newDrawing`

```d
background(0);
saveAs("slide1.png");
newDrawing;
background(0, 0, 255);
saveAs("slide2.png");
```

#### Transformations

##### Rotate
Rotate the canvas.

```d
//     angle in degrees
rotate(45);
rect(100, 100, 500, 200;
```

To rotate from the center of the rect,

```d
//     angle  centerX  centerY
rotate(45,    350,     200);
rect(100, 100, 500, 200;
```

##### Scale

```d
scale(2);
rect(100, 100, 500, 200);
```
To scale x and y seperately,

```d
scale(2, 1);
rect(100, 100, 500, 200);
```

##### Translate

Translate the canvas to given x and y. This will become new origin for all the drawings.

```d
translate(100, 100);
rect(0, 0, 500, 200);
```

This will be very useful to draw the complex shapes. Create the complex shape as a function and then call the function multiple times with different translate values.

### Export/Save

PDF, PNG and SVG output formats are supported.

```d
saveAs("rect.png");
saveAs("rect.pdf");
saveAs("rect.svg");
```

