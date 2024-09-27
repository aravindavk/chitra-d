module chitra.elements.new_page;

import chitra.elements.core;

struct NewPage
{
    void draw(cairo_t* cairoCtx)
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
        s.draw(this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
