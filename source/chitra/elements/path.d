module chitra.elements.path;

import chitra.helpers;

struct Segment
{
    string name;
    Point p1;
    Point p2;
    Point[] controls;
    double radius;

    Point cp1()
    {
        return controls[0];
    }

    Point cp2()
    {
        return controls[1];
    }

    Segment[] controlLines()
    {
        Segment[] pts;
        if (name != "curve") return pts;

        pts ~= Segment("line", p1, controls[0]);
        pts ~= Segment("line", controls[1], p2);
        return pts;
    }

    Point[] points()
    {
        return [p1, p2];
    }

    Box bounds()
    {
        // TODO: Implementation
        return Box(0, 0, 0, 0);
    }
}

struct Path
{
    Point origin;
    Segment[] segments;
    Point lastPoint;

    this(double x, double y)
    {
        origin.x = x;
        origin.y = y;
        lastPoint = origin;
    }

    Point[] points()
    {
        Point[] pts;
        foreach(segment; segments)
            pts ~= segment.points;

        return pts;
    }

    Point[] controls()
    {
        Point[] pts;
        foreach(segment; segments)
            pts ~= segment.controls;

        return pts;
    }

    void curveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x2, double y2)
    {
        curveTo(Point(cp1x, cp1y), Point(cp2x, cp2y), Point(x2, y2));
    }

    void curveTo(Point cp1, Point cp2, Point p2)
    {
        segments ~= Segment("curve", lastPoint, p2, [cp1, cp2]);
        lastPoint = segments[$ - 1].p2;
    }

    void lineTo(double x2, double y2)
    {
        lineTo(Point(x2, y2));
    }

    void lineTo(Point p2)
    {
        segments ~= Segment("line", lastPoint, p2);
        lastPoint = segments[$ - 1].p2;
    }

    void arcTo(double x2, double y2, double radius)
    {
        arcTo(Point(x2, y2), radius);
    }

    void arcTo(Point p2, double radius)
    {
        auto s = Segment("arc", lastPoint, p2);
        s.radius = radius;
        segments ~= s;
        lastPoint = segments[$ - 1].p2;
    }

    void moveTo(Point p2)
    {
        segments ~= Segment("move", lastPoint, p2);
        lastPoint = p2;
    }

    void moveTo(double x, double y)
    {
        moveTo(Point(x, y));
    }
}
