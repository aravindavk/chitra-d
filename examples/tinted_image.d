/+ dub.sdl:
dependency "chitra" path="../"
+/
import std.stdio;

import chitra;

void main()
{
    auto ctx = new Chitra(1012, 1013);

    with (ctx)
    {
        tint("red");
        auto name = "images/tiger.png";
        image(name, 0, 0);
        auto s = imageSize(name); 
        writefln("W: %s, H: %s", s.width, s.height);

        noTint;
        image(name, 200, 200);

        tint("blue", 0.4);
        image(name, 400, 400);
        // Save as png image
        saveAs("output/tinted.png", resolution: 72);
    }
}
