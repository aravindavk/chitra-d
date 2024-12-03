/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra(resolution: 72);

    with (ctx)
    {
        fill(0, 0, 255);
        noStroke;
        point(10, 10, 1);

        fill(0, 255, 0);
        pixel(15, 10);
        saveAs("output/dot.png");
    }
}
