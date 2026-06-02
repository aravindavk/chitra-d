module chitra.surfaces;

import std.conv : to;
import std.string;

import chitra.pangocairo;

cairo_surface_t* createPdfSurface(string outputFile, double width, double height)
{
    return cairo_pdf_surface_create(outputFile.toStringz, width, height);
}

cairo_surface_t* createPngSurface(string outputFile, double width, double height)
{
    return cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width.to!int, height.to!int);
}

cairo_surface_t* createSvgSurface(string outputFile, double width, double height)
{
    return cairo_svg_surface_create(outputFile.toStringz, width, height);
}
