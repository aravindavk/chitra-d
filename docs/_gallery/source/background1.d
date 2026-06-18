#!/usr/bin/env dub
/+ dub.sdl:
dependency "chitra" path="../../../"
+/

import chitra;

void main()
{
    auto ctx = new Chitra(1280, 960);

    with (ctx)
    {
        noStroke;

        background("#3e8ed0");

        fill("#6ea8da");

        circle(300, 150, 700);

        saveAs("static/images/background1.png");
    }
}
