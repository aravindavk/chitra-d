/+ dub.sdl:
dependency "chitra" path="../"
+/
import chitra;

void main()
{
    // Create a Square context with size as 1080
    auto ctx = new Chitra(1080);

    with (ctx)
    {
        // Same as square of full width and height
        background("#3e8ed0");

        // Set fill color of all the next
        // shapes unless changed
        fill("#6ea8da");
        noStroke;

        // Draw a circle
        oval(-50, -200, 700);

        // Save as png image
        saveAs("output/background_1.png");
    }
}
