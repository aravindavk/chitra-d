/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra();

    with (ctx)
    {
        fill(0, 0, 255);
        noStroke;

        auto scaleX = 2.0;
        auto scaleY = 2.0;

        rect(100, 100, 100);

        // Double the scale
        scale(scaleX, scaleY);
        rect(100, 100, 100);

        // Reset the scale
        scale(1/scaleX, 1/scaleY);
        rect(400, 400, 100);

        // Change only X axis scale
        scale(scaleX, 1);
        rect(250, 500, 50);
        scale(1/scaleX, 1);

        // Reduce scale
        scale(1/scaleX, 1/scaleY);
        rect(1200, 1100, 100);

        saveAs("output/scale.png");
    }
}
