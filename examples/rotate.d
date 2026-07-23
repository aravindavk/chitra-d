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
        background(255);

        stroke(100);

        auto part = TWO_PI / 12.0;
        // OR Use:
        // angleMode(DEGREES);
        // auto part = 30; // 360 / 12
        // OR without changing angleMode,
        // auto part = 30.degrees;

        foreach(i; 0 .. 12)
        {
            saveState;
            rotate(part * i, width / 2, height / 2);
            line(width / 2, height / 2, width, height / 2);
            restoreState;
        }

        // OR without saveState
        // foreach(_i; 0 .. 12)
        // {
        //     rotate(part, width / 2, height / 2);
        //     line(width / 2, height / 2, width, height / 2);
        // }

        saveAs("output/rotate.png", resolution: 72);
    }
}
