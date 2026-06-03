/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra(270);

    with (ctx)
    {

        // Example 1: Color and Alpha using 0-255 scale
        colorScale(255);
        fill(94, 103, 175, 127);
        stroke(0, 0, 255, 127);
        rect(10, 10, 50);

        // Example 2: Color using 0-255 scale and Alpha using 0-1.0 scale
        colorScale(255, 1);
        fill(94, 103, 175, 0.5);
        stroke(0, 0, 255, 0.5);
        rect(60, 60, 50);

        // Example 3: Color and Alpha using 0-1.0 scale
        colorScale(1);
        fill(0.368, 0.403, 0.686, 0.5);
        stroke(0, 0, 1, 0.5);
        rect(110, 110, 50);

        // Example 4: 0-1.0 scale with color names and using
        // fillOpacity and strokeOpacity functions
        colorScale(1);
        fill("#5e67af");
        stroke("blue");
        fillOpacity(0.5);
        strokeOpacity(0.5);
        rect(160, 160, 50);

        // Example 5: 0-255 scale with color names and using
        // fillOpacity and strokeOpacity functions
        colorScale(255);
        fill("#5e67af");
        stroke("blue");
        fillOpacity(127);
        strokeOpacity(127);
        rect(210, 210, 50);

        saveAs("output/colors.png");
    }
}
