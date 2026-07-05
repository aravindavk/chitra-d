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


        textFont("American Typewriter", 50);
        text("Hello World", 10, 10);
        auto box = textSize("Hello World");

        // Draw text underline same as text width
        fill(0, 0, 255, 0.5);
        rect(10, 10+box.height, box.width, 5);

        // Algin Text to the middle of the canvas
        auto x = (width - box.width) / 2.0;
        auto y = (height - box.height) / 2.0;
        text("Hello World", x, y);

        saveAs("output/text.png");
    }
}
