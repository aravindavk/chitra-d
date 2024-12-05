module chitra.elements.image;

import std.format;
import std.string : toStringz;

import chitra.properties;
import chitra.elements.core;

struct Image
{
    string path;
    double w, h;
    double x, y;
    ShapeProperties shapeProps;

    this(string path, double x, double y, double w, double h)
    {
        this.path = path;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    void draw(cairo_t* cairoCtx)
    {
        // TODO: Scale the image if width and height are given
        auto surface = cairo_image_surface_create_from_png(path.toStringz);
        cairo_set_source_surface(cairoCtx, surface, x, y);
        cairo_paint(cairoCtx);
    }
}

mixin template imageFunctions()
{
    import std.string : toStringz;

    import chitra.elements.core;

    struct ImageSize
    {
        double width;
        double height;
    }

    /**
       Draw the Image.

       ---
       ctx.image("awesome.png", 100, 100);
       ---
     */
    void image(string path, double x, double y, double w = 0.0, double h = 0.0)
    {
        x = correctedSize(x);
        y = correctedSize(y);
        w = correctedSize(w);
        h = correctedSize(h);

        auto s = Image(path, x, y, w, h);
        s.shapeProps = this.shapeProps;
        s.draw(this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    // Get width of the image
    // ```
    // auto ctx = new Chitra;
    // auto w = ctx.imageWidth("logo.png");
    // ```
    double imageWidth(string path)
    {
        // TODO: Cache the surface for the given path?
        auto surface = cairo_image_surface_create_from_png(path.toStringz);
        return actualSize(cairo_image_surface_get_width(surface));
    }

    // Get height of the image
    // ```
    // auto ctx = new Chitra;
    // auto h = ctx.imageHeight("logo.png");
    // ```
    double imageHeight(string path)
    {
        auto surface = cairo_image_surface_create_from_png(path.toStringz);
        return actualSize(cairo_image_surface_get_height(surface));
    }

    // Get width and height of the image
    // ```
    // auto ctx = new Chitra;
    // auto size = ctx.imageSize("logo.png");
    // ```
    ImageSize imageSize(string path)
    {
        return ImageSize(imageWidth(path), imageHeight(path));
    }
}
