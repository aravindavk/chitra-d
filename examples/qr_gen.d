/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

string sampleTxt = q"[
<b>How to add a QR image?</b>

Use the <tt>qrImage</tt> command to add a QR image to the canvas. Control the background and foreground colours of the QR using the fill and stroke commands, respectively.

```d
// Background color
fill("white");
// Forground color
stroke("black");
//      TEXT            X   Y   WIDTH
qrImage("Hello World!", 50, 50, 200);
```
]";

void main()
{
    auto ctx = new Chitra(700);

    with (ctx)
    {
        background(255);
        image("output/chitra-logo.png", 50, 50, 200);
        noStroke;

        fill("red");
        rect(0, 0, 220, 30);
        fill("white");
        font("Inter", 14);
        text("NEW FEATURE ALERT!", 10, 4);

        fill(0);
        font("American Typewriter", 26);
        text("Chitra is a 2D graphics library written in D.", 50, 110, 250, 200);

        fontSize(14);
        syntaxHighlight(true, theme: EMACS);

        text(sampleTxt, 50, 320, 600, 500);

        fill(255);
        stroke("sapphireblue");
        strokeWeight(4);
        auto qrBox = Box(450, 50, 180);
        rect(qrBox.inset(dx: -10, dy: -10));

        noStroke;
        fill(0);
        textAlign(CENTER);
        fontSize(16);
        text("read the docs", 400, 250, 300, 100);

        fill(255);
        stroke("black");
        qrImage("https://github.com/aravindavk/chitra-d/wiki", qrBox);

        saveAs("output/qr.png", resolution: 72);
    }
}
