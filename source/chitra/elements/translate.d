module chitra.elements.translate;

import std.format;

import chitra.context;
import chitra.elements.core;

struct Translate
{
    double x_, y_;

    this(double x, double y)
    {
        this.x_ = x;
        this.y_ = y;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);

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
        // TODO: Handle when scaled state is implemented
        // @current_saved_context.add_transformation(s) if @current_saved_context.enabled?
        auto s = Translate(x, y);
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
