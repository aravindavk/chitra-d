module chitra.elements.oval;

import std.format;
import std.math.constants;
import std.math : isNaN;

import chitra.context;
import chitra.properties;
import chitra.elements.core;
import chitra.constants;
import chitra.helpers : toRadians;

struct Oval
{
    double x_, y_, w_, h_;
    ShapeProperties shapeProps;
    double angle1 = 0.0;
    double angle2 = 2.0 * PI;
    bool close = false;
    string closeMode = PIE;

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
            if (close && closeMode == PIE)
                cairo_move_to(cairoCtx, 0, 0);

            if (angle2 > angle1)
                cairo_arc(cairoCtx, 0.0, 0.0, 1.0, angle1, angle2);
            else
                cairo_arc_negative(cairoCtx, 0.0, 0.0, 1.0, angle1, angle2);

            if (close)
            {
                if (closeMode == PIE)
                    cairo_line_to(cairoCtx, 0, 0);
                else
                    cairo_close_path(cairoCtx);
            }

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
        auto box = basedOnOvalMode(this.shapeProps.ovalMode, x, y, w, h);
        auto s = Oval(box.x, box.y, box.width, box.height);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    void oval(Box cell)
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

    private Box basedOnOvalMode(string mode, double x, double y, double w, double h = 0.0)
    {
        h = h == 0.0 ? w : h;
        switch (mode)
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

        return Box(x, y, w, h);
    }

    void arc(double x, double y, double w, double h, double angle1, double angle2, string mode = OPEN)
    {
        auto box = basedOnOvalMode(this.shapeProps.ovalMode, x, y, w, h);
        auto s = Oval(box.x, box.y, box.width, box.height);

        s.angle1 = angle1;
        s.angle2 = angle2;
        if (shapeProps.angleMode == DEGREES)
        {
            s.angle1 = toRadians(angle1);
            s.angle2 = toRadians(angle2);
        }

        s.close = mode != OPEN;
        s.closeMode = mode;
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    void arc(double x, double y, double w, double angle1, double angle2, string mode = OPEN)
    {
        arc(x, y, w, 0.0, angle1, angle2, mode);
    }
}
