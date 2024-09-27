module chitra.surfaces;

import std.string;

import chitra.pangocairo;

cairo_surface_t* createPdfSurface(string outputFile, int width, int height)
{
    return cairo_pdf_surface_create(outputFile.toStringz, width, height);
}

cairo_surface_t* createPngSurface(string outputFile, int width, int height)
{
    return cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width, height);
}

cairo_surface_t* createSvgSurface(string outputFile, int width, int height)
{
    return cairo_svg_surface_create(outputFile.toStringz, width, height);
}
