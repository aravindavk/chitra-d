module chitra.elements.new_page;

import chitra.context;
import chitra.elements.core;

struct NewPage
{
    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        cairo_show_page(cairoCtx);
    }
}

mixin template newPageFunctions()
{
    /**
       Creates a new page.

       ---
       ctx.newPage;
       ---
     */
    void newPage()
    {
        NewPage s;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
