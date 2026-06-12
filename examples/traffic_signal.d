/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import chitra;

void trafficSignal(Chitra ctx, string name, string outfile)
{
    auto alpha = 0.5;

    with (ctx)
    {
        noStroke;

        rect(0, 100, 200, 20);
        rect(50, 50, 340, 120);

        alpha = name == "red" ? 1 : 0.5;
        fill(255, 26, 29, alpha);
        circle(60, 60, 100);

        alpha = name == "yellow" ? 1 : 0.5;
        fill(255, 170, 25, alpha);
        circle(170, 60, 100);

        alpha = name == "green" ? 1 : 0.5;
        fill(144, 207, 4, alpha);
        circle(280, 60, 100);

        saveAs(outfile);
    }
}

void main()
{
    auto ctx = new Chitra(400, 220);

    ctx.newDrawing;
    ctx.trafficSignal("red", "output/traffic_signal_red.png");

    ctx.newDrawing;
    ctx.trafficSignal("yellow", "output/traffic_signal_yellow.png");

    ctx.newDrawing;
    ctx.trafficSignal("green", "output/traffic_signal_green.png");
}
