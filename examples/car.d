/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra(1600, 900);

    with (ctx)
    {
        background(255);

        noFill;
        fill("gold");
        newPath(200,600); 
        curveTo(200, 400, 300, 350, 500, 400);    // FRONT
        lineTo(600, 200);                         // FRONT GLASS
        curveTo(700, 150, 1000, 150, 1100, 200);  // TOP
        lineTo(1200, 400);                        // BACK GLASS
        curveTo(1350, 400, 1450, 500, 1400, 600); // BACK
        drawPath(close: true);

        fill(255);
        strokeWeight(20);
        oval(450, 600, 160);
        oval(1100, 600, 160);

        strokeWeight(10);
        fill(0);
        foreach(p; lastPath.points)
            point(p);

        fill("red");
        foreach(p; lastPath.controls)
            point(p);

        strokeDash(10);
        strokeWeight(1);
        stroke(200);
        noFill;
        foreach(seg; lastPath.segments)
        {
            foreach(ctrl;seg.controlLines)
                line(ctrl.p1, ctrl.p2);
        }

        saveAs("output/car.png");
    }
}
