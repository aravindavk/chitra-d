/+ dub.sdl:
dependency "chitra" path="../"
+/
import chitra;
import std.math.constants;

void main()
{
    auto ctx = new Chitra;

    with (ctx)
    {
        // noFill;
        // noStroke;
        fill(100);
        oval(100, 100, 100);

        arc(200, 200, 100, 0, HALF_PI);
        arc(300, 300, 100, 0, PI + QUARTER_PI, mode: CHORD);
        arc(400, 400, 100, 0, PI + QUARTER_PI, mode: PIE);
        arc(500, 500, 100, 50, 0, PI + QUARTER_PI, mode: PIE);

        // Save as png image
        saveAs("output/oval.png");
    }
}
