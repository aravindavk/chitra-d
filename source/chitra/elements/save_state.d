module chitra.elements.save_state;

import chitra.context;
import chitra.elements.core;
import chitra.constants;

struct SaveState
{
    bool group = true;

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        cairo_save(cairoCtx);
        if (group)
            cairo_push_group(cairoCtx);
    }
}

mixin template saveStateFunctions()
{
    void saveState(bool group = false)
    {
        // Save the current properties
        SavedStateContext ctx;
        ctx.shapeProps = this.shapeProps;
        ctx.textProps = this.textProps;
        ctx.borderProps = this.borderProps;
        ctx.colorScaleMax = this.colorScaleMax;
        ctx.colorScaleAlphaMax = this.colorScaleAlphaMax;
        ctx.group = group;

        this.savedStateContexts ~= ctx;

        auto s = SaveState(group);

        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
