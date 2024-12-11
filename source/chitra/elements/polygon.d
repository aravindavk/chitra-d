module chitra.elements.polygon;

import std.format;

import chitra.context;
import chitra.properties;
import chitra.elements.core;

struct Polygon
{
    double[2][] points;
    bool close;
    ShapeProperties shapeProps;

    this(double[2][] points, bool close = false)
    {
        this.points = points;
        this.close = close;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        double[2][] newPoints;
        foreach (p; points)
            newPoints ~= [chitraCtx.correctedSize(p[0]), chitraCtx.correctedSize(p[1])];

        cairo_move_to(cairoCtx, newPoints[0][0], newPoints[0][1]);
        foreach (p; newPoints[1 .. $])
            cairo_line_to(cairoCtx, p[0], p[1]);

        if (this.close)
            cairo_close_path(cairoCtx);

        drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
    }
}

mixin template polygonFunctions()
{
    private double[2][] pointsFromArray(double[] data)
    {
        double[2][] points;
        for (int i = 0; i < data.length / 2; i++)
        {
            points ~= [data[i * 2], data[i * 2 + 1]];
        }

        return points;
    }

    /**
       Draw polygon shape. By default closes the path
    
       ---
       ctx.polygon([[50, 450], [50, 50], [450, 50], [100, 100]], true);
       ---
     */
    void polygon(double[2][] points, bool close = true)
    {
        auto s = Polygon(points, close);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    /**
       Draw polygon shape. By default closes the path

       ---
       ctx.polygon([50, 450, 50, 50, 450, 50, 100, 100], true);
       ---
    */
    void polygon(double[] points, bool close = true)
    {
        auto points1 = pointsFromArray(points);
        polygon(points1);
    }

}
