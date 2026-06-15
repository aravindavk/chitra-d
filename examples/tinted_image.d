/+ dub.sdl:
dependency "chitra" path="../"
+/
import std.stdio;

import chitra;

void main()
{
    auto ctx = new Chitra(1518, 1012);

    with (ctx)
    {
        auto name = "images/tiger.png";
        auto s = imageSize(name); 
        writefln("W: %s, H: %s", s.width, s.height);

        scale(0.5);

        noTint;
        image(name, 0, 0);

        tint("red", 0.4);
        image(name, 1012, 0);

        tint("green", 0.4);
        image(name, 1012*2, 0);

        tint("blue", 0.4);
        image(name, 0, 1012);

        tint("brown", 0.4);
        image(name, 1012, 1012);

        tint("black", 0.4);
        image(name, 1012*2, 1012);

        // Save as png image
        saveAs("output/tinted.png", resolution: 72);
    }
}
