module chitra.helpers;

import std.typecons;
import std.math : isNaN;
import std.algorithm : min, max;
import std.math.constants : PI;

import chitra.rgba;

struct Size
{
    double width;
    double height;
}

struct Point
{
    double x;
    double y;
}

struct Edge
{
    double x1, y1, x2, y2;

    @property size_t length() const
    {
        import std.math : abs;

        if (x1 == x2)
            return cast(ulong) abs(y1 - y2);

        return cast(ulong) abs(x1 - x2);
    }
}

struct Box
{
    double x;
    double y;
    double width;
    double height;

    @property double w() const
    {
        return width;
    }

    @property double x1() const
    {
        return x;
    }

    @property double y1() const
    {
        return y;
    }

    @property double x2() const
    {
        return x + width;
    }

    @property double y2() const
    {
        return y + height;
    }

    @property double h() const
    {
        return height;
    }

    Point origin()
    {
        return Point(x, y);
    }

    Size size()
    {
        return Size(width, height);
    }

    Edge topEdge()
    {
        return Edge(x, y, x2, y);
    }

    Edge t()
    {
        return topEdge;
    }

    Edge rightEdge()
    {
        return Edge(x2, y, x2, y2);
    }

    Edge r()
    {
        return rightEdge;
    }

    Edge bottomEdge()
    {
        return Edge(x, y2, x2, y2);
    }

    Edge b()
    {
        return bottomEdge;
    }

    Edge leftEdge()
    {
        return Edge(x, y, x, y2);
    }

    Edge l()
    {
        return leftEdge;
    }
}

struct Grid
{
    int cols;
    int rows;
    int cellsCount;
    double columnGap = 0;
    double rowGap = 0;
    double width;
    double height;
    double originX = 0;
    double originY = 0;
    double colWidth = 0;
    double rowHeight = 0;
    int lastAccessedCell = 0;

    // Initialize a new Grid
    static Grid create(int cols, int rows, double gap = 0, double columnGap = double.init, double rowGap = double.init)
    {
        Grid g;
        if (columnGap.isNaN) columnGap = gap;
        if (rowGap.isNaN) rowGap = gap;
        g.cols = cols;
        g.rows = rows;
        g.columnGap = columnGap;
        g.rowGap = rowGap;
        g.cellsCount = cols * rows;

        return g;
    }

    // Calculate column and row width based on canvas size and number
    // of columns and rows.
    private void setColWidthRowHeight()
    {
        colWidth = (width - columnGap * (cols + 1)) / cols;
        rowHeight = (height - rowGap * (rows + 1)) / rows;
    }

    // Limit the size of a grid
    void setSize(double x, double y, double w, double h)
    {
        originX = x;
        originY = y;
        width = w;
        height = h;
        setColWidthRowHeight;
    }

    // Fetch Grid Cell by column number and row number
    Box cell(int col, int row)
    {
        double x = originX + columnGap * col + colWidth * (col - 1);
        double y = originY + rowGap * row + rowHeight * (row - 1);
        lastAccessedCell = row * cols - (cols - col);
        return Box(x, y, colWidth, rowHeight);
    }

    // Fetch the Grid cell by cell number
    Box cell(int idx)
    {
        import std.math.rounding : ceil;

        if (idx < 0)
            idx = cellsCount + 1 + idx;

        int col = idx % cols;
        if (col == 0) col = cols;

        int row = cast(int)ceil(cast(double)idx / cols);

        return cell(col, row);
    }

    Box prevCell()
    {
        if (lastAccessedCell == 1) return Box(0, 0, 0, 0);

        return cell(lastAccessedCell - 1);
    }

    Box nextCell()
    {
        if (lastAccessedCell == cellsCount) return Box(0, 0, 0, 0);

        return cell(lastAccessedCell + 1);
    }
}

Box combine(Box b1, Box b2)
{
    auto x1 = min(b1.x1, b2.x1);
    auto y1 = min(b1.y1, b2.y1);
    auto x2 = max(b1.x2, b2.x2);
    auto y2 = max(b1.y2, b2.y2);

    return Box(x1, y1, x2 - x1, y2 - y1);
}

Box intersect(Box b1, Box b2)
{
    auto x1 = max(b1.x1, b2.x1);
    auto y1 = max(b1.y1, b2.y1);
    auto x2 = min(b1.x2, b2.x2);
    auto y2 = min(b1.y2, b2.y2);

    return Box(x1, y1, x2 - x1, y2 - y1);
}

Box shift(Box box, double dx = 0.0, double dy = 0.0)
{
    return Box(box.x + dx, box.y + dy, box.width, box.height);
}

Box shift(Box box, Point pt)
{
    return Box(pt.x, pt.y, box.width, box.height);
}

Box inset(Box box, double dx = 0.0, double dy = 0.0)
{
    return Box(box.x + dx, box.y + dy, box.width - 2 * dx, box.height - 2 * dy);
}

// 1pt = 1/72 of inch
double inch(T)(T value)
{
    return value * 72;
}

double cm(T)(T value)
{
    return (value / 2.54).inch;
}

double mm(T)(T value)
{
    return (value / 10.0).cm;
}

// 1 pt = 1/72 of inch and 1 px = 1/96 of inch
double px(T)(T value)
{
    return (72.0/96.0) * value;
}

// No conversion needed
double pt(T)(T value)
{
    return value;
}

Nullable!RGBA color(int r, int g, int b, float a = 1.0)
{
    return RGBA.parse(r, g, b, a);
}

Nullable!RGBA color(int gray, float a = 1.0)
{
    return RGBA.parse(gray, gray, gray, a);
}

Nullable!RGBA color(string hexValue)
{
    return RGBA.parse(hexValue);
}

double findDistance(double x1, double y1, double x2, double y2)
{
    import std.math : sqrt, abs;

    auto xDist = abs(x2 - x1);
    auto yDist = abs(y2 - y1);

    return sqrt(xDist * xDist + yDist * yDist);
}

double findDistance(Point p1, Point p2)
{
    return findDistance(p1.x, p1.y, p2.x, p2.y);
}

double distance(double x1, double y1, double x2, double y2)
{
    return findDistance(x1, y1, x2, y2);
}

double distance(Point p1, Point p2)
{
    return findDistance(p1, p2);
}

double dist(double x1, double y1, double x2, double y2)
{
    return findDistance(x1, y1, x2, y2);
}

double dist(Point p1, Point p2)
{
    return findDistance(p1, p2);
}

double toRadians(double angle)
{
    return PI * angle / 180;
}

double toDegrees(double angle)
{
    return 180 * angle / PI;
}

// 90.degrees will be converted to equivalant Radians value
double degrees(T)(T angle)
{
    return PI * angle / 180;
}

// No Conversion needed
double radians(T)(T angle)
{
    return angle;
}
