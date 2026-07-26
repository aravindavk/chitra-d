/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra(1000, 1000);

    with (ctx)
    {
        background(255);

        noFill;
        bezier(100, 900, 900, 500, 100, 100, 500, 900);

        fill(0);
        foreach(p; lastPath.points)
            point(p, 10);

        fill("red");
        foreach(p; lastPath.controls)
            point(p, 10);

        strokeDash(10);
        stroke(200);
        noFill;
        foreach(seg; lastPath.segments)
        {
            foreach(ctrl;seg.controlLines)
                line(ctrl.p1, ctrl.p2);
        }

        saveAs("output/path.png");
    }
}
