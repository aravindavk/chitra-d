#!/usr/bin/env dub
/+ dub.sdl:
dependency "chitra" path="../../../"
+/

import std.array : replicate, replace;

import chitra;

void main()
{
    string sampleUuid = "f13a2e83-420d-4d9b-9e10-9f23eddba74e";
    sampleUuid = sampleUuid.replicate(3).replace("-", "");
    auto ctx = new Chitra(800);
    with (ctx)
    {
        background(0);
        noStroke;
        string[] colors;

        auto x = 0;
        auto y = 0;

        foreach(i; 0 .. 16)
        {
            auto col = "#" ~ sampleUuid[i * 6 .. i * 6 + 6];

            if (i != 0 && i % 4 == 0)
            {
                y += 200;
                x = 0;
            }
            
            fill(col);
            square(x, y, 200);

            x += 200;
        }

        saveAs("static/images/uuid_thumbnail.png");
    }
}
