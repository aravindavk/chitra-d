module chitra.elements.background;

import std.format;

import chitra.context;
import chitra.properties;
import chitra.elements.core;

struct Background
{
    double w_, h_;
    ShapeProperties shapeProps;

    this(double w, double h)
    {
        this.w_ = w;
        this.h_ = h;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto w = chitraCtx.correctedSize(w_);
        auto h = chitraCtx.correctedSize(h_);
        cairo_rectangle(cairoCtx, 0, 0, w, h);
        drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
    }
}

mixin template backgroundFunctions()
{
    void background(RGBA color)
    {
        auto s = Background(this.width, this.height);
        s.shapeProps = this.shapeProps;

        // Override the new values for the background
        s.shapeProps.fill = color;
        s.shapeProps.strokeWidth = 0;

        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    /**
       Draw the background.

       ---
       // Draw blue background
       //             r  g  b
       ctx.background(0, 0, 255);
       ---
     */
    void background(float r, float g, float b, float a = -1.0)
    {
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        background(RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a));
    }

    /**
       Draw the background.

       ---
       // Draw gray background
       ctx.background(124);
       ---
     */
    void background(float gray, float a = -1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        background(gray, gray, gray, a);
    }

    /**
       Draw the background.

       ---
       // Draw blue background
       ctx.background("#0000FF");
       ---

       Draw an image as background

       ---
       ctx.background("awesome.png", fit: COVER);
       ---
    */
    void background(string value, float a = -1.0, string fit = FILL, double offsetX = 0.0, double offsetY = 0.0)
    {
        auto col = RGBA.parse(value);
        // If the given value is not a valid Hex code or color name,
        // then it may be a file path.
        if (!col.isNull)
            background(setAlpha(col.get, a));
        else
            image(value, 0, 0, this.width, this.height, fit: fit, offsetX: offsetX, offsetY: offsetY);
    }
}
