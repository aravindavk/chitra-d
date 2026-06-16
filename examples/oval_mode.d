/+ dub.sdl:
dependency "chitra" path="../"
+/
import std.stdio;

import chitra;

void main()
{
    auto ctx = new Chitra(850);

    with (ctx)
    {
        background(1);

        fill("#efd49e");
        ovalMode(CENTER);
        circle(200, 200, 300);

        ovalMode(RADIUS);
        circle(600, 200, 150);

        ovalMode(CORNER);
        circle(50, 450, 300);

        ovalMode(CORNERS);
        circle(450, 450, 750, 750);

        noStroke;
        fill(0);

        textFont("American Typewriter", 10);
        point(200, 200, 6);
        text("(x, y)", 180, 200);
        text("ovalMode(CENTER);", 50, 350);
        text("oval(x, y, w, h);", 50, 370);

        point(600, 200, 6);
        text("(x, y)", 580, 200);
        text("ovalMode(RADIUS);", 450, 350);
        text("oval(x, y, r1, r2);", 450, 370);

        point(50, 450, 6);
        text("(x, y)", 30, 450);
        text("ovalMode(CORNER);", 50, 750);
        text("oval(x, y, w, h);", 50, 770);

        point(450, 450, 6);
        text("(x, y)", 430, 450);
        text("(x2, y2)", 750, 750);
        text("ovalMode(CORNERS);", 450, 750);
        text("oval(x, y, x2, y2);", 450, 770);

        text("w", 100, 200);
        text("h", 210, 100);
        text("w", 100, 600);
        text("h", 210, 500);
        text("r1", 700, 200);
        text("r2", 580, 300);

        strokeWidth(1);
        stroke("#777777");

        // Width and height lines
        line(50, 200, 350, 200);
        line(200, 50, 200, 350);

        // Width and height lines (CORNER)
        line(50, 600, 350, 600);
        line(200, 450, 200, 750);

        // Radius lines
        line(600, 200, 600+150, 200);
        line(600, 200, 600, 200+150);

        // x, y lines of CORNER
        line(50, 450, 50, 450+150);
        line(50, 450, 50+150, 450);

        // x, y lines of CORNERS
        line(450, 450, 450, 450+150);
        line(450, 450, 450+150, 450);

        // x2, y2 lines
        line(750, 750, 750, 750-150);
        line(750, 750, 750-150, 750);
        
        saveAs("output/oval_mode.png");
    }
}
