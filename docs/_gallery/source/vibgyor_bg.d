#!/usr/bin/env dub
/+ dub.sdl:
 dependency "chitra" version="~>0.4.0"
+/

import std.stdio;
import std.format;

import chitra;

void main()
{
    auto ctx = new Chitra(1200, 900);
    auto colors = [
        "#9400D3",   // Violet
        "#4B0082",   // Indigo
        "#0000FF",   // Blue
        "#00FF00",   // Green
        "#FFFF00",   // Yellow
        "#FF7F00",   // Orange
        "#FF0000"    // Red
    ];

    with (ctx)
    {
        grid(7);
        noStroke;

        foreach(col; colors)
        {
            fill(col);
            rect(nextGridCell);
        }

        saveAs("static/images/vibgyor.png");
    }
}
