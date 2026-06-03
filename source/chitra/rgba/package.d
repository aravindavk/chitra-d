module chitra.rgba;

import std.typecons;
import std.string;
import std.conv : to;

import chitra.rgba.names;


int toScale255(float value)
{
    return (value * 255).to!int;
}

struct RGBA
{
    float r;
    float g;
    float b;
    float a = 1.0;

    static Nullable!RGBA parse(float r, float g, float b, float a = 1.0)
    {
        // TODO: Handle invalid values
        return RGBA(r, g, b, a).nullable;
    }

    static Nullable!RGBA parse(float gray, float a = 1.0)
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
            c.r = h[0 .. 2].to!int(16)/255.0;
            c.g = h[2 .. 4].to!int(16)/255.0;
            c.b = h[4 .. 6].to!int(16)/255.0;
            
            c.a = h.length == 8 ? h[6 .. 8].to!int(16)/255.0 : a;
            color = c;
        }
        else
        {
            auto value = name in colorNames;
            if (value !is null)
            {
                auto rgb = *value;
                color = RGBA(rgb[0] / 255.0, rgb[1] / 255.0, rgb[2] / 255.0, a);
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
        auto alpha = a == 1.0 ? "" : hex_(toScale255(a));
        return "#" ~ hex_(toScale255(r)) ~ hex_(toScale255(g)) ~ hex_(toScale255(b)) ~ alpha;
    }

    string name()
    {
        auto rgbColor = RGB(toScale255(r), toScale255(g), toScale255(b));
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
    assert(color.get.r == 1);
    assert(color.get.g == 0);
    assert(color.get.b == 0);
    assert(color.get.a == 1.0);

    auto color2 = RGBA.parse("#dddddd");
    assert(!color2.isNull);
    assert(toScale255(color2.get.r) == 221);
    assert(toScale255(color2.get.g) == 221);
    assert(toScale255(color2.get.b) == 221);
    assert(color2.get.a == 1.0);

    assert(RGBA.parse(221/255.0, 221/255.0, 221/255.0).get.hexString == "#DDDDDD");
}
