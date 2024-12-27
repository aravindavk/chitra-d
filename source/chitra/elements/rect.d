module chitra.elements.rect;

import std.format;
import std.math.constants;

import chitra.context;
import chitra.properties;
import chitra.elements.core;

struct Rect
{
    double x_, y_;
    double w_, h_;
    double r_, rtl_, rtr_, rbl_, rbr_;
    ShapeProperties shapeProps;

    this(double x, double y, double w, double h, double r, double rtl, double rtr, double rbr, double rbl)
    {
        this.x_ = x;
        this.y_ = y;
        this.w_ = w;
        this.h_ = h;
        this.r_ = r;
        this.rtl_ = rtl;
        this.rtr_ = rtr;
        this.rbl_ = rbl;
        this.rbr_ = rbr;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        auto w = chitraCtx.correctedSize(w_);
        auto h = chitraCtx.correctedSize(h_);
        auto r = chitraCtx.correctedSize(r_);
        auto rtl = chitraCtx.correctedSize(rtl_);
        auto rtr = chitraCtx.correctedSize(rtr_);
        auto rbr = chitraCtx.correctedSize(rbr_);
        auto rbl = chitraCtx.correctedSize(rbl_);

        if (r == 0 && rtl < 0 && rtr < 0 && rbl < 0 && rbr < 0)
            cairo_rectangle(cairoCtx, x, y, w, h);
        else
        {
            // Border radius is not given
            if (rtl < 0) rtl = r;
            if (rtr < 0) rtr = r;
            if (rbl < 0) rbl = r;
            if (rbr < 0) rbr = r;

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
        drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
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
    void rect(double x, double y, double w, double h = 0.0, double r = 0, double rtl = -1.0, double rtr = -1.0, double rbr = -1.0, double rbl = -1.0)
    {
        h = h == 0.0 ? w : h;
        auto rct = Rect(x, y, w, h, r, rtl, rtr, rbr, rbl);
        rct.shapeProps = this.shapeProps;
        rct.draw(this, this.defaultCairoCtx);
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
    void square(double x, double y, double w, double r = 0, double rtl = -1.0, double rtr = -1.0, double rbr = -1.0, double rbl = -1.0)
    {
        rect(x, y, w, w, r, rtl, rtr, rbr, rbl);
    }

    /**
       Draw a pixel.

       ---
       //        x    y
       ctx.pixel(100, 100);
       // Pixel with custom width
       ctx.pixel(50, 50, 2);
       ---
     */
    void pixel(double x, double y, int w=1)
    {
        auto prevStrokeWidth = this.shapeProps.strokeWidth;
        strokeWidth(0);
        rect(x, y, w.px);
        strokeWidth(prevStrokeWidth);
    }
}
