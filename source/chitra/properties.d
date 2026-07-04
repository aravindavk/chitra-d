module chitra.properties;

import std.format;
import std.string;
import std.conv;
import std.typecons : Nullable;
import std.math : isNaN;

import chitra.rgba;

public import chitra.elements.formatted_strings;

enum CENTER = "center";
enum RADIUS = "radius";
enum CORNER = "corner";
enum CORNERS = "corners";

// Image or Background Fitting
enum FILL = "fill";
enum CONTAIN = "contain";
enum COVER = "cover";
enum CROP = "crop";

struct GridCell
{
    double x;
    double y;
    double width;
    double height;
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
    GridCell cell(int col, int row)
    {
        double x = originX + columnGap * col + colWidth * (col - 1);
        double y = originY + rowGap * row + rowHeight * (row - 1);
        lastAccessedCell = row * cols - (cols - col);
        return GridCell(x, y, colWidth, rowHeight);
    }

    // Fetch the Grid cell by cell number
    GridCell cell(int idx)
    {
        import std.math.rounding : ceil;

        if (idx < 0)
            idx = cellsCount + 1 + idx;

        int col = idx % cols;
        if (col == 0) col = cols;

        int row = cast(int)ceil(cast(double)idx / cols);

        return cell(col, row);
    }

    GridCell prevCell()
    {
        if (lastAccessedCell == 1) return GridCell(0, 0, 0, 0);

        return cell(lastAccessedCell - 1);
    }

    GridCell nextCell()
    {
        if (lastAccessedCell == cellsCount) return GridCell(0, 0, 0, 0);

        return cell(lastAccessedCell + 1);
    }
}

struct ShapeProperties
{
    RGBA fill = RGBA(0, 0, 0);
    RGBA stroke = RGBA(0, 0, 0);
    int strokeWidth = 1;
    bool noFill = false;
    bool noStroke = false;
    // line_dash = LineDash.new,
    //     line_cap = LibCairo::LineCapT::Butt,
    //   line_join = LibCairo::LineJoinT::Miter
    Nullable!RGBA tint = Nullable!RGBA.init;
    string ovalMode = CENTER;
}

struct BorderProperties
{
    RGBA fill = RGBA(0);
}

mixin template propertiesFunctions()
{
    void fill(float r, float g, float b, float a = -1.0)
    {
        shapeProps.noFill = false;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        shapeProps.fill = RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a);
    }

    void fill(float gray, float a = -1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        shapeProps.noFill = false;
        shapeProps.fill = RGBA(gray, gray, gray, a);
    }

    void fill(string hexValue, float a = -1.0)
    {
        shapeProps.noFill = false;
        // TODO: Handle if RGBA is null
        shapeProps.fill = RGBA.parse(hexValue).get;
        shapeProps.fill = setAlpha(shapeProps.fill, a);
    }

    void fillOpacity(float a)
    {
        shapeProps.fill = RGBA(shapeProps.fill.r, shapeProps.fill.g, shapeProps.fill.b, a / colorScaleAlphaMax);
    }

    void stroke(float r, float g, float b, float a = -1.0)
    {
        shapeProps.noStroke = false;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        shapeProps.stroke = RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a);
    }

    void stroke(float gray, float a = 1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        shapeProps.noStroke = false;
        shapeProps.stroke = RGBA(gray, gray, gray, a);
    }

    void stroke(string hexValue, float a = -1.0)
    {
        shapeProps.noStroke = false;
        // TODO: Handle if RGBA is null
        shapeProps.stroke = RGBA.parse(hexValue).get;
        shapeProps.stroke = setAlpha(shapeProps.stroke, a);
    }

    void strokeOpacity(float a)
    {
        shapeProps.stroke = RGBA(shapeProps.stroke.r, shapeProps.stroke.g, shapeProps.stroke.b, a / colorScaleAlphaMax);
    }

    void noStroke()
    {
        shapeProps.noStroke = true;
    }

    void strokeWidth(int value)
    {
        value = correctedSize(value);
        shapeProps.noStroke = false;
        shapeProps.strokeWidth = value;
    }

    void noFill()
    {
        shapeProps.noFill = true;
    }

    void textColor(float r, float g, float b, float a = -1.0)
    {
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        textProps.color = RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a);
    }

    void textColor(float gray, float a = 1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        textProps.color = RGBA(gray, gray, gray, a);
    }

    void textColor(string hexValue, float a = -1.0)
    {
        // TODO: Handle if RGBA is null
        textProps.color = RGBA.parse(hexValue).get;
        textProps.color = setAlpha(textProps.color.get, a);
    }

    void textOpacity(float a)
    {
        auto c = textProps.color;
        if (!c.isNull)
            textProps.color = RGBA(c.get.r, c.get.g, c.get.b, a / colorScaleAlphaMax);
    }

    void textBgColor(float r, float g, float b, float a = -1.0)
    {
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        textProps.background = RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a);
    }

    void textBgColor(float gray, float a = -1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        textProps.background = RGBA(gray, gray, gray, a);
    }

    void textBgColor(string hexValue, float a = -1.0)
    {
        // TODO: Handle if RGBA is null
        textProps.background = RGBA.parse(hexValue).get;
        textProps.background = setAlpha(textProps.background.get, a);
    }

    void textBgOpacity(float a)
    {
        auto c = textProps.background;
        if (!c.isNull)
            textProps.background = RGBA(c.get.r, c.get.g, c.get.b, a / colorScaleAlphaMax);
    }

    void textSize(float size)
    {
        textProps.size = size;
    }

    void textSize(TextNamedSize size)
    {
        textProps.namedSize = size;
    }

    void textFont(string family)
    {
        textProps.font = family;
    }

    void textFont(string family, float size)
    {
        textFont(family);
        textSize(size);
    }

    void textFont(string family, TextNamedSize size)
    {
        textFont(family);
        textSize(size);
    }

    void textLineHeight(float value)
    {
        textProps.lineHeight = value;
    }

    void textWeight(float value)
    {
        textProps.weight = value;
    }

    void textWeight(TextNamedWeight value)
    {
        textProps.namedWeight = value;
    }

    void textFeatures(string value)
    {
        textProps.features = value;
    }

    void borderColor(float r, float g, float b, float a = -1.0)
    {
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        borderProps.fill = RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a);
    }

    void borderColor(float gray, float a = -1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        borderProps.fill = RGBA(gray, gray, gray, a);
    }

    RGBA setAlpha(RGBA col, float a = -1.0)
    {
        a = a == -1 ? col.a : a / colorScaleAlphaMax;

        return RGBA(col.r, col.g, col.b, a);
    }

    void borderColor(string hexValue, float a = -1.0)
    {
        borderProps.fill = RGBA.parse(hexValue).get;
        borderProps.fill = setAlpha(borderProps.fill, a);
    }

    /**
       Switch between color Scales (Default is 0-255)

       ---
       ctx.colorScale(1); // 0-1 Scale
       ctx.colorScale(255); // 0-255 Scale
       ---

       To use 0-255 scale for RGB and 0-1 for alpha

       ---
       ctx.colorScale(255, 1);
       ctx.fill(186, 239, 60, 0.5);
       ---
     */
    void colorScale(int max = 255, int maxA = 0)
    {
        colorScaleMax = max;
        colorScaleAlphaMax = maxA == 0 ? max : maxA;
    }

    void tint(float r, float g, float b, float a = -1.0)
    {
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        shapeProps.tint = RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a);
    }

    void tint(float gray, float a = -1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        shapeProps.tint = RGBA(gray, gray, gray, a);
    }

    void tint(string hexValue, float a = -1.0)
    {
        // TODO: Handle if RGBA is null
        shapeProps.tint = RGBA.parse(hexValue).get;
        shapeProps.tint = setAlpha(shapeProps.tint.get, a);
    }

    void noTint()
    {
        import std.typecons : Nullable;

        shapeProps.tint = Nullable!RGBA.init;
    }

    void ovalMode(string value)
    {
        shapeProps.ovalMode = value;
    }

    /**
       Initialize a new named grid

       ---
       //       NAME    COLS ROWS
       ctx.grid("main", 3,   2);
       ---

       Optional Rows (Default to 1)

       ---
       //       NAME    COLS
       ctx.grid("main", 3);  // Same as ctx.grid("main", 3, 1);
       ---

       Control Gap between grid cells

       ---
       ctx.grid("main", 3, 2, gap: 10);
       ctx.grid("main", 3, 2, columnGap: 20, rowGap: 10);
       ---

     */
    void grid(string name, int cols, int rows = 1, double gap = 0, double columnGap = double.init, double rowGap = double.init)
    {
        grids_[name] = Grid.create(cols, rows, gap: gap, columnGap: columnGap, rowGap: rowGap);
        grids_[name].setSize(0, 0, width, height);
    }

    /**
       Initialize a new grid (Default name)

       ---
       //       COLS ROWS
       ctx.grid(3,   2);
       ---

       Optional Rows (Default to 1)

       ---
       //       COLS
       ctx.grid(3);  // Same as ctx.grid(3, 1);
       ---

       Control Gap between grid cells

       ---
       ctx.grid(3, 2, gap: 10);
       ctx.grid(3, 2, columnGap: 20, rowGap: 10);
       ---

     */
    void grid(int cols, int rows = 1, double gap = 0, double columnGap = double.init, double rowGap = double.init)
    {
        grid("default", cols, rows, gap, columnGap, rowGap);
    }

    /**
       Set the size of the named Grid. Default size of the grid is canvas/page width.

       ---
       //       NAME    COLS  ROWS
       ctx.grid("main", 3,    2);
       //           NAME    X    Y    WIDTH            HEIGHT
       ctx.gridSize("main", 100, 100, ctx.width - 200, ctx.height - 200);
       ---
     */
    void gridSize(string name, double x, double y, double w, double h)
    {
        grids_[name].setSize(x, y, w, h);
    }

    /**
       Set the size of the default Grid. Default size of the grid is canvas/page width.

       ---
       //       COLS  ROWS
       ctx.grid(3,    2);
       //           X    Y    WIDTH            HEIGHT
       ctx.gridSize(100, 100, ctx.width - 200, ctx.height - 200);
       ---
     */
    void gridSize(double x, double y, double w, double h)
    {
        gridSize("default", x, y, w, h);
    }

    /**
       Set the size of the named Grid using a grid cell.

       ---
       //       NAME    COLS  ROWS  GAP
       ctx.grid("main", 2,    2,    gap: 20);
       ctx.gridSize("main", 50, 50, ctx.width - 100, ctx.height - 100);
       auto firstCell = gridCell("main", 1);
       ctx.grid("subgrid", 4, 4);
       //           NAME    X    Y    WIDTH            HEIGHT
       ctx.gridSize("subgrid", firstCell);
       ---
     */
    void gridSize(string name, GridCell cell)
    {
        gridSize(name, cell.x, cell.y, cell.width, cell.height);
    }

    /**
       Set the size of the default Grid using a grid cell.

       ---
       //       COLS  ROWS  GAP
       ctx.grid(3,    3,    gap: 20);
       ctx.gridSize(50, 50, ctx.width - 100, ctx.height - 100);
       auto middleCell = gridCell(5);
       // Overwrite the default cell using the middle cell
       // dimentions
       ctx.grid(4, 4);
       //           NAME    X    Y    WIDTH            HEIGHT
       ctx.gridSize(middleCell);
       ---
     */
    void gridSize(GridCell cell)
    {
        gridSize("default", cell.x, cell.y, cell.width, cell.height);
    }

    /**
       Get a grid cell of a named grid by column number and row number.

       ---
       //                   NAME    COL  ROW
       auto cell = gridCell("main", 2,   2);
       ---
     */
    GridCell gridCell(string name, int col, int row)
    {
        return grids_[name].cell(col, row);
    }

    /**
       Get a grid cell of the default grid by column number and row number.

       ---
       //                   COL  ROW
       auto cell = gridCell(2,   2);
       ---
     */
    GridCell gridCell(int col, int row)
    {
        return gridCell("default", col, row);
    }

    /**
       Get a grid cell of a named grid by cell number.

       ---
       //                   NAME    INDEX
       auto cell = gridCell("main", 2);
       ---

       Use negative index to access from the last

       ---
       auto cell = gridCell("main", -1);
       ---
    */
    GridCell gridCell(string name, int idx)
    {
        return grids_[name].cell(idx);
    }

    /**
       Get a grid cell of the default grid by cell number.

       ---
       //                   NUMBER
       auto cell = gridCell(2);
       ---

       Use negative index to access from the last

       ---
       auto cell = gridCell(-1);
       ---
     */
    GridCell gridCell(int idx)
    {
        return gridCell("default", idx);
    }

    /**
       Access the previous Cell of a named grid based on last accessed.

       ---
       auto cell = prevGridCell("main");
       ---
     */
    GridCell prevGridCell(string name)
    {
        return grids_[name].prevCell;
    }

    /**
       Access the previous Cell of the default grid based on last accessed.

       ---
       auto cell = prevGridCell;
       ---
     */
    GridCell prevGridCell()
    {
        return prevGridCell("default");
    }

    /**
       Access the next Cell of a named grid based on last accessed.

       ---
       auto cell = nextGridCell("main");
       ---
     */
    GridCell nextGridCell(string name)
    {
        return grids_[name].nextCell;
    }

    /**
       Access the next Cell of the default grid based on last accessed.

       ---
       auto cell = nextGridCell;
       ---
     */
    GridCell nextGridCell()
    {
        return nextGridCell("default");
    }

    /**
       Access multiple grid cells as single cell. For example, Grid cell spanned to two cells.

       ---
       ctx.grid("main", 3, 1, gap: 10);
       ctx.gridSize("main", 10, 10, ctx.width - 20, ctx.height - 20);
       auto mediaCell = ctx.gridCell("main", 1);
       // Draw image ..

       auto secondCell = ctx.gridCell("main", 2);
       auto thirdCell = ctx.gridCell("main", 3);
       auto detailCell = ctx.gridArea("main", secondCell, thirdCell);
       // Add Text ..
       ---
     */
    GridCell gridArea(string name, GridCell c1, GridCell c2)
    {
        double startX, endX, startY, endY;

        if (c1.x < c2.x)
        {
            startX = c1.x;
            endX = c2.x + c2.width;
        }
        else
        {
            startX = c2.x;
            endX = c1.x + c1.width;
        }

        if (c1.y < c2.y)
        {
            startY = c1.y;
            endY = c2.y + c2.height;
        }
        else
        {
            startY = c2.y;
            endY = c1.y + c1.height;
        }

        return GridCell(startX, startY, endX - startX, endY - startY);
    }

    /**
       Access multiple grid cells as single cell (From default grid).
       For example, Grid cell spanned to two cells.

       ---
       ctx.grid(3, 1, gap: 10);
       ctx.gridSize(10, 10, ctx.width - 20, ctx.height - 20);
       auto mediaCell = ctx.gridCell(1);
       // Draw image ..

       auto secondCell = ctx.gridCell(2);
       auto thirdCell = ctx.gridCell(3);
       auto detailCell = ctx.gridArea(secondCell, thirdCell);
       // Add Text ..
       ---
     */
    GridCell gridArea(GridCell start, GridCell end)
    {
        return gridArea("default", start, end);
    }

    /**
       Access multiple grid cells as single cell. For example, Grid cell spanned to two cells.

       ---
       ctx.grid("main", 3, 1, gap: 10);
       ctx.gridSize("main", 10, 10, ctx.width - 20, ctx.height - 20);
       auto mediaCell = ctx.gridCell("main", 1);
       // Draw image ..

       auto detailCell = ctx.gridArea("main", 2, 3);
       // Add Text ..
       ---
     */
    GridCell gridArea(string name, int start, int end)
    {
        auto c1 = gridCell(name, start);
        auto c2 = gridCell(name, end);

        return gridArea(name, c1, c2);
    }

    /**
       Access multiple grid cells as single cell (From default grid).
       For example, Grid cell spanned to two cells.

       ---
       ctx.grid(3, 1, gap: 10);
       ctx.gridSize(10, 10, ctx.width - 20, ctx.height - 20);
       auto mediaCell = ctx.gridCell(1);
       // Draw image ..

       auto detailCell = ctx.gridArea(2, 3);
       // Add Text ..
       ---
     */
    GridCell gridArea(int start, int end)
    {
        return gridArea("default", start, end);
    }
}
