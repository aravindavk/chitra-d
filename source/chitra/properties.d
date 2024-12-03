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
    Color fill = rgb(0, 0, 0);
    Color stroke = rgb(0, 0, 0);
    int strokeWidth = 1;
    bool noFill = false;
    bool noStroke = false;
    // line_dash = LineDash.new,
    //     line_cap = LibCairo::LineCapT::Butt,
    //   line_join = LibCairo::LineJoinT::Miter
}

mixin template propertiesFunctions()
{
    void fill(int r, int g, int b, float a = 1.0)
    {
        shapeProps.noFill = false;
        shapeProps.fill = rgba(r, g, b, a);
    }

    void fill(int gray, float a = 1.0)
    {
        shapeProps.noFill = false;
        shapeProps.fill = rgba(gray, gray, gray, a);
    }

    void fill(string hexValue)
    {
        shapeProps.noFill = false;
        shapeProps.fill = color(hexValue);
    }

    void fillOpacity(float a = 1.0)
    {
        shapeProps.fill = rgba(shapeProps.fill.toRGBAf.r, shapeProps.fill.toRGBAf.g, shapeProps.fill.toRGBAf.b, a);
    }

    void stroke(int r, int g, int b, float a = 1.0)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = rgba(r, g, b, a);
    }

    void stroke(int gray, float a = 1.0)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = rgba(gray, gray, gray, a);
    }

    void stroke(string hexValue)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = color(hexValue);
    }

    void strokeOpacity(float a = 1.0)
    {
        shapeProps.stroke = rgba(shapeProps.stroke.toRGBAf.r, shapeProps.stroke.toRGBAf.g, shapeProps.stroke.toRGBAf.b, a);
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
}
