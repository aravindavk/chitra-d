/+ dub.sdl:
dependency "chitra" path="../"
+/
import std.stdio;

import chitra;

void main()
{
    auto ctx = new Chitra(800, 300);

    with (ctx)
    {
        // Tiger Blend INTERSECT
        saveState(group: true);
        //noStroke;
        font("American Typewriter", 160);
        text("TIGER", 50, 20);

        blendMode(IN);

        //rect(100, 100, 700, 200);
        background("images/tiger.png", fit: COVER, offsetX: -70, offsetY: -70);

        restoreState;

        // Save as png image
        saveAs("output/blend.png", resolution: 72);
    }
}
