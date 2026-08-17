module chitra.elements.new_page;

import std.conv : to;

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
        setPageVariable("currentPage", this.pageVars["currentPage"].to!int + 1);
        setDocumentVariable("totalPages", this.documentVars["totalPages"].to!int + 1);
        this.elements ~= Element(s);
    }
}
