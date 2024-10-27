import std.stdio;

import chitra;

void main()
{
    auto ctx = new Chitra;
    with (ctx)
    {
        background("#777777");
        fill("#dddddd");
        line(0, 0, width, height);
        rect(50, 50, 500, 200);
        fill(0, 0, 1);
        polygon([[50, 450], [50, 50], [450, 50], [100, 100]], true);
        fill(0.5);
        polygon([150, 450, 150, 50, 550, 50, 200, 100], true);
        fill(0, 0, 1);
        writeln(width);
        oval(width/2, height/2, 200);

        translate(200, 50);
        rotate(45);
        rect(200, 200, 300);
        rotate(-45);

        newPage;
        scale(2);
        fill(0, 0, 1);
        oval(200, 200, 200);
        saveAs("sample.png");
    }
}
