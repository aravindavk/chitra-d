module chitra.elements.qr_image;

import std.format;
import std.file : tempDir, remove, exists;
import std.path : buildPath;
import std.uuid : randomUUID;
import std.string : toStringz;

import chitra.context;
import chitra.properties;
import chitra.elements.core;

import qr : QrCode;

struct QrImage
{
    string txt;
    double x_, y_;
    double w_;
    ShapeProperties shapeProps;

    this(string txt, double x, double y, double w)
    {
        this.txt = txt;
        this.x_ = x;
        this.y_ = y;
        this.w_ = w;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        auto w = cast(int)chitraCtx.correctedSize(w_);

        auto tempFile = buildPath(tempDir(), "chitra_" ~ randomUUID().toString()) ~ ".png";
        scope(exit) if (tempFile.exists) remove(tempFile);

        auto qrcode = QrCode(txt);
        auto padding = 1;
        auto moduleSize = w / (qrcode.size + 2 * padding);
        qrcode.saveAs(
            tempFile, padding: padding, moduleSize: moduleSize,
            foreground: shapeProps.stroke.hexString,
            background: shapeProps.fill.hexString
        );

        auto resolutionScale = chitraCtx.correctedSize(1.0);

        auto surface = cairo_image_surface_create_from_png(tempFile.toStringz);

        // Fetch the image width and height, and adjust it to the page resolution
        auto imgW = cairo_image_surface_get_width(surface) * resolutionScale;
        auto imgH = cairo_image_surface_get_height(surface) * resolutionScale;

        if (resolutionScale != 1)
            cairo_scale(cairoCtx, resolutionScale, resolutionScale);

        // Fills the container and not worry about
        // the proportion
        auto scaleX = w / imgW;
        auto scaleY = w / imgH;

        cairo_scale(cairoCtx, scaleX, scaleY);
        auto x1 = (x / resolutionScale) / scaleX;
        auto y1 = (y / resolutionScale) / scaleY;
        cairo_set_source_surface(cairoCtx, surface, x1, y1);
        cairo_scale(cairoCtx, 1 / scaleX, 1 / scaleY);

        // // If width and height is given, draw the rectangle and clip
        // cairo_rectangle(cairoCtx, x / resolutionScale, y / resolutionScale, w / resolutionScale, h / resolutionScale);
        // cairo_clip(cairoCtx);

        cairo_paint(cairoCtx);
        // cairo_reset_clip(cairoCtx);

        // Reverse the Resolution scale applied
        if (resolutionScale != 1)
            cairo_scale(cairoCtx, 1/resolutionScale, 1/resolutionScale);
    }
}

mixin template qrImageFunctions()
{
    /**
       Draw a QR code.

       ---
       ctx.fill(255);
       ctx.stroke(0);
       ctx.qrImage("Hello World!", 100, 100, 500);
       ---
     */
    void qrImage(string txt, double x, double y, double w)
    {
        auto s = QrImage(txt, x, y, w);
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    void qrImage(string txt, Point p, double w)
    {
        qrImage(txt, p.x, p.y, w);
    }

    void qrImage(string txt, Box box)
    {
        qrImage(txt, box.x, box.y, box.width);
    }
}
