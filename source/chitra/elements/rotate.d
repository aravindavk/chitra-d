module chitra.elements.rotate;

import std.format;

import chitra.context;
import chitra.elements.core;

struct Rotate
{
    double angle, centerX_, centerY_;

    this(double angle, double centerX = 0.0, double centerY = 0.0)
    {
        this.angle = angle;
        this.centerX_ = centerX;
        this.centerY_ = centerY;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto centerX = chitraCtx.correctedSize(centerX_);
        auto centerY = chitraCtx.correctedSize(centerY_);

        if (centerX != 0 && centerY != 0)
        {
            cairo_translate(cairoCtx, centerX, centerY);
            cairo_rotate(cairoCtx, angle);
            cairo_translate(cairoCtx, -centerX, -centerY);
        }
        else
            cairo_rotate(cairoCtx, angle);
    }
}

mixin template rotateFunctions()
{
    /*
      Rotate the canvas in clockwise to given angle.
      Negative angle rotates the canvas in anti-clockwise
      direction.
      
      ---
      auto ctx = new Chitra(200);
      ctx.rotate(45);
      ctx.rect(40, 40, 40, 40);
      ---

      Rotate center by default is (0, 0). Change this by adding
      arguments to rotate function
      
      ---
      auto ctx = new Chitra(200);
      ctx.rotate(45, 100, 100);
      ctx.rect(50, 50, 100, 100);
      ---
     */
    void rotate(double angle, double centerX = 0.0, double centerY = 0.0)
    {
        import std.math.constants;

        // TODO: Implement this with saved state
        // @current_saved_context.add_transformation(t) if @current_saved_context.enabled?
        auto rad = PI * angle / 180;
        auto t = Rotate(rad, centerX, centerY);
        t.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(t);
    }
}
