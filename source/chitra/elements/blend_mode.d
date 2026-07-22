module chitra.elements.blend_mode;

import chitra.context;
import chitra.elements.core;
import chitra.constants;

struct BlendMode
{
    auto operator = OVER;

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        cairo_set_operator(cairoCtx, operator);
    }
}

mixin template blendModeFunctions()
{
    void blendMode(T)(T mode = OVER)
    {
        BlendMode s;
        s.operator = mode;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
