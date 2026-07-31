/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import std.file : readText;

import chitra;

void main()
{
    auto ctx = new Chitra(700, 1200);
    string content = readText("article.txt");

    with (ctx)
    {
        background(255);
        // noFill;
        noStroke;
        // hyphenation(true);

        newTextStyle
            .size(50)
            .color("black");

        newTextStyle("str")
            .color("red");

        newTextStyle("link")
            .color("blue");

        newTextStyle("code")
            .font("IBM Plex Mono", SMALL)
            .color("#d63384");

        newTextStyle("h1")
            .size(XXLARGE);

        newTextStyle("error")
            .underline(ERROR)
            .underlineColor("red")
            .font("Monospace");

        newTextStyle("uc")
            .transform(UPPERCASE);

        newTextStyle("highlight")
            .background("#fac000");

        newTextStyle("lh2x")
            .lineHeight(2);

        newTextStyle("inter")
            .font("Inter");

        newTextStyle("tnum")
            .features("tnum");

        newTextStyle("ls")
            .letterSpacing(50);

        text(content, 50, 50, width - 100, height - 100);

        saveAs("output/article.png");
    }
}
