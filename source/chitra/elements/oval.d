module chitra.elements.oval;

import std.format;
import std.math.constants;

import chitra.context;
import chitra.properties;
import chitra.elements.core;

struct Oval
{
    double x_, y_, w_, h_;
    ShapeProperties shapeProps;

    this(double x, double y, double w, double h)
    {
        this.x_ = x;
        this.y_ = y;
        this.w_ = w;
        this.h_ = h;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        auto w = chitraCtx.correctedSize(w_);
        auto h = chitraCtx.correctedSize(h_);

        if (w > 0 && h > 0)
        {
            cairo_save(cairoCtx);
            cairo_translate(cairoCtx, x + w / 2.0, y + h / 2.0);
            cairo_scale(cairoCtx, w / 2.0, h / 2.0);
            cairo_arc(cairoCtx, 0.0, 0.0, 1.0, 0.0, 2.0 * PI);
            cairo_restore(cairoCtx);
            drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
        }
    }
}

mixin template ovalFunctions()
{
    /**
       Draw a Circle or Oval.

       ---
       // Circle of width 100
       //       x   y   w
       ctx.oval(50, 50, 100);

       // Oval of width 100 and height 50
       //       x   y   w    h
       ctx.oval(50, 50, 100, 50);
       ---
     */
    void oval(double x, double y, double w, double h = 0.0)
    {
        h = h == 0.0 ? w : h;
        switch (this.shapeProps.ovalMode)
        {
        case CENTER:
            x = x - (w / 2.0);
            y = y - (h / 2.0);
            break;
        case RADIUS:
            x = x - w;
            y = y - h;
            w = w * 2.0;
            h = h * 2.0;
            break;
        case CORNER:
            break;
        case CORNERS:
            w = w - x;
            h = h - y;
            break;
        default:
            break;
        }

        auto s = Oval(x, y, w, h);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    void oval(GridCell cell)
    {
        oval(cell.x, cell.y, cell.width, cell.height);
    }

    /**
       Draw a Circle.

       ---
       // Circle of width 100
       //         x   y   w
       ctx.circle(50, 50, 100);
       ---
     */
    void circle(double x, double y, double w, double y2 = 0.0)
    {
        oval(x, y, w, y2);
    }

    /**
       Draw a Point

       ---
       // Point with default width(1)
       //        x   y
       ctx.point(50, 50);
       // Point with custom width
       ctx.point(50, 50, 2);
       ---
     */
    void point(double x, double y, int w=1)
    {
        auto prevStrokeWidth = this.shapeProps.strokeWidth;
        auto prevNoStroke = this.shapeProps.noStroke;
        auto prevOvalMode = this.shapeProps.ovalMode;
        strokeWidth(0);
        ovalMode(CENTER);
        oval(x, y, w);
        strokeWidth(prevStrokeWidth);
        if (prevNoStroke) noStroke;
        ovalMode(prevOvalMode);
    }
}
