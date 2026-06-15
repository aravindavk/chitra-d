module chitra.elements.image;

import std.format;
import std.string : toStringz;

import chitra.context;
import chitra.properties;
import chitra.elements.core;

struct Image
{
    string path;
    double w_, h_;
    double x_, y_;
    ShapeProperties shapeProps;

    this(string path, double x, double y, double w, double h)
    {
        this.path = path;
        this.x_ = x;
        this.y_ = y;
        this.w_ = w;
        this.h_ = h;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        auto w = chitraCtx.correctedSize(w_);
        auto h = chitraCtx.correctedSize(h_);

        // TODO: Scale the image if width and height are given
        auto surface = cairo_image_surface_create_from_png(path.toStringz);

        if (!shapeProps.tint.isNull)
        {
            auto imgCtx = cairo_create(surface);
            cairo_set_source_rgba(imgCtx, shapeProps.tint.get.r, shapeProps.tint.get.g,
                                  shapeProps.tint.get.b, shapeProps.tint.get.a); 

            cairo_set_operator(imgCtx, CAIRO_OPERATOR_MULTIPLY); 
            cairo_paint(imgCtx);
        }

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
        auto s = Image(path, x, y, w, h);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    // Get width of the image
    // ```
    // auto ctx = new Chitra;
    // auto w = ctx.imageWidth("logo.png");
    // ```
    double imageWidth(string path)
    {
        return imageSize(path).width;
    }

    // Get height of the image
    // ```
    // auto ctx = new Chitra;
    // auto h = ctx.imageHeight("logo.png");
    // ```
    double imageHeight(string path)
    {
        return imageSize(path).height;
    }

    // Get width and height of the image
    // ```
    // auto ctx = new Chitra;
    // auto size = ctx.imageSize("logo.png");
    // ```
    ImageSize imageSize(string path)
    {
        // TODO: Cache the surface for the given path?
        auto surface = cairo_image_surface_create_from_png(path.toStringz);
        ImageSize size;
        size.width = cairo_image_surface_get_width(surface);
        size.height = cairo_image_surface_get_height(surface);
        return size;
    }
}
