module chitra.elements.polygon;

import std.format;

import chitra.context;
import chitra.properties;
import chitra.elements.core;
import chitra.helpers;

struct Polygon
{
    Point[] points;
    bool close;
    ShapeProperties shapeProps;

    this(Point[] points, bool close = false)
    {
        this.points = points;
        this.close = close;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        Point[] newPoints;
        foreach (p; points)
            newPoints ~= Point(chitraCtx.correctedSize(p.x), chitraCtx.correctedSize(p.y));

        cairo_move_to(cairoCtx, newPoints[0].x, newPoints[0].y);
        foreach (p; newPoints[1 .. $])
            cairo_line_to(cairoCtx, p.x, p.y);

        if (this.close)
            cairo_close_path(cairoCtx);

        drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
    }
}

mixin template polygonFunctions()
{
    private Point[] pointsFromArray(double[] data)
    {
        Point[] points;
        for (int i = 0; i < data.length / 2; i++)
        {
            points ~= Point(data[i * 2], data[i * 2 + 1]);
        }

        return points;
    }

    /**
       Draw polygon shape. By default closes the path
    
       ---
       ctx.polygon([[50, 450], [50, 50], [450, 50], [100, 100]], true);
       ---
     */
    void polygon(Point[] points, bool close = true)
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

    void triangle(double x1, double y1, double x2, double y2, double x3, double y3)
    {
        polygon([Point(x1, y1), Point(x2, y2), Point(x3, y3)], close: true);
    }

    void triangle(Point p1, Point p2, Point p3)
    {
        triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    }
}
