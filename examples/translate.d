/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import std.format;

import chitra;

void main()
{
    auto ctx = new Chitra;

    with (ctx)
    {
        // Translate
        void bar(string label, double percentage)
        {
            noStroke;
            textColor(0);
            textFont("Inter", 10);
            text(label, 0, 0);

            if (percentage > 50)
                fill(0, 255, 0);
            else
                fill(255, 0, 0);

            rect(0, 20, width * percentage / 100, 20);
        }

        double[] values = [93, 70, 41, 56, 77, 21, 87];
        foreach(i, p; values)
        {
            double translateY = i * 50;
            translate(0, translateY);
            bar(format("Subject %d", i), p);
            translate(0, -translateY);
        }

        saveAs("output/translate_bar.png");
    }
}
