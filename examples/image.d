/+ dub.sdl:
dependency "chitra" path="../"
+/
import std.stdio;

import chitra;

void main()
{
    auto ctx1 = new Chitra(600, 500);
    ctx1.background(255);
    ctx1.rect(100, 100, 400, 300);
    ctx1.saveAs("output/img_1.png");

    auto ctx = new Chitra(800, 700);

    with (ctx)
    {
        background(0);
        image("output/img_1.png", 100, 100);
        auto s = imageSize("output/img_1.png");
        writefln("W: %s, H: %s", s.width, s.height);
        // Save as png image
        saveAs("output/img_2.png");
    }
}
