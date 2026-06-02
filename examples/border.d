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

        borderColor("#eecc88");
        border(5, margin: 20, radius: 7);
        saveAs("output/border.png");
    }
}
