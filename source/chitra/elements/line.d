module chitra.elements.line;

import std.format;

import chitra.context;
import chitra.properties;
import chitra.elements.core;

struct Line
{
    double x1_, y1_;
    double x2_, y2_;
    ShapeProperties shapeProps;

    this(double x1, double y1, double x2, double y2)
    {
        this.x1_ = x1;
        this.y1_ = y1;
        this.x2_ = x2;
        this.y2_ = y2;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x1 = chitraCtx.correctedSize(x1_);
        auto y1 = chitraCtx.correctedSize(y1_);
        auto x2 = chitraCtx.correctedSize(x2_);
        auto y2 = chitraCtx.correctedSize(y2_);

        cairo_move_to(cairoCtx, x1, y1);
        cairo_line_to(cairoCtx, x2, y2);
        drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
    }
}

mixin template lineFunctions()
{
    /**
       Draw a Line.

       ---
       ctx.line(100, 100, 500, 500);
       ---
     */
    void line(double x1, double y1, double x2, double y2)
    {
        auto s = Line(x1, y1, x2, y2);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
