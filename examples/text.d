/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra();

    with (ctx)
    {
        noStroke;

        fill(0, 0, 255, 0.5);
        rect(10, 76, 380, 5);

        textFont("American Typewriter", 50);
        text("Hello World", 10, 10);

        saveAs("output/text.png");
    }
}
