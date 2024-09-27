module chitra.elements.scale;

import std.format;

import chitra.elements.core;

struct Scale
{
    double scaleX, scaleY;

    this(double scaleX, double scaleY = 0.0)
    {
        this.scaleX = scaleX;
        this.scaleY = scaleY == 0.0 ? scaleX : scaleY;
    }

    void draw(cairo_t* cairoCtx)
    {
        cairo_scale(cairoCtx, scaleX, scaleY);
    }
}

mixin template scaleFunctions()
{
    /*
      Scale the canvas with the given x and y scale factors.
      direction.
      ---
      auto ctx = new Chitra(200);
      ctx.scale(2);
      ctx.rect(40, 40, 40, 40);
      ---

      Different scaling for x and y

      ---
      auto ctx = new Chitra(200);
      ctx.scale(2, 1);
      ctx.rect(40, 40, 40, 40);
      ---
    */
    void scale(double scaleX, double scaleY = 0.0)
    {
        // TODO: Handle when scaled state is implemented
        // @current_saved_context.add_transformation(s) if @current_saved_context.enabled?
        auto s = Scale(scaleX, scaleY);
        s.draw(this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
