/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra;

    with (ctx)
    {
        fill(0, 0, 255);
        //noStroke;
        rect(100, 100, 500, 200, r: 10);
        saveAs("output/round_rect.png", resolution: 300);
    }
}
