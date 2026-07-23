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
        stroke(255, 0, 0);
        triangle(100, 100, 0, 200, 300, 180);
        saveAs("output/triangle.png");
    }
}
