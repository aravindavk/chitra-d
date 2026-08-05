module chitra.elements.formatted_strings;

import std.stdio;
import std.traits;
import std.array;
import std.conv;
import std.typecons;
import std.math.traits : isNaN;
import std.process;
import std.array : appender;
import std.string;
import std.exception : enforce;

import chitra.rgba;
import chitra.context;
import chitra.pangocairo;

enum FontNamedSize {none, xxSmall, xSmall, small, medium, large, xLarge, xxLarge, smaller, larger}
enum FontStyle { none, normal, oblique, italic }
enum FontNamedWeight { none, ultralight, light, normal, bold, ultrabold, heavy }
enum FontVariant { none, normal, smallCaps, allSmallCaps, petiteCaps, allPetiteCaps, unicase, titleCaps }
enum FontStretch { none, ultracondensed, extracondensed, condensed, semicondensed, normal, semiexpanded, expanded, extraexpanded, ultraexpanded }
enum TextUnderline {none, single, double_, low, error}
enum TextOverline {none, single }
enum TextScale {none, superscript, subscript, smallCaps}
enum TextGravity { none, south, east, north, west, auto_}
enum TextGravityHint { none, natural, strong, line }
enum TextTransform { none, lowercase, uppercase, capitalize }
enum TextSegment { none, word, sentence}
enum TextAlign {none, left, right, center, justify }

string camelCaseToHyphen(T)(T value)
{
    import std.regex;
    import std.string;
    import std.conv;

    string func(Captures!(string) m)
    {
        return "-" ~ m.hit.toLower;
    }

    return replaceAll!(func)(value.to!string, regex("[A-Z]"));
}

string toString(TextUnderline value)
{
    return value.to!string.replace("_", "");
}

struct TextProperties
{
    string font;
    float size;
    FontNamedSize namedSize;
    FontStyle style;
    float weight;
    FontNamedWeight namedWeight;
    FontVariant variant;
    FontStretch stretch;
    // Ex: features='dlig=1, -kern, afrc on'
    string features;
    Nullable!RGBA color;
    bool noTextBackground = true;
    Nullable!RGBA background;
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
    Nullable!bool insertHyphens;
    bool allowLineBreaks;
    float lineHeight;
    TextTransform transform;
    TextSegment segment;
    TextAlign align_;
    string hyphenChar;
    bool hyphenation = false;
    bool syntaxHighlight = false;
    string syntaxHighlightTheme = "algol";

    string get(Context chitraCtx)
    {
        string output;

        if (font != "") output ~= i" font_family=\"$(font)\"".text;

        if (!background.isNull && !noTextBackground) output ~= i" background=\"$(background.get.hexString)\"".text;
        if (!color.isNull) output ~= i" color=\"$(color.get.hexString)\"".text;

        // Set Transparent if noFill is used
        if (color.isNull) output ~= " alpha=\"1\"";

        if (size > 0)
        {
            auto s = chitraCtx.correctedSize(size);
            output ~= i" font_size=\"$(s)pt\"".text;
        }
        if (namedSize != FontNamedSize.none) output ~= i" font_size=\"$(namedSize.camelCaseToHyphen)\"".text;
        if (variant != FontVariant.none) output ~= i" font_variant=\"$(variant.camelCaseToHyphen)\"".text;

        if (weight > 0) output ~= i" weight=\"$(weight)\"".text;
        if (namedWeight != FontNamedWeight.none) output ~= i" weight=\"$(namedWeight)\"".text;

        if (style != FontStyle.none) output ~= i" font_style=\"$(style)\"".text;

        if (strikeThrough) output ~= " strikethrough=\"true\"";
        if (strikeThrough && !strikeThroughColor.isNull)
            output ~= i" strikethrough_color=\"$(strikeThroughColor.get.hexString)\"".text;

        if (underline != TextUnderline.none) output ~= i" underline=\"$(underline.toString)\"".text;
        if (underline != TextUnderline.none && !underlineColor.isNull)
            output ~= i" underline_color=\"$(underlineColor.get.hexString)\"".text;

        if (overline != TextOverline.none) output ~= i" overline=\"$(overline)\"".text;
        if (overline != TextOverline.none && !overlineColor.isNull)
            output ~= i" overline_color=\"$(overlineColor.get.hexString)\"".text;

        if (lineHeight > 0) output ~= i" line_height=\"$(lineHeight)\"".text;

        if (letterSpacing > 0)
        {
            auto s = chitraCtx.correctedSize(letterSpacing);
            output ~= i" letter_spacing=\"$(s * PANGO_SCALE)\"".text;
        }

        if (!features.empty) output ~= i" font_features=\"$(features)\"".text;
        if (!insertHyphens.isNull) output ~= i" insert_hyphens=\"$(insertHyphens.get)\"".text;

        if (rise > 0)
        {
            auto s = chitraCtx.correctedSize(rise);
            output ~= i" rise=\"$(s)pt\"".text;
        }

        if (baselineShift > 0)
        {
            auto s = chitraCtx.correctedSize(baselineShift);
            output ~= i" baseline_shift=\"$(s)pt\"".text;
        }

        if (scale != TextScale.none) output ~= i" font_scale=\"$(scale)\"".text;
        if (gravity != TextGravity.none) output ~= i" gravity=\"$(gravity)\"".text;
        if (gravityHint != TextGravityHint.none) output ~= i" gravity_hint=\"$(gravityHint)\"".text;

        if (transform != TextTransform.none) output ~= i" text_transform=\"$(transform)\"".text;
        if (segment != TextSegment.none) output ~= i" segment=\"$(segment)\"".text;
        if (stretch != FontStretch.none) output ~= i" font_stretch=\"$(stretch)\"".text;

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
    // txt.properties.font = "Futura";
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
        auto props = updateProperties([properties, rhs.currentProperties]);
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

struct TextStyle(T)
{
    T ctx;
    string name;

    TextStyle font(string fontName, double size = double.init)
    {
        ctx.textStyles[name].font = fontName;
        if (!size.isNaN)
            ctx.textStyles[name].size = size;

        return this;
    }

    TextStyle font(string fontName, string size)
    {
        ctx.textStyles[name].font = fontName;
        if (size != "")
            ctx.textStyles[name].namedSize = size.to!FontNamedSize;

        return this;
    }

    TextStyle size(double size)
    {
        ctx.textStyles[name].size = size;
        return this;
    }

    TextStyle size(string size)
    {
        ctx.textStyles[name].namedSize = size.to!FontNamedSize;
        return this;
    }

    TextStyle style(string value)
    {
        ctx.textStyles[name].style = value.to!FontStyle;
        return this;
    }

    TextStyle weight(double value)
    {
        ctx.textStyles[name].weight = value;
        return this;
    }

    TextStyle weight(string value)
    {
        ctx.textStyles[name].namedWeight = value.to!FontNamedWeight;
        return this;
    }

    TextStyle variant(string value)
    {
        ctx.textStyles[name].variant = value.to!FontVariant;
        return this;
    }

    TextStyle stretch(string value)
    {
        ctx.textStyles[name].stretch = value.to!FontStretch;
        return this;
    }

    TextStyle scale(string value)
    {
        ctx.textStyles[name].scale = value.to!TextScale;
        return this;
    }

    TextStyle gravity(string value)
    {
        ctx.textStyles[name].gravity = value.to!TextGravity;
        return this;
    }

    TextStyle gravityHint(string value)
    {
        ctx.textStyles[name].gravityHint = value.to!TextGravityHint;
        return this;
    }

    TextStyle segment(string value)
    {
        ctx.textStyles[name].segment = value.to!TextSegment;
        return this;
    }

    TextStyle transform(string value)
    {
        ctx.textStyles[name].transform = value.to!TextTransform;
        return this;
    }

    TextStyle hyphenChar(string value)
    {
        ctx.textStyles[name].hyphenChar = value;
        return this;
    }

    TextStyle underline(string value)
    {
        ctx.textStyles[name].underline = value.to!TextUnderline;
        return this;
    }

    TextStyle underlineColor(float r, float g, float b, float a = -1.0)
    {
        ctx.textStyles[name].underlineColor = ctx.parseColor(r, g, b, a);
        return this;
    }

    TextStyle underlineColor(float gray, float a = -1.0)
    {
        ctx.textStyles[name].underlineColor = ctx.parseColor(gray, a);
        return this;
    }

    TextStyle underlineColor(string value)
    {
        ctx.textStyles[name].underlineColor = ctx.parseColor(value);
        return this;
    }

    TextStyle overline(string value)
    {
        ctx.textStyles[name].overline = value.to!TextOverline;
        return this;
    }

    TextStyle overlineColor(float r, float g, float b, float a = -1.0)
    {
        ctx.textStyles[name].overlineColor = ctx.parseColor(r, g, b, a);
        return this;
    }

    TextStyle overlineColor(float gray, float a = -1.0)
    {
        ctx.textStyles[name].overlineColor = ctx.parseColor(gray, a);
        return this;
    }

    TextStyle overlineColor(string value)
    {
        ctx.textStyles[name].overlineColor = ctx.parseColor(value);
        return this;
    }

    TextStyle color(float r, float g, float b, float a = -1.0)
    {
        ctx.textStyles[name].color = ctx.parseColor(r, g, b, a);
        return this;
    }

    TextStyle color(float gray, float a = -1.0)
    {
        ctx.textStyles[name].color = ctx.parseColor(gray, a);
        return this;
    }

    TextStyle color(string value, float a = -1.0)
    {
        ctx.textStyles[name].color = ctx.parseColor(value, a);
        return this;
    }

    TextStyle alpha(float a)
    {
        if (!ctx.textStyles[name].color.isNull)
            ctx.textStyles[name].color = ctx.setAlpha(ctx.textStyles[name].color.get, a);

        return this;
    }

    TextStyle background(float r, float g, float b, float a = -1.0)
    {
        ctx.textStyles[name].noTextBackground = false;
        ctx.textStyles[name].background = ctx.parseColor(r, g, b, a);
        return this;
    }

    TextStyle background(float gray, float a = -1.0)
    {
        ctx.textStyles[name].noTextBackground = false;
        ctx.textStyles[name].background = ctx.parseColor(gray, a);
        return this;
    }

    TextStyle background(string value, float a = -1.0)
    {
        ctx.textStyles[name].noTextBackground = false;
        ctx.textStyles[name].background = ctx.parseColor(value, a);
        return this;
    }

    TextStyle noTextBackground()
    {
        ctx.textStyles[name].noTextBackground = true;
        return this;
    }

    TextStyle backgroundAlpha(float a)
    {
        if (!ctx.textStyles[name].background.isNull)
            ctx.textStyles[name].background = ctx.setAlpha(ctx.textStyles[name].background.get, a);

        return this;
    }

    TextStyle lineHeight(double value)
    {
        ctx.textStyles[name].lineHeight = value;
        return this;
    }

    TextStyle rise(double value)
    {
        ctx.textStyles[name].rise = value;
        return this;
    }

    TextStyle baselineShift(double value)
    {
        ctx.textStyles[name].baselineShift = value;
        return this;
    }

    TextStyle letterSpacing(double value)
    {
        ctx.textStyles[name].letterSpacing = value;
        return this;
    }

    TextStyle features(string value)
    {
        ctx.textStyles[name].features = value;
        return this;
    }

    TextStyle insertHyphens(bool value)
    {
        ctx.textStyles[name].insertHyphens = value;
        return this;
    }

    TextStyle allowLineBreaks(bool value)
    {
        ctx.textStyles[name].allowLineBreaks = value;
        return this;
    }

    TextStyle strikeThrough(bool value)
    {
        ctx.textStyles[name].strikeThrough = value;
        return this;
    }

    TextStyle strikeThroughColor(float r, float g, float b, float a = -1.0)
    {
        ctx.textStyles[name].strikeThroughColor = ctx.parseColor(r, g, b, a);
        return this;
    }

    TextStyle strikeThroughColor(float gray, float a = -1.0)
    {
        ctx.textStyles[name].strikeThroughColor = ctx.parseColor(gray, a);
        return this;
    }

    TextStyle strikeThroughColor(string value, float a = -1.0)
    {
        ctx.textStyles[name].strikeThroughColor = ctx.parseColor(value, a);
        return this;
    }
}

string highlightCode(string language, string code, string formatter = "pango", string theme = "algol")
{
    auto pipes = pipeProcess(
        ["pygmentize", "-l", language, "-f", formatter, "-O", "style=" ~ theme],
        Redirect.stdin | Redirect.stdout | Redirect.stderr
    );

    // Feed the source code to pygmentize's stdin, then close it
    // so pygmentize knows the input is complete.
    pipes.stdin.write(code);
    pipes.stdin.flush();
    pipes.stdin.close();

    // Collect stdout (the highlighted result).
    auto output = appender!string();
    foreach (chunk; pipes.stdout.byChunk(4096))
        output.put(cast(string) chunk);

    // Collect stderr in case pygmentize fails (e.g. unknown lexer name).
    auto errOutput = appender!string();
    foreach (line; pipes.stderr.byLine)
    {
        errOutput.put(line);
        errOutput.put("\n");
    }

    auto exitCode = wait(pipes.pid);
    enforce(exitCode == 0,
        "pygmentize failed (exit " ~ exitCode.to!string ~ "): " ~ errOutput.data);

    return output.data;
}

string prepareForCodeHighlight(string content, string theme)
{
    auto output = appender!string();

    bool codeStarted = false;
    string lang;
    auto code = appender!string();

    foreach(line; content.split("\n"))
    {
        if (!codeStarted && line.strip.startsWith("```"))
        {
            codeStarted = true;
            lang = line.strip.replace("```", "");
            continue;
        }

        if (codeStarted && line.strip == "```")
        {
            codeStarted = false;
            output.put(highlightCode(lang, code.data, theme: theme));
            output.put("\n");
            code = appender!string();
            lang = "text";
            continue;
        }

        if (codeStarted)
        {
            code.put(line);
            code.put("\n");
        }
        else
        {
            output.put(line);
            output.put("\n");
        }
    }

    return output.data;
}
