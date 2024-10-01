module chitra.properties;

import std.format;
import std.string;
import std.conv;

import colors;

struct TextProperties
{
    string font = "Serif";
    string slant = "Normal";
    string weight = "Normal";
    int height = 12;
    double lineHeight = 1.5;
    string align_ = "left";
    string hyphenChar = "-";
    bool hyphenation = false;
}

struct ShapeProperties
{
    Color fill;
    Color stroke;
    int strokeWidth = 1;
    bool noFill = false;
    bool noStroke = false;
    // line_dash = LineDash.new,
    //     line_cap = LibCairo::LineCapT::Butt,
    //   line_join = LibCairo::LineJoinT::Miter
}

mixin template propertiesFunctions()
{
    void fill(int r, int g, int b, int a = 255)
    {
        shapeProps.noFill = false;
        shapeProps.fill = Color(r, g, b, a);
    }

    void fill(int gray, int a = 255)
    {
        shapeProps.noFill = false;
        shapeProps.fill = Color(gray, gray, gray, a);
    }

    void fill(string hexValue)
    {
        shapeProps.noFill = false;
        shapeProps.fill = Color.fromHexString(hexValue).get;
    }

    void fillOpacity(int a = 255)
    {
        // TODO: Expose function in colors library to set opacity
        shapeProps.fill.v4 = a;
    }

    void stroke(int r, int g, int b, int a = 255)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = Color(r, g, b, a);
    }

    void stroke(int gray, int a = 255)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = Color(gray, gray, gray, a);
    }

    void stroke(string hexValue)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = Color.fromHexString(hexValue).get;
    }

    void strokeOpacity(int a = 255)
    {
        // TODO: Expose function in colors library to set opacity
        shapeProps.stroke.v4 = a;
    }

    void noStroke()
    {
        shapeProps.noStroke = true;
    }

    void strokeWidth(int value)
    {
        shapeProps.noStroke = false;
        shapeProps.strokeWidth = value;
    }

    void noFill()
    {
        shapeProps.noFill = true;
    }
}
