module chitra.properties;

import std.format;
import std.string;
import std.conv;
import std.typecons : Nullable;

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
    Nullable!RGBA tint = Nullable!RGBA.init;
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
}
