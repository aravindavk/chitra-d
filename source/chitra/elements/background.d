module chitra.elements.background;

import std.format;

import chitra.properties;
import chitra.elements.core;

struct Background
{
    double w, h;
    ShapeProperties shapeProps;

    this(double w, double h)
    {
        this.w = w;
        this.h = h;
    }

    void draw(cairo_t* cairoCtx)
    {
        cairo_rectangle(cairoCtx, 0, 0, w, h);
        drawShapeProperties(cairoCtx, shapeProps);
    }
}

mixin template backgroundFunctions()
{
    /**
       Draw the background.

       ---
       // Draw blue background
       //             r  g  b
       ctx.background(0, 0, 255);
       ---
     */
    void background(int r, int g, int b, int a = 255)
    {
        auto s = Background(this.width, this.height);
        s.shapeProps = this.shapeProps;

        // Override the new values for the background
        s.shapeProps.fill = Color(r, g, b, a);
        s.shapeProps.strokeWidth = 0;

        s.draw(this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    /**
       Draw the background.

       ---
       // Draw gray background
       ctx.background(124);
       ---
     */
    void background(int gray, int a = 255)
    {
        background(gray, gray, gray, a);
    }

    /**
       Draw the background.

       ---
       // Draw blue background
       ctx.background("#0000FF");
       ---
    */
    void background(string hexValue)
    {
        auto color = Color.fromHexString(hexValue).get;
        background(color.r, color.g, color.b, color.a);
    }
}
