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

<a href="https://kadalu.tech"><img src="static/kadalu-technologies-logo.svg" alt="Kadalu Technologies" width="200"/></a>

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

// Create with the required paper size
auto ctx = new Chitra("a4");
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

#### Background and Border

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

Add border to canvas using,

```d
// Black border of thickness 2
border;

// Border with margin
border(m: 10);
border(m: 10, mt: 0);

// Border with different color
border(m: 10, color: color("blue"));

// Border with radius
border(m: 10, color: color("blue"), r: 7);
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

### PNG images

Add PNG image to the canvas using,

```d
//    Path        x   y
image("logo.png", 50, 50);
```

To scale the image,

```d
auto size = imageSize("logo.png");
auto requiredWidth = 300;
auto s = requiredWidth/size.width;
// Scale the canvas
scale(s);
// Draw the image
image("logo.png", 100/s, 100/s);
// Scale the canvas back to its original scale
scale(1/s);
```

### Text

Set the properties and draw text using,

```d
textFont("Inter", 20);
textColor("blue");
text("Hello World!", 100, 100);
```

Use `FormattedString` type to customize the text formatting. Below code is equivalant to the above code.

```d
auto props = TextProperties(color: color("blue"), size: 20, font: "Inter");
auto t = FormattedString("Hello World!", props);
text(t, 100, 100);
```

Adding text and more formatting is very simple. For example,

```d
auto h1Style = TextProperties(size: 24.88, namedWeight: TextNamedWeight.bold, color: color(0));
auto parStyle = TextProperties(size: 12, color: color(0));

alias FS = FormattedString;

FS sample;
sample ~= FS("Hello World!\n", h1Style);
sample ~= FS("This is a paragraph\n", parStyle);

text(sample, 100, 100);
```

### Export/Save

PDF, PNG and SVG output formats are supported.

```d
saveAs("rect.png");
saveAs("rect.pdf");
saveAs("rect.svg");
```

Set resolution

```d
saveAs("rect.png", resolution: 300);
saveAs("rect.pdf", resolution: 300);
saveAs("rect.svg", resolution: 300);
```

## Thanks

- [Cairo Graphics](https://www.cairographics.org/)
- Drawing API syntax are inspired from [Drawbot](https://drawbot.com/) and [Processing](https://processing.org/).

## Contributing

- Fork it (https://github.com/aravindavk/chitra-d/fork)
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request

## Contributors

- [Aravinda VK](https://github.com/aravindavk) - Creator and Maintainer
