import std.file : write, mkdir, getcwd;
import std.path : buildPath;
import std.stdio : writefln;

string content = q"[
import std.stdio;

import chitra;

void main()
{
    // Canvas / Paper size 700x700
    auto ctx = new Chitra(700);

    with (ctx)
    {
        background("white");           // White background
        fill("blue");                  // Fill Blue color
        //   X    Y    W    H
        rect(100, 200, 500, 100);      // Draw a Blue rectangle
        saveAs("blue-rectangle.png");  // Save as PNG image
    }

    writeln("Generated ./blue-rectangle.png");
}
]";

string blankTmpl = q"[
import chitra;

void main()
{
    auto ctx = new Chitra;

    with (ctx)
    {

    }
}
]";

int main(string[] args)
{
    auto sourcePath = buildPath(getcwd(), "source");
	auto appPath = buildPath(sourcePath, "app.d");

	mkdir(sourcePath);

    if (args.length > 1 && args[1] == "blank")
        write(appPath, blankTmpl);
    else
        write(appPath, content);

    string pfx;
	writefln("\n%12s Awesome! Now run your Chitra app by running the following commands:\n\n%12s cd %s\n%12s dub\n", pfx, pfx, getcwd(), pfx);
    return 0;
}
