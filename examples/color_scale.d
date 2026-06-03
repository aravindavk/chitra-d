/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra(2000, 700);

    with (ctx)
    {
        auto w1 = width / 400.0;
        auto w2 = width / 256.0;

        auto x = 0.0;
        auto col = 0.0;
        noStroke();

        colorScale(1);
        foreach(i; 0 .. 401)
        {
            fill(0, 0, col);
            rect(x, 0, w1, 300);
            x += w1;
            col += 0.0025;
        }

        colorScale(255);
        x = 0.0;
        col = 0;

        foreach(i; 0 .. 256)
        {
            fill(0, 0, col);
            rect(x, 400, w2, 300);
            x += w2;
            col += 1;
        }

        saveAs("output/color_scale.png");
    }
}
