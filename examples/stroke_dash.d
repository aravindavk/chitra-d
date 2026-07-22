/+ dub.sdl:
dependency "chitra" path="../"
+/
import std.stdio;

import chitra;

void main()
{
    auto ctx = new Chitra(800);

    with (ctx)
    {
        noFill;
        strokeWidth(2);
        strokeDash([2, 2, 4, 2]);
        rect(10, 10, 100);
        strokeDash(0);
        rect(110, 110, 100);
        strokeDash(4);
        rect(210, 210, 100);

        // Save as png image
        saveAs("output/stroke_dash.png", resolution: 72);
    }
}
