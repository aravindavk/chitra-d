module chitra;

import std.stdio;
import std.conv;

public import chitra.helpers;

import chitra.context;
import chitra.elements.rect;

class Chitra : Context
{
    /**
       Create the Chitra Context by giving the paper sizes.

       ----
       // Create a A4 size context with default resolution 300.
       auto ctx = new Chitra("a4");

       // Create a A4 size landscape context with
       // the default resolution 300.
       auto ctx = new Chitra("a4,landscape");

       // Customize the resolution
       auto ctx = new Chitra("a4", 72);
       auto ctx = new Chitra("a4", resolution: 300);       
       ----
     */
    this(string paper, int resolution = DEFAULT_RESOLUTION)
    {
        super(paper, resolution);
    }

    /**
       Create the Chitra Context.

       ---
       // Creates context with default width(700),
       // height(700) and resolution(300)
       auto ctx = new Chitra;

       // Creates the context with width and height as 500
       // and default resolution 300
       auto ctx = new Chitra(500);
       auto ctx = new Chitra(500, 500);

       // Create the context with the width 1600 and height 900
       auto ctx = new Chitra(1600, 900);

       // Create the context with given width and height
       // with the resolution 72
       auto ctx = new Chitra(1600, 900, 72);
       auto ctx = new Chitra(1600, 900, resolution: 72);
       ---
     */
    this(int width = DEFAULT_WIDTH, int height = 0, int resolution = DEFAULT_RESOLUTION)
    {
        super(width, height, DEFAULT_RESOLUTION);
    }

    /**
       Draw a Square or Rectangle.

       ---
       // Square of width 100
       //       x   y   w
       ctx.rect(50, 50, 100);
       
       // Rectangle of width 100 and height 50
       //       x   y   w    h
       ctx.rect(50, 50, 100, 50);
       ---
     */
    void rect(int x, int y, float w, float h = 0.0)
    {
        h = h == 0.0 ? w : h;
        auto r = new Rect(x, y, w, h);
        this.elements ~= r;
    }
}