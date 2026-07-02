#!/usr/bin/env dub
/+ dub.sdl:
dependency "chitra" path="../../../"
+/

import std.array : replicate, replace, array;
import std.range : chunks;
import std.algorithm : map;
import std.conv;

import chitra;

void main()
{
    string sampleUuid = "f13a2e83-420d-4d9b-9e10-9f23eddba74e";
    string[] colors = sampleUuid.replicate(3).replace("-", "").chunks(6).map!(c => "#" ~ c.to!string).array;

    auto ctx = new Chitra(800);
    with (ctx)
    {
        background(0);
        noStroke;
        grid(4, 4);
        foreach(col; colors)
        {
            fill(col);
            rect(nextGridCell);
        }

        saveAs("static/images/uuid_thumbnail.png");
    }
}
