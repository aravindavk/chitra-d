module chitra.elements.draw_path;

import std.format;

import chitra.context;
import chitra.properties;
import chitra.elements.core;
import chitra.helpers;
import chitra.elements.path;

struct DrawPath
{
    Path path;
    bool close;
    ShapeProperties shapeProps;

    Point corrected(Context chitraCtx, Point p)
    {
        return Point(chitraCtx.correctedSize(p.x), chitraCtx.correctedSize(p.y));
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        // Move to starting point
        auto origin = corrected(chitraCtx, path.origin);
        cairo_move_to(cairoCtx, origin.x, origin.y);

        foreach(segment; path.segments)
        {
            if (segment.name == "line")
            {
                auto p2 = corrected(chitraCtx, segment.p2);
                cairo_line_to(cairoCtx, p2.x, p2.y);
            }
            else if (segment.name == "move")
            {
                auto p2 = corrected(chitraCtx, segment.p2);
                cairo_move_to(cairoCtx, p2.x, p2.y);
            }
            else if (segment.name == "curve")
            {
                auto p2 = corrected(chitraCtx, segment.p2);
                auto cp1 = corrected(chitraCtx, segment.cp1);
                auto cp2 = corrected(chitraCtx, segment.cp2);
                cairo_curve_to(cairoCtx, cp1.x, cp1.y, cp2.x, cp2.y, p2.x, p2.y);
            }
            // TODO: arcTo implement. Based on xy and radius, find center xy,
            // start angle and end angle.
            // else if (segment.name == "arc")
        }

        if (close)
            cairo_close_path(cairoCtx);

        drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
    }
}

mixin template drawPathFunctions()
{
    import chitra.elements.path;

    Path newPath(double x, double y)
    {
        this.lastPath_ = Path(x, y);
        return this.lastPath;
    }

    Path newPath(Point p)
    {
        return newPath(p.x, p.y);
    }

    Path curveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x2, double y2)
    {
        this.lastPath_.curveTo(cp1x, cp1y, cp2x, cp2y, x2, y2);
        return this.lastPath;
    }

    Path curveTo(Point cp1, Point cp2, Point p2)
    {
        this.lastPath_.curveTo(cp1, cp2, p2);
        return this.lastPath;
    }

    Path lineTo(double x2, double y2)
    {
        this.lastPath_.lineTo(x2, y2);
        return this.lastPath;
    }

    Path lineTo(Point p2)
    {
        this.lastPath_.lineTo(p2);
        return this.lastPath;
    }

    Path arcTo(double x2, double y2, double radius)
    {
        this.lastPath_.arcTo(x2, y2, radius);
        return this.lastPath;
    }

    Path arcTo(Point p2, double radius)
    {
        this.lastPath_.arcTo(p2, radius);
        return this.lastPath;
    }

    Path moveTo(double x2, double y2)
    {
        this.lastPath_.moveTo(x2, y2);
        return this.lastPath;
    }

    Path moveTo(Point p2)
    {
        this.lastPath_.moveTo(p2);
        return this.lastPath;
    }

    void drawPath(Path path, bool close = false)
    {
        auto s = DrawPath(path, close);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    void drawPath(bool close = false)
    {
        drawPath(this.lastPath_, close);
    }

    void bezier(Point p1, Point cp1, Point cp2, Point p2, bool close = false)
    {
        newPath(p1);
        curveTo(cp1, cp2, p2);
        drawPath(close);
    }

    void bezier(double x1, double y1, double cp1x, double cp1y, double cp2x, double cp2y, double x2, double y2, bool close = false)
    {
        bezier(Point(x1, y1), Point(cp1x, cp1y), Point(cp2x, cp2y), Point(x2, y2), close);
    }

    Path lastPath()
    {
        return this.lastPath_;
    }
}
