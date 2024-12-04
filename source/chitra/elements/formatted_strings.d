module chitra.elements.formatted_strings;

import std.stdio;
import std.traits;
import std.array;
import std.conv;
import std.typecons;
import std.math.traits : isNaN;

import chitra.rgba;
import chitra.context;

enum TextNamedSize { none, xxSmall, xSmall, small, medium, large, xLarge, xxLarge, smaller, larger}
enum TextStyle { none, normal, oblique, italic }
enum TextNamedWeight { none, ultralight, light, normal, bold, ultrabold, heavy }
enum TextVariant { none, normal, smallCaps, allSmallCaps, petiteCaps, allPetiteCaps, unicase, titleCaps }
enum TextStretch { none, ultracondensed, extracondensed, condensed, semicondensed, normal, semiexpanded, expanded, extraexpanded, ultraexpanded }
enum TextUnderline {none, single, double_, low, error}
enum TextOverline {none, single }
enum TextScale {none, superscript, subscript, smallCaps}
enum TextGravity { none, south, east, north, west, auto_}
enum TextGravityHint { none, natural, strong, line }
enum TextTransform { none, lowercase, uppercase, capitalize }
enum TextSegment { none, word, sentence}
enum TextAlign {none, left, right, center }

string toString(TextVariant variant)
{
    import std.regex;
    import std.string;
    import std.conv;

    string camelCaseToHyphen(Captures!(string) m)
    {
        return "-" ~ m.hit;
    }

    return replaceAll!(camelCaseToHyphen)(variant.to!string, regex("[A-Z]"));
}

struct TextProperties
{
    string family;
    float size;
    TextNamedSize namedSize;
    TextStyle style;
    float weight;
    TextNamedWeight namedWeight;
    TextVariant variant;
    TextStretch stretch;
    // Ex: features='dlig=1, -kern, afrc on'
    string features;
    Nullable!RGBA color;
    Nullable!RGBA background;
    float alpha;
    float backgroundAlpha;
    TextUnderline underline;
    Nullable!RGBA underlineColor;
    TextOverline overline;
    Nullable!RGBA overlineColor;
    float rise;
    float baselineShift;
    TextScale scale;
    bool strikeThrough;
    Nullable!RGBA strikeThroughColor;
    string lang;
    float letterSpacing;
    TextGravity gravity;
    TextGravityHint gravityHint;
    bool insertHyphens;
    bool allowLineBreaks;
    float lineHeight;
    TextTransform transform;
    TextSegment segment;
    TextAlign align_;
    string hyphenChar;
    bool hyphenation = false;

    string get(Context chitraCtx)
    {
        string output;

        if (family != "") output ~= i" font_family=\"$(family)\"".text;

        if (!color.isNull) output ~= i" color=\"$(color.get.hexString)\"".text;
        if (size > 0)
        {
            auto s = chitraCtx.correctedSize(size);
            output ~= i" font_size=\"$(s)pt\"".text;
        }
        if (namedSize != TextNamedSize.none) output ~= i" font_size=\"$(namedSize)\"".text;

        if (style != TextStyle.none) output ~= i" font_style=\"$(style)\"".text;

        if (lineHeight > 0) output ~= i" line_height=\"$(lineHeight)\"".text;
        return output;
    }
}

TextProperties defaultTextProperties()
{
    TextProperties props;
    // TODO: Set default properties
    props.size = 16;

    return props;
}

TextProperties updateProperties(TextProperties[] props)
{
    if (props.length < 2)
        return props[0];

    alias attrNames = FieldNameTuple!(TextProperties);
    auto output = props[0];
    TextProperties defaultProps;
    foreach(prop; props[1..$])
    {
        static foreach(attr; attrNames)
        {
            static if (isFloatingPoint!(typeof(__traits(getMember, TextProperties, attr))))
                mixin("if (!isNaN(prop." ~ attr ~ ")) output." ~ attr ~ " = prop." ~ attr ~ ";");
            else
                mixin("if (prop." ~ attr ~ " != defaultProps." ~ attr ~ ") output." ~ attr ~ " = prop." ~ attr ~ ";");
        }
    }

    return output;
}

struct FormattedString
{
    string text;
    string closeTag = "</span>";
    FormattedString[] children;
    TextProperties currentProperties;
    // If any properties set after initialization of FormattedString
    // Ex:
    // ```
    // auto txt = FormattedString("Hello");
    // txt.properties.family = "Futura";
    // txt ~= "World!";
    // ```
    TextProperties properties;

    this(string txt)
    {
        text = txt;
    }

    this(string txt, TextProperties props)
    {
        text = txt;
        currentProperties = props;
    }

    string openTag(Context chitraCtx)
    {
        return "<span " ~ currentProperties.get(chitraCtx) ~ " >";
    }

    void opOpAssign(string op: "~")(FormattedString rhs)
    {
        // If any properties updated after the initialization, that will be
        // stored in properties. Merge those properties with any properties
        // set by the RHS
        auto props = updateProperties(properties, rhs.currentProperties);
        rhs.currentProperties = props;
        children ~= rhs;
    }

    void opOpAssign(string op: "~")(string rhs)
    {
        auto data = FormattedString(rhs, properties);
        children ~= data;
    }

    string content(Context chitraCtx)
    {
        auto output = appender!string;

        output ~= openTag(chitraCtx) ~ text;
        foreach(element; children)
            output ~= element.content(chitraCtx);

        output ~= closeTag;

        return output.data;
    }
}
