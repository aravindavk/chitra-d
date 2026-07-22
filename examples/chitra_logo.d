#!/usr/bin/env dub
/+ dub.sdl:
dependency "chitra" path="../"
+/

import chitra;

void drawChitra(Chitra ctx, double x, double y)
{
    auto gap = 20.0;
    // C
    ctx.rect(x, y, 150, 50);
    ctx.rect(x, y + 150, 150, 50);
    ctx.rect(x, y, 50, 200);

    x += 150 + gap;
    // H
    ctx.rect(x, y, 50, 200);
    ctx.rect(x + 100, y, 50, 200);
    ctx.rect(x, y + 70, 150, 50);

    x += 150 + gap;
    // I
    ctx.rect(x, y, 50, 200);

    x += 50 + gap;
    // T
    ctx.rect(x, y, 200, 50);
    ctx.rect(x + 75, y, 50, 200);

    x += 200 + gap;
    // R
    ctx.rect(x, y, 50, 200);
    ctx.rect(x + 100, y, 50, 100);
    ctx.polygon([x + 50, y + 140, x + 100, y + 140, x + 150, y + 200, x + 100, y + 200], true);
    ctx.rect(x, y + 99, 150, 50);
    ctx.rect(x, y, 150, 50);

    x += 150 + gap;
    // A
    ctx.rect(x, y, 50, 200);
    ctx.rect(x + 100, y, 50, 200);
    ctx.rect(x, y, 150, 50);
    ctx.rect(x, y + 90, 150, 50);
}

void main(string[] args)
{
    auto ctx = new Chitra(970, 220);

    with (ctx)
    {
        fill("sapphireblue");
        noStroke;

        auto x = 10.0;
        auto y = 10.0;

        drawChitra(ctx, x, y);
        saveAs("output/chitra-logo.png");


        newDrawing;
        noStroke;
        setSize(1024);
        background("sapphireblue");
        translate((width - 970) / 2, (height - 220) / 2);

        fill("#FFFFFF");
        x = 10.0;
        y = 10.0;
        drawChitra(ctx, x, y);
        
        saveAs("output/chitra-logo-square.png");
    }
}
