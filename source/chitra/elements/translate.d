module chitra.elements.translate;

import std.format;

import chitra.elements.core;

struct Translate
{
    double x, y;

    this(double x, double y)
    {
        this.x = x;
        this.y = y;
    }

    void draw(cairo_t* cairoCtx)
    {
        cairo_translate(cairoCtx, x, y);
    }
}

mixin template translateFunctions()
{
    /*
      Translate the canvas to given x and y

      ---
      auto ctx = new Chitra;
      ctx.translate(100, 100);
      ctx.rect(0, 0, 500, 500);
      ---
    */
    void translate(double x, double y)
    {
        x = correctedSize(x);
        y = correctedSize(y);

        // TODO: Handle when scaled state is implemented
        // @current_saved_context.add_transformation(s) if @current_saved_context.enabled?
        auto s = Translate(x, y);
        s.draw(this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
