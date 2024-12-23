module chitra.elements.text;

import std.format;
import std.string;

import chitra.context;
import chitra.properties;
import chitra.elements.core;
import chitra.elements.formatted_strings;
import chitra.rgba;

struct Text
{
    FormattedString txt;
    double x_, y_;
    ShapeProperties shapeProps;
    TextProperties textProps;

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        cairo_save(cairoCtx);
        // Do not use fill color since the text color will be added
        shapeProps.fill = RGBA(0, 0, 0, 0);
        cairo_set_antialias(cairoCtx, CAIRO_ANTIALIAS_BEST);
        cairo_move_to(cairoCtx, x, y);
        auto layout = pango_cairo_create_layout(cairoCtx);
        pango_layout_set_markup(layout, txt.content(chitraCtx).toStringz, -1);
        pango_cairo_update_layout(cairoCtx, layout);
        pango_cairo_show_layout(cairoCtx, layout);
        pango_cairo_layout_path(cairoCtx, layout);

        if (shapeProps.strokeWidth > 0 && !shapeProps.noStroke)
            drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
        else
            cairo_new_path(cairoCtx);

        cairo_restore(cairoCtx);
        g_object_unref(layout);
    }
}

mixin template textFunctions()
{
    /**
       Draw the text.

       ---
       ctx.text("Hello World!", 100, 100);
       ---
     */
    void text(string txt, double x, double y)
    {
        auto formatted = FormattedString(txt);
        text(formatted, x, y);
    }

    void text(FormattedString txt, double x, double y)
    {
        auto props = updateProperties([defaultTextProperties, this.textProps, txt.currentProperties]);
        txt.currentProperties = props;
        auto s = Text(txt, x, y);
        // Copy only top level props
        s.textProps = props;
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }
}
