module chitra.elements.line;

import std.format;

import chitra.properties;
import chitra.elements.core;

struct Line
{
    double x1, y1;
    double x2, y2;
    ShapeProperties shapeProps;

    this(double x1, double y1, double x2, double y2)
    {
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;
    }

    void draw(cairo_t* cairoCtx)
    {
        cairo_move_to(cairoCtx, x1, y1);
        cairo_line_to(cairoCtx, x2, y2);
        drawShapeProperties(cairoCtx, shapeProps);
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
        x1 = correctedSize(x1);
        y1 = correctedSize(y1);
        x2 = correctedSize(x2);
        y2 = correctedSize(y2);

        auto s = Line(x1, y1, x2, y2);
        s.shapeProps = this.shapeProps;
        s.draw(this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
