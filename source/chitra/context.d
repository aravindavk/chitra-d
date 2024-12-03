module chitra.context;

import std.conv : to;
import std.string : toLower, split, toStringz;
import std.algorithm.mutation : swap;
import std.algorithm;

import chitra.pangocairo;
import chitra.surfaces;
import chitra.paper_sizes;

// Import all the elements
import chitra.elements;
import chitra.properties;
import chitra.helpers;

const baseResolution = 72.0;
const defaultResolution = 300;
const defaultWidth = 700;
const portraitMode = "portrait";
const landscapeMode = "landscape";

import colors;

class Context
{
    Element[] elements;
    cairo_surface_t* defaultSurface;
    cairo_t* defaultCairoCtx;
    int width;
    int height;
    int resolution = defaultResolution;
    ShapeProperties shapeProps;
    TextProperties textProps;

    // Change the size as per the resolution specified
    // When a different resolution is specified other
    // than the default one, then correct it accordingly.
    T correctedSize(T)(T value)
    {
        if (resolution == baseResolution)
            return value;

        return cast(T)((value / baseResolution) * resolution);
    }

    this(int width = defaultWidth, int height = 0, int resolution = defaultResolution)
    {
        this.resolution = resolution;
        this.width = width;
        this.height = height == 0 ? width : height;
        this.defaultSurface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32,
            correctedSize(this.width), correctedSize(this.height));
        this.defaultCairoCtx = cairo_create(this.defaultSurface);

        // Scale the default stroke width based on the resolution
        shapeProps.strokeWidth = correctedSize(shapeProps.strokeWidth);

        // FIXME: fill and stroke colors are not initialized properly!
        // is this nested struct initialize issue or colors lib issue? Not sure.
        shapeProps.fill = rgb(0, 0, 0);
        shapeProps.stroke = rgb(0, 0, 0);
    }

    this(string paper, int resolution = defaultResolution)
    {
        string orientation = portraitMode;
        auto parts = paper.toLower.split(",");
        if (parts.length == 2)
        {
            if (parts[0] == portraitMode || parts[0] == landscapeMode)
            {
                paper = parts[1];
                orientation = parts[0];
            }
            else if (parts[1] == portraitMode || parts[1] == landscapeMode)
            {
                paper = parts[0];
                orientation = parts[1];
            }
        }

        auto size = paper in paperSizes;
        if (size is null)
        {
            throw new Exception("invalid paper");
        }
        auto w = (*size)[0].mm.to!int;
        auto h = (*size)[1].mm.to!int;

        if (orientation == landscapeMode)
            swap(w, h);

        this(w, h, resolution);
    }

    void saveAs(string outputFile)
    {
        cairo_surface_t* surface;

        auto w = correctedSize(this.width);
        auto h = correctedSize(this.height);

        if (outputFile.endsWith(".pdf"))
            surface = createPdfSurface(outputFile, w, h);
        else if (outputFile.endsWith(".png"))
            surface = createPngSurface(outputFile, w, h);
        else if (outputFile.endsWith(".svg"))
            surface = createSvgSurface(outputFile, w, h);
        else
            return;

        auto cairoCtx = cairo_create(surface);

        foreach (element; elements)
            element.draw(cairoCtx);

        if (outputFile.endsWith(".png"))
            cairo_surface_write_to_png(surface, outputFile.toStringz);

        cairo_surface_finish(surface);
    }

    // Reset the drawing to clean and empty canvas
    // ```
    // auto ctx = new Chitra;
    // ctx.fill(0);
    // ctx.rect(0, 0, width, height);
    // ctx.saveAs("slide1.png");
    // ctx.newDrawing;
    // ctx.fill(0, 0, 1);
    // ctx.rect(0, 0, width, height);
    // ctx.saveAs("slide2.png");
    // ```
    void newDrawing()
    {
        elements = [];
        defaultSurface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32,
                                                    correctedSize(this.width), correctedSize(this.height));
        defaultCairoCtx = cairo_create(this.defaultSurface);
        shapeProps = ShapeProperties.init;
        textProps = TextProperties.init;
    }
}
