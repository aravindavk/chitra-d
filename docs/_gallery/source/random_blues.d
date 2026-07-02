#!/usr/bin/env dub
/+ dub.sdl:
 dependency "chitra" version="~>0.4.0"
+/

import std.random;

import chitra;

void main()
{
    auto ctx = new Chitra(1280, 960);

    auto squareSize = 20;
    auto gap = 0;
    auto x = gap;
    auto y = gap;

    with (ctx)
    {
        // Set Color scale 0-1.0
        colorScale(1);

        background(1);
        noStroke;

        while (true)
        {
            if (x > width)
            {
                x = gap;
                y += squareSize + gap;
            }

            if (y > height)
                break;

            fill(0, 0, uniform(0.0, 1.0));
            square(x, y, squareSize);
            x += squareSize + gap;
        }

        saveAs("static/images/random_blues.png");
    }
}
