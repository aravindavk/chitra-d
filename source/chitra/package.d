module chitra;

import std.stdio;
import std.conv;

import colors;

public import chitra.helpers;

import chitra.context;
import chitra.properties;
import chitra.elements;

class Chitra : Context
{
    /**
       Create the Chitra Context by giving the paper sizes.

       ----
       // Create a A4 size context.
       auto ctx = new Chitra("a4");

       // Create a A4 size landscape context.
       auto ctx = new Chitra("a4,landscape");
       ----
     */
    this(string paper)
    {
        super(paper);
    }

    /**
       Create the Chitra Context.

       ---
       // Creates context with default width(700),
       // height(700)
       auto ctx = new Chitra;

       // Creates the context with width and height as 500
       auto ctx = new Chitra(500);
       auto ctx = new Chitra(500, 500);

       // Create the context with the width 1600 and height 900
       auto ctx = new Chitra(1600, 900);
       ---
     */
    this(int width = defaultWidth, int height = 0)
    {
        super(width, height);
    }

    mixin propertiesFunctions;
    static foreach(element; ELEMENTS)
        mixin("mixin " ~ element.typeName(false) ~ "Functions;");
}
