/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void main()
{
    auto ctx = new Chitra;

    with (ctx)
    {
        // Translate
        void bar(double percentage)
        {
            writeln(percentage, width);
            if (percentage > 50)
                fill(0, 255, 0);
            else
                fill(255, 0, 0);

            rect(0, 0, width*percentage/100, 20);
        }

        double[] values = [93, 70, 41, 56, 77, 21, 87];
        foreach(i, p; values)
        {
            writeln(i*50);
            translate(0, i*50);
            bar(p);
            translate(0, -i*50);
        }

        saveAs("output/translate_bar.png");
    }
}
