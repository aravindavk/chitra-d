module chitra.elements;

import std.sumtype;
import std.string;
import std.algorithm;
import std.conv : text;

import chitra.elements.core;

const ELEMENTS = [
    "background",
    "line",
    "new_page",
    "oval",
    "polygon",
    "rect",
    "rotate",
    "scale",
    "translate"
];

public
{
    static foreach(element; ELEMENTS)
        mixin("import chitra.elements." ~ element ~ ";");
}

string typeName(string name, bool capitalizeFirst = true)
{
    auto n = name.split("_").map!(p => p.capitalize).join;
    if (!capitalizeFirst)
        return i"$(n[0].toLower)$(n[1..$])".text;

    return n;
}

mixin("alias Element = SumType!(" ~ ELEMENTS.map!(ele => ele.typeName).join(",") ~ ");");

void draw(Element element, cairo_t* cairoCtx)
{
    mixin("element.match!(" ~ ELEMENTS.map!(ele => "(" ~ ele.typeName ~ " p) => p.draw(cairoCtx)").join(",") ~ ");");
}
