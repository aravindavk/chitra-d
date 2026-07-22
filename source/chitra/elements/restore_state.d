module chitra.elements.restore_state;

import chitra.context;
import chitra.elements.core;
import chitra.constants;

struct RestoreState
{
    bool group;

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        if (group)
        {
            cairo_pop_group_to_source(cairoCtx);
            cairo_paint(cairoCtx);
            cairo_set_operator(cairoCtx, OVER);
        }

        cairo_restore(cairoCtx);
    }
}

mixin template restoreStateFunctions()
{
    void restoreState()
    {
        import std.array : popBack;

        if (this.savedStateContexts.length > 0)
        {
            auto ctx = this.savedStateContexts[$-1];
            RestoreState s;
            s.group = ctx.group;
            s.draw(this, this.defaultCairoCtx);
            this.elements ~= Element(s);

            this.shapeProps = ctx.shapeProps;
            this.textProps = ctx.textProps;
            this.borderProps = ctx.borderProps;
            this.colorScaleMax = ctx.colorScaleMax;
            this.colorScaleAlphaMax = ctx.colorScaleAlphaMax;

            this.savedStateContexts.popBack;
        }
    }

    void savedState(void delegate() func)
    {
        saveState(group: false);
        func();
        restoreState;
    }

    void savedState(bool group, void delegate() func)
    {
        saveState(group: group);
        func();
        restoreState;
    }
}
