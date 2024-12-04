module chitra.rgba;

import std.typecons;
import std.string;
import std.conv : to;

import chitra.rgba.names;

struct RGBA
{
    int r;
    int g;
    int b;
    float a = 1.0;

    static Nullable!RGBA parse(int r, int g, int b, float a = 1.0)
    {
        // TODO: Handle invalid values
        return RGBA(r, g, b, a).nullable;
    }

    static Nullable!RGBA parse(int gray, float a = 1.0)
    {
        // TODO: Handle invalid values
        return RGBA(gray, gray, gray, a).nullable;
    }

    static Nullable!RGBA parse(string name, float a = 1.0)
    {
        Nullable!RGBA color;
        if (name.startsWith("#"))
        {
            auto h = name.strip("#");
            RGBA c;
            c.r = h[0 .. 2].to!int(16);
            c.g = h[2 .. 4].to!int(16);
            c.b = h[4 .. 6].to!int(16);
            
            c.a = h.length == 8 ? h[6 .. 8].to!int(16)/255.0 : a;
            color = c;
        }
        else
        {
            auto value = name in colorNames;
            if (value !is null)
            {
                auto rgb = *value;
                color = RGBA(rgb[0], rgb[1], rgb[2], a);
            }
        }

        return color;
    }

    private string hex_(int value)
    {
        auto output = value.to!string(16);
        if (output.length == 2)
            return output;

        return "0" ~ output;
    }

    string hexString()
    {
        auto alpha = a == 1.0 ? "" : hex_((a * 255).to!int);
        return "#" ~ hex_(r) ~ hex_(g) ~ hex_(b) ~ alpha;
    }

    float r100()
    {
        return r / 255.0;
    }

    float g100()
    {
        return g / 255.0;
    }

    float b100()
    {
        return b / 255.0;
    }

    string name()
    {
        auto rgbColor = RGB(r, g, b);
        foreach (color; colorNames.byKeyValue)
        {
            if (color.value == rgbColor)
                return color.key;
        }

        // Name not found, return the hex name
        return hexString;
    }
}

unittest
{
    auto color = RGBA.parse("red");
    assert(!color.isNull);
    assert(color.get.r == 255);
    assert(color.get.g == 0);
    assert(color.get.b == 0);
    assert(color.get.a == 1.0);

    auto color2 = RGBA.parse("#dddddd");
    assert(!color2.isNull);
    assert(color2.get.r == 221);
    assert(color2.get.g == 221);
    assert(color2.get.b == 221);
    assert(color2.get.a == 1.0);

    assert(RGBA.parse(221, 221, 221).get.hexString == "#DDDDDDFF");
}
