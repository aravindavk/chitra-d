/+ dub.sdl:
 dependency "chitra" version="~>0.4.0"
 +/

import std.stdio;

import chitra;

void drawDistance(Chitra ctx, double focusX, double focusY)
{
    with (ctx)
    {
        background(0);
        fill(255);
        noStroke;

        auto maxDist = findDistance(0, 0, width, height);

        for (int i = 0; i <= width; i += 20)
        {
            for (int j = 0; j <= height; j += 20)
            {
                double w = findDistance(focusX, focusY, i, j);
                w = (w / maxDist) * 66.0;
                oval(i, j, w);
            }
        }
    }
}

void main()
{
    auto ctx = new Chitra(640, 360);
    
    with (ctx)
    {
        auto focusX = width/2.0;
        auto focusY = height/2.0;

        drawDistance(ctx, focusX, focusY);

        saveAs("static/images/distance.png");
    }
}
