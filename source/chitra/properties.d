module chitra.properties;

import std.format;
import std.string;
import std.conv;
import std.typecons : Nullable;

import chitra.rgba;
import chitra.pangocairo;
import chitra.constants;

public import chitra.elements.formatted_strings;

struct ShapeProperties
{
    RGBA fill = RGBA(0, 0, 0);
    RGBA stroke = RGBA(0, 0, 0);
    int strokeWidth = 1;
    bool noFill = false;
    bool noStroke = false;
    double[] strokeDash;
    double strokeDashOffset = 0.0;
    auto strokeCap = BUTT;
    auto strokeJoin = MITER;
    Nullable!RGBA tint = Nullable!RGBA.init;
    string ovalMode = CENTER;
    string angleMode = RADIANS;
}

struct BorderProperties
{
    RGBA fill = RGBA(0);
}

mixin template propertiesFunctions()
{
    float applyColorScale(float value)
    {
        return value / colorScaleMax;
    }

    float applyColorScaleAlpha(float value)
    {
        return value / colorScaleAlphaMax;
    }

    RGBA parseColor(float r, float g, float b, float a = -1.0)
    {
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        return RGBA(r / colorScaleMax, g / colorScaleMax, b / colorScaleMax, a);
    }

    RGBA parseColor(float gray, float a = -1.0)
    {
        gray = gray / colorScaleMax;
        a = a == -1 ? colorScaleAlphaMax : a / colorScaleAlphaMax;
        return RGBA(gray, gray, gray, a);
    }

    RGBA parseColor(string hexValue, float a = -1.0)
    {
        auto col = RGBA.parse(hexValue).get;
        return setAlpha(col, a);
    }

    void fill(float r, float g, float b, float a = -1.0)
    {
        shapeProps.noFill = false;
        shapeProps.fill = parseColor(r, g, b, a);
    }

    void fill(float gray, float a = -1.0)
    {
        shapeProps.noFill = false;
        shapeProps.fill = parseColor(gray, a);
    }

    void fill(string hexValue, float a = -1.0)
    {
        shapeProps.noFill = false;
        // TODO: Handle if RGBA is null
        shapeProps.fill = parseColor(hexValue, a);
    }

    void fillAlpha(float a)
    {
        shapeProps.fill = setAlpha(shapeProps.fill, a);
    }

    void stroke(float r, float g, float b, float a = -1.0)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = parseColor(r, g, b, a);
    }

    void stroke(float gray, float a = 1.0)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = parseColor(gray, a);
    }

    void stroke(string hexValue, float a = -1.0)
    {
        shapeProps.noStroke = false;
        // TODO: Handle if RGBA is null
        shapeProps.stroke = parseColor(hexValue, a);
    }

    void strokeAlpha(float a)
    {
        shapeProps.stroke = setAlpha(shapeProps.stroke, a);
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

    void strokeWeight(int value)
    {
        strokeWidth(value);
    }

    void noFill()
    {
        shapeProps.noFill = true;
    }

    void textBackground(float r, float g, float b, float a = -1.0)
    {
        textProps.noTextBackground = false;
        textProps.background = parseColor(r, g, b, a);
    }

    void textBackground(float gray, float a = -1.0)
    {
        textProps.noTextBackground = false;
        textProps.background = parseColor(gray, a);
    }

    void noTextBackground()
    {
        textProps.noTextBackground = true;
    }

    void textBackground(string hexValue, float a = -1.0)
    {
        textProps.noTextBackground = false;
        // TODO: Handle if RGBA is null
        textProps.background = parseColor(hexValue, a);
    }

    void textBackgroundAlpha(float a)
    {
        auto c = textProps.background;
        if (!c.isNull)
            textProps.background = setAlpha(c.get, a);
    }

    void fontSize(float size)
    {
        textProps.size = size;
    }

    void fontSize(FontNamedSize size)
    {
        textProps.namedSize = size;
    }

    void font(string family)
    {
        textProps.font = family;
    }

    void font(string family, float size)
    {
        font(family);
        fontSize(size);
    }

    void font(string family, FontNamedSize size)
    {
        font(family);
        fontSize(size);
    }

    void textAlign(string value)
    {
        auto ta = value.to!(TextAlign);
        textProps.align_ = ta;
    }

    void hyphenation(bool value)
    {
        textProps.hyphenation = value;
    }

    void lineHeight(float value)
    {
        textProps.lineHeight = value;
    }

    void fontWeight(float value)
    {
        textProps.weight = value;
    }

    void fontWeight(string value)
    {
        textProps.namedWeight = value.to!FontNamedWeight;
    }

    void textFeatures(string value)
    {
        textProps.features = value;
    }

    void underline(string value)
    {
        textProps.underline = value.to!TextUnderline;
    }

    void underline(bool value)
    {
        if (!value)
            textProps.underline = TextUnderline.none;
    }

    void borderColor(float r, float g, float b, float a = -1.0)
    {
        borderProps.fill = parseColor(r, g, b, a);
    }

    void borderColor(float gray, float a = -1.0)
    {
        borderProps.fill = parseColor(gray, a);
    }

    RGBA setAlpha(RGBA col, float a = -1.0)
    {
        a = a == -1 ? col.a : a / colorScaleAlphaMax;

        return RGBA(col.r, col.g, col.b, a);
    }

    void borderColor(string hexValue, float a = -1.0)
    {
        borderProps.fill = parseColor(hexValue, a);
    }

    void borderColorAlpha(float a)
    {
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
        shapeProps.tint = parseColor(r, g, b, a);
    }

    void tint(float gray, float a = -1.0)
    {
        shapeProps.tint = parseColor(gray, a);
    }

    void tint(string hexValue, float a = -1.0)
    {
        // TODO: Handle if RGBA is null
        shapeProps.tint = parseColor(hexValue, a);
    }

    void tintAlpha(float a)
    {
        if (!shapeProps.tint.isNull)
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
    void gridSize(string name, Box cell)
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
    void gridSize(Box cell)
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
    Box gridCell(string name, int col, int row)
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
    Box gridCell(int col, int row)
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
    Box gridCell(string name, int idx)
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
    Box gridCell(int idx)
    {
        return gridCell("default", idx);
    }

    /**
       Access the previous Cell of a named grid based on last accessed.

       ---
       auto cell = prevGridCell("main");
       ---
     */
    Box prevGridCell(string name)
    {
        return grids_[name].prevCell;
    }

    /**
       Access the previous Cell of the default grid based on last accessed.

       ---
       auto cell = prevGridCell;
       ---
     */
    Box prevGridCell()
    {
        return prevGridCell("default");
    }

    /**
       Access the next Cell of a named grid based on last accessed.

       ---
       auto cell = nextGridCell("main");
       ---
     */
    Box nextGridCell(string name)
    {
        return grids_[name].nextCell;
    }

    /**
       Access the next Cell of the default grid based on last accessed.

       ---
       auto cell = nextGridCell;
       ---
     */
    Box nextGridCell()
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
    Box gridArea(string name, Box c1, Box c2)
    {
        return combine(c1, c2);
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
    Box gridArea(Box start, Box end)
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
    Box gridArea(string name, int start, int end)
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
    Box gridArea(int start, int end)
    {
        return gridArea("default", start, end);
    }

    /** Set line dash pattern. `line_dash 0` disables
        the dash.Symmetric dash pattern with one value
        to this function.
        ---
        ctx.strokeDash(2);
        ---
        To set the offset value to start the pattern
        ---
        ctx.strokeDash(2, offset: 1);
        ---
    */
    void strokeDash(double inkSkip, double offset = 0)
    {
        shapeProps.strokeDash = inkSkip > 0 ? [inkSkip, inkSkip] : [];
        shapeProps.strokeDashOffset = offset;
    }

    void lineDash(double inkSkip, double offset = 0)
    {
        strokeDash(inkSkip, offset);
    }

    /** Set line dash pattern. `line_dash 0` disables
        the dash.Symmetric dash pattern with one value
        to this function.

        Asymmetric pattern
        ---
        ctx.strokeDash([2, 4, 10]);
        ---
        To set the offset value to start the pattern
        ---
        ctx.strokeDash([2, 4, 10], offset: 1);
        ---
    */
    void strokeDash(double[] inkSkip, double offset=0)
    {
        shapeProps.strokeDash = inkSkip;
        shapeProps.strokeDashOffset = offset;
    }

    void lineDash(double[] inkSkip, double offset=0)
    {
        strokeDash(inkSkip, offset);
    }

    void strokeCap(T)(T value)
    {
        shapeProps.strokeCap = value;
    }

    void lineCap(T)(T value)
    {
        strokeCap(value);
    }

    void strokeJoin(T)(T value)
    {
        // Conflict of Constants!
        import std.conv : asOriginalType;
        switch(value.asOriginalType)
        {
        case ROUND:
            shapeProps.strokeJoin = ROUND_;
            break;
        case BEVEL:
            shapeProps.strokeJoin = BEVEL;
            break;
        default:
            shapeProps.strokeJoin = MITER;
            break;
        }
    }

    void lineJoin(T)(T value)
    {
        strokeJoin(value);
    }

    void angleMode(string value)
    {
        shapeProps.angleMode = value;
    }

    void syntaxHighlight(bool value, string theme="algol")
    {
        textProps.syntaxHighlight = value;
        textProps.syntaxHighlightTheme = theme;
    }
}
