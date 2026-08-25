/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra(1600, 300);

    with (ctx)
    {
        background(255);
        noStroke;
        font("American Typewriter", 20);

        auto x = 100.0;
        frameRate(10);
        foreach(i; 0 .. 130)
        {
            // Cover the top region with the background color and write text
            fill(255);
            rect(0, 0, width, 100);
            fill(0);
            text("{{ currentFrame }} / {{ totalFrames }}", 100, 10);

            fill("green");
            rect(x, 100, 100);
            if (i == 7)
                frameDuration(3.0);

            // Pass `clear: true` to move the rectangle instead of expanding
            endFrame();
            x += 10;
            frameRate(10);
        }

        saveAs("output/animation.webm", resolution: 72);
        saveAs("output/animation.gif", resolution: 72);
    }
}
