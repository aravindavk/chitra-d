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
        // newPath(85, 20);
        // curveTo(10, 10, 90, 90, 15, 80);
        // lineTo(200, 200);
        // // moveTo(250, 210);
        // lineTo(100, 150);
        // drawPath(close: true);

        // bezier(85, 20, 10, 10, 90, 90, 15, 80);

        newPath(300,100); 
        lineTo(500, 100);
        curveTo(450, 150, 450, 250, 500, 300);
        curveTo(650, 400, 650, 700, 500, 800);
        lineTo(300, 800);
        curveTo(150, 700, 150, 400, 300, 300);
        curveTo(350, 250, 350, 150, 300, 100);
        drawPath();

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

        saveAs("output/vase.png");
    }
}
