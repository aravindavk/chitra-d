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

        strokeDash(0);
        strokeWeight(10);
        strokeCap(BUTT);
        line(320, 310, 320, 410);
        strokeCap(ROUND);
        line(350, 310, 350, 410);
        strokeCap(SQUARE);
        line(380, 310, 380, 410);

        strokeJoin(ROUND);
        rect(410, 410, 100, 100);

        // Save as png image
        saveAs("output/stroke_dash.png", resolution: 72);
    }
}
