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
    double offsetX_, offsetY_;
    string fit;
    ShapeProperties shapeProps;

    this(string path, double x, double y, double w, double h, string fit, double offsetX, double offsetY)
    {
        this.path = path;
        this.x_ = x;
        this.y_ = y;
        this.w_ = w;
        this.h_ = h;
        this.fit = fit;
        this.offsetX_ = offsetX;
        this.offsetY_ = offsetY;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        auto w = chitraCtx.correctedSize(w_);
        auto h = chitraCtx.correctedSize(h_);
        auto offsetX = chitraCtx.correctedSize(offsetX_);
        auto offsetY = chitraCtx.correctedSize(offsetY_);

        auto resolutionScale = chitraCtx.correctedSize(1.0);

        auto surface = cairo_image_surface_create_from_png(path.toStringz);

        // Fetch the image width and height, and adjust it to the page resolution
        auto imgW = cairo_image_surface_get_width(surface) * resolutionScale;
        auto imgH = cairo_image_surface_get_height(surface) * resolutionScale;

        if (resolutionScale != 1)
            cairo_scale(cairoCtx, resolutionScale, resolutionScale);

        // Image Tint
        if (!shapeProps.tint.isNull)
        {
            auto imgCtx = cairo_create(surface);
            cairo_set_source_rgba(imgCtx, shapeProps.tint.get.r, shapeProps.tint.get.g,
                                  shapeProps.tint.get.b, shapeProps.tint.get.a); 

            cairo_set_operator(imgCtx, CAIRO_OPERATOR_MULTIPLY); 
            cairo_paint(imgCtx);
        }

        // If Width or height is provided for image, then Fit the image
        // as per the given fitting (FILL, COVER, CROP, CONTAIN)
        if (w > 0 || h > 0)
        {
            // If width is not set, automatically set the
            // width based on the Height scale
            if (w == 0)
            {
                auto s = h / imgH;
                w = imgW * s;
            }

            // If height is not set, automatically set the
            // height based on the Width scale
            if (h == 0)
            {
                auto s = w / imgW;
                h = imgH * s;
            }

            // If fit == CROP, no scale
            auto scaleX = 1.0;
            auto scaleY = 1.0;

            if (fit == FILL)
            {
                // Fills the container and not worry about
                // the proportion
                scaleX = w / imgW;
                scaleY = h / imgH;
            }
            else if (fit == COVER)
            {
                scaleX = w / imgW;
                scaleY = scaleX;
                auto newH = imgH * scaleY;

                // Less than the container height, so
                // not covered
                if (newH < h)
                {
                    scaleY = h / imgH;
                    scaleX = scaleY;
                }
            }
            else if (fit == CONTAIN)
            {
                scaleX = w / imgW;
                scaleY = scaleX;
                auto newH = imgH * scaleY;

                // More than the container height, so
                // not contained
                if (newH > h)
                {
                    scaleY = h / imgH;
                    scaleX = scaleY;
                }
            }

            cairo_scale(cairoCtx, scaleX, scaleY);
            auto x1 = ((x + offsetX) / resolutionScale) / scaleX;
            auto y1 = ((y + offsetY) / resolutionScale) / scaleY;
            cairo_set_source_surface(cairoCtx, surface, x1, y1);
            cairo_scale(cairoCtx, 1 / scaleX, 1 / scaleY);

            // If width and height is given, draw the rectangle and clip
            cairo_rectangle(cairoCtx, x / resolutionScale, y / resolutionScale, w / resolutionScale, h / resolutionScale);
            cairo_clip(cairoCtx);
        }
        else
            cairo_set_source_surface(cairoCtx, surface, x/resolutionScale, y/resolutionScale);

        cairo_paint(cairoCtx);
        cairo_reset_clip(cairoCtx);

        // Reverse the Resolution scale applied
        if (resolutionScale != 1)
            cairo_scale(cairoCtx, 1/resolutionScale, 1/resolutionScale);
    }
}

mixin template imageFunctions()
{
    import std.string : toStringz;

    import chitra.elements.core;

    /**
       Draw the Image.

       ---
       ctx.image("awesome.png", 100, 100);
       ---
     */
    void image(string path, double x, double y, double w = 0.0, double h = 0.0, string fit = FILL, double offsetX = 0.0, double offsetY = 0.0)
    {
        auto s = Image(path, x, y, w, h, fit, offsetX, offsetY);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    void image(string path, Box cell, bool autoW = false, bool autoH = false, string fit = FILL, double offsetX = 0.0, double offsetY = 0.0)
    {
        auto w = autoW ? 0.0 : cell.width;
        auto h = autoH ? 0.0 : cell.height;

        image(path, cell.x, cell.y, w, h, fit: fit, offsetX: offsetX, offsetY: offsetY);
    }

    void image(string path, string fit = "", double offsetX = 0.0, double offsetY = 0.0)
    {
        auto w = 0.0;
        auto h = 0.0;

        if (fit != "")
        {
            w = this.width;
            h = this.height;
        }

        image(path, 0, 0, w: w, h: h, fit: fit, offsetX: offsetX, offsetY: offsetY);
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
    Size imageSize(string path)
    {
        // TODO: Cache the surface for the given path?
        auto surface = cairo_image_surface_create_from_png(path.toStringz);
        Size size;
        size.width = cairo_image_surface_get_width(surface);
        size.height = cairo_image_surface_get_height(surface);
        return size;
    }
}
