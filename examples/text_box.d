/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import std.array;

import chitra;

void main()
{
    auto ctx = new Chitra(300, 220);

    with (ctx)
    {
        noStroke;
        string txt = "\"I don't fear a man who has practiced <span foreground='blue' >10,000</span> kicks once, but I fear a man who has practiced one kick 10,000 times\"\n\n - Bruce Lee";

        string[] words = txt.split(" ");

        textFont("American Typewriter", 14);

        string[] line;
        double x = 30;
        double y = 30;

        fill("yellow");
        rect(20, 20, 260, 180);

        text(txt, 30, 30, 240, 160);

        saveAs("output/text_box.png");
    }
}
