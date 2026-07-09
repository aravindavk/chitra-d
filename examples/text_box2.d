/+ dub.sdl:
 dependency "chitra" path="../"
 +/

// Text box overflow example: Linked Frames

import std.stdio;
import std.array;
import std.file : readText;

import chitra;

void main()
{
    string content = readText("lorem_ipsum.txt");

    auto ctx = new Chitra("a4");

    with (ctx)
    {
        background("yellow");
        noStroke;
        grid(2, gap: 20);
        textFont("American Typewriter", 10);

        auto column1 = gridCell(1);
        text(content, column1);

        auto overflow = overflowText;

        auto column2 = gridCell(2);
        text(overflow, column2);

        saveAs("output/text_box2.png", resolution: 72);
    }
}
