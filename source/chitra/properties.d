module chitra.properties;

import std.format;
import std.string;
import std.conv;

import chitra.rgba;

public import chitra.elements.formatted_strings;

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
}

mixin template propertiesFunctions()
{
    void fill(int r, int g, int b, float a = 1.0)
    {
        shapeProps.noFill = false;
        shapeProps.fill = RGBA(r, g, b, a);
    }

    void fill(int gray, float a = 1.0)
    {
        shapeProps.noFill = false;
        shapeProps.fill = RGBA(gray, gray, gray, a);
    }

    void fill(string hexValue)
    {
        shapeProps.noFill = false;
        // TODO: Handle if RGBA is null
        shapeProps.fill = RGBA.parse(hexValue).get;
    }

    void fillOpacity(float a = 1.0)
    {
        shapeProps.fill = RGBA(shapeProps.fill.r, shapeProps.fill.g, shapeProps.fill.b, a);
    }

    void stroke(int r, int g, int b, float a = 1.0)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = RGBA(r, g, b, a);
    }

    void stroke(int gray, float a = 1.0)
    {
        shapeProps.noStroke = false;
        shapeProps.stroke = RGBA(gray, gray, gray, a);
    }

    void stroke(string hexValue)
    {
        shapeProps.noStroke = false;
        // TODO: Handle if RGBA is null
        shapeProps.stroke = RGBA.parse(hexValue).get;
    }

    void strokeOpacity(float a = 1.0)
    {
        shapeProps.stroke = RGBA(shapeProps.stroke.r, shapeProps.stroke.g, shapeProps.stroke.b, a);
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

    void textColor(int r, int g, int b, float a = 1.0)
    {
        textProps.color = RGBA(r, g, b, a);
    }

    void textColor(int gray, float a = 1.0)
    {
        textProps.color = RGBA(gray, gray, gray, a);
    }

    void textColor(string hexValue)
    {
        // TODO: Handle if RGBA is null
        textProps.color = RGBA.parse(hexValue).get;
    }

    void textOpacity(float a = 1.0)
    {
        auto c = textProps.color;
        if (!c.isNull)
            textProps.color = RGBA(c.get.r, c.get.g, c.get.b, a);
    }

    void textBgColor(int r, int g, int b, float a = 1.0)
    {
        textProps.background = RGBA(r, g, b, a);
    }

    void textBgColor(int gray, float a = 1.0)
    {
        textProps.background = RGBA(gray, gray, gray, a);
    }

    void textBgColor(string hexValue)
    {
        // TODO: Handle if RGBA is null
        textProps.background = RGBA.parse(hexValue).get;
    }

    void textBgOpacity(float a = 1.0)
    {
        auto c = textProps.background;
        if (!c.isNull)
            textProps.background = RGBA(c.get.r, c.get.g, c.get.b, a);
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
}
