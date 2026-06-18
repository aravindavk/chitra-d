#!/usr/bin/env dub
/+ dub.sdl:
dependency "chitra" path="../../../"
+/

import chitra;

void main()
{
    // Create a Square context with size as 1080
    auto ctx = new Chitra(1024);

    with (ctx)
    {
        noStroke;
        ovalMode(CORNER);

        background("#1f8cc5");

        fill("#936b49");
        rect(0, height * 3 / 4, width, height / 4);

        fill("white");
        oval(50, 50, 200, 20);
        oval(400, 70, 200, 20);
        oval(700, 100, 200, 20);

        oval(200, 100, 200, 100);
        oval(130, 150, 200, 100);
        oval(270, 150, 200, 100);

        fill("black");
        oval(100, 600, 50);
        rect(100, 625, 50, 190);

        oval(200, 500, 50);
        rect(200, 525, 50, 450);
        
        oval(300, 530, 50);
        rect(300, 555, 50, 140);

        rect(100, 625 + 190 - 50, 100, 50);
        rect(200, 555 + 140 - 50, 100, 50);

        // Save as png image
        saveAs("static/images/clouds.png");
    }
}
