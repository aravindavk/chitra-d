module chitra.elements.rect;

import std.format;
import std.math.constants;

import chitra.properties;
import chitra.elements.core;

struct Rect
{
    double x, y;
    double w, h;
    double r, rtl, rtr, rbl, rbr;
    ShapeProperties shapeProps;

    this(double x, double y, double w, double h, double r, double rtl, double rtr, double rbr, double rbl)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.r = r;
        this.rtl = rtl;
        this.rtr = rtr;
        this.rbl = rbl;
        this.rbr = rbr;
    }

    void draw(cairo_t* cairoCtx)
    {
        if (r + rtl + rtr + rbl + rbr == 0)
            cairo_rectangle(cairoCtx, x, y, w, h);
        else
        {
            // Border radius is given
            if (rtl == 0) rtl = r;
            if (rtr == 0) rtr = r;
            if (rbl == 0) rbl = r;
            if (rbr == 0) rbr = r;

            double fromX = x + rtl;
            double toX = x + w - rtr;
            double fromY = y;
            double toY = y;
            cairo_move_to(cairoCtx, fromX, fromY);
            cairo_line_to(cairoCtx, toX, toY);
            cairo_arc(cairoCtx, toX, toY+rtr, rtr, PI*3/2, 0);

            fromX = x + w;
            toX = x + w;
            fromY = y + rtr;
            toY = y + h - rbr;
            cairo_line_to(cairoCtx, toX, toY);
            cairo_arc(cairoCtx, toX-rbr, toY, rbr, 0, PI/2);

            toX = x + rbl;
            toY = y + h;
            cairo_line_to(cairoCtx, toX, toY);
            cairo_arc(cairoCtx, toX, toY-rbl, rbl, PI/2, PI);

            toX = x;
            toY = y + rtl;
            cairo_line_to(cairoCtx, toX, toY);
            cairo_arc(cairoCtx, x + rtl, y + rtl, rtl, PI, PI*3/2);

            cairo_close_path(cairoCtx);
        }
        drawShapeProperties(cairoCtx, shapeProps);
    }
}

mixin template rectFunctions()
{
    /**
       Draw a Square or Rectangle.

       ---
       // Square of width 100
       //       x   y   w
       ctx.rect(50, 50, 100);

       // Rectangle of width 100 and height 50
       //       x   y   w    h
       ctx.rect(50, 50, 100, 50);
       ---
     */
    void rect(double x, double y, double w, double h = 0.0, double r = 0, double rtl = 0.0, double rtr = 0.0, double rbr = 0, double rbl = 0)
    {
        h = h == 0.0 ? w : h;
        auto rct = Rect(x, y, w, h, r, rtl, rtr, rbr, rbl);
        rct.shapeProps = this.shapeProps;
        rct.draw(this.defaultCairoCtx);
        this.elements ~= Element(rct);
    }

    /**
       Draw a Square.

       ---
       // Square of width 100
       //         x   y   w
       ctx.square(50, 50, 100);
       ---
     */
    void square(double x, double y, double w, double r = 0, double rtl = 0.0, double rtr = 0.0, double rbr = 0, double rbl = 0)
    {
        rect(x, y, w, w, r, rtl, rtr, rbr, rbl);
    }
}
